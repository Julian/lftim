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
