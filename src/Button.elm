module Button exposing (..)

import Css exposing (..)
import Css.Transitions exposing (backgroundColor, color, transition)
import Theme exposing (..)


type alias Model =
    Theme.Model


primaryBtnStyle : Model -> Style
primaryBtnStyle t =
    Css.batch
        [ Css.backgroundColor t.colors.neutral_400
        , border3 (px 1) solid t.colors.neutral_100
        , letterSpacing (px 1)
        , transition
            [ Css.Transitions.backgroundColor 200
            , Css.Transitions.color 200
            ]
        , hover
            [ Css.backgroundColor t.colors.neutral_300
            , borderColor t.colors.neutral_400
            , Css.color t.colors.textInverted
            ]
        , Css.color t.colors.text
        , display block
        , textAlign center
        , borderRadius <| px 5
        , textDecoration none
        , margin <| px 0
        , padding <| px t.spacing.space_m
        ]
