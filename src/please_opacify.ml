module Register : sig
  type t =
    Names.Id.t list

  val modify :
    (t -> t) -> unit
end = struct
  type t =
    Names.Id.t list

  let registered =
    ref []

  let modify fn =
    let t = !registered in
    try
      registered := fn t
    with exn ->
      registered := t ;
      raise exn
end

let register ~state ~reg ~locality id def =
  let state =
    Vernacinterp_.interp ~state
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
let register ~locality id def =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    Register.modify @@ fun reg ->
      register ~state ~reg ~locality id def

let opacify ~state ~reg =
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
  let state = Vernacinterp_.interp ~state vernacs in
  Vernacstate_.unfreeze_full_state state ;
  []
let opacify () =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    Register.modify @@ fun reg ->
      opacify ~state ~reg
