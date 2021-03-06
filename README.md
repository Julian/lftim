# Lean for the Inept Mathematician

This repository contains source files for a number of articles or posts aimed at explaining bite-sized mathematical concepts with the help of the [Lean Theorem Prover](https://leanprover.github.io/) and [mathlib](https://github.com/leanprover-community/mathlib/), its library of mathematics.

The authors of these posts are themselves not mathematicians (so corrections or pointers are most welcome!).
We aim to learn ourselves, and in the process, perhaps explain a thing or two about mathlib to any who find it useful.

*The name, self-deprecatingly (for those of us who choose to apply it to ourselves), is an homage to the wonderful Lean for the Curious Mathematician event held annually by the Lean community for the last few years.*

## Contributing

You can place Lean code in the `lean` directory and run `$ python lean2md.py lean _posts` to turn your code into a post. Lean docstrings will turn into regular text and everything else will be encapsulated inside code blocks.

This repository is also a Lean project that has `mathlib` as dependency. You
can get cached `olean` files by doing `leanproject get-mathlib-cache`.

# Configure Git hooks
This repository contains a pre-commit hook to automatically convert Lean source files to Markdown files on commit. If you want to use this hook, run
```
$ git config core.hooksPath ./git-hooks
$ chmod +x ./git-hooks/pre-commit
```

Otherwise, you can run `python3 lean2md.py lean _posts` to convert Lean files to Markdown.
