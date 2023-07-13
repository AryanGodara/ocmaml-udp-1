open Lwt

(* Shared mutable counter *)
let listen_address = Unix.inet_addr_loopback
let port = 9000

let handle_message msg =
  print_endline ("Received message in handle_message: " ^ msg);
  match msg with "quit" -> "quit" | _ -> "Ready for next message"

let rec handle_request server_socket =
  server_socket >>= fun server_socket ->
  (* Wait for promise server_socket to resolve, and then use its value *)
  print_endline "Ready to send request";
  print_endline "Enter the value you want to send to the UDP Server: ";

  let userMsg = read_line () in

  Lwt_unix.sendto server_socket (Bytes.of_string userMsg) 0
    (String.length userMsg) []
    (ADDR_INET (listen_address, port))
  >>= fun _ ->
  print_endline "Request sent";

  let buffer = Bytes.create 1024 in
  Lwt_unix.recvfrom server_socket buffer 0 1024 []
  >>= fun (num_bytes, _) ->
  print_endline "Received response from server";
  let message = Bytes.sub_string buffer 0 num_bytes in
  print_endline ("Received message in handle_request: " ^ message);
  let reply = handle_message message in
  match reply with
  | "quit" ->
      print_endline "Quitting Client...";
      return ()
  | _ ->
    print_endline ("Reply from server: " ^ reply);
    handle_request (return server_socket)

      (* print_endline "Enter the value you want to send to the UDP Server: ";
      Lwt_unix.sendto server_socket (Bytes.of_string reply) 0
        (String.length reply) [] client_address
      >>= fun _ ->
      print_endline "Reply sent";
      handle_request (return server_socket) *)

let create_client sock =
  print_endline "Creating client";
  handle_request sock

let create_socket () : Lwt_unix.file_descr Lwt.t =
  print_endline "Creating socket";
  let open Lwt_unix in
  let sock = socket PF_INET SOCK_DGRAM 0 in
  return sock
(* bind sock @@ ADDR_INET (listen_address, port) >>= fun () -> return sock *)
