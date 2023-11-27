(lang dune 3.11)

(name chat_space)

(generate_opam_files true)

(source
 (github b0a04gl/chat-space))

(authors "Balaji Arumugam")

(maintainers "b0a04gl")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name chat_space)
 (synopsis "One-on-one chat")
 (description "Message exchange between client and server using sockets")
 (depends ocaml dune unix)
 (tags
  (topics "socket" chat_space)))