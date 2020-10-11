--
-- EPITECH PROJECT, 2020
-- FUN Project #1 : Wolfram - Cellular automaton
-- File description:
-- isDigit func for [Char]
--

module IsDigit where

-- Bool to check if the int is between 0 and 256 (excl)
isShort :: Int -> Bool
isShort a = a > 0 && a < 256

-- Bool to check if a char is a num or a dot
isFloat :: Char -> Int
isFloat a
    | a `elem` "." = 2
    | a `elem` "0123456789" = 1
    | otherwise = 0

-- Bool to loop isFloat (then intBool when the first dot is found)
floatBool' :: String -> Bool
floatBool' [] = False
floatBool' [a] = odd (isFloat a)
floatBool' (a:xa)
    | isFloat a == 0 = False
    | isFloat a == 2 = intBool xa
    | otherwise = floatBool' xa

-- Init to check if i starts by a dot or not having any dots
floatBool :: String -> Bool
floatBool [a] = False
floatBool [] = False
floatBool (a:xa)
    | a == '.' = False
    | intBool xa = False
    | otherwise = floatBool' (a:xa)

-- Bool to check if a char is a num 0..9
isDigit' :: Char -> Bool
isDigit' a = a `elem` "0123456789"

-- Bool to loop isDigit'
intBool :: String -> Bool
intBool [] = False
intBool [a] = isDigit' a
intBool (a:xa)
    | not (isDigit' a) = False
    | otherwise = intBool xa