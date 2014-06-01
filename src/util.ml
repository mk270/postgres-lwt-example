
let string_of_optional = function
    | None -> "NULL"
    | Some str -> Printf.sprintf "%S" str

let print_row row =
    List.map string_of_optional row |>
    String.concat "; " |>
    Lwt_io.printl
