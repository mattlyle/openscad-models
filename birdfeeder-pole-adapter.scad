include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

bird_feeder_pole_r = 12.2 / 2;
outer_r = 40.0 / 2;

top_extra_r = 3.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

clearance = 0.15;

body_z = 90;
top_z = 3.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    BirdfeederPoleAdapter();
}
else if( render_mode == "print" )
{
    translate([ 0, 0, body_z + top_z ])
        rotate([ 180, 0, 0 ])
            BirdfeederPoleAdapter();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BirdfeederPoleAdapter()
{
    cutout_r = bird_feeder_pole_r + clearance;

    difference()
    {
        union()
        {
            cylinder(
                r = outer_r - clearance,
                h = body_z
                );

            translate([ 0, 0, body_z ])
                cylinder(
                    r = outer_r + top_extra_r,
                    h = top_z
                    );
        }

        translate([
            outer_r - bird_feeder_pole_r - clearance,
            0,
            -DIFFERENCE_CLEARANCE
            ])
            cylinder(
                r = cutout_r,
                h = body_z + top_z + DIFFERENCE_CLEARANCE * 2
                );

        translate([
            outer_r - bird_feeder_pole_r - clearance,
            -cutout_r,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                cutout_r * 2,
                cutout_r * 2,
                body_z + top_z + DIFFERENCE_CLEARANCE * 2
                ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
