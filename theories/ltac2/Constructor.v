Require Export Ltac2.Constructor.
Require Export Ltac2.Init.

Require Import please.prelude.
Require please.ltac2.Constr.
Require please.ltac2.Ind.
Require Import please.options.

Ltac2 number_index t inst :=
  Ind.number_index (inductive t) inst.

Ltac2 arity_full t inst :=
  let t := Constr.Unsafe.make_constructor t inst in
  Constr.product_arity (Constr.type t).
Ltac2 arity t inst :=
  Int.sub (arity_full t inst) (number_index t inst).
