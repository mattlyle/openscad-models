use <../modules/gridfinity-extended-with-snug-fit.scad>

shoebox_demo_thickness = 0.01;

shoebox_x = 202;
shoebox_y = 328;
shoebox_z = 120;

gridfinity_baseplate_snug_fit_into( shoebox_x, 0, 4, 4 );

translate([ 0, 42 * 4, 0 ])
  gridfinity_baseplate_snug_fit_into( shoebox_x, shoebox_y - 42 * 4, 4, 3 );

// near
% translate([ 0, -shoebox_demo_thickness, 0 ]) cube([ shoebox_x, shoebox_demo_thickness, shoebox_z ]);
// right
% translate([ shoebox_x, 0, 0 ]) cube([ shoebox_demo_thickness, shoebox_y, shoebox_z ]);
// far
% translate([ 0, shoebox_y + shoebox_demo_thickness, 0 ]) cube([ shoebox_x, shoebox_demo_thickness, shoebox_z ]);
// left
% translate([ -shoebox_demo_thickness, 0, 0 ]) cube([ shoebox_demo_thickness, shoebox_y, shoebox_z ]);
// base
% translate([ 0, 0, -shoebox_demo_thickness ]) cube([ shoebox_x, shoebox_y, shoebox_demo_thickness ]);
