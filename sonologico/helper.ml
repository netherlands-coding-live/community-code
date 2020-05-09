open! Containers

let addr = Unix.ADDR_INET (Unix.inet_addr_of_string "127.0.0.1", 4997)

module Lib (M : Mllvin_intf.S) = struct
  open M
  include Gen.Gen (M)
  include Rnd

  let fd = Unix.socket Unix.PF_INET Unix.SOCK_DGRAM 0

  let scatterp period ~dens ~pos f =
    let nr_grains = Float.(round (dens * period)) in
    let avg_sep = period /. nr_grains in
    let events =
      Array.init (Float.to_int nr_grains) (fun i ->
          let sync_pos = Float.of_int i *. avg_sep in
          let pos_factor =
            Gamag.Range_map.lin ~src:(0., 1.) ~dst:(0., avg_sep) (pos ())
          in
          let pos_t = Float.max 0. (sync_pos +. pos_factor) in
          f pos_t)
    in
    let str =
      "$"
      ^ Array.to_string
          ~sep:"\n"
          (fun x -> "i" ^ Array.to_string ~sep:" " string_of_float x)
          events
      ^ "\n"
    in
    Unix.sendto_substring fd str 0 (String.length str) [] addr |> ignore


  let now = now

  let wait x = Unix.sleepf x

  let wait_until x = wait (x -. now ())

  let disable = true

  let l1 = "_:l1" %: Dyn.Conv.proc

  let l2 = "_:l2" %: Dyn.Conv.proc

  let l3 = "_:l3" %: Dyn.Conv.proc

  let l4 = "_:l4" %: Dyn.Conv.proc

  let l5 = "_:l5" %: Dyn.Conv.proc

  let l6 = "_:l6" %: Dyn.Conv.proc

  let l7 = "_:l7" %: Dyn.Conv.proc

  let l8 = "_:l8" %: Dyn.Conv.proc

  let root = "root" %: Dyn.Conv.float

  let scatterg
      ?env
      ?distort
      ?filter
      ?modfreq
      ?(dens = 1.0)
      ?(pos = ~>0.0)
      ?(dur = ~>0.5)
      ?(rate = ~>1.0)
      ?(phase = float 0.0 1.0)
      ?(amp = ~>0.1)
      ?(pan = float 0.0 1.0)
      period
      () =
    scatterp period ~dens ~pos (fun pos ->
        let distort, pre, post, negative, positive, d2factor =
          match distort with
          | None ->
              (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
          | Some f ->
              let  d2factor = f () in
              (1.0, 4., 0.9, 1.0, 1.8, d2factor)
        in
        let filter, freq, bwr =
          match filter with
          | None ->
              (0.0, 0.0, 0.0)
          | Some f ->
              let freq, bwr = f () in
              (1.0, freq, bwr)
        in
        let env, att =
          match env with None -> (0.0, 0.0) | Some f -> (1.0, f ())
        in
        let imod, modfreq =
          match modfreq with None -> (0.0, 0.0) | Some f -> (1.0, f ())
        in
        [| 1.0
         ; pos
         ; Float.max 0.0 (dur ())
         ; 10.
         ; rate () (* rate *)
         ; phase () (* phase *)
         ; amp () (* amp *)
         ; env (* env *)
         ; att (* env.perc.att *)
         ; distort (* distort *)
         ; pre (* pregain *)
         ; post (* postgain *)
         ; negative (* negative *)
         ; positive (* positive *)
         ; filter (* filter *)
         ; freq (* freq *)
         ; bwr (* bwr *)
         ; pan () (* pan *)
         ; imod
         ; modfreq
         ; d2factor
        |])


  let of_scale oct scale () = (Rnd.one_of scale (), oct ())

  let harmonics ?(detune = fun () -> 1.0) root p () =
    float_of_int (Rnd.geometric p ()) *. root () *. detune ()


  let n1 = "n1"

  let n2 = "n2"

  let n3 = "n3"

  let n4 = "n4"

  let n5 = "n5"

  let n6 = "n6"

  let n7 = "n7"

  let n8 = "n8"

  let repeat_in period ?(init = "") ?(disable = false) ref f =
    if disable
    then ref <-- fun () -> ()
    else (
      ( ref
      <-- fun () ->
      let next = now () +. period in
      f () ;
      wait_until next ;
      !!ref () ) ;
      if not (String.equal init "") then unique init !!ref () )
end
