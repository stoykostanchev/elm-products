module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Json.Decode exposing (Decoder, field, int, list, maybe, string, succeed)
import Json.Decode.Extra exposing (andMap)



---- MODEL ----


type alias Model =
    { cars : List Car
    , activeCar : Maybe Car
    }


type alias Car =
    { id : Int
    , make : String
    , model : String
    , imgUrl : String
    , rrp : Int
    , summary : String
    , carwowRating : Int
    , availableColors : Maybe (List String)
    , recommendedEngine : Maybe String
    }


decodeCarFullDetails : Decoder Car
decodeCarFullDetails =
    succeed Car
        |> andMap (field "id" int)
        |> andMap (field "make" string)
        |> andMap (field "model" string)
        |> andMap (field "imgUrl" string)
        |> andMap (field "rrp" int)
        |> andMap (field "summary" string)
        |> andMap (field "carwowrating" int)
        |> andMap (field "availableColors" (maybe (list string)))
        |> andMap (field "recommendedEngine" (maybe string))


init : ( Model, Cmd Msg )
init =
    ( { cars = []
      , activeCar = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
