val interp_register :
  locality:Hints.hint_locality option ->
  Names.lident ->
  Vernacexpr.definition_expr ->
  unit

val interp_opacify :
  unit -> unit

val interp_begin :
  unit -> unit
val interp_end :
  unit -> unit
