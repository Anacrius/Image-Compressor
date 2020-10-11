--  
-- EPITECH PROJECT, 2020
-- FUN Project #1 : Wolfram - Cellular automaton
-- File description:
-- Errors file
--

module MyErrors where

import System.Exit
import System.IO


data CustomError    = InvalidParams
                    | InvalidN
                    | InvalidE
                    | InvalidV
                    | InvalidIN String
                    | MiscError String

instance Show CustomError where
    show InvalidParams  = "USAGE: ./imageCompressor n e IN v\n\n"
                        ++ "\tn\tnumber of colors in the final image\n"
                        ++ "\te\tconvergence limit\n"
                        ++ "\tIN      path to the file containing the colors of the pixels\n"
                        ++ "\tv       turn visualizer on (1) or off (0)"
    show InvalidN       = "n parameter need to be an int from 1 to 255"
    show InvalidE       = "e parameter need to be a float value"
    show InvalidV       = "v parameter need to be 0 or 1"
    show (InvalidIN str) = "can't open/find the file on the following path: " ++ str
    show (MiscError str) = str

errorPrinter msg = do
    hPutStrLn stderr $ "\x1b[31mError:\x1b[0m " ++ (show msg)
    exitWith         $ ExitFailure 84

type    ErrorM  =   Either CustomError
