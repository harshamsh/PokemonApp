module Fetch (
    download
) where

import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Simple
-- | Here we are checking the availability and access to the dataset online 
type URL = String

download :: URL -> IO L8.ByteString
download url = do
    request <- parseRequest url
    response <- httpLBS request
    return $ getResponseBody response
