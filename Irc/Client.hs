module Irc.Client(
  Client
, connect
, authenticate
, joinChannel
, sendMessage
, sendPong
) where

import Network (connectTo, PortID(PortNumber))
import System.IO (Handle, hSetBuffering, BufferMode(NoBuffering), hGetLine)

import Text.Printf (hPrintf)

import Control.Monad (forever)

import Irc.Parser

type Client = Handle

connect :: String -> Int -> IO Client
connect server port = do
  socket <- connectTo server (PortNumber (fromIntegral port))
  hSetBuffering socket NoBuffering
  return socket

sendCommand :: Client -> String -> String -> IO ()
sendCommand client = hPrintf client "%s %s\r\n"

authenticate :: Client -> String -> String -> IO ()
authenticate client nick pass = do
  sendCommand client "PASS" pass
  sendCommand client "NICK" nick

joinChannel :: Client -> String -> (String -> Message -> Client -> IO ()) -> IO ()
joinChannel client channel handler = do
  sendCommand client "JOIN" ("#" ++ channel)
  forever $ do
    line <- hGetLine client
    case parseMessage channel line of
      Right msg -> handler channel msg client
      Left _ -> putStrLn $ "Error parsing:" ++ line

sendMessage :: Client -> String -> String -> IO ()
sendMessage client channel msg = do
  let formatted = "#" ++ channel ++ " :" ++ msg
  sendCommand client "PRIVMSG" formatted

sendPong :: Client -> String -> IO ()
sendPong client msg = sendMessage client "PONG" msg
