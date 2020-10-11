{-# LANGUAGE ScopedTypeVariables #-}

module ImageParser where

import MyData
import MyErrors
import Compressor

import Text.Read            (readMaybe)
import Data.Maybe           (fromMaybe)
import System.Exit          (exitWith, ExitCode( ExitFailure ) )

import Data.Either          (lefts, rights)
import System.IO            (hPutStrLn, stderr)
import Control.Exception    (IOException, handle)

-- Get the 1st elem of a Tuple of 3
frst :: (t, t, t) -> t
frst (a, _, _) = a

-- Get the 2nd elem of a Tuple of 3
scnd :: (t, t, t) -> t
scnd (_, a, _) = a

-- Get the 3rd elem of a Tuple of 3
thrd :: (t, t, t) -> t
thrd (_, _, a) = a

-- read function for Tuple of 2
toDuple :: String -> Either String (Int, Int)
toDuple st = do
    let a = fromMaybe (-1, -1) (readMaybe st :: Maybe (Int, Int))
    if a /= (-1, -1)
        then Right a
    else
        Left "\x1b[31mError:\x1b[0m Invalid data in the file (failed to create a Point)"

-- read function for Tuple of 3
toTuple :: String -> Either String (Int, Int, Int)
toTuple st = do
    let a = fromMaybe (-1, -1, -1) (readMaybe st :: Maybe (Int, Int, Int))
    if a /= (-1, -1, -1)
        then Right a
    else
        Left "\x1b[31mError:\x1b[0m Invalid data in the file (failed to create a Color)"

--doColor :: String -> Color
--doColor tup = read tup::Color

-- convert a [(x,y) (_,_,_)] into (Point x y)
toPoint :: String -> Either String Point
toPoint st
        | length (lefts [p]) == 1 = Left $ head (lefts [p])
        | otherwise = do
            let dup = head $ rights [p]
            Right $ uncurry Point dup   -- instead of Right $ Point (fst dup) (snd dup)
        where p = toDuple st

-- convert a [(_,_) (_,_,_)] into (Color r g b)
toColor' :: String -> Either String Color
toColor' st
        | length (lefts [c]) == 1 = Left $ head (lefts [c])
        | otherwise = do
            let tup = head $ rights [c]
            Right $ toColor (frst tup) (scnd tup) (thrd tup)
        where c = toTuple st

-- convert a Point and a Color to a Pixel
toPixel :: [String] -> Either String Pixel
toPixel st
        | length st /= 2 = Left $  "\x1b[31mError:\x1b[0m bad file format\n\n"
                                ++ "Example of file content:\n"
                                ++ "(0,0) (120,200,90)\n"
                                ++ "(0,1) (80,100,10)\n"
                                ++ "(1,0) (255,255,255)\n"
                                ++ "(1,1) (0,0,0)\n"
        | not (null (lefts [maybePoint])) = Left $ head (lefts [maybePoint])
        | not (null (lefts [maybeColor])) = Left $ head (lefts [maybeColor])
        | otherwise = Right (Pixel (head (rights [maybePoint])) (head (rights [maybeColor])))
        where   maybePoint = toPoint  $ head st
                maybeColor = toColor' $ st !! 1


initImage :: Int -> Float -> String -> Int -> IO()
initImage n e path v =
    handle (\(e :: IOException) -> hPutStrLn stderr ( "\x1b[31mError:\x1b[0m " ++ show (InvalidIN path)) >> exitWith (ExitFailure 84)) $ do
        h <- readFile path
        let content = pixelConverter h
        check content
        where
            check content
                | not (null (lefts [content])) = errorPrinter (MiscError (head $ lefts [content]))
                | otherwise = imageCompressor n e (head (rights [content])) v


-- Note :
-- l.76 : "not (null (lefts [maybePoint]))"" instead of "length (lefts [maybePoint]) /= 0"
-- it increases laziness (hlint)

pixelConverter :: String -> Either String [Pixel]
pixelConverter content = do
                        let a = map words $ lines content
                            b = map toPixel a
                        check b
                        where
                            check b
                                | not (null (lefts b)) = Left $ head (lefts b)
                                | otherwise = Right $ rights b