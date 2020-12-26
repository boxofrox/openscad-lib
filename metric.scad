use <hole.scad>
use <shape.scad>

// Reference
// https://littlemachineshop.com/images/gallery/PDF/TapDrillSizes.pdf

function m2_tap_diameter()      = 1.55;
function m2_clearance_diamter() = 2.2;
function m2_close_diameter()    = 2.1;
function m2_loose_diameter()    = 2.4;

function m2_5_tap_diameter() = 2.03;

function m3_tap_diameter()       = 2.9;
function m3_clearance_diameter() = 3.3;
function m3_close_diameter()     = 3.15;
function m3_loose_diameter()     = 3.45;

function m4_clearance_diameter() = 4.5;
function m4_close_diameter()     = 4.3;
function m4_loose_diameter()     = 4.8;



function m2_nut_width_corner() = 4.32;
function m2_nut_width_flat()   = 4.0;
function m2_nut_height()       = 1.6;

function m2_5_nut_width_corner() = 5.45;
function m2_5_nut_width_flat()   = 5.0;
function m2_5_nut_height()       = 2.0;

function m3_nut_width_corner() = 6.01;
function m3_nut_width_flat()   = 5.5;
function m3_nut_height()       = 2.4;

function m3_5_nut_width_corner() = 6.58;
function m3_5_nut_width_flat()   = 6.0;
function m3_5_nut_height()       = 2.8;


function m4_nut_width_corner() = 7.66;
function m4_nut_width_flat()   = 7.0;
function m4_nut_height()       = 3.2;


module m2_thread_hole(h, a=60, vert=false) {
  if (vert) {
    thread_hole_drop_v2(m2_tap_diameter(), h, a);
  } else {
    thread_hole(m2_tap_diameter(), h);
  }
}

module m2_thru_hole(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m2_clearance_diamter(), h, a);
  } else {
    thru_hole(m2_clearance_diamter(), h);
  }
}

module m2_thru_hole_close(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m2_close_diameter(), h), a;
  } else {
    thru_hole(m2_close_diameter(), h);
  }
}

module m2_thru_hole_loose(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m2_loose_diameter(), h, a);
  } else {
    thru_hole(m2_loose_diameter(), h);
  }
}



module m2_5_thread_hole(h, a=60, vert=false) {
  if (vert) {
    thread_hole_drop_v2(m2_5_tap_diameter(), h, a);
  } else {
    thread_hole(m2_5_tap_diameter(), h);
  }
}

module m2_5_thru_hole(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(2.75, h, a);
  } else {
    thru_hole(2.75, h);
  }
}

module m2_5_thru_hole_close(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(2.65, h, a);
  } else {
    thru_hole(2.65, h);
  }
}

module m2_5_thru_hole_loose(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(3.1, h, a);
  } else {
    thru_hole(3.1, h);
  }
}



module m3_thread_hole(h, a=60, vert=false) {
  if (vert) {
    thread_hole_drop_v2(m3_tap_diameter(), h, a);
  } else {
    thread_hole(m3_tap_diameter(), h);
  }
}

module m3_thru_hole(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m3_clearance_diameter(), h, a);
  } else {
    thru_hole(m3_clearance_diameter(), h);
  }
}

module m3_thru_hole_close(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m3_close_diameter(), h, a);
  } else {
    thru_hole(m3_close_diameter(), h);
  }
}

module m3_thru_hole_loose(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m3_loose_diameter(), h, a);
  } else {
    thru_hole(m3_loose_diameter(), h);
  }
}



module m4_thread_hole(h, a=60, vert=false) {
  if (vert) {
    thread_hole_drop_v2(3.25, h, a);
  } else {
    thread_hole(3.25, h);
  }
}

module m4_thru_hole(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m4_clearance_diameter(), h, a);
  } else {
    thru_hole(m4_clearance_diameter(), h);
  }
}

module m4_thru_hole_close(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m4_close_diameter(), h, a);
  } else {
    thru_hole(m4_close_diameter(), h);
  }
}

module m4_thru_hole_loose(h, a=60, vert=false) {
  if (vert) {
    thru_hole_drop_v2(m4_loose_diameter(), h, a);
  } else {
    thru_hole(m4_loose_diameter(), h);
  }
}




module m2_hex_recess(o = [0, 0]) {
  // o :: [x, z] -- Oversize diameter of cavity by amount ([mm, mm]).

  hex_recess(o, m2_nut_height(), m2_nut_width_corner());
}
module m2_5_hex_recess(o = [0, 0]) {
  // o :: [x, z] -- Oversize diameter of cavity by amount ([mm, mm]).

  hex_recess(o, m2_5_nut_height(), m2_5_nut_width_corner());
}
