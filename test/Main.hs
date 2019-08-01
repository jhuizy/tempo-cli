module Main where 

import Test.Hspec

import Tempo

main :: IO ()
main = hspec $ do
  describe "Tempo.tempo" $ do
    it "should return string_value" $ do
      tempo 1 `shouldBe` "Hello_1"
