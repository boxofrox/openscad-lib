use <affine.scad>
use <math.scad>

// Example:
//
// cube([ 1, 1, loop_bounce($t) + 1 ]);
function loop_bounce(t) = 1 - 2 * abs(t - 0.5);
