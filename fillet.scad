use <affine.scad>
use <math.scad>
use <vec.scad>

// Basic fillet of 2d shapes using openscad's offset function.  Quality of
// results may vary.
//
// Example:
//
// fillet2d() {
//   square(r = 5);
// }
module fillet2d(r) {
  offset(r=r) {
    offset(delta=-r) {
      children();
    }
  }
}

// Generate fillet geometry for edge of length `h` with radius `fr`.
// Fillet oriented for edge along [ 0, 0, 1 ].
module fillet_edge(r, h, e = 0.1) {
  // r  :: Real -- Radius of fillet geometry (mm).
  // h  :: Real -- Height of fillet geometry (mm).
  // e  :: Real -- Epsilon. Amount of material to add to fillet geometry's secondary edges.
  fillet_edge_with_arc(r, h, 90, e);
}

module fillet_edge_with_arc(r, h, a = 90, e = 0.1) {
  ii = [ 1, 0 ];
  jj = [ 0, 1 ];

  points = fillet_corner_2d(
    ii,
    ii * cos(a) + jj * sin(a),
    r,
    e
  );

  linear_extrude(height = h, convexity = 2)
    polygon(points);

}

// Generate fillet geometry for edge of length `h` with given radius `fr`
// between vectors `av` and `bv`.
// Fillet oriented for edge along [0, 0, 1].
// `av` and `bv` are not normals, but vectors parallel to two faces that
// intersect to form a corner (presumably the corner you want to fillet).
//
// Similiar to fillet_edge_with_arc, but computes angle between two vectors.
module fillet_edge_bw_vec(fr, h, av, bv, e = 0.1) {
  // fr :: Real -- Radius of fillet geometry (mm).
  // h  :: Real -- Height of edge (mm).
  // av :: [ x, y ] -- 2D vector of first normal.
  // bv :: [ x, y ] -- 2D vector of second normal.
  // e  :: Real -- Epsilon. Amount of material to add to fillet geometry's secondary edges.

  points = fillet_corner_2d(av, bv, fr, e);

  linear_extrude(height = h, convexity = 3)
    polygon(points);
}

// Generate fillet geometry for circular edge with radius `r`.
// Use `aa` to limit fillet to arc along circular edge.
module fillet_circle_with_arc(fr, r, av = [ 1, 0 ], bv = [ 0, 1 ], aa = 360, e = 0.1) {
  // fr   :: Real -- Radius of fillet geometry (mm).
  // r    :: Real -- Radius of circle that fillet follows (mm).
  // av   :: [ x, y ] -- Vector of first edge of fillet corner.
  // bv   :: [ x, y ] -- Vector of second edge of fillet corner.
  // aa   :: Real -- Angle of arc around circle (deg).
  // e    :: Real -- Epsilon. Amount of material to add to fillet geometry's secondary edges.

  points = fillet_corner_2d(av, bv, fr, e);

  rotate_extrude(angle = aa, convexity = 3)
    translate([ r, 0, 0 ])
    polygon(points);
}

// All the magic happens here.
// Form a curve with the given radius `r` between the given vectors `av` and
// `bv`, then route around corner to generate geometry for fillet.
function fillet_corner_2d(av, bv, r, e = 0.1) =
  // av :: [x, y] -- Vector along first edge.
  // bv :: [x, y] -- Vector along second edge.
  // r  :: Real -- Radius of fillet (deg).
  // e  :: Real -- Epsilon. Amount of material to add to fillet geometry's secondary edges.

  // cv = (av + bv) / 2
  // ch = cv / norm(cv)
  // x * ah + r * an = y * ch
  // x * bh - r * bn = y * ch
  // x ah - x bh + r an + r bn = 0
  // x (ah - bh) + r (an + bn) = 0
  // x (bh - ah) = r (an + bn)
  // x dv = r ev
  // x |d| dh = r |e| eh    where dh = eh
  // x |d| = r |e|
  // x = r |e| / |d|

  let
    ( ah = av / norm(av)
    , bh = bv / norm(bv)

    , an = rot_2d_z_90(ah)
    , bn = rot_2d_z_90(bh)

    , x = r * norm(an + bn) / norm(bh - ah)

    , cv = x * ah + sign(dot(an, bh)) * r * an
    , ch = cv / norm(cv)

    , aav = x * ah - cv
    , bbv = x * bh - cv

    , aah = aav / norm(aav)
    , bbh = bbv / norm(bbv)

    , fa = acos(aah * bbh)

    , step = fa / $fn
    , start = fa / 2
    , end = -fa / 2
    )

    (0 > dot(an, bh))
    ? concat(
        [ -e * [ ch.x, ch.y ]
        ,  e * [ an.x, an.y ]
        ,  x * [ ah.x, ah.y ] + e * [ an.x, an.y ]
        ]
        ,
        [ for (a = [ start : -step : end ])
            cv + r * rot_2d_vec([ -cos(a), sin(a) ], ch)
        ]
        ,
        [  x * [ bh.x, bh.y ] - e * [ bn.x, bn.y ]
        , -e * [ bn.x, bn.y ]
        ]
      )
    : concat(
        [ -e * [ ch.x, ch.y ]
        ,  e * [ bn.x, bn.y ]
        ,  x * [ bh.x, bh.y ] + e * [ bn.x, bn.y ]
        ]
        ,
        [ for (a = [ start : -step : end ])
            cv + r * rot_2d_vec([ -cos(a), sin(a) ], ch)
        ]
        ,
        [ x * [ ah.x, ah.y ] - e * [ an.x, an.y ]
        , -e * [ an.x, an.y ]
        ]
      );



/// Examples

$fn = $preview ? 32 : 128;
epsilon = 0.1;

translate([ 0, 0, 0 ])
  example_fillet2d();

