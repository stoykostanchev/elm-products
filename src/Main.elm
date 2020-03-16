module Main exposing (..)

import Browser
import Debug exposing (toString)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Http
import Json.Decode exposing (Decoder, field, int, list, maybe, string, succeed)
import Json.Decode.Extra exposing (andMap)



---- MODEL ----


type alias Model =
    { cars : List Car
    , activeCar : Maybe Car
    , err : Maybe String
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
        |> andMap (field "img_url" string)
        |> andMap (field "rrp" int)
        |> andMap (field "summary" string)
        |> andMap (field "carwow_rating" int)
        |> andMap (maybe (field "available_colors" (list string)))
        |> andMap (maybe (field "recommended_engine" string))


init : ( Model, Cmd Msg )
init =
    ( { cars = []
      , activeCar = Nothing
      , err = Nothing
      }
    , loadActiveCar
    )



---- UPDATE ----


type Msg
    = ActiveCarLoaded (Result Http.Error Car)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ActiveCarLoaded r ->
            case r of
                Ok car ->
                    ( { cars = [ car ]
                      , activeCar = Just car
                      , err = Nothing
                      }
                    , Cmd.none
                    )

                Err e ->
                    ( { cars = []
                      , activeCar = Nothing
                      , err = Just (toString e)
                      }
                    , Cmd.none
                    )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ case model.activeCar of
            Just car ->
                img [ src (.imgUrl car) ] []

            Nothing ->
                case model.err of
                    Just a ->
                        h1 [] [ text a ]

                    Nothing ->
                        h1 [] [ text "Unknown" ]
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



-- HTTP


loadActiveCar : Cmd Msg
loadActiveCar =
    Http.get
        { url = "https://warm-dawn-92320.herokuapp.com/model/1"
        , expect = Http.expectJson ActiveCarLoaded decodeCarFullDetails
        }
