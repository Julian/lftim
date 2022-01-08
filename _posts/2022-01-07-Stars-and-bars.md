layout: post
title: "Stars and bars"
date: 2022-01-07
categories: combinatorics

# Stars and bars

Last month December, in a [pull request](https://github.com/leanprover-community/mathlib/pull/11162), mathlib learned the proof of stars and bars.

Let's learn the proof ourselves, and learn a bit about how the proof is represented in Lean.

_For this and most posts, you likely will want to follow along yourself. Have a look at the [Lean Community Getting Started](https://leanprover-community.github.io/get_started.html) instructions if you haven't already set up your own copy of mathlib._

We'll be looking at mathlib's [src/data/sym/card.lean](https://github.com/leanprover-community/mathlib/blob/51069535ef130ef34349ee3123107a799a0de39c/src/data/sym/card.lean), which is where this bit of mathematics lives.

# The Mathematical Idea
[Wolfram MathWorld](https://mathworld.wolfram.com/Multichoose.html) succinctly states:
> The number of multisets of length k on n symbols is sometimes termed "n multichoose k". n multichoose k is given by the simple formula C(n + k - 1, k).

> Multichoose problems are sometimes called "bars and stars" problems.

The reason why this formula is called "stars and bars" is because stars and bars is a good way to understand how the formula works. Let's say we want to count the number of multisets with cardinality 3 that consist of 5 symbols: 0, 1, 2, 3 and 4.

There are 35 multisets.

```
{{4,4,4},{3,4,4},{3,3,4},{3,3,3},{2,4,4},{2,3,4},{2,3,3},{2,2,4},{2,2,3},{2,2,2},{1,4,4},{1,3,4},{1,3,3},{1,2,4},{1,2,3},{1,2,2},{1,1,4},{1,1,3},{1,1,2},{1,1,1},{0,4,4},{0,3,4},{0,3,3},{0,2,4},{0,2,3},{0,2,2},{0,1,4},{0,1,3},{0,1,2},{0,1,1},{0,0,4},{0,0,3},{0,0,2},{0,0,1},{0,0,0}}
```

How can we count without enumerating everything though?

Notice that there is another way to represent each multiset.

This is how we represent `{4,4,4}`.
# 🍫🍫🍫🍫⭐⭐⭐

The first 🍫 means the multiset contains no `0` element.  
The second 🍫 means the multiset contains no `1` element.  
The third 🍫 means the multiset contains no `2` element.  
The fourth 🍫 means the multiset contains no `3` element.  
The ⭐⭐⭐ means the multiset contains three `3` elements.

This is how we represent `{3,4,4}`.
# 🍫🍫🍫⭐🍫⭐⭐

The first 🍫 means the multiset contains no `0` element.  
The second 🍫 means the multiset contains no `1` element.  
The third 🍫 means the multiset contains no `2` element.  
Then ⭐🍫 means the multiset contains one `3` element.  
The ⭐⭐ means the multiset contains two `4` elements.  

You can see the pattern here. 

The number of ⭐ before the first 🍫 is the number of `0`s in the multiset.  
The number of ⭐ between the first and the second 🍫 is the number of `1`s in the multiset.  
The number of ⭐ between the second and the third 🍫 is the number of `2`s in the multiset.  
The number of ⭐ between the third and the fourth 🍫 is the number of `3`s in the multiset.  
The number of ⭐ after the fourth 🍫 is the number of `4`s in the multiset.  

The number of 🍫 is the number of symbols minus one. Because we have 5 symbols, there are always 4 🍫.  
The number of ⭐ is the cardinality of a multiset. The cardinality of a multiset is 3, so we have 3 ⭐.

When we look at the multisets this way, we can see that the number of multisets is equal to the number of strings of ⭐ and 🍫. We can easily calculate the number of strings by using the formula C(n + k - 1, k), where k is the cardinality of the multiset and n is the number of symbols.

# Lean
In Lean however, there's no stars and there's no bars. We simply can't simulate the informal stars and bars proof in Lean. We need another approach.

The type signature of `stars_and_bars` looks like this:
```lean
lemma stars_and_bars {α : Type*} [decidable_eq α] [fintype α] (n : ℕ) :
  fintype.card (sym α n) = (fintype.card α + n - 1).choose n :=
```

We need to think very formally. We can't just let our imagination roam free because we would get lost.

Notice that because `α` is a `fintype`, there exists an `n` such that `α` is equinumerous to `fin n`. So we can map `α` to `fin n`. Then we need to prove `fintype.card (sym (fin n) k) = (fintype.card (fin n) + k - 1).choose n`.

Notice that `fintype.card (fin n) = n`, so we need to prove `fintype.card (sym (fin n) k) = (n + k - 1).choose n`. Let `multichoose1` be `fintype.card (sym (fin n) k)` and `multichoose2` be `(n + k - 1).choose k`. Now the statement reduces to `multichoose1 = multichoose2`.

Clearly, `multichoose1 n.succ k.succ = multichoose1 n k.succ + multichoose1 n.succ k`. We can use `nat.choose_succ_succ` to prove this.

We can show that `multichoose2` satisfies the same recurrence relation, that is, `multichoose2 n.succ k.succ = multichoose2 n k.succ + multichoose2 n.succ k`. This is equivalent to proving `sym (fin n.succ) k.succ` is equinumerous to `sym (fin n) k.succ ⊕ sym (fin n.succ) k`.

To prove this, we need an `encode` and a `decode` function.

The `encode` function produces a `sym (fin n) k.succ` if the input doesn't contain `fin.last n` by casting `fin n.succ` to `fin n`. Otherwise, the function removes an instance of `fin.last n` from the input and produces a `sym (fin n.succ) k`.

From the output of `encode`, the `decode` function reconstructs the original input. If the output contains `k.succ` elements, the original input can be reconstructed by casting `fin n` back to `fin n.succ`. Otherwise, an instance of `fin.last n` has been removed and the input can be reconstructed by adding it back.

As `encode` and `decode` are inverses of each other, `sym (fin n.succ) k.succ` is equivalent to `sym (fin n) k.succ ⊕ sym (fin n.succ) k`.

This is the proof strategy. The rest is implementation detail.
