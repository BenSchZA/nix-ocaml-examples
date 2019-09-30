open Graphql_lwt
(* open Graphql *)

type role = User | Admin
type user = {
  id   : int;
  name : string;
  role : role;
}

let users = [
  { id = 1; name = "Alice"; role = Admin };
  { id = 2; name = "Bob"; role = User }
]

let role = Schema.(enum "role"
  ~doc:"The role of a user"
  ~values:[
    enum_value "USER" ~value:User;
    enum_value "ADMIN" ~value:Admin;
  ]
)

let user = Schema.(obj "user"
  ~doc:"A user in the system"
  ~fields:(fun _ -> [
    field "id"
      ~doc:"Unique user identifier"
      ~typ:(non_null int)
      ~args:Arg.[]
      ~resolve:(fun info p -> p.id)
    ;
    field "name"
      ~typ:(non_null string)
      ~args:Arg.[]
      ~resolve:(fun info p -> p.name)
    ;
    field "role"
      ~typ:(non_null role)
      ~args:Arg.[]
      ~resolve:(fun info p -> p.role)
  ])
)

let schema = Schema.(schema [
  field "users"
    ~typ:(non_null (list (non_null user)))
    ~args:Arg.[]
    ~resolve:(fun info () -> users)
])

module Graphql_cohttp_lwt = Graphql_cohttp.Make (Schema) (Cohttp_lwt.Body)

let () =
  let callback = Graphql_cohttp_lwt.make_callback (fun _req -> ()) schema in
  let server = Cohttp_lwt_unix.Server.make ~callback () in
  let mode = `TCP (`Port 8080) in
  Cohttp_lwt_unix.Server.create ~mode server
  |> Lwt_main.run