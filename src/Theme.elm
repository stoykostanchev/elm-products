module Theme exposing (..)

import Css exposing (..)
import Css.Global exposing (global, selector)
import Html.Styled exposing (..)



---- MODEL ----


type alias Typography =
    { h1 : Float
    , h2 : Float
    , h3 : Float
    , h4 : Float
    , h5 : Float
    , p : Float
    , helper : Float
    , copyright : Float
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
    { space_default : Int
    , space_xs : Int
    , space_s : Int
    , space_m : Int
    , space_l : Int
    , space_xl : Int
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
        , neutral_100 = rgb 120 120 120
        , neutral_200 = rgb 120 120 120
        , neutral_300 = rgb 120 120 120
        , neutral_400 = rgb 120 120 120
        , neutral_500 = rgb 120 120 120
        , text = rgb 120 120 120
        , textInverted = rgb 120 120 120
        }
    , spacing =
        { space_default = 16
        , space_xs = 4
        , space_s = 8
        , space_m = 16
        , space_l = 32
        , space_xl = 64
        }
    , typography =
        { h1 = 1.8
        , h2 = 1.6
        , h3 = 1.4
        , h4 = 1.2
        , h5 = 1.1
        , p = 1
        , helper = 0.8
        , copyright = 0.7
        }
    }


init : ( Model, Cmd msg )
init =
    ( defaultTheme
    , Cmd.none
    )


themeStyles : Model -> Html msg
themeStyles model =
    global
        [ selector "body"
            [ color model.colors.text
            ]
        ]
