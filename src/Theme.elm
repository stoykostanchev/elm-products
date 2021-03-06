module Theme exposing (..)

import Css exposing (..)
import Css.Global exposing (global, selector)
import Css.Media exposing (..)
import Html.Styled exposing (..)



---- MODEL ----


type alias Typography =
    { h1 : Rem
    , h2 : Rem
    , h3 : Rem
    , h4 : Rem
    , h5 : Rem
    , p : Rem
    , helper : Rem
    , copyright : Rem
    , fontFamilies : List String
    }


type alias Colors =
    { bodyBg : Color
    , bodyLargeViewSideBg : Color
    , buttonPrimaryBg : Color
    , buttonPrimaryBrdr : Color
    , buttonPrimaryDisabledBrdr : Color
    , buttonPrimaryHoverBg : Color
    , buttonPrimaryHoverBrdr : Color
    , cardActiveProductBg : Color
    , cardBg : Color
    , cardBrdr : Color
    , headerBg : Color
    , headerBtmBrdr : Color
    , starActive : Color
    , starInactive : Color
    , text : Color
    , textInverted : Color
    }


type alias Spacing =
    { space_default : Float
    , space_xs : Float
    , space_s : Float
    , space_m : Float
    , space_l : Float
    , space_xl : Float
    , space_xxxl : Float
    }


type alias Model =
    { colors : Colors
    , spacing : Spacing
    , typography : Typography
    }


colorTheme : Model
colorTheme =
    { colors =
        { bodyBg = hex "#f6f7fa"
        , bodyLargeViewSideBg = hex "#f6f7fa"
        , buttonPrimaryBg = hex "#054a23" --hex "#2ecc71"
        , buttonPrimaryBrdr = rgba 0 0 0 0
        , buttonPrimaryDisabledBrdr = rgba 0 0 0 0
        , buttonPrimaryHoverBg = hex "#54d98c"
        , buttonPrimaryHoverBrdr = rgba 0 0 0 0
        , cardActiveProductBg = rgb 255 255 255
        , cardBg = rgb 255 255 255
        , cardBrdr = hex "#dedede"
        , headerBtmBrdr = hex "#00a4ff"
        , headerBg = hex "#00a4ff"
        , starActive = hex "#ffa500"
        , starInactive = rgb 150 150 150
        , text = rgb 255 255 255
        , textInverted = hex "#3d414a"
        }
    , spacing =
        { space_default = 16
        , space_xs = 4
        , space_s = 8
        , space_m = 16
        , space_l = 32
        , space_xl = 64
        , space_xxxl = 1188
        }
    , typography =
        -- https://type-scale.com/, Major Third 1.250 with 10px (62.5%) as a base unit
        { h1 = rem 4.767
        , h2 = rem 3.815
        , h3 = rem 3.052
        , h4 = rem 2.44
        , h5 = rem 1.953
        , p = rem 1.563
        , helper = rem 1.25
        , copyright = rem 1
        , fontFamilies = [ "proxima-nova-1", "Roboto" ]
        }
    }


darkTheme : Model
darkTheme =
    let
        newColors =
            { bodyBg = rgb 80 80 80
            , bodyLargeViewSideBg = rgb 40 40 40
            , buttonPrimaryBg = rgb 140 130 80
            , buttonPrimaryBrdr = rgb 130 130 130
            , buttonPrimaryDisabledBrdr = rgb 100 100 100
            , buttonPrimaryHoverBg = rgb 100 100 70
            , buttonPrimaryHoverBrdr = rgb 130 130 130
            , cardActiveProductBg = rgb 100 100 100
            , cardBg = rgb 80 80 80
            , cardBrdr = rgb 120 120 120
            , headerBtmBrdr = hex "#787878"
            , headerBg = hex "#787878"
            , starActive = hex "#daa520"
            , starInactive = rgb 150 150 150
            , text = rgb 225 225 225
            , textInverted = rgb 255 255 255
            }

        newTypography =
            { h1 = rem 7.478
            , h2 = rem 5.61
            , h3 = rem 4.209
            , h4 = rem 3.157
            , h5 = rem 2.369
            , p = rem 1.777
            , helper = rem 1.333
            , copyright = rem 0.75
            , fontFamilies = [ "monospace" ]
            }
    in
    { colorTheme | colors = newColors, typography = newTypography }


init : ( Model, Cmd msg )
init =
    ( darkTheme
    , Cmd.none
    )



---- PROGRAM ----
--https://medium.com/eightshapes-llc/space-in-design-systems-188bcbae0d62


stack : Float -> Style
stack f =
    Css.batch
        [ margin3 (px 0) (px 0) (px f)
        ]


inline : Float -> Style
inline f =
    Css.batch
        [ margin4 (px 0) (px f) (px 0) (px 0)
        ]


inset : Float -> Style
inset f =
    Css.batch
        [ padding <| px f
        ]


themeStyles : Model -> Html msg
themeStyles model =
    global
        [ selector "html"
            [ backgroundColor model.colors.bodyLargeViewSideBg
            , padding <| px 0
            , margin <| px 0
            , fontSize <| pct 62.5
            , fontFamilies model.typography.fontFamilies
            ]
        , selector "body"
            [ Css.color model.colors.textInverted
            , backgroundColor model.colors.bodyBg
            , margin2 (px 0) auto
            , Css.maxWidth <| px model.spacing.space_xxxl
            , Css.minHeight <| vh 100
            ]
        , selector "*"
            [ boxSizing borderBox ]
        , selector "h1" [ fontSize <| model.typography.h1, stack model.spacing.space_xl ]
        , selector "h2" [ fontSize <| model.typography.h2, stack model.spacing.space_l ]
        , selector "h3" [ fontSize <| model.typography.h3, stack model.spacing.space_m ]
        , selector "h4" [ fontSize <| model.typography.h4 ]
        , selector "h5" [ fontSize <| model.typography.h5 ]
        , selector "h4, h5, ul" [ stack model.spacing.space_m ]
        , selector "p, a, button, strong" [ fontSize <| model.typography.p, stack model.spacing.space_s ]
        , selector "h1, h2, h3, h4, h5, p, strong" [ padding <| px 0 ]
        ]


over : Float -> List Style -> Style
over x =
    withMedia
        [ only screen
            [ Css.Media.minWidth (px x)
            ]
        ]


overS : List Style -> Style
overS =
    over 568


overM : List Style -> Style
overM =
    over 768


overL : List Style -> Style
overL =
    over 1024
