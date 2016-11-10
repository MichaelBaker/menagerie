module FunctorSpec where

import Prelude hiding (fmap)
import Menagerie.Functor

import Test.Hspec
import Test.QuickCheck

spec = do
  describe "Functor" $ do
    describe "list" $ do
      it "applies the function to each element of the list" $ do
        fmap (== 1) [1, 2, 3] `shouldBe` [True, False, False]

      it "satisfies law 1" $ property $ \x ->
        fmap id x == id (x :: [Int])

      it "satisfies law 2" $ property $ \x ->
        let g = (> 0.1)
            h = fromInteger
        in fmap (g . h) (x :: [Integer]) == (fmap g (fmap h x))

    describe "either" $ do
      it "doesn't affect Left" $ do
        fmap (+ 1) (Left 1 :: Either Int Int) `shouldBe` (Left 1 :: Either Int Int)

      it "applies to the element of a Right" $ do
        fmap (== 1) (Right 1) `shouldBe` (Right True :: Either () Bool)

      it "satisfies law 1" $ property $ \x ->
        fmap id x == id (x :: Either Bool Int)

      it "satisfies law 2" $ property $ \x ->
        let g = (> 0.1)
            h = fromInteger
        in fmap (g . h) (x :: Either Bool Integer) == (fmap g (fmap h x))

    describe "(->) a" $ do
      it "composes the functions" $ do
        fmap (== 1) (+ 1) 0 `shouldBe` True

      it "satisfies law 1" $ property $ \x ->
        fmap id (+ 1) x == id (+ 1) (x :: Int)

      it "satisfies law 2" $ property $ \x ->
        let g = (> 0.1)
            h = fromInteger
        in fmap (g . h) (+ 1) (x :: Integer) == (fmap g (fmap h (+ 1))) x

    describe "Functor composition" $ do
      it "applies to elements of the innermost functor" $ do
        let actual   = fmap not (Compose ([Left 1, Right True, Right False]))
        let expected = [Left 1, Right False, Right True]
        extract actual `shouldBe` expected
