module rotate_at_point(a, p) {
  // a :: [x, y, z] -- Angle amount to rotate about each axis (deg).
  // p :: [x, y, z] -- Location to rotate about.

  translate(p)
    rotate(a)
    translate(-p)
    children();
}

module rotate_axis_at_point(a, axis, p) {
  // a    :: Real      -- Angle amount to rotate (deg).
  // axis :: [x, y, z] -- Axis to rotate about.
  // p    :: [x, y, z] -- Location to rotate about.

  translate(p)
    rotate(a, axis)
    translate(-p)
    children();
}

module rotate_at_center(a, s, c = [0, 0, 0]) {
  // a :: [x, y, z] -- Angle amount to rotate about each axis (deg).
  // s :: [x, y, z] -- Dimensions of object to rotate (mm).  Used to find center of object.
  // c :: [x, y, z] -- Position of corner of object to rotate (mm).

  translate(c + s / 2)
    rotate(a)
    translate(-(c + s / 2))
    children();
}

module rotate_axis_at_center(a, axis, s, c = [0, 0, 0]) {
  // a    :: Real      -- Angle amount to rotate (deg).
  // axis :: [x, y, z] -- Axis to rotate about.
  // s    :: [x, y, z] -- Dimensions of object to rotate (mm).  Used to find center of object.
  // c    :: [x, y, z] -- Position of corner of object to rotate (mm).

  translate(c + s / 2)
    rotate(a, axis)
    translate(-(c + s / 2))
    children();
}

function rot_2d_z_90(v) = [ -v.y, v.x ];

function rot_2d_vec(va, vb) =
  // va :: [x, y] -- Vector to rotate.
  // vb :: [x, y] -- Unit vector to rotate by.

  // (va.x + va.y i) * (vb.x + vb.y i)
  // va.x vb.x + va.x vb.y i + va.y i vb.x - va.y vb.y
  // (va.x vb.x - va.y vb.y) + i (va.x vb.y + va.y vb.x)

  [ va.x * vb.x - va.y * vb.y
  , va.x * vb.y + va.y * vb.x
  ];

function center_x(v) =
  (3 == len(v))
  ? [ v.x / 2, v.y, v.z ]
  : [ v.x / 2, v.y ];
function center_y(v) =
  (3 == len(v))
  ? [ v.x, v.y / 2, v.z ]
  : [ v.x, v.y / 2 ];
function center_xy(v) =
  (3 == len(v))
  ? [ v.x / 2, v.y / 2, v.z ]
  : [ v.x / 2, v.y / 2 ];

function center_xy(v) = [ v.x / 2, v.y / 2, v.z ];

function center_a_on_b(va, vb) = (vb - va) / 2;
function center_xy_a_on_b(va, vb) =
  [ (vb.x - va.x) / 2
  , (vb.y - va.y) / 2
  , va.z
  ];

function invert_x(v) =
  (3 == len(v))
  ? [ v.x * -1, v.y, v.z ]
  : [ v.x * -1, v.y ];

function vx00(v) = [ v.x, 0, 0 ];
function v0y0(v) = [ 0, v.y, 0 ];
function v00z(v) = [ 0, 0, v.z ];
function vxy0(v) = [ v.x, v.y, 0 ];
function vx0z(v) = [ v.x, 0, v.z ];
function v0yz(v) = [ 0, v.y, v.z ];
