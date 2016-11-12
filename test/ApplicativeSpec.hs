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
        (pure id <*> x) == (x :: [Int])

      it "follow the homomorphism law" $ property $ \x ->
        let f = (+ 1)
        in (pure f <*> (pure x :: [Int])) == pure (f x)

      it "follows the interchange law" $ property $ \x ->
        let u = pure (+ 1)
        in (u <*> (pure x :: [Int])) == (pure ($ x) <*> u)

      it "follows the composition law" $ property $ \x ->
        let u = pure (+ 1)
            v = pure (* 3)
        in (u <*> (v <*> x)) == (pure (.) <*> u <*> v <*> (x :: [Int]))

      it "follows the functor law" $ property $ \x ->
        let g = (+ 1)
        in fmap g x == (pure g <*> (x :: [Int]))

    describe "maybe" $ do
      it "applies the function to the value inside of Just" $ do
        (Just (+ 1) <*> Just 1) == (Just 2)

      it "follows the identity law" $ property $ \x ->
        (pure id <*> x) == (x :: Maybe Int)

      it "follow the homomorphism law" $ property $ \x ->
        let f = (+ 1)
        in (pure f <*> (pure x :: Maybe Int)) == pure (f x)

      it "follows the interchange law" $ property $ \x ->
        let u = pure (+ 1)
        in (u <*> (pure x :: Maybe Int)) == (pure ($ x) <*> u)

      it "follows the composition law" $ property $ \x ->
        let u = pure (+ 1)
            v = pure (* 3)
        in (u <*> (v <*> x)) == (pure (.) <*> u <*> v <*> (x :: Maybe Int))

      it "follows the functor law" $ property $ \x ->
        let g = (+ 1)
        in fmap g x == (pure g <*> (x :: Maybe Int))
