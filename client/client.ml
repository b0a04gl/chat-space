open Unix
open Shared


let start_client port =
  let server_addr = ADDR_INET (inet_addr_loopback, port) in
  let client_sock = socket PF_INET SOCK_STREAM 0 in
  try
    connect client_sock server_addr;
    Printf.printf "Client started..\n> %!"; 
    let in_channel = Lwt_io.of_fd ~mode:Lwt_io.input (Lwt_unix.of_unix_file_descr client_sock) in
    let out_channel = Lwt_io.of_fd ~mode:Lwt_io.output (Lwt_unix.of_unix_file_descr client_sock) in
    
    let _ = Lwt.async (fun () -> listen_for_messages in_channel out_channel) in

    Lwt_main.run (send_user_input in_channel out_channel)
  with
  | Unix.Unix_error (Unix.ECONNREFUSED, _, _) ->
    Printf.printf "Error: Server is not alive. Exiting...\n"
  | ex ->
    Printf.printf "Error: %s\n" (Printexc.to_string ex)
