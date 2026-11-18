let nat =
  "Corelib.Init.Datatypes.nat"
let nat_qualid =
  nat
  |> Libnames.qualid_of_string
let nat_gref () =
  nat_qualid
  |> Nametab.global

let _Z =
  "Corelib.Numbers.BinNums.Z"
let _Z_qualid =
  _Z
  |> Libnames.qualid_of_string
let _Z_gref () =
  _Z_qualid
  |> Nametab.global

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
