////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/rounded-cube.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

pvc_r = 26.7 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";

cradle_base_x = 60;
cradle_base_y = 60;
cradle_base_z = 2;

cradle_riser_x = 10;
cradle_riser_extra_y = 10;
cradle_riser_extra_z = 10;

cradle_clearance_r = 0.75;

cradle_rounding_r = 0.7;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

cradle_riser_y = cradle_riser_extra_y + pvc_r * 2 + cradle_clearance_r * 2;
cradle_riser_z = cradle_riser_extra_z + pvc_r;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    PVCCradle();
}
else if( render_mode == "print-holder" )
{
    PVCCradle();
}
else
{
    echo( str( "invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// this is just to elevate the PVC while it's drying

module PVCCradle()
{
    // base
    RoundedCubeAlt2(
        cradle_base_x,
        cradle_base_y,
        cradle_base_z + DIFFERENCE_CLEARANCE,
        r = cradle_rounding_r,
        round_bottom = false
        );

    // riser
    difference()
    {
        translate( [
            calculateOffsetToCenter( cradle_base_x, cradle_riser_x ),
            calculateOffsetToCenter( cradle_base_y, cradle_riser_y ),
            cradle_base_z
            ] )
            RoundedCubeAlt2(
                cradle_riser_x,
                cradle_riser_y,
                cradle_riser_z,
                r = cradle_rounding_r,
                round_bottom = false
                );

        translate([ 0, cradle_base_y / 2, cradle_base_z + cradle_riser_z ])
            rotate([ 0, 90, 0 ])
                cylinder(
                    r = pvc_r + cradle_clearance_r,
                    h = cradle_base_x
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
