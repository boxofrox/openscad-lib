
// Oversize hexagon by 0.3 to compensate for PLA shrinkage.  May differ for
// other printers or plastics.
module hexagon(d, o = 0.3) {
  // d :: Real - Diameter between corners.
  // o :: Real - Adjustment added to diameter to compensate for shrinkage.

  regular_polygon(6, d, o);
}

module regular_polygon(n = 6, d = 1, o = 0) {
  a = 360 / n;

  polygon([
    for (b = [0:1:n - 1])
      (d + o) / 2 * [ cos(a * b), sin(a * b) ]
  ]);
}
