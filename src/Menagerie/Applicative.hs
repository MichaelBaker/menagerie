module Menagerie.Applicative where

import Prelude ()
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
