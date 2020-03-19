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
    { primary_100 : Color
    , primary_200 : Color
    , primary_300 : Color
    , primary_400 : Color
    , primary_500 : Color
    , neutral_100 : Color
    , neutral_200 : Color
    , neutral_300 : Color
    , neutral_400 : Color
    , neutral_500 : Color
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


defaultTheme : Model
defaultTheme =
    { colors =
        { primary_100 = rgb 120 120 120
        , primary_200 = rgb 120 120 120
        , primary_300 = rgb 120 120 120
        , primary_400 = rgb 120 120 120
        , primary_500 = rgb 120 120 120
        , neutral_300 = rgb 120 120 120
        , neutral_200 = rgb 80 80 80
        , neutral_100 = rgb 40 40 40
        , neutral_400 = rgb 120 120 120
        , neutral_500 = rgb 120 120 120
        , text = rgb 0 0 0
        , textInverted = rgb 255 255 255
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
        { h1 = rem 1.8
        , h2 = rem 1.6
        , h3 = rem 1.4
        , h4 = rem 1.2
        , h5 = rem 1.1
        , p = rem 1
        , helper = rem 0.8
        , copyright = rem 0.7
        , fontFamilies = [ "proxima-nova-1", "Roboto" ]
        }
    }


init : ( Model, Cmd msg )
init =
    ( defaultTheme
    , Cmd.none
    )



---- PROGRAM ----


themeStyles : Model -> Html msg
themeStyles model =
    global
        [ selector "html"
            [ backgroundColor model.colors.neutral_100
            , padding <| px 0
            , margin <| px 0
            , fontFamilies model.typography.fontFamilies
            ]
        , selector "body"
            [ Css.color model.colors.textInverted
            , backgroundColor model.colors.neutral_200
            , margin2 (px 0) auto
            , Css.maxWidth <| px model.spacing.space_xxxl
            ]
        , selector "*"
            [ boxSizing borderBox ]
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
