module Main where

import System.IO
import Types
import Fetch
import Parse
import Database

main :: IO ()
main = do
    putStrLn "---------------------------------"
    putStrLn "  Welcome to the pokemon data app  "
    putStrLn "  (1) Download data              "
    putStrLn "  (2) All Pokemons requring the same candy    "
    putStrLn "  (3) Pokemons with less candies than the entered number     "
    putStrLn "  (4) Pokemons with more candies than the entered number    "
    putStrLn "  (5) To get the BMIs of pokemons with same candy "
    putStrLn "  (6) Quit                       "
    putStrLn "---------------------------------"
    conn <- initialiseDB
    hSetBuffering stdout NoBuffering
    putStr "Choose an option > "
    option <- readLn :: IO Int
    case option of
        1 -> do
            let url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json"
            print "Downloading..."
            json <- download url
            print "Parsing..."
            case (parsePokemon json) of
                Left err -> print err
                Right recs -> do
                    print "Saving on DB..."
                    savePokemons conn (pokemon recs)
                    print "Saved!"
                    main
        2 -> do
            entries <- queryCandyAllPokemons conn
            mapM_ print entries
            main
        3 -> do
            entriess <- queryLessThan conn
            mapM_ print entriess
            main
        4 -> do
            entriess <- queryMoreThan conn
            mapM_ print entriess
            main
        5 -> do
            putStr "Enter any candy name from the candies table [eg:'Bulbasaur Candy','Charmander Candy','Zubat Candy'..etc]"
            candyName <- getLine
            pheight <- queryHi conn candyName
            pweight <- queryWi conn candyName 
            let x1 =map hite pheight
            let x2 =map hite pweight
            let x = map (takeWhile('m'>) ) x1
            let y = map (takeWhile (/='k').dropWhile (=='g')) x2
            let px = map (read::String->Float) x
            let py = map (read::String->Float) y
            let calcBmi (h, w) = w / (h*h)
            let bmis= map calcBmi (zip px py)
            print bmis
            main
        6 -> print "Hope you've enjoyed using the app!"
        otherwise -> do 
            print "Invalid option"
            main
