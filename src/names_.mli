include module type of struct
  include Names
end

module Id : sig
  include module type of struct
    include Id
  end

  val map :
    (string -> string) -> t -> t
end

module DirPath : sig
  include module type of struct
    include DirPath
  end

  val case :
    empty:'a -> snoc:(Names.Id.t -> t -> 'a) -> t -> 'a
end

val lident_of_string :
  string -> lident

val lname_of_lident :
  lident -> lname
val lname_of_ident :
  Id.t -> lname
val lname_of_string :
  string -> lname
