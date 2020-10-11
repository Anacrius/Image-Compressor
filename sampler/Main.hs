-- Little code to randomly write a txt file with 20x20 pixels

import System.Random (RandomGen, newStdGen, randoms)

h :: Int -- height
h = 20

w :: Int -- width
w = 20

-- (0, 0) (255, 255, 255) into "(0,0) (255,255,255)"
stringify :: (Int, Int) -> (Int, Int , Int) -> String
stringify (x, y) (r, g, b) = "(" ++ show x ++ "," ++ show y ++ ") "
                            ++ "(" ++ show r ++ "," ++ show g ++ "," ++ show b ++ ")"

-- turn a list of 3 Int into a tuple a 3 Int
tuplify3 :: [a] -> (a,a,a)
tuplify3 [x,y,z] = (x,y,z)

-- random (r, g, b)
pixelGen :: RandomGen g => g -> (Int, Int, Int)
pixelGen g = tuplify3 $ take 3 (map (`mod` 256) $ randoms g :: [Int])

createPoint :: Int -> Int -> IO()
createPoint x y = do
    g <- newStdGen
    putStrLn $ stringify (x, y) $ pixelGen g

-- from a given x, create a w amount of Points on the x axis
createLine :: Int -> IO()
createLine x = mapM_ (createPoint x) (take w [0..])

main :: IO()
main = mapM_ createLine $ (take h [0..])