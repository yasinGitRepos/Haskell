---- RUN COMMAND
-- runghc .\tic.hs

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
    let board = (updateBoard sign [0,num-1] ls)
    printBoard board
    usrInput (if sign == 1 then sign+1 else sign-1) board


main :: IO ()
main = do
    let list = [0,0,0,0,0,0,0,0,0]
    printBoard list
    usrInput 1 list

 
