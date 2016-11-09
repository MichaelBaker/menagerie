module FunctorSpec where

import Prelude hiding (fmap)
import Menagerie.Functor

import Test.Hspec
import Test.QuickCheck

spec = do
  describe "Functor" $ do
    describe "list" $ do
      it "applies the function to each element of the list" $ do
        fmap (+ 1) [1, 2, 3] `shouldBe` [2, 3, 4]

      it "satisfies law 1" $ property $ \x ->
        fmap id x == id (x :: [Int])

      it "satisfies law 2" $ property $ \x ->
        let g = (> 0.1)
            h = fromInteger
        in fmap (g . h) (x :: [Integer]) == (fmap g (fmap h x))
