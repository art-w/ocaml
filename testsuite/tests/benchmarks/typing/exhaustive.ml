(* TEST
script = "sh ${test_source_directory}/../benchmark.sh typing"
flags = "-dtimings"
* setup-ocamlc.byte-build-env
** ocamlc.byte
*** script
*)

type t0 and t1 and t2 and t3 and t4 and t5 and t6 and t7 and t8 and t9
and t10 and t11 and t12 and t13 and t14 and t15 and t16 and t17 and t18 and t19
and t20 and t21 and t22 and t23 and t24 and t25 and t26 and t27 and t28 and t29

type 'a t =
    | T0 : t0 t -> t0 t
    | T1 : t1 t -> t1 t
    | T2 : t2 t -> t2 t
    | T3 : t3 t -> t3 t
    | T4 : t4 t -> t4 t
    | T5 : t5 t -> t5 t
    | T6 : t6 t -> t6 t
    | T7 : t7 t -> t7 t
    | T8 : t8 t -> t8 t
    | T9 : t9 t -> t9 t
    | T10 : t10 t -> t10 t
    | T11 : t11 t -> t11 t
    | T12 : t12 t -> t12 t
    | T13 : t13 t -> t13 t
    | T14 : t14 t -> t14 t
    | T15 : t15 t -> t15 t
    | T16 : t16 t -> t16 t
    | T17 : t17 t -> t17 t
    | T18 : t18 t -> t18 t
    | T19 : t19 t -> t19 t
    | T20 : t20 t -> t20 t
    | T21 : t21 t -> t21 t
    | T22 : t22 t -> t22 t
    | T23 : t23 t -> t23 t
    | T24 : t24 t -> t24 t
    | T25 : t25 t -> t25 t
    | T26 : t26 t -> t26 t
    | T27 : t27 t -> t27 t
    | T28 : t28 t -> t28 t
    | T29 : t29 t -> t29 t

let rec f : type a. a t -> a = function
    | T0 (T0 (T0 (T0 (T0 (T0 (T0 (T0 (T0 (T0 x))))))))) -> f x
    | T1 (T1 (T1 (T1 (T1 (T1 (T1 (T1 (T1 (T1 x))))))))) -> f x
    | T2 (T2 (T2 (T2 (T2 (T2 (T2 (T2 (T2 (T2 x))))))))) -> f x
    | T3 (T3 (T3 (T3 (T3 (T3 (T3 (T3 (T3 (T3 x))))))))) -> f x
    | T4 (T4 (T4 (T4 (T4 (T4 (T4 (T4 (T4 (T4 x))))))))) -> f x
    | T5 (T5 (T5 (T5 (T5 (T5 (T5 (T5 (T5 (T5 x))))))))) -> f x
    | T6 (T6 (T6 (T6 (T6 (T6 (T6 (T6 (T6 (T6 x))))))))) -> f x
    | T7 (T7 (T7 (T7 (T7 (T7 (T7 (T7 (T7 (T7 x))))))))) -> f x
    | T8 (T8 (T8 (T8 (T8 (T8 (T8 (T8 (T8 (T8 x))))))))) -> f x
    | T9 (T9 (T9 (T9 (T9 (T9 (T9 (T9 (T9 (T9 x))))))))) -> f x
    | T10 (T10 (T10 (T10 (T10 (T10 (T10 (T10 (T10 (T10 x))))))))) -> f x
    | T11 (T11 (T11 (T11 (T11 (T11 (T11 (T11 (T11 (T11 x))))))))) -> f x
    | T12 (T12 (T12 (T12 (T12 (T12 (T12 (T12 (T12 (T12 x))))))))) -> f x
    | T13 (T13 (T13 (T13 (T13 (T13 (T13 (T13 (T13 (T13 x))))))))) -> f x
    | T14 (T14 (T14 (T14 (T14 (T14 (T14 (T14 (T14 (T14 x))))))))) -> f x
    | T15 (T15 (T15 (T15 (T15 (T15 (T15 (T15 (T15 (T15 x))))))))) -> f x
    | T16 (T16 (T16 (T16 (T16 (T16 (T16 (T16 (T16 (T16 x))))))))) -> f x
    | T17 (T17 (T17 (T17 (T17 (T17 (T17 (T17 (T17 (T17 x))))))))) -> f x
    | T18 (T18 (T18 (T18 (T18 (T18 (T18 (T18 (T18 (T18 x))))))))) -> f x
    | T19 (T19 (T19 (T19 (T19 (T19 (T19 (T19 (T19 (T19 x))))))))) -> f x
    | T20 (T20 (T20 (T20 (T20 (T20 (T20 (T20 (T20 (T20 x))))))))) -> f x
    | T21 (T21 (T21 (T21 (T21 (T21 (T21 (T21 (T21 (T21 x))))))))) -> f x
    | T22 (T22 (T22 (T22 (T22 (T22 (T22 (T22 (T22 (T22 x))))))))) -> f x
    | T23 (T23 (T23 (T23 (T23 (T23 (T23 (T23 (T23 (T23 x))))))))) -> f x
    | T24 (T24 (T24 (T24 (T24 (T24 (T24 (T24 (T24 (T24 x))))))))) -> f x
    | T25 (T25 (T25 (T25 (T25 (T25 (T25 (T25 (T25 (T25 x))))))))) -> f x
    | T26 (T26 (T26 (T26 (T26 (T26 (T26 (T26 (T26 (T26 x))))))))) -> f x
    | T27 (T27 (T27 (T27 (T27 (T27 (T27 (T27 (T27 (T27 x))))))))) -> f x
    | T28 (T28 (T28 (T28 (T28 (T28 (T28 (T28 (T28 (T28 x))))))))) -> f x
    | T29 (T29 (T29 (T29 (T29 (T29 (T29 (T29 (T29 (T29 x))))))))) -> f x
    | _ -> .
