
open Printf

let (>>=) = Lwt.bind

module Lwt_thread = struct
  include Lwt
  include Lwt_chan
end

module Lwt_PGOCaml = PGOCaml_generic.Make (Lwt_thread)

let print_row row =
	let string_of_optional = function
		| None -> "NULL"
        | Some str -> sprintf "%S" str
	in
		List.map string_of_optional row |>
		String.concat "; " |>
		Lwt_io.printl

let init () =
	let query = "select * from package;"
	and user = "iatidq"
	and name = "stmt1" (* nonce identifier of prepared statement *)
	in

	lwt dbh = Lwt_PGOCaml.connect ~user () in
        Lwt_PGOCaml.prepare dbh ~query ~name () >>
        Lwt_PGOCaml.execute dbh ~name ~params:[] () >>=
        Lwt_list.iter_s print_row >>
        Lwt_PGOCaml.close dbh
