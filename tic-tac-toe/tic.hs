---- RUN COMMAND
-- runghc .\tic.hs

import Text.Read (readMaybe)


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

usr :: Int
usr = 1

bot :: Int
bot  
    | usr == 1  = 2
    | otherwise = 1


vak :: Int -> String
vak x
    | x == usr  = " X "
    | x == bot  = " O "
    | otherwise = "   "

xo :: Int -> Int
xo sign 
    | sign == usr = sign+1 
    | otherwise = sign-1


printRow :: [Int] -> IO ()
printRow row = do
    putStrLn (vak(row !! 0) ++ vak(row !! 1) ++ vak(row !! 2))

printBoard :: [Int] -> IO ()
printBoard board = do
    let row3 = take 3 board
    let row2 = take 3 (drop 3 board)
    let row1 = drop 6 board
    putStr "\ESC[H\ESC[J"
    printRow(row1)
    printRow(row2)
    printRow(row3)
   
   
usrInput :: Int -> [Int] -> IO Int
usrInput sign list = do
    putStrLn "Your turn:"
    input <- getLine

    case readMaybe input :: Maybe Int of
        Just move
            | move >= 1 && move <= 9 && list !! (move - 1) == 0 -> return move
        _ -> do 
                putStrLn "Geen geldige invoer:"
                usrInput sign list



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
    loop list usr


loop :: [Int] -> Int -> IO ()
loop list sign = do
    input <- if sign == usr
        then usrInput sign list
        else return (cmpInput list)
        
    let board = (updateBoard sign [0,input-1] list)
    printBoard board
    if all (/= 0) board
        then putStrLn ("\n" ++ "Tie")
        else
            if winCheck sign board winCombos
                then putStrLn ("\n" ++"Player" ++ vak(sign) ++ "Wins")
                else loop board (xo(sign)) 



cmpInput :: [Int] -> Int
cmpInput board =
    fst ( bestScore
            [ (move, miniMax (makeMove bot move board) usr)
            | move <- availableMoves board
            ]
        )
        
bestScore :: [(Int, Int)] -> (Int, Int)
bestScore [x] = x
bestScore (x:y:xs)
    | snd x > snd y = bestScore (x:xs)
    | otherwise     = bestScore (y:xs)


miniMax :: [Int] -> Int -> Int
miniMax board sign
    | winCheck bot board winCombos = 10
    | winCheck usr board winCombos = -10
    | all (/= 0) board = 0
    | sign == bot =
        maximum $ map
            (\move -> miniMax (makeMove bot move board) usr)
            (availableMoves board)
    | otherwise =
        minimum $ map
            (\move -> miniMax (makeMove usr move board) bot)
            (availableMoves board)
        

availableMoves :: [Int] -> [Int]
availableMoves board =
    [move | move <- [1..9], board !! (move - 1) == 0]

makeMove :: Int -> Int -> [Int] -> [Int]
makeMove sign move board =
    updateBoard sign [0, move - 1] board
    
