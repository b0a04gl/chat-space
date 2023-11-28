open Unix
open Shared

let rec start_server port =
  try
    let sockaddr = ADDR_INET (inet_addr_loopback, port) in
    let server_sock = socket PF_INET SOCK_STREAM 0 in
    bind server_sock sockaddr;
    Printf.printf "Server started..\n> %!" ;

    listen server_sock 1;
    let client_sock, _ = accept server_sock in
    let in_channel = Lwt_io.of_fd ~mode:Lwt_io.input (Lwt_unix.of_unix_file_descr client_sock) in
    let out_channel = Lwt_io.of_fd ~mode:Lwt_io.output (Lwt_unix.of_unix_file_descr client_sock) in

    let _ = Lwt.async (fun () -> listen_for_messages in_channel out_channel) in

    Lwt_main.run (send_user_input in_channel out_channel)
  with
  | Unix.Unix_error (Unix.EADDRINUSE, _, _) ->
    Printf.printf "Error: Port %d is already in use. Exiting...\n" port
  | _ ->
    Printf.printf "Error.. relistening ... \n";
    start_server port
