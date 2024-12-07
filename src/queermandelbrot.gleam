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

pub fn main() {
  let colorscheme = Lesbian

  let ctx = get_context("mandelbrot")

  let canvas_width = 600
  let canvas_height = 400
  let min_x = -2.0
  let max_x = 1.0
  let min_y = -1.0
  let max_y = 1.0

  list.range(0, canvas_width - 1)
  |> list.each(fn(x) {
    list.range(0, canvas_height - 1)
    |> list.each(fn(y) {
      let location =
        Complex(
          real: int.to_float(x)
            /. int.to_float(canvas_width)
            *. { max_x -. min_x }
            +. min_x,
          imaginary: int.to_float(y)
            /. int.to_float(canvas_height)
            *. { max_y -. min_y }
            +. min_y,
        )
      let value = get_mandelbrot_value(location, 1000.0, Complex(0.0, 0.0), 0)
      case value {
        Converges -> set_pixel(ctx, x, y, "#000")
        Diverges(value) ->
          set_pixel(ctx, x, y, value_to_color(colorscheme, value))
      }
    })
  })
}

type Context2D

@external(javascript, "./canvas.mjs", "getContext")
fn get_context(id: String) -> Context2D

@external(javascript, "./canvas.mjs", "setPixel")
fn set_pixel(ctx: Context2D, x: Int, y: Int, color: String) -> Nil
