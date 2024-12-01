use <../../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// straight tweezers
tweezers_1_x = 7.1;
tweezers_1_y = 6.8;

// curved tweezers
tweezers_2_x = 5.1;
tweezers_2_y = 10.4;

// green pry tool
green_pry_tool_x = 10.0;
green_pry_tool_y = 5.5;

// tiny black screwdriver
tiny_black_screwdriver_shaft_diameter = 2.1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";

cup_x = 1; // in grid cells
cup_y = 1; // in grid cells
cup_z = 1;

clearance = 1.0;

holder_clearance = 0.15;

corner_rounding_radius = 3.7;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cup_z * 42.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
            translate([ holder_clearance, holder_clearance, 0 ])
                RoundedCube(
                    size = [ holder_x, holder_y, holder_z ],
                    r = corner_rounding_radius,
                    fn = 36
                    );

            // cut off the area the gridfinity base covers
            // cube([ base_x, base_y, base_z ]);

            // front-left = straight tweezers
            translate([ base_x / 4 - tweezers_1_x / 2 - clearance, base_y / 4 - tweezers_1_y / 2 - clearance, base_z ])
                cube([ tweezers_1_x + clearance * 2, tweezers_1_y + clearance * 2, holder_z - base_z ]);

            // front-right = curved tweezers
            translate([ base_x / 4 * 3 - tweezers_2_x / 2 - clearance, base_y / 4 - tweezers_2_y / 2 - clearance, base_z ])
                cube([ tweezers_2_x + clearance * 2, tweezers_2_y + clearance * 2, holder_z - base_z ]);
 
            // back-left = green pry tool
            translate([ base_x / 4 - green_pry_tool_x / 2 - clearance, base_y / 4 * 3 - green_pry_tool_y / 2 - clearance, base_z ])
                cube([ green_pry_tool_x + clearance * 2, green_pry_tool_y + clearance * 2, holder_z - base_z ]);

            // back-right = tiny screwdriver
            translate([ base_x / 4 * 3, base_y / 4 * 3, base_z ])
                cylinder( h = holder_z - base_z, r = tiny_black_screwdriver_shaft_diameter / 2 + clearance, $fn = 24 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
