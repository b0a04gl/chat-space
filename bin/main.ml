open Server
open Client

let print_help () =
  Printf.printf "Usage: main.exe <mode: 1 for Server, 2 for Client> <port>\n"

let () =
  match Array.to_list Sys.argv with
  | [_; "--0help"] | [_; "--0h"] ->
    print_help ()
  | [_; mode_str; port_str] ->
    let mode = int_of_string mode_str in
    let port = int_of_string port_str in
    (match mode with
    | 1 -> start_server port
    | 2 -> start_client port
    | _ -> failwith "Invalid choice for mode")
  | _ ->
    failwith "Invalid command-line arguments. Use --0help for usage information."
