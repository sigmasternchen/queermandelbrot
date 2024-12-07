import esgleam

pub fn main() {
  esgleam.new("./dist/")
  |> esgleam.entry("queermandelbrot.gleam")
  |> esgleam.kind(esgleam.Script)
  |> esgleam.format(esgleam.Iife)
  |> esgleam.raw("--outfile=./dist/queermandelbrot.js")
  |> esgleam.serve("./dist/")
  |> esgleam.bundle
}
