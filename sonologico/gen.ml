open Containers

module Gen (M : Mllvin_intf.S) = struct
  open M

  let now () = Unix.gettimeofday ()

  let seconds () =
    let zero = now () in
    fun () -> now () -. zero


  let singleton x =
    let finished = ref false in
    fun () ->
      if !finished
      then raise Done
      else (
        finished := true ;
        x )


  let of_array xs =
    let i = ref 0 in
    fun () ->
      if !i >= Array.length xs
      then raise Done
      else (
        incr i ;
        xs.(!i) )


  let of_list xs = of_array (Array.of_list xs)

  let take n g =
    let k = ref n in
    fun () ->
      if !k = 0
      then raise Done
      else (
        decr k ;
        g () )


  let discard g =
    ignore (g ()) ;
    g


  let drop n g =
    let rec loop g = function 0 -> () | k -> loop (discard g) (k - 1) in
    loop g n ;
    g


  let interleave xs =
    let arr = Array.of_list xs in
    let index = ref 0 in
    fun () ->
      let i = !index in
      index := (i + 1) mod Array.length arr ;
      arr.(i) ()


  let repeat x () = x

  let ( ~> ) = repeat

  let cycle xs =
    let arr = Array.of_list xs in
    let index = ref 0 in
    fun () ->
      let i = !index in
      index := (i + 1) mod Array.length arr ;
      arr.(i)


  let stutter count gen =
    let curr = ref None in
    let curr_count = ref 0 in
    fun () ->
      while !curr_count = 0 do
        curr := Some (gen ()) ;
        curr_count := count ()
      done ;
      decr curr_count ;
      Option.get_exn !curr


  let seq ?(single = false) lst =
    let arr = Array.of_seq (Seq.map (fun f -> f ()) (List.to_std_seq lst)) in
    let index = ref 0 in
    let rec loop () =
      let i = !index in
      if i < Array.length arr
      then (
        try arr.(i) () with
        | Done ->
            incr index ;
            loop () )
      else if single
      then raise Done
      else (
        List.iteri (fun i f -> arr.(i) <- f ()) lst ;
        index := 0 ;
        loop () )
    in
    loop


  let time_bound dur f =
    let limit = now () +. dur in
    fun () -> Float.(if now () >= limit then raise Done else f ())


  let tbseq ?(single = false) lst =
    seq ~single (List.map (fun (f, d) () -> time_bound d (f ())) lst)


  let zip_with f a b () = f (a ()) (b ())

  module Rnd = struct
    let int low high () = Random.run (Random.int_range low (high - 1))

    let float low high () = Random.run (Random.float_range low high)

    let bool = Random.bool

    let beta ~alpha ~beta =
      let distr = Pareto.Distributions.Beta.create ~alpha ~beta in
      fun () -> Pareto.Distributions.Beta.random distr


    let bernoulli p =
      let distr = Pareto.Distributions.Bernoulli.create ~p in
      fun () -> Pareto.Distributions.Bernoulli.random distr


    let binomial ~trials ~p =
      let distr = Pareto.Distributions.Binomial.create ~trials ~p in
      fun () -> Pareto.Distributions.Binomial.random distr


    let cauchy ~location ~scale =
      let distr = Pareto.Distributions.Cauchy.create ~location ~scale in
      fun () -> Pareto.Distributions.Cauchy.random distr


    let chi_squared df =
      let distr = Pareto.Distributions.ChiSquared.create ~df in
      fun () -> Pareto.Distributions.ChiSquared.random distr


    let exponential scale =
      let distr = Pareto.Distributions.Exponential.create ~scale in
      fun () -> Pareto.Distributions.Exponential.random distr


    let gamma ~shape ~scale =
      let distr = Pareto.Distributions.Gamma.create ~shape ~scale in
      fun () -> Pareto.Distributions.Gamma.random distr


    let gaussian mean stdev =
      let distr = Pareto.Distributions.Normal.create ~mean ~sd:stdev in
      fun () -> Pareto.Distributions.Normal.random distr


    let geometric p =
      let distr = Pareto.Distributions.Geometric.create ~p in
      fun () -> Pareto.Distributions.Geometric.random distr


    let hypergeometric ~m ~t ~k =
      let distr = Pareto.Distributions.Hypergeometric.create ~m ~t ~k in
      fun () -> Pareto.Distributions.Hypergeometric.random distr


    let logistic ~location ~scale =
      let distr = Pareto.Distributions.Logistic.create ~location ~scale in
      fun () -> Pareto.Distributions.Logistic.random distr


    let log_normal ~mean ~stdev =
      let distr = Pareto.Distributions.LogNormal.create ~mean ~sd:stdev in
      fun () -> Pareto.Distributions.LogNormal.random distr


    let negative_binomial ~failures ~p =
      let distr = Pareto.Distributions.NegativeBinomial.create ~failures ~p in
      fun () -> Pareto.Distributions.NegativeBinomial.random distr


    let poisson rate =
      let distr = Pareto.Distributions.Poisson.create ~rate in
      fun () -> Pareto.Distributions.Poisson.random distr


    let t df =
      let distr = Pareto.Distributions.T.create ~df in
      fun () -> Pareto.Distributions.T.random distr


    let one_of xs =
      let arr = Array.of_list xs in
      fun () -> arr.(Random.run (Random.int (Array.length arr)))


    module Weighted_int = Pareto.Distributions.Categorical.Make (Int)

    let wone_of xs =
      let arr = Array.of_list xs in
      let arr_fst = Array.map fst arr in
      let distr =
        Weighted_int.create (Array.mapi (fun i (_, prob) -> (i, prob)) arr)
      in
      fun () ->
        let i = Weighted_int.random distr in
        arr_fst.(i)
  end

  let rec filter f xs () =
    let x = xs () in
    if f xs then x else filter f xs ()


  let map f g () = f (g ())

  let bind f g () = f (g ()) ()

  let labelled_pair label dur =
    let ref = dref label Dyn.Conv.(tup2 float float) in
    match !?ref with
    | None ->
        let zero_t = now () in
        let pair = (zero_t, zero_t +. dur) in
        ref <-- pair ;
        pair
    | Some pair ->
        pair


  let line ?(continue = false) label ((a, b) as dst) dur =
    let open Float in
    let cmp_f = if b > a then Float.min else Float.max in
    let src = labelled_pair label dur in
    fun () ->
      let x = Gamag.Range_map.lin_exp ~src ~dst (now ()) in
      if continue then x else cmp_f b x


  let linex ?(continue = false) label ((a, b) as dst) dur =
    let open Float in
    let cmp_f = if b > a then Float.min else Float.max in
    let src = labelled_pair label dur in
    fun () ->
      let x = Gamag.Range_map.lin_exp ~src ~dst (now ()) in
      if continue then x else cmp_f b x


  let sine label range period =
    let src = labelled_pair label period in
    fun () ->
      Gamag.Range_map.lin ~src:(-1.0, 1.0) ~dst:range
      @@ sin
      @@ Gamag.Range_map.lin
           ~src
           ~dst:
             ( 0.0
             , 2.0
               *. 3.141592653589793238462643
             )
           (now ())


  let cosine ?(range = (0.0, 1.0)) period =
    let zero_t = now () in
    fun () ->
      Gamag.Range_map.lin ~src:(-1.0, 1.0) ~dst:range
      @@ cos
      @@ Gamag.Range_map.lin
           ~src:(zero_t, zero_t +. period)
           ~dst:
             ( 0.0
             , 2.0
               *. 3.141592653589793238462643
             )
           (now ())


  let hann label range dur = time_bound dur (sine label range (dur *. 2.))

  let iterate init f =
    let s = ref init in
    fun () ->
      let x = !s in
      s := f x ;
      x


  let some_or_none x = Rnd.one_of [ Some x; None ]

  let rec rem' x n = if x < 0 then rem' (x + n) n else x mod n

  let mod_walk ~modulo init step =
    iterate init (fun x -> rem' (x + step ()) (modulo ()))


  let walk init step = iterate init (fun x -> x + step ())

  let walk_float init step = iterate init (fun x -> x +. step ())

  let zip a b () = (a (), b ())

  let zip3 a b c () = (a (), b (), c ())

  let zip4 a b c d () = (a (), b (), c (), d ())

  let zip5 a b c d e () = (a (), b (), c (), d (), e ())

  let zip6 a b c d e f () = (a (), b (), c (), d (), e (), f ())

  let zip7 a b c d e f g () = (a (), b (), c (), d (), e (), f (), g ())

  let zip8 a b c d e f g h () = (a (), b (), c (), d (), e (), f (), g (), h ())

  let zip9 a b c d e f g h i () =
    (a (), b (), c (), d (), e (), f (), g (), h (), i ())


  let zip10 a b c d e f g h i j () =
    (a (), b (), c (), d (), e (), f (), g (), h (), i (), j ())


  let ( +~ ) = zip_with ( + )

  let ( *~ ) = zip_with ( * )

  let ( /~ ) = zip_with ( / )

  let ( -~ ) = zip_with ( - )

  let ( +.~ ) = zip_with ( +. )

  let ( *.~ ) = zip_with ( *. )

  let ( -.~ ) = zip_with ( -. )

  let ( /.~ ) = zip_with ( /. )

  let ( ||~ ) (a : unit -> 'a) (b : unit -> 'a) : unit -> 'a =
    let x = Rnd.one_of [ a; b ] in
    fun () -> x () ()


  module Infix = struct
    let ( >|= ) x f = map f x

    let ( >>= ) x f = bind f x
  end

  let ( ! ) = repeat
end
