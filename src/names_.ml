include Names

module Id = struct
  include Id

  let map fn t =
    t
    |> Names.Id.to_string
    |> fn
    |> Names.Id.of_string
end

module DirPath = struct
  include DirPath

  let case ~empty ~snoc t =
    match repr t with
    | [] ->
        empty
    | id :: ids ->
        snoc id (make ids)
end

let lident_of_string str =
  str
  |> Names.Id.of_string
  |> CAst.make

let lname_of_lident =
  CAst.map Names.Name.mk_name
let lname_of_ident id =
  id
  |> Names.Name.mk_name
  |> CAst.make
let lname_of_string str =
  str
  |> Names.Id.of_string
  |> lname_of_ident
