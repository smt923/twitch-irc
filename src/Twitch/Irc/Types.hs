module Twitch.Irc.Types where

import Data.Map (Map)
import Data.Text (Text)

import System.IO (Handle)


data Input = Input Message deriving (Show, Read)
data Output = Output Action deriving (Show, Read)

data Message
  = PrivateMessage Channel User Text (Maybe PrivateMessageTags)
  | JoinMessage Channel User
  | PartMessage Channel User
  | ServerMessage (Maybe Channel) Int Text
  | JtvCommand Command Text
  | JtvMode Channel Mode User
  | Ping Text deriving (Show, Read)

data Action
  = SendMessage Channel Text
  | Log Text
  | Join Channel deriving (Show, Read)

type Channel = String
type User = String
type Command = String
type Mode = String
type Client = Handle

type PrivateMessageTags = Map String String
