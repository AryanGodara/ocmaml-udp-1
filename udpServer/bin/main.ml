let () =
    print_endline "Hello, world!";
    let () = Logs.set_reporter (Logs.format_reporter ()) in
    let () = Logs.set_level (Some Logs.Info) in
    (* let sock = Server.create_socket () in
    let serve = Server.create_server sock in
    Lwt_main.run @@ serve *)

    let server_socket = Server.create_socket () in
    Lwt_main.run Server.(create_server server_socket)


    (* Lwt_main.run @@ ( let redune build
    c serve () = Lwt_unix.accept sock >>= accept_connection >>= serve in serve ) () *)