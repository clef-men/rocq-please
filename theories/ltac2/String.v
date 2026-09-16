Require Import Stdlib.Strings.String.

Require Export Ltac2.Init.
Require Export Ltac2.String.

Require Import please.prelude.
Require please.ltac2.Char.
Require please.ltac2.Message.
Require Import please.ltac2.Notations.
Require Import please.options.

Module Rocq.
  Ltac2 Type t :=
    constr.

  Ltac2 rec length t :=
    match! t with
    | EmptyString =>
        0
    | String _ ?t =>
        Int.add 1 (length t)
    | _ =>
        Control.throw (Invalid_argument (Some (Message.of_string "String.Rocq.length")))
    end.
End Rocq.

#[local] Ltac2 rec blit_rocq_bytes i bytes t :=
  lazy_match! bytes with
  | nil =>
        ()
  | ?byte :: ?bytes =>
      let chr := Char.of_rocq byte in
      String.set t i chr ;
      blit_rocq_bytes (Int.add i 1) bytes t
  end.
Ltac2 of_rocq_string str :=
  let t := String.make (Rocq.length str) (Char.of_int 0) in
  let bytes := Std.eval_vm None constr:(list_byte_of_string $str) in
  blit_rocq_bytes 0 bytes t ;
  t.
