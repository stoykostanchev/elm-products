module Car exposing (..)

import Browser
import Css exposing (borderColor, px)
import Debug exposing (toString)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, field, int, list, maybe, string, succeed)
import Json.Decode.Extra exposing (andMap)
import Theme



---- MODEL ----


type alias Model =
    { cars : List Car
    , err : Maybe String
    , theme : Theme.Model
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
        |> andMap (maybe (field "available_colors" (Json.Decode.list string)))
        |> andMap (maybe (field "recommended_engine" string))


decodeCars : Decoder (List Car)
decodeCars =
    Json.Decode.list decodeCarFullDetails


init : ( Model, Cmd Msg )
init =
    let
        ( theme, _ ) =
            Theme.init
    in
    ( { cars = []
      , err = Nothing
      , theme = theme
      }
    , loadCars
    )



---- UPDATE ----


type Msg
    = CarsLoaded (Result Http.Error (List Car))


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



---- VIEW ----


carCard : Theme.Model -> Car -> Html Msg
carCard t c =
    div
        [ class "car"
        , css
            [ borderColor t.colors.primary_100
            ]
        ]
        [ h2 [] [ text c.model ]
        , img [ src c.imgUrl ] []
        , p [] [ text c.model ]
        , a [ href ("/car/" ++ String.fromInt c.id) ] [ text "View details" ]
        , p [] [ text ("Theme data available:" ++ String.fromFloat t.typography.h1) ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ Theme.themeStyles model.theme
        , div
            []
            (List.map
                (carCard model.theme)
                model.cars
            )
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
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


loadCars : Cmd Msg
loadCars =
    Http.get
        { url = getAllCars
        , expect = Http.expectJson CarsLoaded decodeCars
        }
