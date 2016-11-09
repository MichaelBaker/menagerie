# Menagerie

## Abstraction

Abstraction is a technique that is used to simplify problem solving and create compact, general solutions that we can use to solve a wide variety of problems.

Programmers lean heavily on abstraction to convert wildly complex problems into managable ones and to convert solutions written by one programmer into reusable pieces of code that other programmers can use to save time and avoid making the same mistakes as others who have already solved their problem.

An abstraction is a set of assumptions about the way a thing behaves, regardless of the specifics of the thing. In a programming language with objects, an abstraction can be represented by a set of methods with particular behaviors. Different classes can then implement the abstraction by defining those methods in a way that makes sense for that particular class. Languages with an ML style type system represent abstractions as a set of functions parameterized by a type. OCaml calls such an abstraction a module whereas Haskell calls it a typeclass. Math is almost nothing but abstraction. Mathematicians take some concrete problem full of unnecessary detail, then they extract only the relevant features of the objects involved, and discard the rest of the specifics.

I've promised that using this technique will simplify problems and make their solutions reusable.

An abstraction simplifies a problem by dramatically reducing the number of things you need to understand in order to verify that your solution is correct. A programmer writing an algorithm in terms of an abstraction only needs to understand the assumptions of the abstraction in order to understand the algorithm. They don't need to be concerned with the limitless combinations of inputs behaviors available in the language.

Such an abstract algorithm is also inherently reusable because if a programmer maps their problem onto the abstraction then the original solution, which will work for anything that meets the assumptions of the abstraction, will work reliably for their problem too.

Defining an abstraction then is all about specifying these assumptions in a clear way and seeing where they take us.

I'll be demonstrating the common abstractions of Haskell. Haskell's abstractions are extremely general, which makes them opaque to programmers who aren't used to them. But that is also what makes them so powerful. It is because they are so general and because they make so few assumptions about your specific problem that they are extremely reusable. In fact, one or more of these abstractions are used in just about every Haskell program I've ever read.

## Functor

The Functor typeclass is parameterized by one type, we'll call `f`. This means that for the purposes of the abstraction we are not allowed to know any specifics of `f` except those that we define in the abstraction.

## Typeclass

class Functor f where
  fmap :: (a -> b) -> f a -> f b

### Assumptions

* `f` itself is always parameterized by another type. 
* `f` has one behavior, called `fmap`, which takes an `f` parameterized by one type `a`, a function `g` converting that type to another type `b`, and produces an `f` parameterized by the new type `b`. In a sense, `fmap` defines a way to change the type parameter of `f` on the fly.
* Functor makes no assumptions about the type parameter of `f`.
* Functor makes no assumptions about the function `g` except that the input to the function is of the same type as the input functor's parameter. It may look like we're assuming that `a` and `b` are different, but in reality we're simply saying that they can be different, not that they must be. This is actually removing an assumption rather than adding one.

Instances of the typeclass cannot make any assumptions about the type parameter or the nature of the function because the abstraction doesn't make those assumptions. This simplifies instances because they don't need to be concerned with the details of the type parameter or the function. The type parameter adds zero cognitive load to the abstraction.

Instances must, however, address the details of `f`. 

### Laws

Assumptions that cannot be encoded directly in the type system are often called laws. Laws place restrictions on how an instance of the typeclass can behave. An instance that violates the laws will still compile, but there is no guarantee that the instance will behave correctly with other code because the code might be operating under the assumption that every instance also satisfies these less formal laws.

* fmap id = id
* fmap (g . h) = (fmap g) . (fmap h)
