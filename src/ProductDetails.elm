module ProductDetails exposing (..)

import Browser
import Css exposing (..)
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


colorDisplay : String -> Html Msg
colorDisplay c =
    li [ css [ backgroundColor <| hex c ] ] []


colorsView : Maybe (List String) -> Html Msg
colorsView lst =
    section []
        [ h5 [] [ text "Available colors" ]
        , case lst of
            Just clrs ->
                ul [] (List.map colorDisplay clrs)

            Nothing ->
                text ""
        ]


view : Model -> Html Msg
view model =
    div []
        [ case model.activeProduct of
            Just product ->
                section [ class "product-view" ]
                    [ h1 [] [ text product.make ]
                    , img [ src product.imgUrl ] []
                    , p [] [ text <| product.model ++ "," ++ Maybe.withDefault "" product.recommendedEngine ]
                    , p [] [ text product.summary ]
                    , p []
                        [ text <| String.fromInt product.carwowRating ]
                    , colorsView product.availableColors
                    , button [] [ text "Get offers" ]
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
