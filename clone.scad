module linear_array(n, o) {
  // n :: [x, y, z] -- Number of copies per axis.
  // o :: [x, y, z] -- Offsets between copies along each axis. 

  for (xx = [0:1:n.x - 1]) {
    translate([ xx * o.x, 0, 0 ]) {
      for (yy = [0:1:n.y - 1]) {
        translate([ 0, yy * o.y, 0 ]) {
          for (zz = [0:1:n.z - 1]) {
            translate([ 0, 0, zz * o.z ])
              children();
          }
        }
      }
    }
  }
}
