module Main exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Car as Product
import CarView as ProductView
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
    | ListProductsPage Product.Model
    | ProductView ProductView.Model



---- UPDATE ----


type Msg
    = ListProductsPageMsg Product.Msg
    | ProductViewPageMsg ProductView.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ProductViewPageMsg subMsg, ProductView pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ProductView.update subMsg pageModel
            in
            ( { model | page = ProductView updatedPageModel }
            , Cmd.map ProductViewPageMsg updatedCmd
            )

        ( ListProductsPageMsg subMsg, ListProductsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Product.update subMsg pageModel
            in
            ( { model | page = ListProductsPage updatedPageModel }
            , Cmd.map ListProductsPageMsg updatedCmd
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

        ListProductsPage pageModel ->
            Product.view pageModel
                |> map ListProductsPageMsg

        ProductView pageModel ->
            ProductView.view pageModel
                |> map ProductViewPageMsg


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

                Route.ProductView productId ->
                    let
                        ( pageModel, _ ) =
                            ProductView.init
                    in
                    ( ProductView pageModel, Cmd.map ProductViewPageMsg (ProductView.loadActiveProduct productId) )

                Route.Products ->
                    let
                        ( pageModel, pageCmds ) =
                            Product.init
                    in
                    ( ListProductsPage pageModel, Cmd.map ListProductsPageMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )
