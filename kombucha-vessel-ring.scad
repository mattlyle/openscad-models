////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/rounded-cylinder.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

vessel_r = 218.0/2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print-ring";

extra_r = 0.8;

ring_r = 2.0;
top_r = 10;

top_z = 2.0;
ring_z = 10.0;

rounding_r = 0.8;

strut_width = 8.0;

preview_vessel_z = 40;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 128 : 256;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if ( render_mode == "preview" )
{
    % cylinder( r = vessel_r, h = preview_vessel_z );

    translate([ 0, 0, preview_vessel_z - ring_z ])
        KombuchaVesselRing();
}
else if ( render_mode == "print-ring" )
{
    translate([ 0, 0, ring_z + top_z ])
    rotate([ 180, 0, 0 ])
        KombuchaVesselRing();
}
else
{
    echo( str( "Invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module KombuchaVesselRing()
{
    outer_r = vessel_r + extra_r + extra_r;

    // top
    translate([ 0, 0, ring_z ])
    {
        difference()
        {
            RoundedCylinder(
                h = top_z,
                r = outer_r,
                rounding_r = 1.0,
                round_top = true,
                round_bottom = false
                );

            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                cylinder(
                    h = top_z + DIFFERENCE_CLEARANCE * 2,
                    r = outer_r - top_r
                    );
        }
    }

    // ring
    difference()
    {
        RoundedCylinder(
            h = ring_z,
            r = outer_r,
            rounding_r = rounding_r,
            round_top = false,
            round_bottom = true
            );

        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                h = ring_z + DIFFERENCE_CLEARANCE * 2,
                r = outer_r - ring_r
                );
    }

    // horizontal strut
    translate([ -outer_r + top_r / 2, -strut_width / 2, ring_z ])
        cube([ outer_r * 2 - top_r, strut_width, top_z ] );

    // vertical strut
    translate([ -strut_width / 2, -outer_r + top_r / 2, ring_z ])
        cube([ strut_width, outer_r * 2 - top_r, top_z ] );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
