module ProductDetails exposing (..)

import Button exposing (..)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Http
import ProductList exposing (Product, decodeProductFullDetails, getProduct)
import Svg.Styled as Svg exposing (svg)
import Svg.Styled.Attributes as SvgA
import Theme exposing (..)



---- MODEL ----


type alias Model =
    { activeProduct : Maybe Product
    , theme : Theme.Model
    , err : Maybe String
    }


init : Theme.Model -> ( Model, Cmd Msg )
init theme =
    ( { activeProduct = Nothing
      , theme = theme
      , err = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ActiveProductLoaded (Result Http.Error Product)
    | ThemeChanged Theme.Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ThemeChanged t ->
            ( { model | theme = t }, Cmd.none )

        ActiveProductLoaded r ->
            case r of
                Ok product ->
                    ( { model | activeProduct = Just product }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | activeProduct = Nothing, err = Just "Error while fetching this product..." }
                    , Cmd.none
                    )



---- VIEW ----


starDisplay : Theme.Model -> Bool -> Html Msg
starDisplay t active =
    let
        c =
            if active then
                t.colors.starActive

            else
                t.colors.starInactive
    in
    li
        [ css
            [ overM [ Theme.inline t.spacing.space_s ]
            , Css.color c
            ]
        ]
        [ svg
            [ SvgA.width "26"
            , SvgA.height "26"
            , SvgA.fill "currentColor"
            ]
            [ Svg.path [ SvgA.d "m12.49338,19.62212l-8.03562,5.90377l3.0717,-9.54995l-8.03382,-5.90376l9.93057,0.00183l2.63934,-8.21168l0.43055,-1.3337l3.06627,9.54355l9.93327,0l-8.03743,5.90376l3.07261,9.55269l-8.03744,-5.90651l0,0z" ] [] ]
        ]


ratingDisplay : Theme.Model -> Int -> Html Msg
ratingDisplay t rating =
    ul
        [ css
            [ displayFlex
            , listStyle none
            , paddingLeft <| px 0
            ]
        ]
        (List.repeat rating (starDisplay t True)
            ++ List.repeat (10 - rating) (starDisplay t False)
        )


colorDisplay : Theme.Model -> String -> Html Msg
colorDisplay t c =
    li
        [ css
            [ backgroundColor <| hex c
            , Css.width <| px 30
            , Css.height <| px 30
            , borderRadius <| px 5
            , border3 (px 1) solid t.colors.cardBrdr
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
                    , backgroundColor model.theme.colors.cardActiveProductBg
                    , overM
                        [ displayFlex
                        , flexDirection row
                        , margin2 (px 0) auto
                        ]
                    ]
                ]
                [ div
                    [ css
                        [ displayFlex
                        , justifyContent center
                        , alignItems center
                        , overM
                            [ marginRight <| px model.theme.spacing.space_m
                            , flex <| num 1
                            , maxWidth <| px 512
                            ]
                        ]
                    ]
                    [ img
                        [ src product.imgUrl
                        , css [ Css.maxWidth <| pct 100 ]
                        ]
                        []
                    ]
                , div
                    [ css
                        [ overM
                            [ marginLeft <| px model.theme.spacing.space_m
                            , Css.minWidth <| px 360
                            , flex <| num 1
                            ]
                        ]
                    ]
                    [ h1
                        [ css
                            [ stack model.theme.spacing.space_xl
                            , overM
                                [ displayFlex
                                , stack model.theme.spacing.space_l
                                ]
                            ]
                        ]
                        [ div
                            [ css
                                [ overM
                                    [ Theme.inline model.theme.spacing.space_s
                                    , flex <| num 1
                                    ]
                                ]
                            ]
                            [ text product.make ]
                        , div
                            []
                            [ text <| "£" ++ String.fromInt product.rrp
                            , p [ css [ float right, fontSize model.theme.typography.helper ] ] [ text " (rrp)" ]
                            ]
                        ]
                    , h2
                        []
                        [ text product.model ]
                    , h3 [] [ text <| Maybe.withDefault "" product.recommendedEngine ]
                    , p [ css [ stack model.theme.spacing.space_m ] ]
                        [ text product.summary ]
                    , ratingDisplay t product.carwowRating
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



---- HTTP ----


loadActiveProduct : Int -> Cmd Msg
loadActiveProduct n =
    Http.get
        { url = getProduct (Just n)
        , expect = Http.expectJson ActiveProductLoaded decodeProductFullDetails
        }
