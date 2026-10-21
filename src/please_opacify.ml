module Register : sig
  type t =
    Names.Id.t list

  val begin_ :
    unit -> unit
  val end_ :
    unit -> unit

  val modify :
    (t -> t) -> unit
end = struct
  type t =
    Names.Id.t list

  let registered =
    Stack.create ()

  let begin_ () =
    Stack.push (ref []) registered

  let () =
    begin_ ()

  let end_ () =
    if 1 < Stack.length registered then
      Stack.drop registered

  let modify fn =
    let registered = Stack.top registered in
    let t = !registered in
    try
      registered := fn t
    with exn ->
      registered := t ;
      raise exn
end

let interp_register ~state ~reg ~locality id def =
  let state =
    Vernacinterp_.interp_synpure ~state
      [ ( locality
        , VernacDefinition
          ( (NoDischarge, Definition)
          , (id |> Names_.lname_of_lident, None)
          , def
          )
        )
      ] ;
  in
  Vernacstate_.unfreeze_full_state state ;
  id.v :: reg
let interp_register ~locality id def =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    Register.modify @@ fun reg ->
      interp_register ~state ~reg ~locality id def

let interp_opacify ~state ~reg =
  let vernacs =
    reg |> List.map @@ fun id ->
      let open Vernacexpr in
      let open Constrexpr in
      ( Some Libobject.SuperGlobal
      , VernacSetOpacity
        ( ( Opaque
          , [AN (id |> Libnames.qualid_of_ident) |> CAst.make]
          )
        , false
        )
      )
  in
  let state = Vernacinterp_.interp_synpure ~state vernacs in
  Vernacstate_.unfreeze_full_state state ;
  []
let interp_opacify () =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    Register.modify @@ fun reg ->
      interp_opacify ~state ~reg

let interp_begin =
  Register.begin_

let interp_end =
  Register.end_
