{-# LANGUAGE OverloadedStrings #-}

-- or, on GHCI:
-- > :set -XOverloadedStrings

module Database (
    initialiseDB,
    -- getOrCreatePokemonDet,
    getOrCreatePcc,
    savePokemons,
    queryLessThan,
    queryMoreThan,
    queryCandyAllPokemons,
    queryHi,
    queryWi

) where

import Types
import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.Internal
import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.ToRow
import Control.Exception

-- |Instance creating for PokemonDet table
instance FromRow PokemonDet where
    fromRow = PokemonDet <$> field <*> field <*> field <*> field <*> field
instance ToRow PokemonDet where
    toRow (PokemonDet id_ name_ height_ weight_ fk_candy)
        = toRow (id_, name_, height_, weight_, fk_candy)

-- |INstance creation for candies table
instance FromRow Pcc where
    fromRow = Pcc <$> field <*> field <*> field 
instance ToRow Pcc where
    toRow (Pcc cid_ candy_ candy_count_)
        = toRow (cid_, candy_, candy_count_)


-- |Instance creation for query output
instance FromRow Pokemonrec where
    fromRow = Pokemonrec <$> field
instance FromRow PokeBod where
    fromRow = PokeBod  <$> field 

-- |Initialises connection the Database and creates the tables required
initialiseDB :: IO Connection
initialiseDB = do
        conn <- open "pokemon.sqlite"
        execute_ conn "CREATE TABLE IF NOT EXISTS PokemonDet (\
            \id INTEGER PRIMARY KEY,\
            \name VARCHAR(80) NOT NULL, \
            \height VARCHAR(50) NOT NULL, \
            \weight VARCHAR(50) NOT NULL, \
            \fk_candy INTEGER\
            \)"
        execute_ conn "CREATE TABLE IF NOT EXISTS candies (\
            \cid INTEGER PRIMARY KEY AUTOINCREMENT ,\
            \candy VARCHAR(40) NOT NULL, \
            \candy_count INTEGER \      
            \)"
        return conn

-- |Inserts values/fileds to the table candies
getOrCreatePcc :: Connection -> String -> Maybe Int->IO Pcc
getOrCreatePcc conn candy candy_count = do
    results <- queryNamed conn "SELECT * FROM candies WHERE candy=:candy" [":candy" := candy]
    if length results > 0 then
        return . head $ results
    else do
        execute conn "INSERT INTO candies ( candy, candy_count) VALUES (?,?)" (candy, candy_count)
        getOrCreatePcc conn candy candy_count
-- |Inserts values for PokemonDet table and also inserts foreign key from candies table connecting the PokemonDet to candies table.
createPokemon :: Connection -> Pokemon1 -> IO ()
createPokemon conn pokemon = do
    candies <- getOrCreatePcc conn (candy pokemon) (candy_count pokemon) 
    let ent = PokemonDet{
        id_ = xid pokemon,
        name_ = name pokemon,
        height_ = height pokemon,
        weight_ = weight pokemon,
        fk_candy = cid_ candies
    }
    execute conn "INSERT INTO PokemonDet VALUES (?,?,?,?,?)" ent
-- |Dataset is generated and saved
savePokemons :: Connection -> [Pokemon1] -> IO()
savePokemons conn = mapM_ (createPokemon conn)
-- |Fetches the names of pokemon which has a specific candy which is a input from the user.
queryCandyAllPokemons  :: Connection -> IO [Pokemonrec]
queryCandyAllPokemons conn = do
    putStr "Enter candy name > "
    candyName <- getLine
    putStrLn $ "Looking for " ++ candyName ++ " Pokemons..."
    let sql = "SELECT PokemonDet.name FROM PokemonDet INNER JOIN candies ON PokemonDet.fk_candy=candies.cid WHERE candy= ?"
    query conn sql [candyName]
-- |Fetches pokemons who have candy count less than a specific number.
queryLessThan :: Connection -> IO [Pokemonrec]
queryLessThan conn = do
    putStr "Enter a number to see the pokemons with less candies than the entered number  "
    maxNum <- getLine
    putStrLn $ "Looking for pokemons with less than" ++ maxNum ++ " candies..."
    let sql = "SELECT PokemonDet.name FROM PokemonDet INNER JOIN candies ON PokemonDet.fk_candy=candies.cid WHERE candy_count< ?"
    query conn sql [maxNum]
-- |Fetches pokemons who have candy count more than a specific number.
queryMoreThan :: Connection -> IO [Pokemonrec]
queryMoreThan conn = do
    putStr "Enter a number to see the pokemons with more candies than the entered number  "
    minNum <- getLine
    putStrLn $ "Looking for pokemons with more than" ++ minNum ++ " candies..."
    let sql = "SELECT PokemonDet.name FROM PokemonDet INNER JOIN candies ON PokemonDet.fk_candy=candies.cid WHERE candy_count> ?"
    query conn sql [minNum]

-- |Fetches the heights of the pokemons that takes the candy type that was sent to input
queryHi :: Connection -> String -> IO [PokeBod]
queryHi conn candyName = do
    let sql = "SELECT PokemonDet.height FROM PokemonDet INNER JOIN candies ON PokemonDet.fk_candy=candies.cid WHERE candy= ?"   
    query conn sql [candyName]
-- |Fetches the weights of the pokemons that takes the candy type that was sent to input
queryWi :: Connection -> String -> IO [PokeBod]
queryWi conn candyName = do
    let sql = "SELECT PokemonDet.weight FROM PokemonDet INNER JOIN candies ON PokemonDet.fk_candy=candies.cid WHERE candy= ?"
    query conn sql[candyName]

