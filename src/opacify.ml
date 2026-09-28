module Register : sig
  type t

  val empty :
    t
  val add :
    Names.Id.t -> t -> t
  val iter :
    (Names.Id.t -> unit) -> t -> unit

  val update :
    (t -> t) -> unit
end = struct
  type t =
    Names.Id.t list

  let empty =
    []

  let add id t =
    id :: t

  let iter fn t =
    List.iter fn t

  let registered =
    ref empty
  let update fn =
    let t = !registered in
    try
      registered := fn t
    with exn ->
      registered := t ;
      raise exn
end

let register ~state ~reg id def =
  let state =
    Vernacinterp_.interp ~state
      [ ( None
        , VernacDefinition
          ( (NoDischarge, Definition)
          , (id |> Names_.lname_of_ident, None)
          , def
          )
        )
      ] ;
  in
  Vernacstate_.unfreeze_full_state state ;
  Register.add id reg
let register id def =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    Register.update @@ fun reg ->
      register ~state ~reg id def

let opacify ~state ~reg =
  reg |> Register.iter (fun id ->
    let state =
      Vernacinterp_.interp ~state
        [ ( Some SuperGlobal
          , VernacSetOpacity
            ( ( Opaque
              , [Constrexpr.AN (id |> Libnames.qualid_of_ident) |> CAst.make]
              )
            , false
            )
          )
        ] ;
    in
    Vernacstate_.unfreeze_full_state state ;
  ) ;
  Register.empty
let opacify () =
  Vernacstate_.freeze_full_state_and_try @@ fun state ->
    Register.update @@ fun reg ->
      opacify ~state ~reg
