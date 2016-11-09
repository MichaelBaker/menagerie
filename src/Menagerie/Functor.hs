module Menagerie.Functor where

import Prelude ()

class Functor f where
  fmap :: (a -> b) -> f a -> f b

-- LAWS
-- 1. fmap id = id
-- 2. fmap (g . h) = (fmap g) . (fmap h)

instance Functor [] where
  fmap _ []     = []
  fmap g (a:as) = g a : fmap g as
