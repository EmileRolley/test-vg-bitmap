open Bimage
open Gg
open Vg
module Pm = Vgr_pixmap.F32_ba
module Pixmap_renderer = Vgr_pixmap.Make (Pm)

(** Colors the pixel at ([x], [y]) of [img] with the color [c] *)
let color_pixel img x y c =
  Image.set img x y 0 (Color.r c);
  Image.set img x y 1 (Color.g c);
  Image.set img x y 2 (Color.b c);
  Image.set img x y 3 (Color.a c)

(** Save the drawing as a PNG in [path] *)
let save path pixmap =
  let w = Pm.w pixmap in
  let h = Pm.h pixmap in
  let img = Image.create f32 Bimage.rgba w h in
  ignore
    (Image.for_each ~width:(Pm.w pixmap) ~height:(Pm.h pixmap)
       (fun x y _px ->
         let x' = Int.to_float x in
         let y' = Int.to_float y in
         color_pixel img x y (Pm.get pixmap x' y'))
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

let render_pixmap file view size img =
  let res = 300. /. 25.4 in
  let w = int_of_float (res *. Size2.w size) in
  let h = int_of_float (res *. Size2.h size) in

  let pixmap = Pm.create w h in
  (* NOTE: change [use_width] to false in order to have 1-pixel width lines. *)
  let target = Pixmap_renderer.target pixmap res ~use_width:true in
  let warn w = Vgr.pp_warning Format.err_formatter w in
  let r = Vgr.create ~warn target `Other in
  let r_time =
    get_render_time (fun _ ->
        ignore (Vgr.render r (`Image (size, view, img)));
        ignore (Vgr.render r `End))
  in
  save file pixmap;
  r_time

let () =
  let aspect = 1. in
  let size = Size2.v (aspect *. 100.) 100. (* mm *) in
  let view = Box2.v P2.o (Size2.v (aspect *. 1.) 1.) in
  let render r i name img =
    let t, f =
      match r with
      | `Cairo -> ("cairo", render_png_cairo)
      | `pixmap -> ("pixmap", render_pixmap)
    in
    log_rendering
      (t ^ "-" ^ name)
      (fun _ ->
        f
          ("imgs/" ^ string_of_int i ^ "-" ^ t ^ "-" ^ name ^ ".png")
          view size img)
  in
  Itest.vg_imgs
  |> Array.iter ~f:(fun (i, name, img) ->
         render `Cairo i name img;
         render `pixmap i name img)
