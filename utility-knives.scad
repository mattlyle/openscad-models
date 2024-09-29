use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// folding knife
folding_knife_x = 22.6;
folding_knife_y = 35.8;

// retractable knife
retractable_knife_x = 18.6;
retractable_knife_y = 29.3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

cup_x = 3; // in grid cells
cup_y = 1; // in grid cells
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
        translate([ spacing_x, base_y / 2, base_z ])
            UtilityKnifeCutout( folding_knife_x, folding_knife_y, holder_z - base_z );

        translate([ spacing_x * 2 + folding_knife_x, base_y / 2, base_z ])
            UtilityKnifeCutout( folding_knife_x, folding_knife_y, holder_z - base_z );

        translate([ spacing_x * 3 + folding_knife_x * 2, base_y / 2, base_z ])
            UtilityKnifeCutout( retractable_knife_x, retractable_knife_y, holder_z - base_z );

        translate([ spacing_x * 4 + folding_knife_x * 2 + retractable_knife_x, base_y / 2, base_z ])
            UtilityKnifeCutout( retractable_knife_x, retractable_knife_y, holder_z - base_z );
    }
}

color([ 0, 0, 0 ])
    translate([ spacing_x * 2 + folding_knife_x - 2, 3.5, holder_z ])
        rotate([ 0, 0, 90 ])
        linear_extrude( 0.5 )
            text( "Utility Knives", size = 4.5 );

color([ 0, 0, 0 ])
    translate([ spacing_x * 4 + folding_knife_x * 2 + retractable_knife_x - 5.5, 39, holder_z ])
        rotate([ 0, 0, -90 ])
        linear_extrude( 0.5 )
            text( "Utility Knives", size = 4.5 );


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module UtilityKnifeCutout( width_x, depth_y, height_z )
{
    translate([ 0, -depth_y / 2, 0 ])
        cube([ width_x, depth_y, height_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
