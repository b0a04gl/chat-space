(lang dune 3.11)

(name chat_space)

(generate_opam_files true)

(source
 (github b0a04gl/chat-space))

(authors "Balaji Arumugam")

(maintainers "b0a04gl")

(license MIT)

(documentation https://github.com/b0a04gl/chat-space#readme)

(package
 (name chat_space)
 (synopsis "One-on-one chat")
 (description "Message exchange between client and server using sockets")
(depends
  (ocaml (>= 4.08))
  (dune (>= 3.0.0))
  (lwt (>= 5.0.0))
  (yojson (>= 1.7.0))
  (ounit2 (>= 2.2.0))
)

 (tags
  (topics "socket" chat_space)))
