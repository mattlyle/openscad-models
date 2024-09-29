use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

screw_driver_shaft_diameter = 3.0;
screw_driver_handle_diameter = 18.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

cup_x = 2; // in grid cells
cup_y = 1; // in grid cells
cup_z = 1;

screw_driver_shaft_clearance = 0.4;

// other_tool_side_length = 10.5;

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
                cube([ base_x, base_y, base_z ]);

                front_row_count = 4;
                back_row_count = 4;
                max_columns = max( front_row_count, back_row_count );

                spacing = screw_driver_handle_diameter + screw_driver_shaft_clearance;
                offset_x = ( holder_x - spacing * max_columns ) / 2 + spacing / 2;
                echo("spacing",spacing);

                // cut out the back row
                for( i = [ 0 : max_columns - 1 ])
                {
                    translate([ offset_x + spacing * i, holder_y / 3 * 2, base_z ])
                        cylinder( h = holder_z - base_z, r = screw_driver_shaft_diameter / 2 + screw_driver_shaft_clearance, $fn = 48 );
                }

                // cut out the front row
                for( i = [ 0 : max_columns - 1 ])
                {
                    // if( i < front_row_count )
                    // {
                        // screw driver shafts on the left
                        translate([ offset_x + spacing * i, holder_y / 3, base_z ])
                            cylinder( h = holder_z - base_z, r = screw_driver_shaft_diameter / 2 + screw_driver_shaft_clearance, $fn = 48 );
                    // }
                    // else
                    // {
                    //     translate([ offset_x + spacing * i - other_tool_side_length / 2, holder_y / 3 - other_tool_side_length / 2, base_z ])
                    //         cube([ other_tool_side_length, other_tool_side_length, holder_z - base_z ]);
                    // }
                }
        }
    }
}

if( render_mode == "preview" || render_mode == "text-only" )
{
    translate([ 0, holder_y - holder_y / 3, holder_z ])
        CenteredTextLabel( "Small Screwdriver Set", 5, holder_x, holder_y / 3 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
