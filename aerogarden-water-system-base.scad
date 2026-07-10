include <modules/utils.scad>;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

cup_bottom_r = 67.0 / 2;
cup_top_r = 97.7 / 2; // with lip 104.9.0 / 2;
cup_z = 180.1 - 3.1; // remove the lip

cup_hole_offset_z = 19;
cup_hole_r = 6.4 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

wall_width = 2.0;
cup_clearance = 0.4;

cup_hole_extra_r = 2.0;

base_r = 140 / 2;
base_h = 10;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

// translate([ 0, 0, wall_width ])
//     CupPreview();

AerogardenWaterSystemBase();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CupPreview()
{
    cylinder(
        r1 = cup_bottom_r,
        r2 = cup_top_r,
        h = cup_z
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AerogardenWaterSystemBase()
{
    // cup
    difference()
    {
        union()
        {
            // cup outside
            cylinder(
                r1 = cup_bottom_r + wall_width + cup_clearance,
                r2 = cup_top_r + wall_width + cup_clearance,
                h = cup_z + wall_width
                );
            
            // base bottom
            cylinder(
                r = base_r,
                h = wall_width
                );

            // base cone
            translate([ 0, 0, wall_width ])
                cylinder(
                    r1 = base_r,
                    r2 = cup_bottom_r,
                    h = base_h - wall_width
                    );
        }


        // remove the inside of the cone
        translate([ 0, 0, wall_width ])
            cylinder(
                r1 = cup_bottom_r + cup_clearance,
                r2 = cup_top_r + cup_clearance,
                h = cup_z + DIFFERENCE_CLEARANCE
                );

        // remove the hole
        translate([ 0, 0, wall_width + cup_hole_offset_z + cup_hole_r + cup_hole_extra_r ])
            rotate([ 90, 0, 0 ])
                cylinder(
                    r = cup_hole_r + cup_hole_extra_r,
                    h = cup_top_r
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
