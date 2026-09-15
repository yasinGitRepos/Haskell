---- RUN COMMAND
-- runghc .\tic.hs
import Control.Concurrent (threadDelay)

updateBoard :: Int -> [Int] -> [Int] -> [Int]
updateBoard sign (cur:i) (l:ls)
    | cur == (i !! 0) = (sign:ls)
    | otherwise = l : updateBoard sign [(cur+1),(i !! 0)] ls

vak :: Int -> String
vak x
    | x == 1 = " X "
    | x == 2 = " O "
    | otherwise = "   "

printRow :: [Int] -> IO ()
printRow r = do
    print (vak(r !! 0) ++ vak(r !! 1) ++ vak(r !! 2))

printBoard :: [Int] -> IO ()
printBoard board = do
    let row3 = take 3 board
    let row2 = take 3 (drop 3 board)
    let row1 = drop 6 board
    putStr "\ESC[H\ESC[J"
    printRow(row1)
    printRow(row2)
    printRow(row3)
   
usrInput :: Int -> [Int] -> IO ()
usrInput sign ls = do
    putStrLn "Your turn:"
    input <- getLine
    let num = read input :: Int
    if (ls !! (num-1)) /= 0 
        then usrInput sign ls 
        else do
        let board = (updateBoard sign [0,num-1] ls)
        printBoard board
        threadDelay 300000
        cmpInput (if sign == 1 then sign+1 else sign-1) board 1

cmpInput :: Int -> [Int] -> Int ->  IO()
cmpInput sign ls num = do
    if (ls !! (num-1)) /= 0 
        then cmpInput sign ls (num+1)
        else do
        let board = (updateBoard sign [0,num-1] ls)
        printBoard board
        usrInput (if sign == 1 then sign+1 else sign-1) board



main :: IO ()
main = do
    let list = [0,0,0,0,0,0,0,0,0]
    printBoard list
    usrInput 1 list


    -- Win combinations
    -- 123 - 456 - 789 - 741 - 852 - 963 - 753 - 951




-- winCheck :: Int -> [Int] -> IO()
-- winCheck sign board = do
--     let winCombos = [
--                      [1,2,3], [4,5,6], [7,8,9],
--                      [7,4,1], [8,5,2], [9,6,3],
--                      [7,5,3], [9,5,1]
--                     ]
--     comboCheck sign board winCombos


-- comboCheck :: Int -> [Int] -> [[Int]] -> IO ()
-- comboCheck sign board combo = do
--     if (combo.length > 0)
--         then do 
--             if (board !! ((combo !! 0) !! 0) == 0 
--             && (board !! ((combo !! 0) !! 1)) /= 0 
--             && (board !! ((combo !! 0) !! 2))) 
--             then putStrLn sign + " Wins"
--             else comboCheck sign board (combo drop 1)
--         else 