module Menagerie.Applicative where

import Prelude (Maybe(..))
import Menagerie.Functor

(<$>) :: (Functor f) => (a -> b) -> f a -> f b
(<$>) = fmap

class Functor f => Applicative f where
  pure  :: a -> f a
  infixl 4 <*>
  (<*>) :: f (a -> b) -> f a -> f b

instance Applicative [] where
  pure a    = [a]
  fs <*> as = [f a | f <- fs, a <- as]

instance Applicative Maybe where
  pure a = Just a
  (Just f) <*> (Just a) = Just (f a)
  _        <*> _        = Nothing
