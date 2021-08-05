(lang dune 2.0)
(name vg-bitmap-test)
(source (github EmileRolley/vg-bitmap-test))
(license MIT)
(authors "Emile Rolley")
(maintainers "Emile Rolley")

(generate_opam_files true)

(package
 (name vg-bitmap-test)
 (synopsis "Temporary repository to store test programs for the WIP Vg bitmap renderer.")
 (depends
  (ocaml (>= 4.08.0))
  (dune (>= 2.0))
  (alcotest :with-test)
  (odoc :with-doc)))
