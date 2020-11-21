use <affine.scad>
use <math.scad>

module fillet2d(r) {
  offset(r=r) {
    offset(delta=-r) {
      children();
    }
  }
}

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

module fillet_edge_with_arc_2(r, h, a = 90, e = 0.1) {
  // r  :: Real -- Radius of fillet geometry (mm).
  // h  :: Real -- Height of fillet geometry (mm).
  // a  :: Real -- Angle of corner (deg).
  // e  :: Real -- Epsilon. Amount of material to add to fillet geometry's secondary edges.

  i = [ 1, 0, 0 ];
  j = [ 0, 1, 0 ];
  k = [ 0, 0, 1 ];

  ah = i;
  bh = i * cos(a) + j * sin(a);

  function rot_z_90(v) = [ -v.y, v.x ];

  an = rot_z_90(ah);
  bn = rot_z_90(bh);

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

  x = r * norm(an + bn) / norm(bh - ah);

  cv = x * ah + r * an;
  ch = cv / norm(cv);

  points =
    [ -e * [ ch.x, ch.y ]
    ,  e * [ bn.x, bn.y ]
    ,  x * [ bh.x, bh.y ] + e * [ bn.x, bn.y ]
    ,  cv
    ,  x * [ ah.x, ah.y ] - e * [ an.x, an.y ]
    , -e * [ an.x, an.y ]
    ];

  color("green")
  difference() {
    linear_extrude(height = h, convexity = 3)
      polygon(points);

    translate(cv - k * 0.1)
      cylinder(r = r, h = h + 0.2);
  }
}

module fillet_edge_bw_vec(fr, h, av, bv, e = 0.1) {
  // fr :: Real -- Radius of fillet geometry (mm).
  // h  :: Real -- Height of fillet geometry (mm).
  // a  :: Real -- Angle of corner (deg).
  // e  :: Real -- Epsilon. Amount of material to add to fillet geometry's secondary edges.

  i = [ 1, 0, 0 ];
  j = [ 0, 1, 0 ];
  k = [ 0, 0, 1 ];

  function rot_z_90(v) = [ -v.y, v.x ];

  ah = av / norm(av);
  bh = bv / norm(bv);

  an = rot_z_90(ah);
  bn = rot_z_90(bh);

  // cv = (av + bv) / 2
  // ch = cv / norm(cv)
  // x * ah + fr * an = y * ch
  // x * bh - fr * bn = y * ch
  // x ah - x bh + fr an + fr bn = 0
  // x (ah - bh) + fr (an + bn) = 0
  // x (bh - ah) = fr (an + bn)
  // x dv = fr ev
  // x |d| dh = fr |e| eh    where dh = eh
  // x |d| = fr |e|
  // x = fr |e| / |d|

  x = fr * norm(an + bn) / norm(bh - ah);

  cv = x * ah + fr * an;
  ch = cv / norm(cv);

  points =
    [ -e * [ ch.x, ch.y ]
    ,  e * [ bn.x, bn.y ]
    ,  x * [ bh.x, bh.y ] + e * [ bn.x, bn.y ]
    ,  cv
    ,  x * [ ah.x, ah.y ] - e * [ an.x, an.y ]
    , -e * [ an.x, an.y ]
    ];

  color("green")
  difference() {
    linear_extrude(height = h, convexity = 3)
      polygon(points);

    translate(cv - k * 0.1)
      cylinder(r = fr, h = h + 0.2);
  }
}

module fillet_circle_with_arc(fr, r, fa1 = 0, fa2 = 90, aa = 360, e = 0.1) {
  // fr   :: Real -- Radius of fillet geometry (mm).
  // r    :: Real -- Radius of circle that fillet follows (mm).
  // fa1  :: Real -- Angle of corner fillet occupies (deg).
  // fa2  :: Real -- Angle of corner fillet occupies (deg).
  // aa   :: Real -- Angle of arc around circle (deg).
  // e    :: Real -- Epsilon. Amount of material to add to fillet geometry's secondary edges.

  i = [ 1, 0, 0 ];
  j = [ 0, 1, 0 ];
  k = [ 0, 0, 1 ];

  v1 = i * cos(90 * $t) + j * sin(90 * $t);
  v2 = i * cos(90 * $t) + j * -sin(90 * $t);

  v3 = -[ -sin(90 * $t), cos(90 * $t) ];
  v4 = -[ -sin(90 * $t), -cos(90 * $t) ];

  ah = i * cos(fa1) - j * sin(fa1);
  bh = i * cos(fa2) + j * sin(fa2);

  assert(-1 < ah * bh, "error: fillet_circle_with_arc: fa1 + fa2 >= 180");

  points = fillet_corner_2d(ah, bh, fr, e);

  rotate_extrude(angle = aa, convexity = 3)
    translate([ r, 0, 0 ])
    polygon(points);
}

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

module mark() {
  cylinder(d = 0.1, h = 100, $fn = 32);
}

module vec2(v) {
  hull() {
    cylinder(d = 0.1, h = 0.1, $fn = 30);
    translate([ v.x, v.y, 0 ])
      cylinder(d = 0.1, h = 0.1, $fn = 30);
  }
}

module vec3(v) {
  hull() {
    cylinder(d = 0.1, h = 0.1, $fn = 30);
    translate(v)
      cylinder(d = 0.1, h = 0.1, $fn = 30);
  }
}
