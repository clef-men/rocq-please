val register :
  locality:Hints.hint_locality option ->
  Names.lident ->
  Vernacexpr.definition_expr ->
  unit

val opacify :
  unit -> unit
