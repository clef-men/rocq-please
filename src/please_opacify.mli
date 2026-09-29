val register :
  locality:Hints.hint_locality option ->
  Names.lident ->
  Vernacexpr.definition_expr ->
  unit

val opacify :
  unit -> unit

val begin_ :
  unit -> unit
val end_ :
  unit -> unit
