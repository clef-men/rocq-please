Require Import please.prelude.
Require Import please.options.

Ltac solve_inhabited :=
  first
  [ apply _
  | refine (populate _);
    constructor; apply inhabitant
  ].

Module tests.
  Variant test₁ :=
    | test₁₁ : False → test₁
    | test₁₂
    | test₁₃ : False → test₁.
  #[local] Instance test₁ｰinhabited : Inhabited test₁ :=
    ltac:(solve_inhabited).

  Variant test₂ :=
    | test₂₁ : False → test₂
    | test₂₂ : unit → test₂
    | test₂₃ : False → test₂.
  #[local] Instance test₂ｰinhabited : Inhabited test₂ :=
    ltac:(solve_inhabited).

  Variant test₃ :=
    | test₃₁ : False → test₃
    | test₃₂ : unit → unit → test₃
    | test₃₃ : False → test₃.
  #[local] Instance test₃ｰinhabited : Inhabited test₃ :=
    ltac:(solve_inhabited).
End tests.
