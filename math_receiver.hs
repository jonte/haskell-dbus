{-# LANGUAGE OverloadedStrings #-}

import DBus.Client
import Control.Monad

-- This method will act as a dbus function which accepts a dbus string, and
-- returns a dbus string. This works because we use testMethod via the dbus
-- function autoMethod.
square :: Double -> IO Double
square x = return $ x**2

plus :: Double -> Double -> IO Double
plus x y = return $ x + y

main :: IO ()
main = do
  -- Connect to the per-user session-bus
  client <- connectSession

  -- Request a mnemonical name, instead of the automatic
  -- numerical one
  requestName client "org.jonte.math" []

  -- Export the object 'my_object' complying to the interface
  -- 'org.jonte.Test.Test'. When the object is called, testMethod will be
  -- invoked
  export client "/math_object"
    [
      autoMethod "org.jonte.math" "square"  square,
      autoMethod "org.jonte.math" "plus"    plus
    ]

  -- We need a sort of 'main loop' to keep the program from terminating, none of 
  -- the dbus calls above will keep the program alive.
  forever $ getLine
