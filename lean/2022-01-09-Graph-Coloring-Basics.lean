/-
layout: post
title: "Graph Coloring Basics"
date: 2022-01-09
categories: graph

Prelude:

* [Graph homomorphism](https://en.wikipedia.org/wiki/Graph_homomorphism)
* [NP-hardness](https://en.wikipedia.org/wiki/NP-hardness)

# Graph Coloring Basics

In Graph Theory, finding a proper coloring of a graph regards to attributing "colors"
to its vertices in a way that adjacent vertices have different colors.

[In Lean](https://github.com/leanprover-community/mathlib/pull/10287), a coloring (short
for "proper coloring") is represented as a homomorphism from the graph being colored to
the complete graph of available colors. Let's seen an example of how this works.

Suppose we have a graph `G` that we want to color with three colors: `c1`, `c2` and `c3`.

```
      G            Complete graph of colors
  D-------A                   c₁
  |       | \                /  \
  |       |  C              c₂---c₃
  |       | /
  E-------B
```

The following mapping can be seen as a coloring of `G`:

```
A → c₁
B → c₂
C → c₃
D → c₂
E → c₃
```

Now note that this mapping is in fact a homomorphism. And you may wonder, why does such
a homomorphism represent a coloring?

Informally, consider two adjacent vertices in G. Since our mapping is an homomorphism,
those vertices must be mapped to adjacent vertices in the complete graph of colors.
And such adjacent vertices represent different colors.

You can check Mathlib's formalization of the above [here](https://leanprover-community.github.io/mathlib_docs/combinatorics/simple_graph/coloring.html#simple_graph.coloring.valid).

Let's play with the API a bit.

-/

import combinatorics.simple_graph.coloring
import tactic.derive_fintype

@[derive [decidable_eq, fintype]]
inductive verts : Type
| A | B | C | D | E

open verts

def edges : list (verts × verts) :=
[ (A, B), (B, C), (A, C), (A, D), (D, E), (B, E) ]

/- This function tells whether two vertices are adjacent. -/

def adj (v w : verts) : bool := edges.mem (v, w) || edges.mem (w, v)

/- Coercing `bool` to `Prop`: -/

def adj_prop (v w : verts) : Prop := adj v w

/- The following proofs are required to construct a `simple_graph`: -/

lemma adj_symmetric : ∀ (x y : verts), adj x y → adj y x := dec_trivial
lemma adj_loopless : ∀ (x : verts), ¬adj x x := dec_trivial

def my_graph : simple_graph verts := ⟨adj_prop, adj_symmetric, adj_loopless⟩

/- Now we can color `my_graph`.-/

@[derive [decidable_eq, fintype]]
inductive colors : Type
| c₁ | c₂ | c₃

open colors

def color_fn : verts → colors
  | A := c₁
  | B := c₂
  | C := c₃
  | D := c₂
  | E := c₃

/- And this proof allows us to use the API: -/

lemma color_fn_is_valid : ∀ (v w : verts), adj v w → color_fn v ≠ color_fn w :=
dec_trivial

def my_coloring : my_graph.coloring colors := ⟨color_fn, color_fn_is_valid⟩

/-
Notice that `color_fn_is_valid` wouldn't have been accepted by Lean if `color_fn`
weren't in fact a proper coloring function.

## The real challenge

Coloring graphs would be a trivial task if we could use as many colors as we wanted.
Just color each vertex with a different color! This is done in [Mathlib](https://leanprover-community.github.io/mathlib_docs/combinatorics/simple_graph/coloring.html#simple_graph.self_coloring)
by coloring vertices using themselves as colors.

However, the interesting question is: what is the **minimum** number of colors required
to color a certain graph? This quantity is called *chromatic number* and finding it
for any given graph is a NP-Hard problem. Although Mathlib does provide proofs for some
known results:

* If `G` is a subgraph of `G'`, the chromatic number of `G'` is at least the
chromatic number of `G`

    [`simple_graph.chromatic_number_le_of_le_colorable`](https://leanprover-community.github.io/mathlib_docs/combinatorics/simple_graph/coloring.html#simple_graph.chromatic_number_le_of_le_colorable)

* The chromatic number of a complete graph is the number of vertices it has:

    [`simple_graph.chromatic_number_complete_graph`](https://leanprover-community.github.io/mathlib_docs/combinatorics/simple_graph/coloring.html#simple_graph.chromatic_number_complete_graph)

* The chromatic number of a complete bipartite graph is 2:

    [`simple_graph.complete_bipartite_graph.chromatic_number`](https://leanprover-community.github.io/mathlib_docs/combinatorics/simple_graph/coloring.html#simple_graph.complete_bipartite_graph.chromatic_number)

## Conclusion

Graph coloring is an important problem in Computer Science, with
[applications](https://en.wikipedia.org/wiki/Graph_coloring#Applications) in different
areas of study. This is an ongoing field of research and finding lower/upper bounds for
the chromatic number, as well as potent coloring heuristics for graphs of certain shapes,
is of immense value for the academic community and for the industry in general.
-/
