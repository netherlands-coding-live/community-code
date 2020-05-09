(* sonologico - 2020-05 *)
open Mllvin_intf
open! Containers

;;
run
@@ fun (module M : S) ->
let open! M in
let open! Helper.Lib (M) in

let _ =
  node n1 @@ fun () ->
  let period = 1. in
  scatterg period
    ~dens:8.
    ~pos:(gaussian 0.6 0.4)
    ~dur:(gaussian 1.1 0.2)
    ~rate:(sine "r" (0.01, 4.0) 40. *.~ one_of [0.9; 1.2; 2.; 3.; 4.])
    ~amp:(sine "a" (0.1, 0.6) 57.)
    ~modfreq:(float 20. 778. *.~ one_of [1.;2.; 4.1; 0.7; 0.5; 0.3; 0.28; 1.3])
    ~distort:(float 2.0 3.0)
  |> repeat_in period l1 ~disable ~init:"l1"
in

let _ =
  node n2 @@ fun () ->
  let period = 1. in
  scatterg period
    ~dens:16.
    ~dur:(gaussian 3. 0.1)
    ~pos:(float 0. 1.)
    ~rate:(sine "q" (0.01, 0.3) 47.)
    ~amp:(sine "p" (0.1, 0.03) 43.)
    ~filter:(map (fun x -> x , 0.7) (harmonics ~detune:(float 0.7 1.2) !90. 0.7))
    ~modfreq:(float 21. 121.)
    ~distort:(gaussian 1.7 0.2)
  |> repeat_in period l1 ~init:"l1" ~disable
in
let _ =
  node n3 @@ fun () ->
  let period = 1. in
  scatterg period
    ~dens:8.
    ~pos:(gaussian 0.6 0.3)
    ~dur:(gaussian 1.2 0.2)
    ~rate:(sine "r" (0.01, 5.7) 17. *.~ one_of [1.; 1.; 2.; 3.; 4.])
    ~amp:(sine "a" (0.1, 0.4) 57.)
    ~modfreq:(float 7770. 10000.)
    ~filter:(map (fun x -> x , 0.7) (harmonics ~detune:(float 0.9 1.4) !120. 0.7))
    ~distort:(linex "l" (0.01, 2.5) 150.)
  |> repeat_in period l1 ~disable ~init:"l1"
in


()
