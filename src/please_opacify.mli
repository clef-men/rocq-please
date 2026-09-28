val register :
  locality:Hints.hint_locality option ->
  Names.Id.t ->
  Vernacexpr.definition_expr ->
  unit

val opacify :
  unit -> unit
