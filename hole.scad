use <reflect.scad>

module thru_hole(d, h) {
  cylinder(d=d, h=h);
}

module thread_hole(d, h) {
  cylinder(d=d, h=h);
}

// Deprecate teardrop_hole.  Use teardrop_hole_v1 instead.
// Eventually convert teardrop_hole to teardrop_hole_v2.
module teardrop_hole(d, h, a=45) {
  teardrop_hole_v1(d, h, a);
}

module teardrop_hole_v1(d, h, a=45) {
  // d :: Diameter (mm).
  // h :: Height (mm).
  // a :: Angle of teardrop corner (deg).

  r = d/2;

  // Teardrop corner.
  v0 = [r * cos(a), r * sin(a)];
  b_y = v0[0] * v0[0] / v0[1];
  v1 = [-r * cos(a), b_y];
  v2 = -reflect(v1, [0, 1]);

  p0 = [0, 0] + v0;
  p1 = p0 + v1;
  p2 = p1 + v2;

  linear_extrude(height=h)
    union() {
      polygon([p0, p1, p2]);
      circle(d=d);
    };
}

module teardrop_hole_v2(d, h, a=45) {
  // 2020-04-10 Add translate and rotate.  Need to update older scad files.
  rotate([90, 0, 0])
    translate([0, 0, -h/2])
    teardrop_hole_v1(d, h, a=a);
}


// Deprecate thru_hole_drop.  Use thru_hole_drop_v1 instead.
// Eventually convert thru_hole_drop to thru_hole_drop_v2.
module thru_hole_drop(d, h, a=45) {
  teardrop_hole_v1(d, h, a);
}

module thru_hole_drop_v1(d, h, a=45) {
  teardrop_hole_v1(d, h, a);
}

module thru_hole_drop_v2(d, h, a=45) {
  teardrop_hole_v2(d, h, a);
}


// Deprecate thread_hole_drop.  Use thread_hole_drop_v1 instead.
// Eventually convert thread_hole_drop to thread_hole_drop_v2.
module thread_hole_drop(d, h, a=45) {
  teardrop_hole_v1(d, h, a);
}

module thread_hole_drop_v1(d, h, a=45) {
  teardrop_hole_v1(d, h, a);
}

module thread_hole_drop_v2(d, h, a=45) {
  teardrop_hole_v2(d, h, a);
}
