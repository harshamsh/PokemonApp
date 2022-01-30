{-# LANGUAGE DeriveGeneric #-}

module Types (
    Pokemon (..),
    Pokemon1 (..),
    PokemonDet (..),
    Pokemonrec(..),
    PokeBod(..),
    Pcc (..)
) where

import GHC.Generics
-- |Creates datatypes for the first table PokemonDet which contains details like id,nanme,height,weight and a foreign key candy which connects it to second table.
data PokemonDet = PokemonDet {
    id_ :: Int,
    name_:: String,
    height_::String,
    weight_::String,
    fk_candy :: Int
} deriving (Show)
-- |Creates dataypes for the second table candies which has details of types of candy and number of candies required for evolution.
data Pcc = Pcc{
    cid_ :: Int,

    candy_ :: String,
    candy_count_ :: Maybe Int
}deriving (Show)
-- |Creates datatype to use every field from the dataset inorder to put it into tables given above.
data Pokemon1 = Pokemon1 {
    xid :: Int,
    num :: String,
    name :: String,
    height :: String,
    weight :: String,
    candy :: String,
    candy_count :: Maybe Int,
    egg :: String,
    spawn_chance :: Float,
    avg_spawns :: Float,
    spawn_time::String    
} deriving (Show, Generic)
-- |Declares the datatye for every entry present in the dataset
data Pokemon = Pokemon {
    pokemon :: [Pokemon1]
} deriving (Show, Generic)
-- |Declares the datatpe for the query output
data Pokemonrec = Pokemonrec {
    pokeemon:: String  
} deriving (Show, Generic)

data PokeBod = PokeBod{  
    hite:: String
} deriving (Show, Generic)