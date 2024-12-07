import gleam/float

pub type Complex {
  Complex(real: Float, imaginary: Float)
}

pub fn add(x: Complex, y: Complex) -> Complex {
  Complex(real: x.real +. y.real, imaginary: x.imaginary +. y.imaginary)
}

pub fn multiply(x: Complex, y: Complex) -> Complex {
  Complex(
    real: x.real *. y.real -. x.imaginary *. y.imaginary,
    imaginary: x.imaginary *. y.real +. x.real *. y.imaginary,
  )
}

pub fn absolute(x: Complex) -> Float {
  let assert Ok(result) =
    float.square_root(x.real *. x.real +. x.imaginary *. x.imaginary)
  result
}
