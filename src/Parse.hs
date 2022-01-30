{-# LANGUAGE DeriveGeneric #-}

module Parse (
    parsePokemon,
) where

import Types
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L8
-- |Inorder to avoid any conflicts due to the wording "id" we changeg it to "xid".
renameFields "xid" = "id"
renameFields other = other

customOptions = defaultOptions {
    fieldLabelModifier = renameFields
    }
instance FromJSON Pokemon1 where
    parseJSON = genericParseJSON customOptions



instance FromJSON Pokemon

parsePokemon :: L8.ByteString -> Either String Pokemon
parsePokemon json = eitherDecode json :: Either String Pokemon