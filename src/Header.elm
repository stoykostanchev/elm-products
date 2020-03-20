module Header exposing (..)

import Button exposing (primaryBtnStyle)
import Css exposing (..)
import Html.Styled exposing (Html, a, button, form, input, nav, p, text)
import Html.Styled.Attributes as HtmlA exposing (css, disabled, href, type_)
import Html.Styled.Events exposing (custom)
import Json.Decode exposing (succeed)
import Theme exposing (Model, colorTheme, darkTheme, inline, inset)



---- MODEL ----


type alias Model =
    { editorExpanded : Bool
    , theme : Theme.Model
    }



---- UPDATE ----


type Msg
    = ThemeSet Theme.Model



---- VIEW ----


homeLink : Model -> Html msg
homeLink m =
    a
        [ href "/elm-products/buidl/"
        , css
            [ textDecoration none
            , fontSize <| m.theme.typography.h3
            , fontFamilies [ "cursive" ]
            , position relative
            , top <| rem -0.5
            , paddingLeft <| px m.theme.spacing.space_m
            , color <| rgb 255 255 255
            , flex <| num 1
            ]
        ]
        [ text "carwow" ]


onClickSetTheme : msg -> Html.Styled.Attribute msg
onClickSetTheme message =
    custom "click" (succeed { message = message, stopPropagation = True, preventDefault = True })


themeBtn : Theme.Model -> String -> Bool -> Color -> msg -> Html msg
themeBtn theme txt active color msg =
    button
        [ onClickSetTheme msg
        , css
            [ cursor pointer
            , border3 (px 1) solid theme.colors.buttonPrimaryBrdr
            , borderRadius <| px 5
            , Theme.inline theme.spacing.space_m
            , Theme.inset theme.spacing.space_s
            , backgroundColor color
            , Css.color <| rgb 255 255 255
            , fontWeight bold
            ]
        , HtmlA.disabled active
        ]
        [ text txt ]


editor : Model -> Html Msg
editor m =
    let
        btn =
            if m.theme == darkTheme then
                themeBtn m.theme "Light" (m.theme == colorTheme) colorTheme.colors.headerBg <| ThemeSet colorTheme

            else
                themeBtn m.theme "Dark" (m.theme == darkTheme) darkTheme.colors.headerBg <| ThemeSet darkTheme
    in
    form
        [ css [ displayFlex, alignItems center ] ]
        [ p [ css [ Theme.inline m.theme.spacing.space_m ] ] [ text "Change theme: " ]
        , btn
        ]


view : Model -> Html Msg
view m =
    nav
        [ css
            [ Theme.inset m.theme.spacing.space_s
            , backgroundColor m.theme.colors.headerBg
            , borderBottom3 (px 1) solid m.theme.colors.headerBtmBrdr
            , displayFlex
            , alignItems center
            , justifyContent center
            ]
        ]
        [ homeLink m
        , editor m
        ]
