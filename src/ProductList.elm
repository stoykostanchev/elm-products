module ProductList exposing (..)

import Button exposing (..)
import Css exposing (..)
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
        |> andMap (field "id" Json.Decode.int)
        |> andMap (field "make" string)
        |> andMap (field "model" string)
        |> andMap (field "img_url" string)
        |> andMap (field "rrp" Json.Decode.int)
        |> andMap (field "summary" string)
        |> andMap (field "carwow_rating" Json.Decode.int)
        |> andMap (maybe (field "available_colors" (Json.Decode.list string)))
        |> andMap (maybe (field "recommended_engine" string))


decodeProducts : Decoder (List Product)
decodeProducts =
    Json.Decode.list decodeProductFullDetails


init : Theme.Model -> ( Model, Cmd Msg )
init theme =
    ( { products = []
      , err = Nothing
      , theme = theme
      }
    , loadProducts
    )



---- UPDATE ----


type Msg
    = ProductsLoaded (Result Http.Error (List Product))
    | ThemeChanged Theme.Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ThemeChanged t ->
            ( { model | theme = t }, Cmd.none )

        ProductsLoaded r ->
            case r of
                Ok products ->
                    ( { model | products = products }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | err = Just "Error loading products..." }
                    , Cmd.none
                    )



---- VIEW ----


marginLeftIfDevisible : Int -> Int -> Float -> Style
marginLeftIfDevisible i n size =
    marginLeft <|
        px <|
            -- only the Ith item MUST have a left margin
            if remainderBy n i == 0 then
                size

            else
                0


productCard : Theme.Model -> Int -> Product -> Html Msg
productCard t i c =
    li
        [ class "product"
        , css
            [ listStyle none
            , borderRadius <| px 5
            , border3 (px 1) solid t.colors.cardBrdr
            , backgroundColor t.colors.cardBg
            , margin <| px t.spacing.space_m
            , padding <| px t.spacing.space_m
            , marginTop <| px t.spacing.space_m
            , marginRight <| px t.spacing.space_m
            , marginBottom <| px 0
            , displayFlex
            , flexDirection column
            , Theme.overL
                [ Css.width (calc (pct 25) minus (px ((5 / 4) * t.spacing.space_m)))
                , marginLeftIfDevisible i 4 t.spacing.space_m
                ]
            , Theme.overM
                [ Css.width (calc (pct ((1.0 / 3.0) * 100)) minus (px ((4 / 3) * t.spacing.space_m)))
                , marginLeftIfDevisible i 3 t.spacing.space_m
                ]
            , Theme.overS
                [ Css.width (calc (pct 50) minus (px ((3 / 2) * t.spacing.space_m)))
                , marginLeftIfDevisible i 2 t.spacing.space_m
                ]
            ]
        ]
        [ img
            [ src c.imgUrl
            , css [ Css.width <| pct 100 ]
            ]
            []
        , h4 [ css [ displayFlex ] ]
            [ div [ css [ flex <| num 1 ] ] [ text c.model ]
            , div []
                [ text <| "£" ++ String.fromInt c.rrp
                , p [ css [ float right, fontSize t.typography.helper ] ] [ text " rrp" ]
                ]
            ]
        , strong [] [ text c.make ]
        , p
            [ css
                [ flex <| num 1
                ]
            ]
            [ text c.summary ]
        , p [ css [ displayFlex ] ]
            [ div [ css [ flex <| num 1 ] ] [ text "Our rating:" ]
            , div [] [ strong [] [ text <| String.fromInt c.carwowRating ], text "/10" ]
            ]
        , a
            [ href ("/elm-products/build/#/product/" ++ String.fromInt c.id)
            , css
                [ primaryBtnStyle t
                ]
            ]
            [ text "View details" ]
        ]


view : Model -> Html Msg
view model =
    section []
        [ ul
            [ css
                [ paddingLeft <| px 0
                , margin <| px 0
                , paddingBottom <| px model.theme.spacing.space_m
                , Theme.overS
                    [ displayFlex
                    , flexWrap Css.wrap
                    ]
                ]
            ]
            (List.indexedMap
                (productCard model.theme)
                model.products
            )
        ]



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
