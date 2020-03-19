module ProductDetails exposing (..)

import Browser
import Button exposing (..)
import Css exposing (..)
import Debug exposing (toString)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Http
import ProductList exposing (Product, decodeProductFullDetails, getProduct)
import Theme exposing (..)



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


colorDisplay : Theme.Model -> String -> Html Msg
colorDisplay t c =
    li
        [ css
            [ backgroundColor <| hex c
            , Css.width <| px 30
            , Css.height <| px 30
            , Theme.inline t.spacing.space_m
            ]
        ]
        []


colorsView : Theme.Model -> Maybe (List String) -> Html Msg
colorsView t lst =
    section []
        [ h5 [] [ text "Available colors" ]
        , case lst of
            Just clrs ->
                ul
                    [ css
                        [ listStyle none
                        , displayFlex
                        , padding <| px 0
                        , stack <| t.spacing.space_l
                        ]
                    ]
                    (List.map (colorDisplay t) clrs)

            Nothing ->
                text ""
        ]


view : Model -> Html Msg
view model =
    let
        t =
            model.theme
    in
    case model.activeProduct of
        Just product ->
            section
                [ css
                    [ padding <| px t.spacing.space_l
                    ]
                ]
                [ div []
                    [ img [ src product.imgUrl ] [] ]
                , div []
                    [ h1 [] [ text product.make ]
                    , h2 [] [ text <| product.model ++ "," ++ Maybe.withDefault "" product.recommendedEngine ]
                    , p [] [ text product.summary ]
                    , p []
                        [ text <| String.fromInt product.carwowRating ]
                    , colorsView model.theme product.availableColors
                    , a
                        [ href <| "mailto:company@company.com?subject=Offers for " ++ product.make ++ " " ++ product.model
                        , css
                            [ primaryBtnStyle t
                            , Css.width <| pct 50
                            , margin2 (px 0) auto
                            ]
                        ]
                        [ text "Get offers" ]
                    ]
                ]

        Nothing ->
            case model.err of
                Just a ->
                    h1 [] [ text a ]

                Nothing ->
                    text ""



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