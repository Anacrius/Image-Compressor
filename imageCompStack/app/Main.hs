{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Compressor
import MyErrors
import IsDigit
import ImageParser

import System.Environment

main :: IO()
main = do
    args    <- getArgs
    check args
    where
        check args
            | length args /= 4                      = errorPrinter InvalidParams
            | not (intBool (head args))             = errorPrinter InvalidN
            | not (isShort (read (head args)::Int)) = errorPrinter InvalidN
            | not (floatBool (args !! 1))           = errorPrinter InvalidE
            | (read $ args !! 3) > 1                = errorPrinter InvalidV
            | otherwise =   initImage (read (head args)::Int) (read (args !! 1)::Float) (args !! 2) (read $ args !! 3)