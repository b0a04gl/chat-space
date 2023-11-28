open OUnit2
open Shared


let test_format_timestamp _ =
  let timestamp = Unix.time () in
  let formatted_timestamp = format_timestamp timestamp in

  let expected_length = 19 in
  let msg_length = Printf.sprintf "Expected length: %d, Actual length: %d" expected_length (String.length formatted_timestamp) in
  OUnit2.assert_equal ~msg:msg_length expected_length (String.length formatted_timestamp)


let test_generate_message_id _ =
  let id1 = generate_message_id () in
  let id2 = generate_message_id () in
  assert_bool "Generated message IDs should be different" (id1 <> id2)

let test_message_to_json _ =
  let message = { id = 1; payload = "Test"; created_time = 123.45; message_type = Normal } in
  let json = message_to_json message in
  let expected_json = `Assoc [
    "id", `Int 1;
    "payload", `String "Test";
    "created_time", `Float 123.45;
    "message_type", `String "Normal"
  ] in
  assert_equal ~printer:Yojson.Basic.to_string expected_json json

let suite =
  "Test Suite" >::: [
    "test_format_timestamp" >:: test_format_timestamp;
    "test_generate_message_id" >:: test_generate_message_id;
    "test_message_to_json" >:: test_message_to_json;
  ]

let () = run_test_tt_main suite
