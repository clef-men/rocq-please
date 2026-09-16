Require Export Ltac2.Char.
Require Export Ltac2.Init.

Require Import please.prelude.
Require please.ltac2.Int.
Require Import please.options.

Ltac2 of_rocq byte :=
  of_int (Int.of_rocq_byte byte).
