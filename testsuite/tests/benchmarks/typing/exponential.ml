(* TEST
script = "sh ${test_source_directory}/../benchmark.sh typing"
flags = "-dtimings"
* setup-ocamlopt.byte-build-env
** ocamlopt.byte
*** script
*)

let pair x f = f x x
let f1 x = pair x
let f2 x = f1 (f1 x)
let f3 x = f2 (f2 x)
let f4 x = f3 (f3 x)
let f5 x = f4 (f4 x)
let final z = f5 (fun x -> x) z
