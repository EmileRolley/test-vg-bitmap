open Gg
open Vg
open P2

let simple_cut ?(c = Color.black) p =
  I.cut ~area:(`O { P.o with P.width = 0.01 }) p (I.const c)

(* PASS. (mod y-flip) *)
let two_stroked_straight_lines =
  P.empty
  |> P.sub (v 0.2 0.)
  |> P.line (v 0.5 0.25)
  |> P.line (v 0.25 0.5)
  |> simple_cut

(* PASS. (mod y-flip) *)
let three_stroked_straight_lines =
  P.empty
  |> P.sub (v 0.2 0.)
  |> P.line (v 0.5 0.25)
  |> P.line (v 0.25 0.5)
  |> P.line (v (-0.25) 0.3)
  |> simple_cut

(* PASS. (mod y-flip) *)
let two_stroked_sub_lines =
  P.empty
  |> P.sub (v 0.2 0.)
  |> P.line (v 0.5 0.25)
  |> P.sub (v 0.25 0.5)
  |> P.line (v (-0.25) 0.3)
  |> simple_cut

(* PASS. (mod y-flip) *)
let issue_12 =
  P.empty
  |> P.rect (Box2.v (v 0.25 0.25) (v 0.75 0.75))
  |> simple_cut ~c:(Color.v 0.2 0.2 0.8 1.)

(* PASS. (mod y-flip) *)
let simple_stroked_square =
  P.empty
  |> P.rect (Box2.v (v 0.25 0.25) (v 0.50 0.50))
  |> simple_cut ~c:(Color.v 0.2 0.2 0.8 1.)

(* PASS. (mod y-flip) *)
let imbricated_stroked_squares =
  P.empty
  |> P.rect (Box2.v (v 0.25 0.25) (v 0.5 0.5))
  |> P.rect (Box2.v (v 0.3 0.3) (v 0.4 0.4))
  |> simple_cut ~c:(Color.v 0.2 0.2 0.8 1.)
