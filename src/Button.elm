module Button exposing (..)

import Css exposing (..)
import Css.Transitions exposing (backgroundColor, color, transition)
import Theme exposing (..)


type alias Model =
    Theme.Model


primaryBtnStyle : Model -> Style
primaryBtnStyle t =
    Css.batch
        [ Css.backgroundColor t.colors.buttonPrimaryBg
        , border3 (px 1) solid t.colors.buttonPrimaryBrdr
        , Css.color t.colors.text
        , letterSpacing (px 1)
        , cursor pointer
        , transition
            [ Css.Transitions.backgroundColor 200
            , Css.Transitions.color 200
            ]
        , hover
            [ Css.backgroundColor t.colors.buttonPrimaryHoverBg
            , borderColor t.colors.buttonPrimaryHoverBrdr
            , Css.color t.colors.textInverted
            ]
        , display block
        , textAlign center
        , borderRadius <| px 5
        , textDecoration none
        , margin <| px 0
        , padding <| px t.spacing.space_m
        ]
