module ApplicativeSpec where

import Prelude hiding (pure, (<*>), (<$>))
import Menagerie.Applicative

import Test.Hspec
import Test.QuickCheck

spec = do
  describe "Applicative" $ do
    describe "list" $ do
      it "applies each function in a list to each value in another list" $ do
        [(+), (*)] <*> [1, 2] <*> [3, 4] `shouldBe` [4, 5, 5, 6, 3, 4, 6, 8]

      it "follows the identity law" $ property $ \x ->
        let v = [x] :: [Int]
        in (pure id <*> v) == v

      it "follow the homomorphism law" $ property $ \x ->
        let f = (+ 1)
        in (pure f <*> (pure x :: [Int])) == pure (f x)

      it "follows the interchange law" $ property $ \x ->
        let u = pure (+ 1)
        in (u <*> (pure x :: [Int])) == (pure ($ x) <*> u)

      it "follows the composition law" $ property $ \x ->
        let u = pure (+ 1)
            v = pure (* 3)
            w = pure x :: [Int]
        in (u <*> (v <*> w)) == (pure (.) <*> u <*> v <*> w)

      it "follows the functor law" $ property $ \y ->
        let g = (+ 1)
            x = pure y :: [Int]
        in fmap g x == (pure g <*> x)

    describe "either" $ do
      it "doesn't affect Left" $ do
        1 `shouldBe` 2

    describe "(->) a" $ do
      it "composes the functions" $ do
        1 `shouldBe` 2

    describe "Functor composition" $ do
      it "applies to elements of the innermost functor" $ do
        1 `shouldBe` 2
