# Please [[rocqdoc](https://clef-men.github.io/doc/rocq-please/toc.html)]

## Building

First, you need to install [`opam`](https://opam.ocaml.org/) (>= 2.0).

To make sure it is up-to-date, run:

```
opam update --all --repositories
```

Then, create a new local `opam` switch and install dependencies with:

```
opam switch create . --empty --repos default,rocq-released=https://rocq-prover.github.io/opam/released,iris-dev=git+https://gitlab.mpi-sws.org/iris/opam.git --yes
eval $(opam env --switch=. --set-switch)
opam install . --deps-only --yes
```

Finally, to compile the Rocq plugin and Rocq proofs, run:

```
make
```

## Installation

rocq-please is not available on `opam` yet, but you can use it in your Rocq developments by adding the following `opam` dependency:

```
pin-depends: [
  ["rocq-please.dev" "git+https://github.com/clef-men/rocq-please.git#main"]
]
depends: [
  "rocq-please"
]
```
