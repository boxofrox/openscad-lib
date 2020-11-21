
module hexagon(d) {
  regular_polygon(6, d);
}

module regular_polygon(n = 6, d = 1) {
  a = 360 / n;

  polygon([
    for (b = [0:1:n - 1])
      d / 2 * [ cos(a * b), sin(a * b) ]
  ]);
}
