Require Export Ltac2.Ident.
Require Export Ltac2.Init.

Require Import please.prelude.
Require Import please.ltac2.Notations.
Require please.ltac2.String.
Require Import please.options.

Ltac2 of_string_opt :=
  of_string.

Ltac2 of_string str :=
  match Ident.of_string str with
  | Some id =>
      id
  | None =>
      Control.throw (Invalid_argument (Some (Message.of_string "Ident.of_string")))
  end.

Ltac2 of_rocq str :=
  let str := String.of_rocq_string str in
  let str := of_string str in
  str.

Ltac2 rec list_of_rocq strs :=
  lazy_match! strs with
  | nil =>
      []
  | cons ?str ?strs =>
      let t := of_rocq str in
      let ts := list_of_rocq strs in
      t :: ts
  end.
