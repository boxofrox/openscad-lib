module iter_rect_corners(size, vc=[true, true, true, true]) {
  // size :: [x, y] -- Rectangle width and length.
  // vc :: [Bool; 4] -- Visit corner if true, else skip corner.

  corners = [
    [0, 0],
    [0, size.y],
    [size.x, size.y],
    [size.x, 0]
  ];

  for (i=[0:3]) {
    if (vc[i]) {
      c = corners[i];
      translate([c.x, c.y, 0])
        children();
    }
  }
}

module iter_rect_corners_with_rot(size, vc = [true, true, true, true]) {
  // size :: [x, y] -- Rectangle width and length.
  // vc :: [Bool; 4] -- Visit corner if true, else skip corner.

  corners = [
    [0, 0, 0],
    [0, size.y, -90],
    [size.x, size.y, -180],
    [size.x, 0, -270]
  ];

  for (i=[0:3]) {
    if (vc[i]) {
      c = corners[i];
      translate([c.x, c.y, 0])
        rotate([0, 0, c.z])
        children();
    }
  }
}
