// :: Vec3 -> Vec3
// Isolate single component of vec3.
function vx00(v) = [ v.x, 0, 0 ];
function v0y0(v) = [ 0, v.y, 0 ];
function v00z(v) = [ 0, 0, v.z ];

// :: Vec3 -> Vec3
// Isolate two components of vec3.
function vxy0(v) = [ v.x, v.y, 0 ];
function vx0z(v) = [ v.x, 0, v.z ];
function v0yz(v) = [ 0, v.y, v.z ];

function vx0(v) = [ v.x, 0 ];
function v0y(v) = [ 0, v.y ];

function vxy(v) = [ v.x, v.y ];
function vxz(v) = [ v.x, v.z ];
function vyz(v) = [ v.y, v.z ];
