/////////////////////////////////////////////////////////////////////////////////
//  2014-09-09 Heinz Spiess, Switzerland
//  2020-12-22 Justin Charette
//    - Reformat & refactor into multiple functions.
//    - Fix bug: inconsistent angle direction.
//    - Add stop/stop params.
//    - Add sline_goto.
//    - Add sline_stroke with variable widths.
//
//  released under Creative Commons - Attribution - Share Alike licence (CC BY-SA)
/////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////
// sline - generate a "snake line" of width w and height h
// with a arbitrary sequence of segments defined by a radius and a turning angle
//
//   angles[i] > 0  left turn / counter-clockwise
//   angles[i] < 0  left turn / clockwise
//   angles[i] = 0  straight segment with length radii[i]
//
module sline(angles, radii, w, h, convexity = 1, e = 0.1, start = 0, stop = 9999) {
  stop1 = (stop >= 0) ? stop : len(angles) - stop;

  linear_extrude(h, convexity = convexity)
    sline_path(angles, radii, w, e = e, start = start, stop = stop1);

  module sline_path(angles, radii, w, i = 0, e = 0.01, start = 0, stop = 9999) {
    if (i < len(angles)) {
      path(angles[i], radii[i]);
    }

    module path(angle, radius) {
      r = abs(radii[i]);
      a = abs(angles[i]);

      sx = angles[i] >= 0 ? -1 : 1;
      dx = a ? -r : 0;

      if (i >= start) {
        if (a) {
          if (i > 0) {
            translate([ -w / 2, 0, 0 ])
              translate([ 0, -e ])
              square([ w, 2 * e ]);
          }
          scale([ sx, 1 ])
          translate([ -r, 0 ])
            polygon(sline_curve_to(a, r, w));
        } else if (r > 0) {
          translate([ -w / 2, 0, 0 ])
            translate([ 0, -e, 0 ])
            square([ w, r + e ]);
        }
      }

      scale([ sx, 1 ])
      translate([ dx, 0 ]) {
        let (
          dxy = (a > 0)
            ? r * [ cos(a), sin(a) ]
            : (a < 0)
              ? r * [ -cos(a), sin(a) ]
              : [ 0, r ]
        ) {
          translate(dxy)
            rotate(a)
            scale([ sx, 1 ])
            sline_path(angles, radii, w, i + 1, start = start, stop = stop);
        }
      }
    }
  }

  function sline_curve_to (a, r, w, $fn = $fn) =
    let (
      n = max(2, floor((abs(a) / 360) * $fn)),
      da = a / n
    )
      [ each [ for (i = [0 : n]) (r + w / 2) * [ cos(i * da), sin(i * da) ] ]
      , each [ for (i = [0 : n]) (r - w / 2) * [ cos((n - i) * da), sin((n - i) * da) ] ]
      ];
}

/////////////////////////////////////////////////////////////////////////////////
// sline_stroke - generate a "snake line" of varying width and height h
// with a arbitrary sequence of segments defined by a radius and a turning angle
//
//   angles[i] > 0  left turn / counter-clockwise
//   angles[i] < 0  left turn / clockwise
//   angles[i] = 0  straight segment with length radii[i]
//
//   widths[i] = x s.t. x > 0
//
//   len(angles) = len(radii) = len(widths) - 1
//
module sline_stroke(angles, radii, widths, h, convexity = 1, e = 0.1, start = 0, stop = 9999) {
  stop1 = (stop >= 0) ? stop : len(angles) - stop;

  assert(len(angles) < len(widths));

  linear_extrude(h, convexity = convexity)
    sline_path(angles, radii, widths, e = e, start = start, stop = stop1);

  module sline_path(angles, radii, widths, i = 0, e = 0.01, start = 0, stop = 9999) {
    if (i < len(angles)) {
      path(angles[i], radii[i], widths[i], widths[i + 1]);
    }

    module path(angle, radius, width1, width2) {
      r = abs(radii[i]);
      a = abs(angles[i]);
      w1 = width1;
      w2 = width2;

      sx = angles[i] >= 0 ? -1 : 1;
      dx = a ? -r : 0;

      if (i >= start) {
        if (a) {
          if (i > start) {
            polygon(
              [ [ -widths[i-1] / 2, -e ]
              , [  widths[i-1] / 2, -e ]
              , [  widths[i] / 2,  e ]
              , [ -widths[i] / 2,  e ]
              ]
            );
          }
          scale([ sx, 1 ])
          translate([ -r, 0 ])
            polygon(sline_curve_to(a, r, w1, w2));
        } else if (r > 0) {
          polygon(
            [ [ -w1 / 2, -e ]
            , [ -w1 / 2,  0 ]
            , [ -w2 / 2,  r ]
            , [  w2 / 2,  r ]
            , [  w1 / 2,  0 ]
            , [  w1 / 2, -e ]
            ]
          );
        }
      }

      scale([ sx, 1 ])
      translate([ dx, 0 ]) {
        let (
          dxy = (a > 0)
            ? r * [ cos(a), sin(a) ]
            : (a < 0)
              ? r * [ -cos(a), sin(a) ]
              : [ 0, r ]
        ) {
          translate(dxy)
            rotate(a)
            scale([ sx, 1 ])
            sline_path(angles, radii, widths, i + 1, start = start, stop = stop);
        }
      }
    }
  }

  function sline_curve_to (a, r, w1, w2, $fn = $fn) =
    let (
      n = max(2, floor((abs(a) / 360) * $fn)),
      da = a / n
    )
      [ each
        [ for (i = [0 : n])
          let (
            t = i / n,
            w = (w1 * (1 - t) + w2 * t)
          ) (r + w / 2) * [ cos(i * da), sin(i * da) ]
        ]
      , each
        [ for (i = [0 : n])
          let (
            t = i / n,
            w = (w2 * (1 - t) + w1 * t)
          ) (r - w / 2) * [ cos((n - i) * da), sin((n - i) * da) ]
        ]
      ];
}

module sline_goto(angles, radii, i = 0, stop = 9999) {
  stop1 = (stop >= 0) ? stop : len(angles) + stop;
  stop_rem = stop1 - floor(stop1);

  end = min(len(angles) - 1, floor(stop1));

  module goto(angle, radius, stop) {
    a = abs(angle);
    r = abs(radius);

    sx = angle >= 0 ? -1 : 1;
    dx = a ? -r : 0;

    scale([ sx, 1 ])
      translate([ dx, 0 ]) {
        let (
          dxy = (a > 0)
            ? r * [ cos(a), sin(a) ]
            : (a < 0)
              ? r * [ -cos(a), sin(a) ]
              : [ 0, r ]
        ) {
          translate(dxy)
            rotate(a)
            scale([ sx, 1 ])
            sline_goto(angles, radii, i + 1, stop)
              children();
        }
      }
  }

  if (i <= end) {
    goto(angles[i], radii[i], stop1)
      children();
  } else if (i < len(angles) && stop_rem > 0) {
    if (angles[i]) {
      goto(stop_rem * angles[i], radii[i], 0)
        children();
    } else {
      goto(angles[i], stop_rem * radii[i], 0)
        children();
    }
  } else {
    children();
  }
}
