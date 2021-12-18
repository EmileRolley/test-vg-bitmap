open Gg
open Vg
open P2

let simple_cut ?(w = 0.07) ?(c = Color.v_srgb 0.48 0.71 0.38 ~a:1.) p =
  I.cut ~area:(`O { P.o with P.width = w }) p (I.const c)

let simple_filled_cut ?(area = `Anz) ?(c = Color.black) p =
  I.cut ~area p (I.const c)

let filled_with_border ?(area = `Anz) ?(c = Color.black) p =
  p |> simple_filled_cut ~area ~c |> I.blend (simple_cut p ~w:0.02)

(* PASS. *)
let two_stroked_straight_lines =
  P.empty
  |> P.sub (v 0.2 0.3)
  |> P.line (v 0.75 0.5)
  |> P.line (v 0.2 0.85)
  |> simple_cut

(* PASS. *)
let three_stroked_straight_lines =
  P.empty
  |> P.sub (v 0.2 0.)
  |> P.line (v 0.5 0.25)
  |> P.line (v 0.25 0.5)
  |> P.line (v (-0.25) 0.3)
  |> simple_cut

(* PASS. *)
let two_stroked_sub_lines =
  P.empty
  |> P.sub (v 0.2 0.)
  |> P.line (v 0.5 0.25)
  |> P.sub (v 0.25 0.5)
  |> P.line (v (-0.25) 0.3)
  |> simple_cut

(* PASS. *)
let closed_sub_paths =
  P.empty
  |> P.sub (v 0.15 0.15)
  |> P.line (v 0.5 0.5)
  |> P.sub (v 0.7 0.6)
  |> P.line (v 0.9 0.7)
  |> P.line (v 0.7 0.9)
  |> P.close
  |> simple_cut

(* PASS. *)
let issue_12 =
  P.empty
  |> P.rect (Box2.v (v 0.25 0.25) (v 0.75 0.75))
  |> simple_cut ~c:(Color.v 0.2 0.2 0.8 1.)

(* PASS. *)
let simple_stroked_square =
  P.empty
  |> P.rect (Box2.v (v 0.25 0.25) (v 0.5 0.5))
  |> simple_cut ~c:(Color.v 0.2 0.2 0.8 1.)

(* PASS. *)
let imbricated_squares =
  P.empty
  |> P.rect (Box2.v (v 0.25 0.25) (v 0.5 0.5))
  |> P.rect (Box2.v (v 0.3 0.3) (v 0.6 0.6))
  |> filled_with_border ~area:`Anz ~c:(Color.v 0.2 0.2 0.8 1.)

(* PASS. *)
let simple_filled_rect =
  P.empty
  |> P.rect (Box2.v (v 0.25 0.25) (v 0.5 0.5))
  |> simple_filled_cut ~area:`Aeo ~c:(Color.v 0.88 0.69 1. 1.)

(* PASS. *)
let imbricated_filled_squares_same_dir =
  P.empty
  |> P.rect (Box2.v (v 0.1 0.1) (v 0.8 0.8))
  |> P.rect (Box2.v (v 0.2 0.2) (v 0.6 0.6))
  |> P.rect (Box2.v (v 0.3 0.3) (v 0.4 0.4))
  |> filled_with_border ~area:`Anz ~c:(Color.v 0.88 0.69 1. 1.)

(* PASS. *)
let imbricated_filled_squares_not_same_dir =
  P.empty
  |> P.rect (Box2.v (v 0.1 0.1) (v 0.8 0.8))
  |> P.sub (v 0.2 0.2)
  |> P.line (v 0.2 0.8)
  |> P.line (v 0.8 0.8)
  |> P.line (v 0.8 0.2)
  |> P.close
  |> P.rect (Box2.v (v 0.3 0.3) (v 0.4 0.4))
  |> filled_with_border ~area:`Anz ~c:(Color.v 0.88 0.69 1. 1.)

(** PASS. *)
let basic_cbezier =
  P.empty |> P.ccurve (v 0.8 0.2) (v 0.2 0.8) (v 0.5 0.5) |> simple_cut

(** PASS. *)
let closed_cbezier =
  P.empty
  |> P.ccurve (v 0.8 0.2) (v 0.8 0.2) (v 0.5 0.8)
  |> P.close
  |> simple_cut

(** PASS. *)
let filled_cbezier =
  P.empty
  |> P.ccurve (v 0.8 0.2) (v 0.8 0.2) (v 0.5 0.8)
  |> P.close
  |> simple_filled_cut ~area:`Aeo ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let mult_filled_cbeziers =
  P.empty
  |> P.ccurve (v 0.6 0.2) (v 0.6 0.2) (v 0.5 0.8)
  |> P.ccurve (v 0.8 0.2) (v 0.8 0.2) (v 0.6 0.3)
  |> P.close
  |> simple_filled_cut ~area:`Aeo ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let mult_filled_cbeziers_bug =
  P.empty
  |> P.ccurve (v 0.8 0.2) (v 0.8 0.2) (v 0.5 0.5)
  |> P.ccurve (v 0.8 0.2) (v 0.8 0.2) (v 0.8 0.2)
  |> P.close
  |> simple_filled_cut ~area:`Aeo ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let simple_qbezier =
  P.empty |> P.qcurve (v 0.8 0.2) (v 0.6 0.8) |> P.close |> simple_cut

(** PASS. *)
let filled_qbezier =
  P.empty
  |> P.qcurve (v 0.6 0.2) (v 0.5 0.5)
  |> P.close
  |> simple_filled_cut ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let mult_filled_qbeziers =
  P.empty
  |> P.qcurve (v 0.8 0.2) (v 0.5 0.5)
  |> P.qcurve (v 0.8 0.2) (v 0.6 0.3)
  |> P.close
  |> simple_filled_cut ~area:`Aeo ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let triangle =
  P.empty
  |> P.sub (v 0.2 0.2)
  |> P.line (v 0.6 0.2)
  |> P.line (v 0.4 0.8)
  |> P.close
  |> simple_filled_cut ~area:`Anz ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let poly1 =
  P.empty
  |> P.sub (v 0.2 0.2)
  |> P.line (v 0.2 0.7)
  |> P.line (v 0.3 0.4)
  |> P.line (v 0.5 0.7)
  |> P.line (v 0.8 0.2)
  |> P.close
  |> filled_with_border ~area:`Aeo ~c:(Color.v 0.48 0.71 0.38 1.)

let star =
  P.empty
  |> P.sub (v 0.2 0.1)
  |> P.line (v 0.5 0.9)
  |> P.line (v 0.8 0.1)
  |> P.line (v 0.1 0.65)
  |> P.line (v 0.9 0.65)
  |> P.close

(** PASS. *)
let nz_star =
  star |> filled_with_border ~area:`Anz ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let eo_star =
  star |> filled_with_border ~area:`Aeo ~c:(Color.v 0.48 0.71 0.38 1.)

(** PASS. *)
let scaled_poly = I.scale (v 0.5 0.5) poly1

(** ERR. *)
let moved_poly = I.move (v 0.25 0.25) scaled_poly

(** PASS. *)
let rotated_poly = I.rot 0.20 moved_poly

(** PASS. *)
let m_poly = I.tr M3.(v 0.5 0. 0.3 0. 1. 0. 0. 0. 1.) scaled_poly

(** PASS. *)
let m_poly2 = I.tr M3.(v 0.5 0. 0.3 0. 1. 0. 0. 0. 1.) rotated_poly

(* FAIL. *)
let even_odd_winding_area_rule =
  let directed_pentagram arrow area r =
    let arrow p0 p1 =
      (* arrow at the beginning of the line p0p1. *)
      let l = V2.(p1 - p0) in
      let angle = V2.angle l in
      let loc = V2.(p0 + (0.2 * l)) in
      I.const Color.black |> I.cut arrow |> I.rot angle |> I.move loc
    in
    let a = Float.pi_div_2 in
    (* points of the pentagram. *)
    let da = Float.two_pi /. 5. in
    let p0 = V2.polar r a in
    let p1 = V2.polar r (a -. (2. *. da)) in
    let p2 = V2.polar r (a +. da) in
    let p3 = V2.polar r (a -. da) in
    let p4 = V2.polar r (a +. (2. *. da)) in
    let pentagram =
      (* http://mathworld.wolfram.com/StarPolygon.html *)
      P.(empty |> sub p0 |> line p1 |> line p2 |> line p3 |> line p4 |> close)
    in
    let lines = `O { P.o with P.width = 0.01 } in
    I.const (Color.gray 0.8)
    |> I.cut ~area pentagram
    |> I.blend (I.const Color.black |> I.cut ~area:lines pentagram)
    |> I.blend (arrow p0 p1)
    |> I.blend (arrow p1 p2)
    |> I.blend (arrow p2 p3)
    |> I.blend (arrow p3 p4)
    |> I.blend (arrow p4 p0)
  in

  let directed_annulus arrow ~rev area r =
    let arrow ?(rev = false) r a =
      (* arrow at polar coordinate (r, a). *)
      let angle = a +. if rev then -.Float.pi_div_2 else Float.pi_div_2 in
      let loc = V2.polar r a in
      I.const Color.black |> I.cut arrow |> I.rot angle |> I.move loc
    in
    let _arrows ?(rev = false) r =
      arrow ~rev r 0.
      |> I.blend (arrow ~rev r Float.pi_div_2)
      |> I.blend (arrow ~rev r (2. *. Float.pi_div_2))
      |> I.blend (arrow ~rev r (-.Float.pi_div_2))
    in
    let circle ?(rev = false) r =
      let c = P.empty |> P.circle P2.o r in
      if rev then (* flip *) P.tr (M3.scale2 (V2.v (-1.) 1.)) c else c
    in
    let outer = r in
    let inner = r *. 0.6 in
    let annulus = P.append (circle outer) (circle ~rev inner) in
    let outline = `O { P.o with P.width = 0.01 } in
    I.const (Color.gray 0.8)
    |> I.cut ~area annulus
    |> I.blend (I.const Color.black |> I.cut ~area:outline annulus)
    (* |> I.blend (arrows outer) *)
    (* |> I.blend (arrows ~rev inner) *)
  in

  let area_rule_examples area =
    let arrow =
      let a = Float.two_pi /. 3. in
      let pt a = V2.polar 0.032 a in
      P.(empty |> sub (pt 0.) |> line (pt (-.a)) |> line (pt a) |> close)
    in
    let pentagram = directed_pentagram arrow area 0.4 in
    let annulus = directed_annulus arrow ~rev:false area 0.3 in
    let annulus_r = directed_annulus arrow ~rev:true area 0.3 in
    let y = 0.46 in
    pentagram
    |> I.move (V2.v 0.5 y)
    |> I.blend (annulus |> I.move (V2.v 1.5 y))
    |> I.blend (annulus_r |> I.move (V2.v 2.5 y))
  in
  area_rule_examples `Aeo

(* PASS. *)
let arrowhead_path =
  let arrowhead_path i len =
    let angle = Float.pi /. 3. in
    let rec loop i len sign turn p =
      if i = 0 then p |> P.line ~rel:true V2.(polar len turn)
      else
        p
        |> loop (i - 1) (len /. 2.) (-.sign) (turn +. (sign *. angle))
        |> loop (i - 1) (len /. 2.) sign turn
        |> loop (i - 1) (len /. 2.) (-.sign) (turn -. (sign *. angle))
    in
    P.empty |> loop i len 1. 0.
  in
  let area = `O { P.o with P.width = 0.005 } in
  let gray = I.const (Color.gray 0.1) in
  let acc = ref I.void in
  for i = 0 to 9 do
    let x = float (i mod 2) +. 0.1 in
    let y = (0.85 *. float (i / 2)) +. 0.1 in
    acc :=
      gray
      |> I.cut ~area (arrowhead_path i 0.8)
      |> I.move (V2.v x y)
      |> I.blend !acc
  done;
  !acc

let circle = P.empty |> P.circle (P2.v 0.5 0.5) 0.25 |> simple_cut

let vg_imgs =
  [|
    (0, "two_stroked_straight_lines", two_stroked_straight_lines);
    (1, "closed_sub_paths", closed_sub_paths);
    ( 2,
      "imbricated_filled_squares_not_same_dir",
      imbricated_filled_squares_not_same_dir );
    (3, "imbricated_filled_squares_same_dir", imbricated_filled_squares_same_dir);
    (4, "closed_cbezier", closed_cbezier);
    (5, "filled_cbezier", filled_cbezier);
    (6, "mult_filled_cbeziers", mult_filled_cbeziers);
    (7, "simple_qbezier", simple_qbezier);
    (8, "non_zero_rule_star", nz_star);
    (9, "even_odd_rule_star", eo_star);
    (10, "poly1", poly1);
    (11, "scaled_poly", scaled_poly);
    (12, "moved_poly", moved_poly);
    (13, "rotated_poly", rotated_poly);
    (14, "tr_matrix_poly", m_poly);
  |]

(* |> filled_with_border ~area:`Anz ~c:(Color.v 0.48 0.71 0.38 1.) *)
