open Server
open Client

let print_help () =
  Printf.printf "Usage: main.exe <mode: 1 for Server, 2 for Client> <port>\n"

let () =
  match Array.length Sys.argv with
  | 1 -> failwith "Not enough arguments. Use --0help for usage information."
  | 2 when Sys.argv.(1) = "--0help" || Sys.argv.(1) = "--0h" ->
    print_help ()
  | 3 ->
    let mode = int_of_string Sys.argv.(1) in
    let port = int_of_string Sys.argv.(2) in
    (match mode with
    | 1 -> start_server port
    | 2 -> start_client port
    | _ -> failwith "Invalid choice for mode")
  | _ ->
    failwith "Invalid command-line arguments. Use --0help for usage information."
