module Menagerie.Functor where

import Prelude (($), (.), Either(..), Maybe(..))

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

instance Functor Maybe where
  fmap f (Just a) = Just (f a)
  fmap _ Nothing  = Nothing

newtype Compose a b c = Compose { extract :: a (b c) }
instance (Functor a, Functor b) => Functor (Compose a b) where
  fmap g (Compose f) = Compose $ fmap (fmap g) f
