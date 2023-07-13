open Lwt

(* Shared mutable counter *)
let counter = ref 0

let listen_address = Unix.inet_addr_loopback
let port = 9000
let backlog = 10


let handle_message msg =
    print_endline ("Received message in handle_message: " ^ msg);
    match msg with
    | "read" -> string_of_int !counter
    | "inc"  -> counter := !counter + 1; "Counter has been incremented"
    | _      -> "Unknown command"


let rec handle_request server_socket =
  print_endline "Waiting for request";
  let buffer = Bytes.create 1024 in
  print_endline "just created buffer";
  server_socket >>= fun server_socket -> 
    print_endline "just got server_socket";
    Lwt_unix.recvfrom server_socket buffer 0 1024 [] >>= fun (num_bytes, client_address) ->
  print_endline "Received request";
  let message = Bytes.sub_string buffer 0 num_bytes in
  print_endline ("Received message in handle_request: " ^ message);
  let reply = handle_message message in
  print_endline ("Replying with: " ^ reply);
  Lwt_unix.sendto server_socket (Bytes.of_string reply) 0 (String.length reply) [] client_address >>= fun _ ->
    print_endline "Reply sent";
  handle_request (return server_socket)

let my_func (t: unit Lwt.t) : unit Lwt.t =
  t >>= fun () ->
  Lwt.return_unit

let create_socket () : Lwt_unix.file_descr Lwt.t =
    print_endline "Creating socket";
    let open Lwt_unix in
    let sock = socket PF_INET SOCK_DGRAM 0 in
    (* bind sock @@ ADDR_INET(listen_address, port) |> ignore; *)
    (* Unix.sleep 5; *)
    bind sock @@ ADDR_INET(listen_address, port) >>= fun () -> return sock

let create_server sock =
  print_endline "Creating server";
  handle_request sock