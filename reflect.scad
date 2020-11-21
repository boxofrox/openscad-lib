function reflect(v, axis) = 
    let ( proj_a = ((axis * v) / norm(axis)) * axis
        , proj_b = v - proj_a
        )
        v - proj_b - proj_b;
