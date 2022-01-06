layout: post
title: "Lattice Ordered Groups"
date: 2022-01-06
categories: algebra

# Lattice Ordered Groups

This past August, in a [pull request](https://github.com/leanprover-community/mathlib/pull/8673), mathlib learned what a lattice-ordered group is.

Let's learn what one is ourselves, and learn a bit about what Lean knows about them.

*For this and most posts, you likely will want to follow along yourself. Have a look at the [Lean Community Getting Started](https://leanprover-community.github.io/get_started.html) instructions if you haven't already set up your own copy of mathlib.*

We'll be looking at mathlib's [src/algebra/order/lattice_group.lean file](https://github.com/leanprover-community/mathlib/blob/master/src/algebra/order/lattice_group.lean), which is where this bit of mathematics lives.

## The Mathematical Idea

[nLab](https://ncatlab.org/nlab/show/lattice+ordered+group) succinctly states:

  > A lattice ordered group is a group which is also a lattice in a compatible way.

There are three pieces of the short definition to decompose. Our structure will:

  * have a multiplication[^1], `*`, and this multiplication will satisfy the group axioms (a full refresher of these is [here](https://en.wikipedia.org/wiki/Group_(mathematics)#Definition)). Our Lean file will deal mostly with commutative groups (ones where a * b = b * a), so we will assume here that our group is commutative unless otherwise mentioned.

  * have a way to partially order elements, `≤`, and this order is a [lattice](https://en.wikipedia.org/wiki/Lattice_(order)) -- meaning in short, any two elements have a unique element which is their supremum (or least upper bound) and one which is their infimum (or greatest lower bound). In simple terms, given two elements, one can find a unique least element which both are simultaneously less than or equal to.

  * the multiplication and order "play well" with each other -- meaning specifically, if `a ≤ b`, then `a * g ≤ b * g` for any elements `a`, `b` and `g`. In other words, if `a` is less than `b`, multiplying both sides by the same group element preserves the order.[^2]

[^1]: Lean, discussed momentarily, has two ways to represent the operation in a group -- multiplicatively with `*`, or additively with `+`. Mathematically which one uses is purely a matter of notation, since a group is defined simply to have a binary operation which can be represented using any desired symbol (and Lean uses some automation to duplicate everything it knows about groups to both notations). In this article we will restrict ourselves to groups notated multiplicatively.

[^2] In general mathematical objects with 2 or more kinds of structure on them (here a multiplication and an order) seem to be "interesting" mostly when the two structures interact with each other somehow, rather than being completely unrelated, such as by simply asking that group elements be orderable without adding any additional axioms for how the multiplication interacts with the order.

## Lean

From our lattice group's docstring, we can see that Lean has 3 [typeclasses](https://leanprover-community.github.io/glossary.html#class) which correspond quite directly to the above definition:


    > A lattice ordered commutative group is a type `α` satisfying:

    > * `[lattice α]`
    > * `[comm_group α]`
    > * `[covariant_class α α (*) (≤)]`

The first two are somewhat transparent -- they say that a type `α` is a lattice and a commutative group. The third must represent our "play nicely" axiom, which indeed it does, but in a more generic setting, typical of mathlib's preference for generality. More details on how this says what's needed can be found in [`covariant_class`'s own docstring](https://leanprover-community.github.io/mathlib_docs/algebra/covariant_and_contravariant.html#covariant_class), but in brief it puts the condition laid out above on the multiplication and order of our structure.

## More Lean

In successive pull requests, Lean learned even more about these objects.

See:

  * [#10322](https://github.com/leanprover-community/mathlib/pull/10322)

## Further Resources

  * Wikipedia's article on [Partially Ordered Groups](https://en.wikipedia.org/wiki/Partially_ordered_group) which discusses variations and generalizations

  * [Lattice Ordered Group from nLab](https://ncatlab.org/nlab/show/lattice+ordered+group)

<!---
What class, if any, might someone learn about these objects? Order theory? A further class in group theory?
-->
