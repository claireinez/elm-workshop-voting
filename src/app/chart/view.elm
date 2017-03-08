module App.Chart.View exposing (chart)

import App.Shared exposing (Msg)
import Svg exposing (Svg, svg, g, rect)
import Svg.Attributes exposing (height, width, viewBox, x, y, fill, fontSize, textAnchor, color)
import Html.Attributes exposing (style)
import List exposing (map, indexedMap, length, maximum)
import Maybe exposing (withDefault)

barWidth : Int
barWidth = 8

chartStyle : List (String, String)
chartStyle =
  [ ("height", "auto")
  , ("width", "100%")
  ]

bar : (Int, Int) -> (String, Int, Float) -> Svg Msg
bar (xSize, ySize) (label, xPos, yHeight) =
  g []
    [ rect
      [ width (toString barWidth)
      , height (toString yHeight)
      , x (toString (xPos - barWidth // 2))
      , y (toString (toFloat ySize - yHeight))
      , fill "#FFBD24"
      ] []
    , Svg.text_
      [ x (toString xPos)
      , y (toString (toFloat ySize - yHeight - toFloat 7))
      , fontSize "13"
      , color "rgba(255, 255, 255, 0.85)"
      , textAnchor "middle"
      ] [ Svg.text label ]
    ]

bars : List (String, Int)
bars =
  [ ("React", 20)
  , ("Preact", 7)
  , ("Inferno", 5)
  , ("Elm", 10)
  ]

calcBarDimensions : (Int, Int) -> (Int, Int) -> Int -> (String, Int) -> (String, Int, Float)
calcBarDimensions (xSize, ySizeInt) (barsLength, maxVotes) index (name, votes) =
  let
    ySize = toFloat ySizeInt
    xPos = (xSize // barsLength) * index + (xSize // barsLength) // 2
    yHeight = min ySize (toFloat votes / toFloat maxVotes * ySize)
  in
    (name, xPos, yHeight)

calcBarsDimensions : (Int, Int) -> List (String, Int) -> List (String, Int, Float)
calcBarsDimensions dimensions bars =
  let
    barsLength = length bars
    maxVotes = withDefault 0 (maximum (map (\(_, votes) -> votes) bars))
  in
    indexedMap (calcBarDimensions dimensions (barsLength, maxVotes)) bars

chart : (Int, Int) -> Svg Msg
chart dimensions =
  let
    (xSize, ySize) = dimensions
    paddedDimensions = (xSize, ySize - 20)
    barsDimensions = calcBarsDimensions paddedDimensions bars
  in
    svg
      [ height (toString ySize)
      , width (toString xSize)
      , viewBox "0 0 450 300"
      , style chartStyle
      ]
      [ g []
        (map (\x -> bar dimensions x) barsDimensions)
      ]