translate([ 10, 0, 0 ])
  example_fillet_edge();

translate([ 20, 0, 0 ])
  example_fillet_edge_with_arc();

translate([ 30, 0, 0 ])
  example_fillet_edge_bw_vec();

translate([ 40, 0, 0 ])
  example_fillet_circle_with_arc_1();

translate([ 50, 0, 0 ])
  example_fillet_circle_with_arc_2();


module example_fillet2d() {
  module shape() {
    square([ 5, 5 ]);
  }

  // Initial shape.
  shape();

  // With fillet applied.
  translate([ 0, 10, 0 ])
    fillet2d()
    shape();
}

module example_fillet_edge() {
  size = [ 5, 5, 2 ];

  module shape() {
    cube(size);
  }

  // Initial shape.
  shape();

  // With fillet applied to one edge.
  translate([ 0, 10, 0 ]) {
    difference() {
      shape();

      translate([ 0, 0, -epsilon ])
        fillet_edge(r = 1, h = size.z + 2 * epsilon);
    }
  }

  // With fillet applied to three edges of one corner.
  translate([ 0, 20, 0 ]) {
    difference() {
      shape();

      translate([ 0, 0, -epsilon ])
        fillet_edge(r = 1, h = size.z + 2 * epsilon);

      translate([ 0, -epsilon, size.z ])
        rotate([ -90, 0, 0 ])
        fillet_edge(r = 1, h = size.y + 2 * epsilon);

      translate([ -epsilon, 0, size.z ])
        rotate([ 0, 90, 0 ])
        fillet_edge(r = 1, h = size.y + 2 * epsilon);
    }
  }
}

module example_fillet_edge_with_arc() {
  size = [ 5, 5, 2 ];

  module shape() {
    difference() {
      cube(size);

      translate([ 0, 0, -epsilon ])
        rotate([ 0, 0, 45 ])
        cube([ 20, 20, 3 ]);
    }
  }

  // Initial shape with corner != 90 deg.
  shape();

  // With fillet applied applied to 45 deg corner.
  translate([ 0, 10, 0 ])
    difference() {
      shape();

      translate([ 0, 0, -epsilon ])
        fillet_edge_with_arc(r = 1, h = size.z + 2 * epsilon, a = 45);
    }
}

module example_fillet_edge_bw_vec() {
  size = [ 5, 5, 2 ];

  module shape() {
    difference() {
      cube(size);

      translate([ 0, 0, -epsilon ])
        rotate([ 0, 0, 45 ])
        cube([ 20, 20, 3 ]);
    }
  }

  // Initial shape with corner != 90 deg.
  shape();

  // With fillet applied applied to 45 deg corner using normals of faces
  // adjacent to corner..
  translate([ 0, 10, 0 ])
    difference() {
      shape();

      translate([ 0, 0, -epsilon ])
        fillet_edge_bw_vec(fr = 1, h = size.z + 2 * epsilon, av = [ 1, 1 ], bv = [ 1, 0 ]);
    }
}

module example_fillet_circle_with_arc_1() {
  i = [ 1, 0, 0 ];
  j = [ 0, 1, 0 ];
  k = [ 0, 0, 1 ];

  size_a = [ 5, 0, 1 ];
  size_b = [ 3, 0, 2 ];

  module shape() {
    cylinder(d = size_a.x, h = size_a.z);
    translate(k * size_a.z)
      cylinder(d = size_b.x, h = size_b.z);
  }

  // Initial shape with convex and concave edges.
  shape();

  // Fillet two edges of shape a full 360 deg.
  translate([ 0, 10, 0 ])
    difference() {
      union() {
        shape();

        // Fillet concave edge (add material).
        translate(k * size_a.z)
          color("#8ab347")
          fillet_circle_with_arc(fr = 0.5, r = size_b.x / 2, av = [ 1, 0 ], bv = [ 0, 1 ]);
      }

      // Fillet convex edge (remove material).
      translate(k * (size_a.z + size_b.z))
        fillet_circle_with_arc(fr = 0.5, r = size_b.x / 2, av = [ -1, 0 ], bv = [ 0, -1 ]);
    }

  // Fillet two edges of shape a full 180 deg.
  translate([ 0, 20, 0 ])
    difference() {
      union() {
        shape();

        // Fillet concave edge (add material).
        translate(k * size_a.z)
          color("#8ab347")
          fillet_circle_with_arc(fr = 0.5, r = size_b.x / 2, av = [ 1, 0 ], bv = [ 0, 1 ], aa = 180);
      }

      // Fillet convex edge (remove material).
      translate(k * (size_a.z + size_b.z))
        fillet_circle_with_arc(fr = 0.5, r = size_b.x / 2, av = [ -1, 0 ], bv = [ 0, -1 ], aa = 180);
    }
}

module example_fillet_circle_with_arc_2() {
  i = [ 1, 0, 0 ];
  j = [ 0, 1, 0 ];
  k = [ 0, 0, 1 ];

  radius = [ 2.5, 1.5, 1 ];
  height = [ 1, 2 ];

  // Make angle of circular edge more obtuse.

  module shape() {
    cylinder(r1 = radius[0], r2 = radius[1], h = height[0]);
    translate(k * height[0])
      cylinder(r1 = radius[1], r2 = radius[2], h = height[1]);
  }

  // Initial shape.
  shape();

  // Fillet obtuse concave edge.
  translate(10 * j) {
    shape();

    translate(k * height[0]) {
      // Don't forget to convert diameters to radii.
      av = [ radius[0] - radius[1], -height[0] ];
      bv = [ radius[2] - radius[1],  height[1] ];

      color("#8ab347")
      fillet_circle_with_arc(fr = 0.5, r = radius[1], av = av, bv = bv, e = 0.01);
    }
  }
}
