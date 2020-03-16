module Car exposing (..)

import Browser
import Debug exposing (toString)
import Html exposing (Html, div, h1, h2, img, p, text)
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


decodeCars : Decoder (List Car)
decodeCars =
    list decodeCarFullDetails


init : ( Model, Cmd Msg )
init =
    ( { cars = []
      , activeCar = Nothing
      , err = Nothing
      }
    , Cmd.batch
        [ loadActiveCar
        , loadCars
        ]
    )



---- UPDATE ----


type Msg
    = ActiveCarLoaded (Result Http.Error Car)
    | CarsLoaded (Result Http.Error (List Car))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CarsLoaded r ->
            case r of
                Ok cars ->
                    ( { model | cars = cars }
                    , Cmd.none
                    )

                Err e ->
                    ( { model | err = Just (toString e) }
                    , Cmd.none
                    )

        ActiveCarLoaded r ->
            case r of
                Ok car ->
                    ( { model | activeCar = Just car }
                    , Cmd.none
                    )

                Err e ->
                    ( { model | activeCar = Nothing, err = Just (toString e) }
                    , Cmd.none
                    )



---- VIEW ----


carView : Car -> Html Msg
carView c =
    div []
        [ h2 [] [ text c.model ]
        , img [ src c.imgUrl ] []
        , p [] [ text c.model ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ case model.activeCar of
                Just car ->
                    div []
                        [ h1 [] [ text ("Selected car: " ++ car.model) ]
                        ]

                Nothing ->
                    case model.err of
                        Just a ->
                            h1 [] [ text a ]

                        Nothing ->
                            h1 [] [ text "Unknown" ]
            ]
        , div
            []
            (List.map
                carView
                model.cars
            )
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


formUrl : String -> String
formUrl =
    (++) "https://warm-dawn-92320.herokuapp.com/model"


getCar : Maybe Int -> String
getCar id =
    case id of
        Just param ->
            formUrl "/" ++ String.fromInt param

        Nothing ->
            formUrl "s"


getAllCars : String
getAllCars =
    getCar Nothing


loadActiveCar : Cmd Msg
loadActiveCar =
    Http.get
        { url = getCar (Just 1)
        , expect = Http.expectJson ActiveCarLoaded decodeCarFullDetails
        }


loadCars : Cmd Msg
loadCars =
    Http.get
        { url = getAllCars
        , expect = Http.expectJson CarsLoaded decodeCars
        }
