module Header exposing (..)

import Button exposing (primaryBtnStyle)
import Css exposing (..)
import Html.Styled exposing (Html, a, button, form, input, nav, text)
import Html.Styled.Attributes as HtmlA exposing (css, disabled, href, type_)
import Html.Styled.Events exposing (custom)
import Json.Decode exposing (succeed)
import Theme exposing (Model, colorTheme, defaultTheme, inset, lightTheme)



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
        [ href "/"
        , css
            [ textDecoration none
            , fontSize <| m.theme.typography.h3
            , fontFamilies [ "cursive" ]
            , position relative
            , top <| rem -0.5
            , color m.theme.colors.textInverted
            , flex <| num 1
            ]
        ]
        [ text "carwow" ]


onClickSetTheme : msg -> Html.Styled.Attribute msg
onClickSetTheme message =
    custom "click" (succeed { message = message, stopPropagation = True, preventDefault = True })


themeBtn : Theme.Model -> String -> Bool -> msg -> Html msg
themeBtn theme txt active msg =
    button
        [ onClickSetTheme msg
        , css [ primaryBtnStyle theme ]
        , HtmlA.disabled active
        ]
        [ text txt ]


editor : Model -> Html Msg
editor m =
    form
        [ css [ displayFlex ] ]
        [ themeBtn m.theme "Light" (m.theme == lightTheme) <| ThemeSet lightTheme
        , themeBtn m.theme "Dark" (m.theme == defaultTheme) <| ThemeSet defaultTheme
        , themeBtn m.theme "Color" (m.theme == colorTheme) <| ThemeSet colorTheme
        ]


view : Model -> Html Msg
view m =
    nav
        [ css
            [ Theme.inset m.theme.spacing.space_s
            , backgroundColor m.theme.colors.headerBg
            , borderBottom3 (px 1) solid m.theme.colors.primary_200
            , displayFlex
            , alignItems center
            , justifyContent center
            ]
        ]
        [ homeLink m
        , editor m
        ]
