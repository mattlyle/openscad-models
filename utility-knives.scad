use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// folding knives
folding_knife_x = 22.6;
folding_knife_y = 109;
folding_knife_z = 35.8;

// retractable knives
retractable_knife_x = 21.5;
retractable_knife_y = 158;
retractable_knife_z = 29.3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

cup_x = 3; // in grid cells
cup_y = 4; // in grid cells
cup_z = 1;

clearance = 1.5;

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

spacing_x = ( base_x - folding_knife_x * 2 - retractable_knife_x * 2 - clearance * 8 ) / 4;

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

            // cut out the utility knife areas
            translate([ spacing_x, ( base_y - folding_knife_y ) / 2, base_z ])
                cube([ folding_knife_x, folding_knife_y, holder_z - base_z ]);

            translate([ spacing_x * 2 + folding_knife_x, ( base_y - folding_knife_y ) / 2, base_z ])
                cube([ folding_knife_x, folding_knife_y, holder_z - base_z ]);

            translate([ spacing_x * 3 + folding_knife_x * 2, ( base_y - retractable_knife_y ) / 2, base_z ])
                cube([ retractable_knife_x, retractable_knife_y, holder_z - base_z ]);

            translate([ spacing_x * 4 + folding_knife_x * 2 + retractable_knife_x, ( base_y - retractable_knife_y ) / 2, base_z ])
                cube([ retractable_knife_x, retractable_knife_y, holder_z - base_z ]);
        }
    }
}

if( render_mode == "preview" || render_mode == "text-only" )
{
    translate([ spacing_x, 18, holder_z ])
        CenteredTextLabel( "Utility", 8, "Georgia:style=Bold", spacing_x + folding_knife_x * 2, -1 );
    translate([ spacing_x, 7, holder_z ])
        CenteredTextLabel( "Knives", 8, "Georgia:style=Bold", spacing_x + folding_knife_x * 2, -1 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
