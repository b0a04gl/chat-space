open OUnit2
open Shared

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
    "test_generate_message_id" >:: test_generate_message_id;
    "test_message_to_json" >:: test_message_to_json;
  ]

let () = run_test_tt_main suite
