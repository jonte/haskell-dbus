{-# LANGUAGE OverloadedStrings #-}

import DBus
import DBus.Client


square :: Client -> Double -> IO Double
square client n= do
  -- Call the function 'Test' of the object object '/jonte', exported on the
  -- name 'org.jonte.Test'. Pass one parameter to the function; the string
  -- "hej".
  reply <- call_ client 
        (methodCall "/math_object" "org.jonte.math" "square") 
        { methodCallDestination = Just "org.jonte.math"
        , methodCallBody = [toVariant n]}

  -- Use the accessor function methodReturnBody to get the return value of the
  -- function we called, retrieve the first value (there is only one), then
  -- convert it from a variant to a Maybe String, take only the String value.
  return (unwrapFirst reply)

add :: Client -> Double -> Double -> IO Double
add client x y = do
  reply <- call_ client 
        (methodCall "/math_object" "org.jonte.math" "plus") 
        { methodCallDestination = Just "org.jonte.math"
        , methodCallBody = [toVariant x, toVariant y]}
  return (unwrapFirst reply)
  
-- Gives the first return value of a function called over DBus
unwrapFirst :: IsVariant a => MethodReturn -> a
unwrapFirst ret = unwrapped
  where Just unwrapped = fromVariant $ head $ methodReturnBody ret


main :: IO ()
main = do
  -- Connect to the per-user session-bus.
  client <- connectSession

  squared <- square client 4
  added <- add client 4 5

  -- Print our string return value from the function we called.
  putStrLn $ show $ (added + squared)
