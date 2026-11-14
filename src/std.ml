let nil =
  "Corelib.Init.Datatypes.nil"
let nil_constr =
  nil
  |> Libnames.qualid_of_string
  |> (fun qualid -> Constrexpr.CRef (qualid, None))
  |> CAst.make

let cons =
  "Corelib.Init.Datatypes.cons"
let cons_constr =
  cons
  |> Libnames.qualid_of_string
  |> (fun qualid -> Constrexpr.CRef (qualid, None))
  |> CAst.make
