module Header exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Theme exposing (Model, inset)



---- MODEL ----


type alias Model =
    { editorExpanded : Bool
    , theme : Theme.Model
    }



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
            ]
        ]
        [ text "carwow" ]


view : Model -> Html msg
view m =
    nav
        [ css
            [ Theme.inset m.theme.spacing.space_s
            , backgroundColor m.theme.colors.primary_100
            , borderBottom3 (px 1) solid m.theme.colors.primary_200
            ]
        ]
        [ homeLink m
        ]
