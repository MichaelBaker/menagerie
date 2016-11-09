module Menagerie.Functor where

import Prelude (Either(..), (.))

class Functor f where
  fmap :: (a -> b) -> f a -> f b

-- LAWS
-- 1. fmap id = id
-- 2. fmap (g . h) = (fmap g) . (fmap h)

instance Functor [] where
  fmap _ []     = []
  fmap g (a:as) = g a : fmap g as

instance Functor (Either l) where
  fmap _ (Left l)  = Left l
  fmap g (Right r) = Right (g r)

instance Functor ((->) a) where
  fmap g h  = g . h
