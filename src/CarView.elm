module CarView exposing (..)

import Browser
import Car exposing (Car, decodeCarFullDetails, getCar)
import Debug exposing (toString)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Http
import Theme



---- MODEL ----


type alias Model =
    { activeCar : Maybe Car
    , theme : Theme.Model
    , err : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    let
        ( theme, _ ) =
            Theme.init
    in
    ( { activeCar = Nothing
      , theme = theme
      , err = Nothing
      }
    , Cmd.none
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
                    ( { model | activeCar = Just car }
                    , Cmd.none
                    )

                Err e ->
                    ( { model | activeCar = Nothing, err = Just (toString e) }
                    , Cmd.none
                    )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ case model.activeCar of
            Just car ->
                div [ class "car-view" ]
                    [ h1 [] [ text ("Selected car: " ++ car.model) ]
                    ]

            Nothing ->
                case model.err of
                    Just a ->
                        h1 [] [ text a ]

                    Nothing ->
                        text ""
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



---- HTTP ----


loadActiveCar : Int -> Cmd Msg
loadActiveCar n =
    Http.get
        { url = getCar (Just n)
        , expect = Http.expectJson ActiveCarLoaded decodeCarFullDetails
        }
