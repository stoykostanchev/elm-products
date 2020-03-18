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
    { products : List Product
    , err : Maybe String
    , theme : Theme.Model
    }


type alias Product =
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


decodeProductFullDetails : Decoder Product
decodeProductFullDetails =
    succeed Product
        |> andMap (field "id" int)
        |> andMap (field "make" string)
        |> andMap (field "model" string)
        |> andMap (field "img_url" string)
        |> andMap (field "rrp" int)
        |> andMap (field "summary" string)
        |> andMap (field "carwow_rating" int)
        |> andMap (maybe (field "available_colors" (Json.Decode.list string)))
        |> andMap (maybe (field "recommended_engine" string))


decodeProducts : Decoder (List Product)
decodeProducts =
    Json.Decode.list decodeProductFullDetails


init : ( Model, Cmd Msg )
init =
    let
        ( theme, _ ) =
            Theme.init
    in
    ( { products = []
      , err = Nothing
      , theme = theme
      }
    , loadProducts
    )



---- UPDATE ----


type Msg
    = ProductsLoaded (Result Http.Error (List Product))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductsLoaded r ->
            case r of
                Ok products ->
                    ( { model | products = products }
                    , Cmd.none
                    )

                Err e ->
                    ( { model | err = Just (toString e) }
                    , Cmd.none
                    )



---- VIEW ----


productCard : Theme.Model -> Product -> Html Msg
productCard t c =
    div
        [ class "product"
        , css
            [ borderColor t.colors.primary_100
            ]
        ]
        [ h2 [] [ text c.model ]
        , img [ src c.imgUrl ] []
        , p [] [ text c.model ]
        , a [ href ("/product/" ++ String.fromInt c.id) ] [ text "View details" ]
        , p [] [ text ("Theme data available:" ++ String.fromFloat t.typography.h1) ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ Theme.themeStyles model.theme
        , div
            []
            (List.map
                (productCard model.theme)
                model.products
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


getProduct : Maybe Int -> String
getProduct id =
    case id of
        Just param ->
            formUrl "/" ++ String.fromInt param

        Nothing ->
            formUrl "s"


getAllProducts : String
getAllProducts =
    getProduct Nothing


loadProducts : Cmd Msg
loadProducts =
    Http.get
        { url = getAllProducts
        , expect = Http.expectJson ProductsLoaded decodeProducts
        }
