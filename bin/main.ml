open Bimage
open Gg
open Vg
module B = Vgr_bitmap.F32_ba
module Bitmap_renderer = Vgr_bitmap.Make (B)

(* To PNG functions (from school project). *)

(*(1** Converts a Graphics.color [c] into its rgb code. *1) *)
(*let color_to_rgb (rgb : float) = *)
(*  (1* let rgb = Int32.to_int rgb in *1) *)
(*  (1* Printf.printf "rgb: %dd\n" rgb; *1) *)
(*  let rgb = Int.of_float rgb in *)
(*  let r = (rgb lsr 16) land 0xFF in *)
(*  (1* Printf.printf "r: %d\n" r; *1) *)
(*  let g = (rgb lsr 8) land 0xFF in *)
(*  (1* Printf.printf "g: %d\n" g; *1) *)
(*  let b = rgb land 0xFF in *)
(*  (1* Printf.printf "b: %d\n" b; *1) *)
(*  (r, g, b) *)

(*let to_255_int_rgb v = Int.of_float (255. *. v) *)

(*let rgba_to_int rgb = *)
(*  let open Gg.V4 in *)
(*  let sa res = Stdlib.( + ) (res lsl 8) in *)
(*  let res = x rgb |> to_255_int_rgb in *)
(*  Printf.printf "res1: %d\n" res; *)
(*  let res = y rgb |> to_255_int_rgb |> sa res in *)
(*  Printf.printf "res2: %d\n" res; *)
(*  let res = z rgb |> to_255_int_rgb |> sa res in *)
(*  Printf.printf "res3: %d\n" res; *)
(*  res *)

(** Colors the pixel at ([x], [y]) of [img] with the color [c] *)
let color_pixel (img : (float, Bimage.f32, Bimage.rgb) Bimage.Image.t) x y c =
  Image.set img x y 0 (Color.r c);
  Image.set img x y 1 (Color.g c);
  Image.set img x y 2 (Color.b c)

(** Save the drawing as a PNG in [path] *)
let save path bitmap =
  let w = B.width bitmap in
  let h = B.height bitmap in
  let img = Image.create f32 Bimage.rgb w h in
  (* Printf.printf "w: %d, h: %d\n" Bimage.Image.for_each_pixel *)
  ignore
    (Image.for_each_pixel
       (fun x y _px ->
         let x' = Int.to_float x in
         let y' = Int.to_float y in
         (* Printf.printf "(%d, %d) (%f, %f)\n" x y x' y'; *)
         color_pixel img x y (B.get bitmap x' y'))
       img);
  Bimage_unix.Magick.write path img;
  Printf.printf "PNG file saved here: %s\n" path

let () =
  let aspect = 1.618 in
  let size = Size2.v (aspect *. 10.) 10. (* mm *) in
  let view = Box2.v P2.o (Size2.v aspect 1.) in
  (* let circle = P.empty |> P.circle (P2.v 0.5 0.5) 0.4 in *)
  (* let image = I.cut circle (I.const (Color.v_srgb 0.314 0.784 0.471)) in *)
  let image = I.const Color.red in

  (* How the renderer should be used. *)
  let res = 300. /. 25.4 in
  let w = int_of_float (res *. Size2.w size) in
  let h = int_of_float (res *. Size2.h size) in
  Printf.printf "w: %d, h: %d\n" w h;

  (* Ba.fill buff (Int.to_float blue); *)
  (* Printf.printf "dim: %d\n" (Array1.dim buff); *)
  let bitmap = B.create w h in
  for i = 0 to w - 1 do
    B.set bitmap (Int.to_float i) 0. Color.white
  done;
  for i = 0 to w - 1 do
    B.set bitmap (Int.to_float i) (Int.to_float (h - 1)) Color.green
  done;
  Printf.printf "width: %d, height: %d\n" (B.width bitmap) (B.height bitmap);
  let target = Bitmap_renderer.target bitmap in
  let warn w = Vgr.pp_warning Format.err_formatter w in
  let r = Vgr.create ~warn target `Other in
  ignore (Vgr.render r (`Image (size, view, image)));
  ignore (Vgr.render r `End);
  save "testoutput.png" bitmap
