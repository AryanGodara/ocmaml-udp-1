let () =
  print_endline "Launching UDP Server...";

  let () = Logs.set_reporter (Logs.format_reporter ()) in
  let () = Logs.set_level (Some Logs.Info) in

  let server_socket = Server.create_socket () in
  Lwt_main.run Server.(create_server server_socket)
