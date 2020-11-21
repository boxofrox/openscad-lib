function dot(av, bv) =
  assert(len(av) == len(bv), "dot product given vectors of different sizes")
  (3 == len(av))
  ? av.x * bv.x + av.y * bv.y + av.z * bv.z
  : av.x * bv.x + av.y * bv.y;
