---- RUN COMMAND
-- runghc .\tic.hs
import Control.Concurrent (threadDelay)

updateBoard :: Int -> [Int] -> [Int] -> [Int]
updateBoard sign (cur:i) (l:ls)
    | cur == (i !! 0) = (sign:ls)
    | otherwise = l : updateBoard sign [(cur+1),(i !! 0)] ls

winCombos :: [[Int]]
winCombos = [ 
                [1,2,3], [4,5,6], [7,8,9],
                [7,4,1], [8,5,2], [9,6,3],
                [7,5,3], [9,5,1]
            ]

vak :: Int -> String
vak x
    | x == 1 = " X "
    | x == 2 = " O "
    | otherwise = "   "

xo :: Int -> Int
xo sign 
    | sign == 1 = sign+1 
    | otherwise = sign-1


printRow :: [Int] -> IO ()
printRow r = do
    print (vak(r !! 0) ++ vak(r !! 1) ++ vak(r !! 2))

printBoard :: [Int] -> IO ()
printBoard board = do
    let row3 = take 3 board
    let row2 = take 3 (drop 3 board)
    let row1 = drop 6 board
    -- putStr "\ESC[H\ESC[J"
    printRow(row1)
    printRow(row2)
    printRow(row3)
   
   
usrInput :: Int -> [Int] -> IO Int
usrInput sign ls = do
    putStrLn "Your turn:"
    input <- readLn
    if input > 9 || (ls !! (input-1)) /= 0 
        then usrInput sign ls 
    else do
        return input
       


winCheck :: Int -> [Int] -> [[Int]] -> Bool
winCheck sign board combos =
    if not (null combos)
        then 
            if (board !! (((combos !! 0) !! 0)-1)) == sign
                && (board !! (((combos !! 0) !! 1)-1)) == sign
                && (board !! (((combos !! 0) !! 2)-1)) == sign
            then True
            else winCheck sign board (drop 1 combos)
    else False



main :: IO ()
main = do
    let list = [0,0,0,0,0,0,0,0,0]
    printBoard list
    loop list 1


loop :: [Int] -> Int -> IO ()
loop list sign = do
    input <- if sign == 1
        then usrInput sign list
        else do
            result <- miniMax sign list 1
            return (result !! 1)
    let board = (updateBoard sign [0,input-1] list)
    print input
    printBoard board
    -- threadDelay 150000 
    if winCheck sign board winCombos
        then 
            print ("Player" ++ vak(sign) ++ "Wins ")
        else loop board (xo(sign)) 
    

-- cpmInput :: Int -> [Int] -> Int -> Int
-- cpmInput sign board num = do 
--     if miniMax sign board num !! 0 ==


miniMax :: Int -> [Int] -> Int -> IO [Int] 
miniMax sign board num
    | winCheck 2 board winCombos = return [10,num]
    | winCheck 1 board winCombos = return [(-10),num]
    | all (/= 0) board = return [0,num]
    | num > length board = return [0,num]
    | board !! (num - 1) /=0 = miniMax sign board (num +1)
    | otherwise = do
        let nb = updateBoard sign [0, num -1] board
        score <- miniMax (xo sign) nb num
        nextScore <- miniMax sign board (num +1)
        -- printBoard nb
        -- print nb
        -- print score
        let s = score !! 0
        let ns = nextScore !! 0
        let np = nextScore !! 1

        if sign == 2
            then if (s > ns) 
                then return [s, num]
                else return [ns, np -1]         
            else if (s < ns) 
                then return [s, num]
                else return [ns, np -1]
