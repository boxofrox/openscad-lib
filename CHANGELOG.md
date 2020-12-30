# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Incomplete set of affine and alignment transformations.
- Animate lib with bounce function to append reversed period to time variable
  argument (e.g. [0..1] becomes [0..1, 1..0]).
- Clone lib creates linear arrays of children.
- Set of fillet radius functions for straight and circular edges.
- Hole library for bolt holes and hex nut recesses.
- Teardrop holes for bolt holes in vertical surfaces.
- Iter functions to visit corners of an XY rectangle (with/without rotation).
- List member and tail functions.
- Math functions for dot product (dot) and unit vector (unit).
- Convenience functions that augment hole library with default values for:
  - An incomplete set of small metric bolt fits (M2 - M4) (clearance fit,
    close fit, and loose fit).
  - An incomplete set of small metric hex nuts (M2 - M4).
- Reflect function to reflect vectors along an arbitrary axis.
- Shape functions for regular polygons.
- Convencience function for hexagon shapes.
- Snake line functions for uniform stroke and variable stroke.
- Unit conversion functions between inch and mm.
- Vector swizzling functions.
