open Ltac_plugin

module type SPEC = sig
  val class_ :
    string
  val tactic :
    string
  val name :
    string
  val opaque :
    bool
end

module Make (Spec : SPEC) = struct
  let class_ =
    Spec.class_
    |> Libnames.qualid_of_string
    |> (fun id -> Constrexpr.CRef (id, None))
    |> CAst.make

  let solve () =
    Spec.tactic
    |> Libnames.qualid_of_string
    |> Tacenv.locate_tactic
    |> Loc.tag
    |> Tacexpr.(fun id -> TacArg (Reference (Locus.ArgArg id)))
    |> CAst.make
    |> Tacinterp.eval_tactic

  let derive ~locality ~ty =
    let ty_name = ty |> Libnames.qualid_basename |> Names.Id.to_string in
    let name = Printf.sprintf "%sｰ%s" ty_name Spec.name in
    let name = Names.(Name.Name (Id.of_string name)) |> CAst.make in
    let ty = Constrexpr.CRef (ty, None) |> CAst.make in
    let class_ = Constrexpr.CApp (class_, [ty, None]) |> CAst.make in
    let _id, proof =
      Classes.new_instance_interactive
        ~locality
        ~poly:PolyFlags.default
        (name, None)
        []
        class_
        Hints.empty_hint_info
        None
    in
    let _ctx, proof =
      Declare.Proof.set_proof_using
        proof
        (Proof_using.using_from_string "Type*")
    in
    let proof, _safe =
      Declare.Proof.by
        (Global.env ())
        (solve ())
        proof
    in
    let _refs =
      Declare.Proof.save_regular
        ~proof
        ~opaque:(if Spec.opaque then Opaque else Transparent)
        ~idopt:None
    in
    ()
end

module Inhabited =
  Make (
    struct
      let class_ =
        "stdpp.base.Inhabited"
      let tactic =
        "please.inhabited.solve_inhabited"
      let name =
        "inhabited"
      let opaque =
        false
    end
  )

module Eq_decision =
  Make (
    struct
      let class_ =
        "stdpp.base.EqDecision"
      let tactic =
        "stdpp.decidable.solve_decision"
      let name =
        "eq_dec"
      let opaque =
        false
    end
  )

module Countable =
  Make (
    struct
      let class_ =
        "stdpp.countable.Countable"
      let tactic =
        "please.countable.solve_countable"
      let name =
        "countable"
      let opaque =
        true
    end
  )

type kind =
  | Inhabited
  | Eq_decision
  | Countable

let derive ~locality ~kind ~ty =
  match kind with
  | Inhabited ->
      Inhabited.derive ~locality ~ty
  | Eq_decision ->
      Eq_decision.derive ~locality ~ty
  | Countable ->
      Countable.derive ~locality ~ty
