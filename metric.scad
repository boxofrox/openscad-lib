use <hole.scad>
use <shape.scad>

// Reference
// https://littlemachineshop.com/images/gallery/PDF/TapDrillSizes.pdf

m2_tap_diameter = 1.55;

m2_5_tap_diameter = 2.03;

m3_tap_diameter       = 2.9;
m3_clearance_diameter = 3.3;
m3_close_diameter     = 3.15;
m3_loose_diameter     = 3.45;



m2_nut_width_corner = 4.32;
m2_nut_width_flat   = 4.0;
m2_nut_height       = 1.6;

m2_5_nut_width_corner = 5.45;
m2_5_nut_width_flat   = 5.0;
m2_5_nut_height       = 2.0;

m3_nut_width_corner = 6.01;
m3_nut_width_flat   = 5.5;
m3_nut_height       = 2.4;

m3_5_nut_width_corner = 6.58;
m3_5_nut_width_flat   = 6.0;
m3_5_nut_height       = 2.8;


m4_nut_width_corner = 7.66;
m4_nut_width_flat   = 7.0;
m4_nut_height       = 3.2;


module m2_thread_hole(h) {
  thread_hole(m2_tap_diameter, h); 
}

module m2_thru_hole(h) {
  thru_hole(d=2.2, h=h);
}

module m2_thru_hole_close(h) {
  thru_hole(d=2.1, h=h);
}

module m2_thru_hole_loose(h) {
  thru_hole(d=2.4, h=h);
}

module m2_5_thread_hole(h) {
  thread_hole(d=m2_5_tap_diameter, h=h); 
}

module m2_5_thru_hole(h) {
  thru_hole(d=2.75, h=h);
}

module m2_5_thru_hole_close(h) {
  thru_hole(d=2.65, h=h);
}

module m2_5_thru_hole_loose(h) {
  thru_hole(d=3.1, h=h);
}

module m2_5_hex_recess(o = [0, 0]) {
  // o :: [x, z] -- Oversize diameter of cavity by amount ([mm, mm]).

  linear_extrude(height = m2_5_nut_height + o.y, convexity = 1) {
    hexagon(m2_5_nut_width_corner + o.x);
  }
}


module m3_thread_hole(h) {
  thread_hole(m3_tap_diameter, h); 
}

module m3_thru_hole(h) {
  thru_hole(m3_clearance_diameter, h);
}

module m3_thru_hole_close(h) {
  thru_hole(m3_close_diameter, h);
}

module m3_thru_hole_loose(h) {
  thru_hole(m3_loose_diameter, h);
}



module m4_thread_hole(h) {
  thread_hole(3.25, h); 
}

module m4_thru_hole(h) {
  thru_hole(4.40, h);
}

module m4_thru_hole_close(h) {
  thru_hole(4.20, h);
}

module m4_thru_hole_loose(h) {
  thru_hole(4.60, h);
}

