--IN      ::= POINT ' ' COLOR ('\n' POINT ' ' COLOR)*

--OUT   ::= CLUSTER*
--CLUSTER   ::= '--\n' COLOR '\n-\n' (POINT ' ' COLOR '\n')*

--POINT ::= '(' int ',' int ')'
--COLOR ::= '(' SHORT ',' SHORT ',' SHORT ')'
--SHORT ::= '0'..'255'

module MyData where

data Color = Color  { red :: Int
                    , green :: Int
                    , blue :: Int
                    } deriving Show

data Point = Point  { x :: Int
                    , y :: Int
                    } deriving Show

data Pixel = Pixel  { point :: Point
                    , color :: Color
                    } deriving Show

data Cluster = Cluster  { ccolor :: Color
                        , pixels :: [Pixel]
                        } deriving Show

toShort :: Int -> Int
toShort num | num >= 0 && num <= 255 = num
            | otherwise              = error "\nStack overflow short :)"

toColor :: Int -> Int -> Int -> Color
toColor a b c = Color (toShort a) (toShort b) (toShort c)

sumColor :: Color -> Color -> Color
sumColor col1 col2 = Color (red col1 + red col2) (green col1 + green col2) (blue col1 + blue col2)

divColor :: Color -> Int -> Color
divColor col1 diviseur
        | diviseur == 0 = Color 0 0 0
        | otherwise = Color (red col1 `div` diviseur) (green col1 `div` diviseur) (blue col1 `div` diviseur)

printColor :: Color -> IO ()
printColor color = putStrLn ("(" ++ show (red color) ++ "," ++ show (green color) ++ "," ++ show (blue color) ++ ")")

printPoint :: Point -> IO ()
printPoint point = putStr ("(" ++ show (x point) ++ "," ++ show (y point) ++ ")")

sumPixelsColors :: [Pixel] -> Color
sumPixelsColors = foldr (sumColor . color) (Color 0 0 0)

printPixel :: Pixel -> IO ()
printPixel (Pixel point color) = do
    printPoint point
    putStr " "
    printColor color

printPixels :: [Pixel] -> IO ()
printPixels [] = putStr ""
printPixels (x:xs) = do
    printPixels xs
    printPixel x

instance Eq Cluster where
    (Cluster color1 pixels1) == (Cluster color2 pixels2) = (red color1 == red color2) && (green color1 == green color2) && (blue color1 == blue color2)

printCluster :: Cluster -> IO ()
printCluster (Cluster ccolor pixels) = do
    putStrLn "--"
    printColor ccolor
    putStrLn "-"
    printPixels pixels

printClusters :: [Cluster] -> IO ()
printClusters [] = putStr ""
printClusters (x:xs) = do
    printClusters xs
    printCluster x