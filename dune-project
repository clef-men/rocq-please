(lang dune 3.21)

(using rocq 0.11)

(name rocq-please)

(generate_opam_files)

(authors
 "Clément Allain"
)
(maintainers
 "clement.allain@cs.au.dk"
)

(source (github clef-men/rocq-please))
(license ISC)

(package
 (name rocq-please)
 (synopsis "Common Rocq utilities")
 (depends
  (rocq-core (= 9.2.0))
  (rocq-stdlib (= 9.2.0))
  rocq-stdpp
 )
)
