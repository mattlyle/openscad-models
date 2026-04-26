////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/rounded-cube.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

pvc_r = 26.7 / 2;

manifold_x = 570;
manifold_spacing_ab_y = 120;
manifold_spacing_bc_y = 120;
manifold_z = 280;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-cradle";
// render_mode = "print-leg-bracket";
// render_mode = "print-bottle-holder-framework";
// render_mode = "print-bottle-holder-inset-small";
// render_mode = "print-bottle-holder-inset-medium";
// render_mode = "print-bottle-holder-inset-large";

cradle_base_x = 60;
cradle_base_y = 60;
cradle_base_z = 2;
cradle_riser_x = 10;
cradle_riser_extra_y = 10;
cradle_riser_extra_z = 10;
cradle_clearance_r = 0.3;
cradle_rounding_r = 0.7;

leg_bracket_wall_r = 3;
leg_bracket_z = 25;
leg_bracket_bottom_clearance_r = 0.1;
leg_bracket_top_clearance_r = 0.1;
leg_bracket_joiner_z = 4; // the height between the bottom leg bracket and the top manifold bracket
leg_bracket_top_z_percent = 0.75; // the percentage of the manifold bracket to wrap around

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

    translate([ 100, 0, 0 ])
    {
        ManifoldPreview();

        translate([ manifold_x, 0, 0 ])
            LegPreviews();

        translate([ manifold_x + pvc_r * 2, 0, 0 ])
            LegBracket();
    }

    // translate([ 200, 0, 0 ])
    //     BuildHolderFramework();
}
else if( render_mode == "print-cradle" )
{
    PVCCradle();
}
else if( render_mode == "print-leg-bracket" )
{
    LegBracket();
}
else
{
    assert( false, str( "invalid render mode: ", render_mode ) );
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

module ManifoldPreview()
{
    sphere(r=1);

    // manifold a
    % translate([ 0, manifold_spacing_ab_y + manifold_spacing_bc_y, manifold_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // manifold a
    % translate([ 0, manifold_spacing_bc_y, manifold_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // manifold c
    % translate([ 0, 0, manifold_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // left a-b
    % translate([ 0, manifold_spacing_bc_y, manifold_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );

    // left b-c
    % translate([ 0, 0, manifold_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );

    // right a-b
    % translate([ manifold_x, manifold_spacing_bc_y, manifold_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );

    // right b-c
    % translate([ manifold_x, 0, manifold_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LegPreviews()
{
    // far leg
    % translate([ 0, manifold_spacing_bc_y + manifold_spacing_ab_y / 2, 0 ])
        cylinder( r= pvc_r, h = manifold_z );

    % translate([ 0, manifold_spacing_bc_y / 2, 0 ])
        cylinder( r= pvc_r, h = manifold_z );

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LegBracket()
{
    outer_r = pvc_r + leg_bracket_wall_r + leg_bracket_bottom_clearance_r;

    difference()
    {
        cylinder(
            r = outer_r,
            h = leg_bracket_z + leg_bracket_joiner_z + leg_bracket_top_z_percent * pvc_r * 2
            );

        // cut out the bottom
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                r = pvc_r + leg_bracket_bottom_clearance_r,
                h = leg_bracket_z + DIFFERENCE_CLEARANCE
                );

        // cut out the manifold
        translate([
            -outer_r - DIFFERENCE_CLEARANCE,
            0,
            leg_bracket_z + leg_bracket_joiner_z + pvc_r
            ])
            rotate([ 0, 90, 0 ])
                cylinder(
                    r = pvc_r + leg_bracket_top_clearance_r,
                    h = outer_r * 2 + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
