open Lwt.Infix
open Yojson.Basic

type message_type = Normal | Ack

type message = {
  id: int;
  payload: string;
  created_time: float;
  message_type: message_type;
}

let message_id_counter = ref 0

let generate_message_id () =
  incr message_id_counter;
  !message_id_counter

let message_to_json msg =
  `Assoc [
    "id", `Int msg.id;
    "payload", `String msg.payload;
    "created_time", `Float msg.created_time;
    "message_type", `String (match msg.message_type with Normal -> "Normal" | Ack -> "Ack")
  ]

let format_timestamp timestamp =
  let localtime = Unix.localtime timestamp in
  Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d"
    (localtime.Unix.tm_year + 1900) (localtime.Unix.tm_mon + 1) localtime.Unix.tm_mday
    localtime.Unix.tm_hour localtime.Unix.tm_min localtime.Unix.tm_sec



let send_message out_channel message =
  let json_message = to_string (message_to_json message) in
  Lwt_io.write_line out_channel json_message >>= fun () ->
  Lwt_io.flush out_channel

let receive_message in_channel =
  Lwt_io.read_line in_channel >>= fun json_message ->
  let message = Yojson.Basic.from_string json_message in
  let id = Yojson.Basic.Util.(message |> member "id" |> to_int) in
  let payload = Yojson.Basic.Util.(message |> member "payload" |> to_string) in
  let created_time = Yojson.Basic.Util.(message |> member "created_time" |> to_float) in
  let message_type =
    match Yojson.Basic.Util.(message |> member "message_type" |> to_string) with
    | "Normal" -> Normal
    | "Ack" -> Ack
    | _ -> Normal
  in
  Lwt.return { id; payload; created_time; message_type }

let rtt_map : (int, float) Hashtbl.t = Hashtbl.create 10

let print_normal_message received_message =
  let formatted_message =
    Printf.sprintf "Timestamp@%s : %s"
      (format_timestamp received_message.created_time)
      received_message.payload
  in
  Lwt_io.printf "> %s\n" formatted_message


let send_ack_message received_message out_channel =
  let ack_message = { id = received_message.id; payload = "Ack"; created_time = Unix.gettimeofday (); message_type = Ack } in
  send_message out_channel ack_message

let handle_ack_message received_message =
  try
    let send_time = Hashtbl.find rtt_map received_message.id in
    let rtt_ns = (Unix.gettimeofday () -. send_time) *. 1_000_000.0 in
    Lwt_io.printf "=> RTT for message %d: %.0f milliseconds\n" received_message.id rtt_ns >>= fun () ->
    Lwt_io.printf "> %!"
  with Not_found -> Lwt.return_unit

let rec listen_for_messages in_channel out_channel =
  receive_message in_channel >>= fun received_message ->
  match received_message.message_type with
  | Normal ->
    print_normal_message received_message >>= fun () ->
    Lwt_io.printf "> %!" >>= fun () ->
    send_ack_message received_message out_channel >>= fun () ->
    listen_for_messages in_channel out_channel
  | Ack ->
    handle_ack_message received_message >>= fun () ->
    listen_for_messages in_channel out_channel


let rec send_user_input out_channel =
 
  Lwt_io.read_line_opt Lwt_io.stdin >>= function
  | Some user_input ->
    let message = { id = generate_message_id (); payload = user_input; created_time = Unix.gettimeofday (); message_type = Normal } in
    Hashtbl.add rtt_map message.id message.created_time;
    send_message out_channel message >>= fun () ->
    send_user_input out_channel
  | None ->
    Lwt.return_unit