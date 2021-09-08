open Bimage
open Gg
open Vg
module B = Vgr_bitmap.F32_ba
module Bitmap_renderer = Vgr_bitmap.Make (B)

(** Colors the pixel at ([x], [y]) of [img] with the color [c] *)
let color_pixel img x y c =
  Image.set img x y 0 (Color.r c);
  Image.set img x y 1 (Color.g c);
  Image.set img x y 2 (Color.b c);
  Image.set img x y 3 (Color.a c)

(** Save the drawing as a PNG in [path] *)
let save path bitmap =
  let w = B.w bitmap in
  let h = B.h bitmap in
  let img = Image.create f32 Bimage.rgba w h in
  ignore
    (Image.for_each ~width:(B.w bitmap) ~height:(B.h bitmap)
       (fun x y _px ->
         let x' = Int.to_float x in
         let y' = Int.to_float y in
         color_pixel img x y (B.get bitmap x' y'))
       img);
  Bimage_unix.Magick.write path img

let get_render_time yield =
  let s = Unix.gettimeofday () in
  yield ();
  let e = Unix.gettimeofday () in
  e -. s

let log_rendering name yield =
  let r_time = yield () in
  Printf.printf "[LOG] - Rendered '%s' in %fs\n" name r_time

let render_png_cairo file view size img =
  let res = 300. /. 0.0254 in
  let fmt = `Png (Size2.v res res) in
  let warn w = Vgr.pp_warning Format.err_formatter w in
  let oc = open_out file in
  let r = Vgr.create ~warn (Vgr_cairo.stored_target fmt) (`Channel oc) in
  let r_time =
    get_render_time (fun _ ->
        ignore (Vgr.render r (`Image (size, view, img)));
        ignore (Vgr.render r `End))
  in
  close_out oc;
  r_time

let render_bitmap file view size img =
  let res = 300. /. 25.4 in
  let w = int_of_float (res *. Size2.w size) in
  let h = int_of_float (res *. Size2.h size) in

  let bitmap = B.create w h in
  let target = Bitmap_renderer.target bitmap res in
  let warn w = Vgr.pp_warning Format.err_formatter w in
  let r = Vgr.create ~warn target `Other in
  let r_time =
    get_render_time (fun _ ->
        ignore (Vgr.render r (`Image (size, view, img)));
        ignore (Vgr.render r `End))
  in
  save file bitmap;
  r_time

let () =
  let aspect = 1. in
  let size = Size2.v (aspect *. 100.) 100. (* mm *) in
  let view = Box2.v P2.o (Size2.v (aspect *. 2.) 1.) in
  let render r i name img =
    let t, f =
      match r with
      | `Cairo -> ("cairo", render_png_cairo)
      | `Bitmap -> ("bitmap", render_bitmap)
    in
    log_rendering
      (t ^ "-" ^ name)
      (fun _ ->
        f
          ("imgs/" ^ string_of_int i ^ "-" ^ t ^ "-" ^ name ^ ".png")
          view size img)
  in
  Itest.vg_imgs
  |> Array.iteri ~f:(fun i (name, img) ->
         render `Cairo i name img;
         render `Bitmap i name img)
