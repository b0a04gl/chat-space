(* main.ml *)

open Server
open Client

let () =
  print_endline "Choose mode: (1) Server, (2) Client";
  match read_int () with
  | 1 ->
    print_endline "Enter the port number for the server:";
    let port = read_int () in
    start_server port
  | 2 ->
    print_endline "Enter the port number for the client:";
    let port = read_int () in
    start_client port
  | _ -> failwith "Invalid choice"
