{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module Tempo where

import Network.Wreq 
import Control.Lens
import Data.ByteString
import Data.Monoid
import qualified Data.Text as T 
import Data.Aeson.TH
import Data.Aeson.Types
import Data.Time.Clock
import Data.Time.Format

import GHC.Generics

data Worklog = Worklog
  { _timeSpendSeconds :: Int
  , _description :: String
  , _author :: Author
  } deriving (Generic, Show)

data Author = Author 
  { _username :: String
  , _displayName :: String
  } deriving (Generic, Show)

makeLenses ''Author
makeLenses ''Worklog

deriveJSON defaultOptions{fieldLabelModifier = Prelude.drop 1} ''Author

baseUrl :: String
baseUrl = "https://api.tempo.io/2"

mkOpts :: Network.Wreq.Options -> ByteString -> Network.Wreq.Options
mkOpts o token = o & auth ?~ oauth2Bearer token 

utcTime1WeekAgo :: IO UTCTime
utcTime1WeekAgo = addUTCTime (nominalDay * (-7)) <$> getCurrentTime

main :: IO ()
main = do
  let apiKey = ""
  from <- utcTime1WeekAgo
  to <- getCurrentTime
  let opts = mkOpts defaults apiKey & param "from".~ [T.pack . formatShow . iso8601Format $ from] & param "to"  .~ [T.pack . formatShow . iso8601Format $ to]
  res <- getWith opts $ baseUrl <> "/worklogs" 
  print res
  -- let opts = defaults & auth ?~ oauth2Bearer "5U0O84VWFv337XYjdTx8N9dpB0mwRS"  
  -- res <- getWith opts $ baseUrl <> "/worklogs"
  -- print res
