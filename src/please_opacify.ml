module Register : sig
  val begin_ :
    unit -> unit
  val end_ :
    unit -> unit

  val get :
    unit -> Names.Id.t list

  val add :
    Names.Id.t -> unit

  val clear :
    unit -> unit
end = struct
  let scopes =
    Stack.create ()

  let begin_ () =
    Stack.push Names.Id.Set.empty scopes

  let () =
    begin_ ()

  let end_ () =
    if 1 < Stack.length scopes then
      Stack.drop scopes

  let get () =
    Stack.top scopes |> Names.Id.Set.elements

  let add id =
    let scope = Stack.pop scopes in
    let scope = Names.Id.Set.add id scope in
    Stack.push scope scopes

  let clear () =
    Stack.drop scopes ;
    Stack.push Names.Id.Set.empty scopes
end

let interp_register ~state ~locality id def =
  let state =
    Vernacinterp_.interp_synpure ~state
      [ ( locality
        , VernacDefinition
          ( (NoDischarge, Definition)
          , (id |> Names_.lname_of_lident, None)
          , def
          )
        )
      ]
  in
  Vernacstate_.unfreeze_full_state state ;
  Register.add id.v
let interp_register ~locality id def =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    interp_register ~state ~locality id def

let interp_opacify ~state =
  let vernacs =
    Register.get () |> List.map @@ fun id ->
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
  Register.clear ()
let interp_opacify () =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    interp_opacify ~state

let interp_begin =
  Register.begin_

let interp_end =
  Register.end_
