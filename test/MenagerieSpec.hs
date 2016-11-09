module MenagerieSpec where

import Test.Hspec
import Test.QuickCheck

spec = do
  describe "test" $ do
    it "passes" $ do
      1 `shouldBe` 1
