module Header exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)



---- MODEL ----


type alias Model =
    { backBtnShown : Bool
    , editorExpanded : Bool
    }



---- VIEW ----


homeLink : Model -> Html msg
homeLink m =
    if m.backBtnShown then
        a [ href "/" ] [ text "Home" ]

    else
        text ""


view : Model -> Html msg
view m =
    nav
        [ css
            []
        ]
        [ homeLink m
        ]
