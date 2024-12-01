use <../../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <../modules/rounded-cube.scad>
include <../modules/triangular-prism.scad>
// include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// TODO: should add a little bin for cable management in the back?

multimeter_main_body_x = 92.0;
multimeter_main_body_y = 43.0;
multimeter_main_body_z = 195.0;

multimeter_main_body_back_z = 115.0;
multimeter_main_body_front_z = 55.0;
multimeter_main_body_front_sides_x = 11.0;
multimeter_main_body_angle = 15.0; // TODO: maybe only 10 degrees, not 15

multimeter_probe_tip_radius = 2.1 / 2;
multimeter_probe_tip_length = 16;

multimeter_probe_handle_radius = 10.1 / 2;
multimeter_probe_handle_length = 19.0;

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

multimeter_probe_offset_x = 10;
multimeter_probe_1_offset_y = 14;
multimeter_probe_2_offset_y = 36;
multimeter_probe_clearance = 1.0;

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
multimeter_main_body_offset_y = 3;

offset_z = base_z + multimeter_back_sides_width + 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" || render_mode == "bin-only" )
{
    MultimeterHolder();
}

// if( render_mode == "preview" )
// {
//     % translate([ multimeter_main_body_offset_x, multimeter_main_body_offset_y, offset_z + multimeter_main_body_y * sin( multimeter_main_body_angle ) ])
//         rotate([ -multimeter_main_body_angle, 0, 0 ])
//             MultimeterBody();
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultimeterHolder()
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

    back_width = multimeter_main_body_x + multimeter_back_sides_width * 2 + multimeter_back_clearance * 2;
    back_depth = multimeter_main_body_y + multimeter_back_sides_width * 2 + multimeter_back_clearance * 2;

    render()
    {
        difference()
        {
            translate([ holder_clearance, holder_clearance, 0 ])
                RoundedCube(
                    size = [ holder_x, holder_y, holder_z ],
                    r = corner_rounding_radius,
                    fn = 36 );

            // cut off the area the gridfinity base covers
            cube([ base_x, base_y, base_z ]);

            // remove the section for the main body
            translate([ multimeter_main_body_offset_x - multimeter_back_sides_width - multimeter_back_clearance, multimeter_main_body_offset_y - multimeter_back_clearance * 2 - multimeter_back_sides_width, offset_z + back_depth * sin( multimeter_main_body_angle ) - multimeter_back_sides_width ])
                rotate([ -multimeter_main_body_angle, 0, 0 ])
                    cube([ back_width, back_depth, multimeter_main_body_z ]);

            // remove the front too
            translate([ multimeter_main_body_offset_x - multimeter_back_sides_width - multimeter_back_clearance, 0, offset_z + back_depth * sin( multimeter_main_body_angle ) ])
                cube([ back_width, back_depth, multimeter_main_body_front_z ]);

            // remove the probe 1
            translate([ multimeter_probe_offset_x, multimeter_probe_1_offset_y, holder_z - multimeter_probe_handle_length ])
                cylinder( h = multimeter_probe_handle_length, r = multimeter_probe_handle_radius + multimeter_probe_clearance, $fn = 24 );
            translate([ multimeter_probe_offset_x, multimeter_probe_1_offset_y, holder_z - multimeter_probe_handle_length - multimeter_probe_tip_length ])
                cylinder( h = multimeter_probe_tip_length, r = multimeter_probe_tip_radius + multimeter_probe_clearance, $fn = 24 );
            
            // remove the probe 2
            translate([ multimeter_probe_offset_x, multimeter_probe_2_offset_y, holder_z - multimeter_probe_handle_length ])
                cylinder( h = multimeter_probe_handle_length, r = multimeter_probe_handle_radius + multimeter_probe_clearance, $fn = 24 );
            translate([ multimeter_probe_offset_x, multimeter_probe_2_offset_y, holder_z - multimeter_probe_handle_length - multimeter_probe_tip_length ])
                cylinder( h = multimeter_probe_tip_length, r = multimeter_probe_tip_radius + multimeter_probe_clearance, $fn = 24 );
        }
    }

    // now add all the other parts back

    color([ 0.4, 0, 0 ])
    {
        translate([ multimeter_main_body_offset_x - multimeter_back_sides_width - multimeter_back_clearance, multimeter_main_body_offset_y + multimeter_main_body_y, offset_z ])
        {
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
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultimeterBody()
{
    cube([ multimeter_main_body_x, multimeter_main_body_y, multimeter_main_body_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultimeterProbe()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
