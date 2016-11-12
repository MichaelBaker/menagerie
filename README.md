# Menagerie

This is my attempt to make sense of the menagerie of typeclasses that are commonly used in Haskell. It is mostly a reinterpretation of my reading of [Typeclassopedia](https://wiki.haskell.org/Typeclassopedia) at this point.

## Section Template

This is the structure that each typeclass description will follow.

```
## <Typeclass Name>
Freeform introductory comments about the typeclass.

### Typeclass
The Haskell definition of the typeclass.

### Assumptions
A list of simplifying assumptions that the typeclass allows us to make about its instances.

### Laws
A list of rules that a good instance of the typeclass will follow, even if the type system cannot check them.

### Value
An explanation of what value the typeclass provides. What does it let you do? Why would you make one yourself? How should you think about an instance of this typeclass provided by a library?
```

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

### Typeclass

```
class Functor f where
  fmap :: (a -> b) -> f a -> f b
```

### Assumptions

* `f` itself is always parameterized by another type. 
* `f` has one behavior, called `fmap`, which takes an `f` parameterized by one type `a`, a function `g` converting that type to another type `b`, and produces an `f` parameterized by the new type `b`. In a sense, `fmap` defines a way to change the type parameter of `f` on the fly.
* Functor makes no assumptions about the type parameter of `f`.
* Functor makes no assumptions about the function `g` except that the input to the function is of the same type as the input functor's parameter. It may look like we're assuming that `a` and `b` are different, but in reality we're simply saying that they can be different, not that they must be. This is actually removing an assumption rather than adding one.

Instances of the typeclass cannot make any assumptions about the type parameter or the nature of the function because the abstraction doesn't make those assumptions. This simplifies instances because they don't need to be concerned with the details of the type parameter or the function. The type parameter adds zero cognitive load to the abstraction.

Instances must, however, address the details of `f`. 

### Laws

Assumptions that cannot be encoded directly in the type system are often called laws. Laws place restrictions on how an instance of the typeclass can behave. An instance that violates the laws will still compile, but there is no guarantee that the instance will behave correctly with other code because the code might be operating under the assumption that every instance also satisfies these less formal laws.

* `fmap id = id`
  * Mapping the `id` function over a functor has no effect on the functor or the values it contains.
  * `fmap` has no side effects.

* `fmap (g . h) = (fmap g) . (fmap h)`
  * `fmap` is distributive over function composition.
  * Because it has no side effects, applying fmap once is the same as applying it multiple times and composing the results.

These laws are meant to ensure that fmap never alters the `f` it's being applied to. The benefit of that restriction is that it makes Functors easier to use. When you write an algorithm using `fmap`, you can totally ignore the `f` because the `fmap` can't change it anyway.

### Value

So what's the point? How should you think about a Functor that a libary gives you to work with? When should you think about making your own Functor?

Remember that abstractions have two benefits. They simplify problems and facilitate code reuse.

It's subtle, but the Functor abstraction makes life easier for by the implementor and the user by controlling who has what information. The implementor worries about the details of the functor, the user worries about the details of the type parameter, and neither worries about anything else.

Libraries often create a Functor to attach some kind of book keeping to any arbitrary data the user might have. In fact, that's all they can do, because they can't control the type parameter. One classic example is a tree. A tree is useful because many of its operations are fast, but often the user doesn't care that it's a tree. They just want to know that they can store things in it and that is operations will be fast. When the library writer creates their instance of Functor for their tree, they only worry about how to traverse the tree, which is in their wheelhouse because they're they ones making the damn thing. As a user, I now have a standard, simple way to apply transformations to every element in the tree with absolutely zero need to understand how it works. And if I'm writing another library that takes an abitrary functor as an argument, then I only need to worry about the types. I know I have a way to convert `f a` into `f b` and that's the end of the story.

Functors facilitate reuse because often you've already got a function `a -> b` lying around from some other code you've written and by definition, you can reuse that function with any functor in existance. If you've got a function that sanitizes an email address, you can use it to sanitize a list of email addresses with zero effort. `sanitize myAddress` becomes `fmap sanitize myEmailAddresses`. And this works for the tremendous number of Functor instances out there.

## Applicative

Applicative is a lot like Functor, but it unlocks a whole world of possibilities by describing computation (the application of functions) inside of a context.

### Typeclass

```
class Functor f => Applicative f where
  pure  :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
```

### Assumptions

* `f` is a type that has exactly one type parameter
* `f` also has a Functor instance. This allows us to assume that if we have an applicative type, we can also use it as a functor for free. This is a fair assumption to make because you can mechanically generate an instance of Functor from an instance of Applicative.
* No other assumptions are made about the nature of `f` itself or its type parameter `a`.

### Laws

* `pure id <*> v = v`
  * Applying `id` in the context of a functor has the same meaning as applying `id` normally would.
  * Applying a function in the context of a functor has no side effects.
  * We can work with applicative computations the same way we would work with normal computations.

* `pure f <*> pure x = pure (f x)`
  * This is a generalizatino of the above law.
  * Applying a function inside the context of a functor has the same meaning as applying the function outside of the context of the functor.

* `u <*> pure y = pure ($ y) <*> u`
  * The order of evaluation does not effect the meaning of of `<*>`, just as it would not with normal evaluation. Again, demonstrating the lack of side effects.

* `u <*> (v <*> w) = pure (.) <*> u <*> v <*> w`
  * Function composition has the same meaning inside of the context as it does outside.

### Value

Functor lets you execute computations on a type `a` embeded inside a structure `f` without modifying that structure. Put another way, Functor lets you perform ordinary computations on values living in a context. Applicative, with a seemingly minor addition, provides a framework for creating an entirely new language using ordinary functions. It does this by adding context to both the values _and_ the computations of an expression. The creator of a Functor gets no visibility into the computation happening inside of fmap. Applicative gives its creator a method for performing some book keeping at each computational step while still separating the book keeping from the computation itself. The power of this is that you can program in a completely normal style, but the result of your expression is not a final value, but instead a datastructure describing how to get the final value. That in turn lets you reinterpret the computation in any way you want.

From this perspective, functions that work for any Applicative are providing ways to building descriptions of arbitrary computations and instances of Applicative are providing different interpreters for those descriptions.
