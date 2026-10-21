open Ltac_plugin

type kind =
  | Inhabited
  | Eq_decision
  | Countable

val interp :
  locality:Hints.hint_locality ->
  kind:kind ->
  ty:Libnames.qualid ->
  unit
