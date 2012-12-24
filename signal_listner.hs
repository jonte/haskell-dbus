{-# LANGUAGE OverloadedStrings #-}

import DBus
import DBus.Client
import Control.Monad

-- This callback is called whenever an apropriate signal is matched
signalCallback :: Signal -> IO ()
signalCallback signal_ = putStrLn $ "Received signal: " ++ show sig
  where 
    sig :: String
    Just sig = fromVariant $ head $ signalBody signal_

main :: IO ()
main = do
  -- Connect to the per-user session-bus
  client <- connectSession

  -- Register signalCallback as a callback for any signal we find
  listen client matchAny signalCallback

  -- We need a sort of 'main loop' to keep the program from terminating, none of 
  -- the dbus calls above will keep the program alive.
  forever $ getLine
