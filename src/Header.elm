module Header exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html, a, form, input, nav, text)
import Html.Styled.Attributes exposing (css, href, type_)
import Html.Styled.Events exposing (onInput)
import Theme exposing (Model, inset)



---- MODEL ----


type alias Model =
    { editorExpanded : Bool
    , theme : Theme.Model
    }



---- UPDATE ----


type Msg
    = Primary1Changed String



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


editor : Model -> Html Msg
editor m =
    form
        [ onInput Primary1Changed
        ]
        [ input [ type_ "color" ] []
        ]


view : Model -> Html Msg
view m =
    nav
        [ css
            [ Theme.inset m.theme.spacing.space_s
            , backgroundColor m.theme.colors.primary_100
            , borderBottom3 (px 1) solid m.theme.colors.primary_200
            , displayFlex
            , alignItems center
            , justifyContent center
            ]
        ]
        [ homeLink m
        , editor m
        ]
