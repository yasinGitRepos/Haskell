---- RUN COMMAND
-- runghc .\tic.hs

import Text.Read (readMaybe)

-- Recursive loop die sign in het goede vakje zet 
-- cur = index 0 en i = de rest van de meegegeven array
-- If cur == i(het juiste vakje) then zet sign op de die plek
-- Else roep zichzelf aan met cur +1 en plak l (alle vorige posities) ervoor.
updateBoard :: Int -> [Int] -> [Int] -> [Int]
updateBoard sign (cur:i) (l:board)
    | cur == (i !! 0) = (sign:board)
    | otherwise = l : updateBoard sign [(cur+1),(i !! 0)] board

-- Alle mogelijk win combinaties
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

-- wissel sign
xo :: Int -> Int
xo sign 
    | sign == usr = sign+1 
    | otherwise = sign-1

-- roep vak aan voor elk item uit de array row
-- print resultaat
printRow :: [Int] -> IO ()
printRow row = putStrLn (concatMap vak row)

-- take index 0-2, 3-5, 6-8 van board
-- roep voor de 3 arrays printRow aan
printBoard :: [Int] -> IO ()
printBoard board = do
    putStr "\ESC[H\ESC[J"
    mapM_ printRow [drop 6 board, take 3 (drop 3 board), take 3 board]

   
-- get usr input
usrInput :: Int -> [Int] -> IO Int
usrInput sign list = do
    putStrLn "Your turn:"
    input <- getLine

-- Try(maybe) to cast input to int
-- Als het geen int is of niet tussen de 1 en 9 ligt, print msg en roep start opnieuw 
    case readMaybe input :: Maybe Int of
        Just move
            | move >= 1 && move <= 9 && list !! (move - 1) == 0 -> return move
        _ -> do 
                putStrLn "Geen geldige invoer:"
                usrInput sign list



-- ga door de wincombos arrays, If sign op alle 3 indexs staat, return true
-- else probeer opnieuw voor de volgende wincombo
winCheck :: Int -> [Int] -> [[Int]] -> Bool
winCheck sign board combos =
    if not (null combos)
        then  -- board[(combo[0][0]-1)] == sign 
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
    if all (/= 0) board -- if all indexes of board != 0
        then putStrLn ("\n" ++ "Tie")
        else
            if winCheck sign board winCombos
                then putStrLn ("\n" ++"Player" ++ vak(sign) ++ "Wins")
                else loop board (xo(sign)) 


-- check alle mogelijke moves, en vul ze in op een tijdelijk bord
-- roep mninimax aan met het tijdelijke bord.
-- roep bestscore aan met een array van alle results van minimax en de bijhorende move
-- return het eerste item(de move) van de return van bestScore
cmpInput :: [Int] -> Int
cmpInput board =
    fst ( bestScore
            [ (move, miniMax (makeMove bot move board) usr)
            | move <- availableMoves board
            ]
        )
        

-- vergelijk de score van eerste 2 indexs,
-- delete de laagste, en herhaal to er maar 1 overblijft
-- return de move van de eerste index
-- [x] = x is pattern matching, houd in dat x wordt gereturnd als er maar 1 item in de array staat. 
bestScore :: [(Int, Int)] -> (Int, Int)
bestScore [x] = x
bestScore (x:y:xs)
    | snd x > snd y = bestScore (x:xs)
    | otherwise     = bestScore (y:xs)




-- check alle mogelijke moves, en vul ze in op een tijdelijk bord
-- roep mninimax opnieuw aan met het tijdelijke bord, 
-- en heraal tot een win, los of tie en return bijhoorde punten 
-- return de route met de positiefste uitkomst. 

-- map voert avalibleMoves voor elke index van board uit,
-- en stopt ze vervolgens 1 voor 1 in minimax
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
    
