use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
include <modules/triangular-prism.scad>
// include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

multimeter_main_body_x = 92.0;
multimeter_main_body_y = 43.0;
multimeter_main_body_z = 195.0;

multimeter_main_body_back_z = 115.0;
multimeter_main_body_front_z = 55.0;
multimeter_main_body_front_sides_x = 11.0;
multimeter_main_body_angle = 10.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

cup_x = 3; // in grid cells
cup_y = 2; // in grid cells
cup_z = 1;

multimeter_back_clearance = 1.5;
multimeter_back_sides_width = 2.0;

corner_rounding_radius = 3.7;
holder_clearance = 0.15;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cup_z * 42.0;

multimeter_main_body_offset_x = 25;
multimeter_main_body_offset_y = 5;

offset_z = base_z + 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" || render_mode == "bin-only" )
{
    // base
    gridfinity_cup(
        width = cup_x,
        depth = cup_y,
        height = cup_z,
        position = "zero",
        filled_in = true,
        lip_style = "none"
        );

    render()
    {
        difference()
        {
            union()
            {
                translate([ holder_clearance, holder_clearance, 0 ])
                    RoundedCube(
                        size = [ holder_x, holder_y, holder_z ],
                        r = corner_rounding_radius,
                        fn = 36 );

                back_width = multimeter_main_body_x + multimeter_back_sides_width * 2 + multimeter_back_clearance * 2;
                back_depth = multimeter_main_body_y + multimeter_back_sides_width * 2 + multimeter_back_clearance * 2;

                // add the back
                // # translate([
                //     multimeter_main_body_offset_x + back_width - multimeter_back_sides_width - multimeter_back_clearance,
                //     multimeter_main_body_offset_y + mult, offset_z ])
                //     rotate([ 0, 0, 180 ])
                //         TriangularPrism( x = back_width, y = 20, z = 30 );

                color([ 0.4, 0, 0 ])
                    translate([ multimeter_main_body_offset_x - multimeter_back_sides_width - multimeter_back_clearance, multimeter_main_body_offset_y + multimeter_main_body_y, offset_z ])
                        rotate([ -multimeter_main_body_angle, 0, 0 ])
                        {
                            // back
                            cube([ back_width, multimeter_back_sides_width, multimeter_main_body_back_z ]);

                            // left side - bottom
                            translate([ 0, -back_depth + multimeter_back_sides_width, 0 ])
                                cube([ multimeter_back_sides_width, back_depth, multimeter_main_body_front_z ]);

                            // left side - top
                            translate([ multimeter_back_sides_width, 0, multimeter_main_body_front_z ])
                                rotate([ 0, 0, 180 ])
                                    TriangularPrism( multimeter_back_sides_width, back_depth - multimeter_back_sides_width, multimeter_main_body_back_z - multimeter_main_body_front_z );

                            // right side - bottom
                            translate([ back_width - multimeter_back_sides_width, -back_depth + multimeter_back_sides_width, 0 ])
                                cube([ multimeter_back_sides_width, back_depth, multimeter_main_body_front_z ]);

                            // right side - top
                            translate([ back_width, 0, multimeter_main_body_front_z ])
                                rotate([ 0, 0, 180 ])
                                    TriangularPrism( multimeter_back_sides_width, back_depth - multimeter_back_sides_width, multimeter_main_body_back_z - multimeter_main_body_front_z );

                            // bottom
                            translate([ 0, -back_depth + multimeter_back_sides_width, -multimeter_back_sides_width ])
                                cube([ back_width, back_depth, multimeter_back_sides_width ]);

                            // front left
                            translate([ 0, -back_depth + multimeter_back_sides_width, 0 ])
                                cube([ multimeter_main_body_front_sides_x + multimeter_back_sides_width + multimeter_back_clearance, multimeter_back_sides_width, multimeter_main_body_front_z ]);

                            // front right
                            translate([ back_width - multimeter_main_body_front_sides_x - multimeter_back_sides_width - multimeter_back_clearance, -back_depth + multimeter_back_sides_width, 0 ])
                                cube([ multimeter_main_body_front_sides_x + multimeter_back_sides_width + multimeter_back_clearance, multimeter_back_sides_width, multimeter_main_body_front_z ]);
                    }
                }

                // cut off the area the gridfinity base covers
                cube([ base_x, base_y, base_z ]);

        }
    }
}

if( render_mode == "preview" )
{
    % translate([ multimeter_main_body_offset_x, multimeter_main_body_offset_y, offset_z + multimeter_main_body_y * sin( multimeter_main_body_angle ) ])
        rotate([ -multimeter_main_body_angle, 0, 0 ])
            MultimeterBody();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultimeterHolder()
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultimeterBody()
{
    cube([ multimeter_main_body_x, multimeter_main_body_y, multimeter_main_body_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultimeterTester()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
