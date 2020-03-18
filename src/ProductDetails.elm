module ProductDetails exposing (..)

import Browser
import Debug exposing (toString)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Http
import ProductList exposing (Product, decodeProductFullDetails, getProduct)
import Theme



---- MODEL ----


type alias Model =
    { activeProduct : Maybe Product
    , theme : Theme.Model
    , err : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    let
        ( theme, _ ) =
            Theme.init
    in
    ( { activeProduct = Nothing
      , theme = theme
      , err = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ActiveProductLoaded (Result Http.Error Product)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ActiveProductLoaded r ->
            case r of
                Ok product ->
                    ( { model | activeProduct = Just product }
                    , Cmd.none
                    )

                Err e ->
                    ( { model | activeProduct = Nothing, err = Just (toString e) }
                    , Cmd.none
                    )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ case model.activeProduct of
            Just product ->
                div [ class "product-view" ]
                    [ h1 [] [ text ("Selected Product: " ++ product.model) ]
                    ]

            Nothing ->
                case model.err of
                    Just a ->
                        h1 [] [ text a ]

                    Nothing ->
                        text ""
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }



---- HTTP ----


loadActiveProduct : Int -> Cmd Msg
loadActiveProduct n =
    Http.get
        { url = getProduct (Just n)
        , expect = Http.expectJson ActiveProductLoaded decodeProductFullDetails
        }
