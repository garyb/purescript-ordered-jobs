module Test.Main where

import Control.Monad.Eff (Eff())
import Data.Either (Either (..))
import Debug.Trace (Trace(), trace)
import OrderedJobs (getSequence)

main :: Eff (trace :: Trace) Unit
main = do

  test ""

  test "a =>"

  test """a =>
          b =>
          c =>"""

  test """a =>
          b => c
          c =>"""

  test """a =>
          b => c
          c => f
          d => a
          e => b
          f =>"""

  test """a =>
          b =>
          c => c"""

  test """a =>
          b => c
          c => f
          d => a
          e =>
          f => b"""


test :: String -> Eff (trace :: Trace) Unit
test input = do
  trace $ "Running " ++ input ++ ":"
  case getSequence input of
    Left err -> trace $ "Error: " ++ err
    Right value -> trace $ "Result: " ++ show value
  trace "\n\n"
