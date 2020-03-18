module Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, top)


type Route
    = NotFound
    | Products
    | ProductDetails Int


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Products top
        , map Products (s "products")
        , map ProductDetails (s "product" </> int)
        ]
