open Gg
open Vg

(* PASS. (mod y-flip) *)
let two_straight_lines =
  let l =
    P.empty
    |> P.sub (P2.v 0.2 0.)
    |> P.line (P2.v 0.5 0.25)
    |> P.line (P2.v 0.25 0.5)
  in
  I.cut ~area:(`O { P.o with P.width = 0.01 }) l (I.const Color.red)

(* PASS. (mod y-flip) *)
let three_straight_lines =
  let l =
    P.empty
    |> P.sub (P2.v 0.2 0.)
    |> P.line (P2.v 0.5 0.25)
    |> P.line (P2.v 0.25 0.5)
    |> P.line (P2.v (-0.25) 0.3)
  in
  I.cut ~area:(`O { P.o with P.width = 0.01 }) l (I.const Color.red)

(* PASS. (mod y-flip) *)
let two_sub_lines =
  let l =
    P.empty
    |> P.sub (P2.v 0.2 0.)
    |> P.line (P2.v 0.5 0.25)
    |> P.sub (P2.v 0.25 0.5)
    |> P.line (P2.v (-0.25) 0.3)
  in
  I.cut ~area:(`O { P.o with P.width = 0.01 }) l (I.const Color.red)
