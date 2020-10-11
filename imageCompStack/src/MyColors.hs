module MyColors 
( colorAsso
, picture
, drawPic
, printMap
) where

import MyData

import Data.List


distance :: Color -> Color -> Float
distance cluster color =
    let sqr k = k * k
        x = sqr(red cluster - red color)
        y = sqr(green cluster - green color)
        z = sqr(blue cluster - blue color)
    in sqrt (fromIntegral(x + y + z))

-- default var

colorAsso ::    [(Color, String)]
colorAsso =     [ (Color 0   0   0  , c_black)
                , (Color 123 0   0  , c_dred)
                , (Color 0   123 0  , c_dgreen)
                , (Color 255 123 0  , c_orange)
                , (Color 0   0   123, c_dblue)
                , (Color 123 0   255, c_purple)
                , (Color 0   123 123, c_midcyan)
                , (Color 123 123 123, c_lgrey)
                , (Color 200 200 200, c_dgrey)
                , (Color 255 0   0  , c_lred)
                , (Color 0   255 0  , c_lgreen)
                , (Color 255 255 0  , c_yellow)
                , (Color 0   0   255, c_lblue)
                , (Color 255 0   255, c_pink)
                , (Color 0   255 255, c_cyan)
                , (Color 255 255 255, c_white) ]

-- functions for list editing

createLine :: Int -> [String]
createLine x = take x $ repeat " "

createMap :: Int -> Int -> [[String]]
createMap x y = take y $ repeat (createLine x)

deleteNth :: Int -> [a] -> [a]
deleteNth n list =  let (pref, suff) = splitAt n list
                    in  pref ++ (tail suff)

-- splitAt idx list gives back the first part of the list, before the index idx as the first component of the pair, and the rest as the second
-- pref = everything b4 n inside the given list
-- suff = the rest (so we need to apply tail to remove the the wanted element)
replaceNth :: Int -> a -> [a] -> [a]
replaceNth n r list =   let (pref, suff) = splitAt n list
                        in  pref ++ [r] ++ (tail suff)

replace2D :: Int -> Int -> a -> [[a]] -> [[a]]
replace2D x y r llist = let (pref, suff) = splitAt y llist
                        in  pref ++ [replaceNth x r $ head suff] ++ (tail suff)

-- functions for printing

printMap :: [[String]] -> IO ()
printMap pic = mapM_ putStrLn $ map (intercalate "") pic

-- replace to a given x,y pos of a Pixel, the color inside the pic
drawPic'' :: [[String]] -> String -> Pixel -> [[String]]
drawPic'' pic col pix = replace2D _x _y col pic
        where   _x = x $ point pix
                _y = y $ point pix

-- remplace each " " which has the pos inside [Pixel] by the color (col) value
-- one by one by calling drawPic''
drawPic' :: [[String]] -> String  -> [Pixel]-> [[String]]
drawPic' pic col [] = pic
drawPic' pic col [pix] = drawPic'' pic col pix
drawPic' pic col (pix:pixs) = drawPic' (drawPic'' pic col pix) col pixs

-- handle the whole print
-- first loop   : take the neoClosest of the first cluster and the colorAsso (= n);
--              : call drawPic' to print the (asso !! n) color on every x,y pos from clus
drawPic :: [[String]] -> [Cluster] -> [(Color, String)] -> [[String]]
drawPic pic [] asso = pic
drawPic pic (clus:xclus) asso = drawPic (drawPic' pic (snd $ asso !! n) (pixels clus)) xclus (deleteNth n asso)
            where n = neoClose clus asso

picture :: [[String]]
picture =  createMap 20 20

neoClose' :: Color -> [(Color, String)] -> Color -> Int -> Int -> Int
neoClose' col [asso] ccarry icarry pos
    | (distance col ccarry) > distance col (fst asso) = icarry
    | otherwise = icarry - pos
neoClose' col (asso:xasso) ccarry icarry pos
    | (distance col ccarry) > distance col (fst asso) = neoClose' col xasso (fst asso) (icarry + 1) (0)
    | otherwise = neoClose' col xasso ccarry (icarry + 1) (pos + 1)

neoClose :: Cluster -> [(Color, String)] -> Int
neoClose clus asso = neoClose' (ccolor clus) asso (Color 0 0 0) 0 0


-- Colors (16 for now)

c_black :: String -- (0, 0, 0)
c_black = "\x1b[7;30m \x1b[0m"

c_dred :: String -- (123, 0, 0)
c_dred = "\x1b[7;31m \x1b[0m"

c_dgreen :: String -- (0, 123, 0)
c_dgreen = "\x1b[7;32m \x1b[0m"

c_orange :: String -- (255, 123, 0)
c_orange = "\x1b[7;33m \x1b[0m"

c_dblue :: String -- (0, 0, 123)
c_dblue = "\x1b[7;34m \x1b[0m"

c_purple :: String -- (123, 0, 255)
c_purple = "\x1b[7;35m \x1b[0m"

c_midcyan :: String -- (0, 123, 123)
c_midcyan = "\x1b[7;36m \x1b[0m"

c_lgrey :: String -- (123, 123, 123)
c_lgrey = "\x1b[7;37m \x1b[0m"

c_dgrey :: String -- (200, 200, 200)
c_dgrey = "\x1b[7;90m \x1b[0m"

c_lred :: String -- (255, 0, 0)
c_lred = "\x1b[7;91m \x1b[0m"

c_lgreen :: String -- (0, 255, 0)
c_lgreen = "\x1b[7;92m \x1b[0m"

c_yellow :: String -- (255, 255, 0)
c_yellow = "\x1b[7;93m \x1b[0m"

c_lblue :: String -- (0, 0, 255)
c_lblue = "\x1b[7;94m \x1b[0m"

c_pink :: String -- (255, 0, 255)
c_pink = "\x1b[7;95m \x1b[0m"

c_cyan :: String -- (0, 255, 255)
c_cyan = "\x1b[7;96m \x1b[0m"

c_white :: String -- (255, 255, 255)
c_white = "\x1b[7;97m \x1b[0m"