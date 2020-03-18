module Main exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Car
import CarView
import Debug exposing (log, toString)
import Html.Styled exposing (..)
import Route exposing (Route)
import Url exposing (Url)



---- MODEL ----


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | ListCarsPage Car.Model
    | CarView CarView.Model



---- UPDATE ----


type Msg
    = ListCarsPageMsg Car.Msg
    | CarViewPageMsg CarView.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( CarViewPageMsg subMsg, CarView pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    CarView.update subMsg pageModel
            in
            ( { model | page = CarView updatedPageModel }
            , Cmd.map CarViewPageMsg updatedCmd
            )

        ( ListCarsPageMsg subMsg, ListCarsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Car.update subMsg pageModel
            in
            ( { model | page = ListCarsPage updatedPageModel }
            , Cmd.map ListCarsPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( _, _ ) ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Document Msg
view model =
    { title = "Carwow"
    , body = [ toUnstyled (currentView model) ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView

        ListCarsPage pageModel ->
            Car.view pageModel
                |> map ListCarsPageMsg

        CarView pageModel ->
            CarView.view pageModel
                |> map CarViewPageMsg


notFoundView : Html Msg
notFoundView =
    h1 [] [ text "404 Page Not Found!" ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.CarView carId ->
                    let
                        ( pageModel, _ ) =
                            CarView.init
                    in
                    ( CarView pageModel, Cmd.map CarViewPageMsg (CarView.loadActiveCar carId) )

                Route.Cars ->
                    let
                        ( pageModel, pageCmds ) =
                            Car.init
                    in
                    ( ListCarsPage pageModel, Cmd.map ListCarsPageMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )
