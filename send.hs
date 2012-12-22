{-# LANGUAGE OverloadedStrings #-}

import DBus
import DBus.Client


main :: IO ()
main = do
  -- Connect to the per-user session-bus.
  client <- connectSession

  -- Call the function 'Test' of the object object '/jonte', exported on the
  -- name 'org.jonte.Test'. Pass one parameter to the function; the string
  -- "hej".
  reply <- call_ client 
        (methodCall "/my_object" "org.jonte.Test" "Test") 
        { methodCallDestination = Just "org.jonte.Test"
        , methodCallBody = [toVariant ("hej" :: String)]}

  -- Use the accessor function methodReturnBody to get the return value of the
  -- function we called, retrieve the first value (there is only one), then
  -- convert it from a variant to a Maybe String, take only the String value.
  let Just msg = fromVariant $ head $ methodReturnBody reply

  -- Print our string return value from the function we called.
  putStrLn $ msg
