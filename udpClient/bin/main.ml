let () =
  print_endline "Launching UDP Client...";

  let () = Logs.set_reporter (Logs.format_reporter ()) in
  let () = Logs.set_level (Some Logs.Info) in

  let client_socket = Client.create_socket () in
  Lwt_main.run Client.(create_client client_socket)
