{-# LANGUAGE OverloadedStrings #-}

import DBus.Client
import Control.Monad

-- This method will act as a dbus function which accepts a dbus string, and
-- returns a dbus string. This works because we use testMethod via the dbus
-- function autoMethod.
testMethod :: String -> IO String
testMethod x = return $ "Hello " ++ x

main :: IO ()
main = do
  -- Connect to the per-user session-bus
  client <- connectSession

  -- Request a mnemonical name, instead of the automatic
  -- numerical one
  requestName client "org.jonte.Test" []

  -- Export the object 'my_object' complying to the interface
  -- 'org.jonte.Test.Test'. When the object is called, testMethod will be
  -- invoked
  export client "/my_object"
    [autoMethod "org.jonte.Test" "Test" testMethod]

  -- We need a sort of 'main loop' to keep the program from terminating, none of 
  -- the dbus calls above will keep the program alive.
  forever $ getLine
