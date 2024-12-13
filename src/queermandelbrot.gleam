import gleam/int
import gleam/io
import gleam/list

import complex.{type Complex, Complex, absolute, add, multiply}

type MandelbrotValue {
  Converges
  Diverges(Int)
}

fn square(x: Complex) -> Complex {
  multiply(x, x)
}

fn get_mandelbrot_value(
  location: Complex,
  threshold: Float,
  current: Complex,
  iteration: Int,
) -> MandelbrotValue {
  case iteration > 100 {
    True -> Converges
    False -> {
      let next = square(current) |> add(location)

      case absolute(next) >. threshold {
        True -> Diverges(iteration)
        False -> get_mandelbrot_value(location, threshold, next, iteration + 1)
      }
    }
  }
}

type ColorScheme {
  Rainbow
  Trans
  Lesbian
}

fn value_to_color(colorscheme: ColorScheme, value: Int) -> String {
  case colorscheme {
    Rainbow ->
      case value {
        n if n < 5 -> "#732982"
        n if n < 6 -> "#004CFF"
        n if n < 7 -> "#008026"
        n if n < 9 -> "#FFED00"
        n if n < 13 -> "#FF8C00"
        _ -> "#E40303"
      }
    Trans ->
      case value {
        n if n < 6 -> "#5BCFFB"
        n if n < 7 -> "#F5ABB9"
        n if n < 9 -> "#FFFFFF"
        n if n < 13 -> "#F5ABB9"
        _ -> "#5BCFFB"
      }
    Lesbian ->
      case value {
        n if n < 5 -> "#D52D00"
        n if n < 6 -> "#EF7627"
        n if n < 7 -> "#FF9A56"
        n if n < 8 -> "#FFFFFF"
        n if n < 9 -> "#D162A4"
        n if n < 13 -> "#B55690"
        _ -> "#A30262"
      }
  }
}

fn animate_for_each(
  list: List(a),
  still_valid: fn() -> Bool,
  callback: fn(a) -> Nil,
) -> Nil {
  case list, still_valid() {
    _, False -> Nil
    [], True -> Nil
    [head, ..rest], True -> {
      callback(head)
      request_animation_frame(fn() {
        animate_for_each(rest, still_valid, callback)
      })
    }
  }
}

fn redraw(ctx: Context2D, canvas_width: Int, canvas_height: Int) {
  let colorscheme = Lesbian

  set_size(ctx, canvas_width, canvas_height)
  clear(ctx)

  let min_x = -2.0
  let max_x = 1.0
  let min_y = -1.0
  let max_y = 1.0

  list.range(0, canvas_width - 1)
  |> list.sized_chunk(1)
  |> animate_for_each(
    fn() {
      get_inner_width() == canvas_width && get_inner_height() == canvas_height
    },
    list.each(_, fn(x) {
      io.debug(x)
      list.range(0, canvas_height - 1)
      |> list.each(fn(y) {
        let pad_horizontal =
          { max_x -. min_x } /. { max_y -. min_y }
          <. int.to_float(canvas_width) /. int.to_float(canvas_height)

        let #(sizing_factor, x_offset, y_offset) = case pad_horizontal {
          True -> #(
            int.to_float(canvas_height) /. { max_y -. min_y },
            min_x,
            min_y,
          )
          False -> #(
            int.to_float(canvas_width) /. { max_x -. min_x },
            min_x,
            min_y,
          )
        }

        let location =
          Complex(
            real: int.to_float(x) /. sizing_factor +. x_offset,
            imaginary: int.to_float(y) /. sizing_factor +. y_offset,
          )
        let value = get_mandelbrot_value(location, 1000.0, Complex(0.0, 0.0), 0)
        case value {
          Converges -> set_pixel(ctx, x, y, "#000")
          Diverges(value) ->
            set_pixel(ctx, x, y, value_to_color(colorscheme, value))
        }
      })
    }),
  )
}

pub fn main() {
  let ctx = get_context("mandelbrot")

  redraw(ctx, get_inner_width(), get_inner_height())

  on_resize(fn() { redraw(ctx, get_inner_width(), get_inner_height()) })
}

type Context2D

@external(javascript, "./canvas.mjs", "getContext")
fn get_context(id: String) -> Context2D

@external(javascript, "./canvas.mjs", "getInnerWidth")
fn get_inner_width() -> Int

@external(javascript, "./canvas.mjs", "getInnerHeight")
fn get_inner_height() -> Int

@external(javascript, "./canvas.mjs", "onResize")
fn on_resize(callback: fn() -> Nil) -> Nil

@external(javascript, "./canvas.mjs", "setPixel")
fn set_pixel(ctx: Context2D, x: Int, y: Int, color: String) -> Nil

@external(javascript, "./canvas.mjs", "clear")
fn clear(ctx: Context2D) -> Nil

@external(javascript, "./canvas.mjs", "setSize")
fn set_size(ctx: Context2D, width: Int, height: Int) -> Nil

@external(javascript, "./canvas.mjs", "requestAnimationFrame")
fn request_animation_frame(callback: fn() -> Nil) -> Nil
