{-# LANGUAGE OverloadedStrings #-}

import DBus
import DBus.Client
import Control.Monad
import Control.Concurrent

-- This is the emitter process, it will emit the string "Hello world"
-- untill the process is killed.
emitter :: Client -> IO ()
emitter client = do
  emit client  (signal "/signal_object" "org.jonte.signal" "signal") 
    {signalBody = [toVariant ("Hello world" :: String)]}
  putStrLn "Emitted signal"
  threadDelay 1000000
  emitter client

main :: IO ()
main = do
  -- Connect to the per-user session-bus.
  client <- connectSession

  -- Request a well-known name
  requestName client "org.jonte.math" []

  -- Fork a signal emitter
  forkIO $ emitter client

  -- Keep program from terminating
  forever $ getLine
