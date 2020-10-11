module Compressor where

import Data.List
import MyData
import MyColors

import System.Random (RandomGen, newStdGen, randoms)

distance :: Color -> Color -> Float
distance cluster color =
    let sqr k = k * k
        x = sqr(red cluster - red color)
        y = sqr(green cluster - green color)
        z = sqr(blue cluster - blue color)
    in sqrt (fromIntegral(x + y + z))

findCloserCluster :: [Cluster] -> Color -> Cluster
findCloserCluster [first] obj = first
findCloserCluster (first:list) obj
    | distance (ccolor first) obj < distance (ccolor res) obj = first
    | otherwise = res
    where res = findCloserCluster list obj

linkPixelCluster :: [Cluster] -> [Pixel] -> [Cluster]
linkPixelCluster clusters [] = clusters
linkPixelCluster clusters (x:xs) =
    do
        let closest = findCloserCluster clusters (color x)
            newListClusters = delete closest clusters
            newCluster = Cluster (ccolor closest) (x : pixels closest)
        linkPixelCluster (newCluster : newListClusters) xs

nextClusters :: [Cluster] -> [Cluster]
nextClusters [] = []
nextClusters (x:xs)
    | len == 0  = Cluster (Color 0 0 0) [] : nextClusters xs
    | otherwise = Cluster newColor [] : nextClusters xs
    where   sum = sumPixelsColors (pixels x)
            len = length (pixels x)
            newColor = divColor sum len

checkLimit :: [Cluster] -> [Cluster] -> Float -> Bool
checkLimit [] [] limit = True
checkLimit (x:xs) (y:ys) limit
    | distance (ccolor x) (ccolor y) >= limit = False
    | otherwise = checkLimit xs ys limit

-- first clusters are random and first pixels come from the input
compressor :: [Cluster] -> [Pixel] -> Float -> [Cluster]
compressor lastClusters pixels limit = do
    let newClusters = linkPixelCluster (nextClusters lastClusters) pixels
    if checkLimit lastClusters newClusters limit == False
        then compressor newClusters pixels limit
    else newClusters

-- 1st function to be call call

imageCompressor :: Int -> Float -> [Pixel] -> Int -> IO()
imageCompressor n e iN v = do
    g <- newStdGen
    let clusters = randomClusters n (randomInt g (n * 3))
        final_clusters = compressor (linkPixelCluster clusters iN) iN e
    if v == 1
        then printMap (drawPic picture final_clusters colorAsso)
    else printClusters final_clusters

randomInt :: RandomGen g => g -> Int -> [Int]
randomInt g nbNum = take nbNum (map (`mod` 256) (randoms g :: [Int]))

randomClusters :: Int -> [Int] -> [Cluster]
randomClusters num randomList
    | num > 0 = Cluster (Color red green blue) [] : randomClusters (num - 1) randomList
    | otherwise = []
    where index = (num - 1) * 3
          red = randomList !! index
          green = randomList !! (index + 1)
          blue = randomList !! (index + 2)