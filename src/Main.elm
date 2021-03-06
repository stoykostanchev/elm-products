module Main exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Css exposing (hex, rgb)
import Debug exposing (log, toString)
import Header exposing (..)
import Html.Styled exposing (..)
import ProductDetails
import ProductList
import Route exposing (Route)
import Theme
import Url exposing (Url)



---- MODEL ----


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    , theme : Theme.Model
    }


type Page
    = NotFoundPage
    | ProductListPage ProductList.Model
    | ProductDetailsPage ProductDetails.Model



---- UPDATE ----


type Msg
    = ProductListMsg ProductList.Msg
    | ProductDetailsMsg ProductDetails.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
    | ThemeChanged Header.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ThemeChanged (ThemeSet theme), page ) ->
            let
                newModel =
                    { model | theme = theme }

                ( pageUpdatedModel, updatedCmd ) =
                    case page of
                        ProductDetailsPage pageModel ->
                            let
                                ( a, b ) =
                                    ProductDetails.update (ProductDetails.ThemeChanged theme) pageModel
                            in
                            ( { newModel | page = ProductDetailsPage a }, Cmd.map ProductDetailsMsg b )

                        ProductListPage pageModel ->
                            let
                                ( a, b ) =
                                    ProductList.update (ProductList.ThemeChanged theme) pageModel
                            in
                            ( { newModel | page = ProductListPage a }, Cmd.map ProductListMsg b )

                        NotFoundPage ->
                            ( newModel, Cmd.none )
            in
            ( pageUpdatedModel, updatedCmd )

        -- , Cmd.none
        ( ProductDetailsMsg subMsg, ProductDetailsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ProductDetails.update subMsg pageModel
            in
            ( { model | page = ProductDetailsPage updatedPageModel }
            , Cmd.map ProductDetailsMsg updatedCmd
            )

        ( ProductListMsg subMsg, ProductListPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ProductList.update subMsg pageModel
            in
            ( { model | page = ProductListPage updatedPageModel }
            , Cmd.map ProductListMsg updatedCmd
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
            if newRoute /= model.route then
                ( { model | route = newRoute }, Cmd.none )
                    |> initCurrentPage

            else
                ( model, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Document Msg
view model =
    { title = "Carwow"
    , body =
        List.map toUnstyled
            [ Theme.themeStyles model.theme
            , Header.view { editorExpanded = False, theme = model.theme }
                |> map ThemeChanged
            , main_ [] [ currentView model ]
            ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView

        ProductListPage pageModel ->
            ProductList.view pageModel
                |> map ProductListMsg

        ProductDetailsPage pageModel ->
            ProductDetails.view pageModel
                |> map ProductDetailsMsg


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
        ( themeModel, _ ) =
            Theme.init

        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            , theme = themeModel
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

                Route.ProductDetails productId ->
                    let
                        ( pageModel, _ ) =
                            ProductDetails.init model.theme
                    in
                    ( ProductDetailsPage pageModel, Cmd.map ProductDetailsMsg (ProductDetails.loadActiveProduct productId) )

                Route.Products ->
                    let
                        ( pageModel, pageCmds ) =
                            ProductList.init model.theme
                    in
                    ( ProductListPage pageModel, Cmd.map ProductListMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )
