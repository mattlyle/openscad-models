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
manifold_copper_tube_r = 6.5 / 2;
manifold_copper_tube_a_z = 165;
manifold_copper_tube_bc_z = 215;
manifold_copper_tube_offset_x = 105;
manifold_copper_tube_spacing_x = 115;

jar_small_sizes = [ // coords are [ r, z ]
    [ 73.7 / 2, 0 ],
    [ 73.7 / 2, 110 ],
    [ 43.6 / 2, 130 ],
    [ 28.0 / 2, 190 ],
    [ 28.0 / 2, 220 ],
    ];

jar_medium_sizes = [ // coords are [ r, z ]
    [ 86.8 / 2, 0 ],
    [ 86.8 / 2, 185 ],
    [ 61.0 / 2, 210 ],
    [ 53.5 / 2, 230 ],
    [ 29.6 / 2, 250 ],
    [ 29.6 / 2, 295 ],
    ];

jar_large_sizes = [ // coords are [ r, z ]
    [ 92.3 / 2, 0 ],
    [ 92.3 / 2, 140 ],
    [ 56.0 / 2, 170 ],
    [ 27.4 / 2, 250 ],
    [ 27.4 / 2, 280  ],
    ];

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

bottle_manifold_spacing_z = 20; // this is the vertical spacing off the manifold we want the bottle to sit

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

cradle_riser_y = cradle_riser_extra_y + pvc_r * 2 + cradle_clearance_r * 2;
cradle_riser_z = cradle_riser_extra_z + pvc_r;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function GenerateBottlePolygonPoints( measurements ) = [
    [ 0, 0 ],
    for( i = [ 0 : len( measurements ) - 1 ] )
        [ measurements[ i ][ 0 ], measurements[ i ][ 1 ] ],
    [ 0, measurements[ len( measurements ) - 1 ][ 1 ] ]
    ];

function GetBottleHeight( measurements ) = measurements[ len( measurements ) - 1 ][ 1 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    PVCCradle();

    translate([ 150, 0, 0 ])
        LegBracket();

    translate([ 250, 0, 0 ])
    {
        ManifoldPreview( false );
    }
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

module ManifoldPreview( use_z_preview = true )
{
    preview_z = use_z_preview ? manifold_z : 0;

    // manifold a
    % translate([ 0, manifold_spacing_ab_y + manifold_spacing_bc_y, preview_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // manifold a
    % translate([ 0, manifold_spacing_bc_y, preview_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // manifold c
    % translate([ 0, 0, preview_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // left a-b
    % translate([ 0, manifold_spacing_bc_y, preview_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );

    // left b-c
    % translate([ 0, 0, preview_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );

    // right a-b
    % translate([ manifold_x, manifold_spacing_bc_y, preview_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );

    // right b-c
    % translate([ manifold_x, 0, preview_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_bc_y );

    // copper tubes
    for( i = [ 0 : 3 ] )
    {
        // manifold a
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_ab_y + manifold_spacing_bc_y,
            preview_z + pvc_r
            ])
            cylinder( r = manifold_copper_tube_r, h = manifold_copper_tube_a_z );

        // manifold b
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_bc_y,
            preview_z + pvc_r
            ])
            cylinder( r = manifold_copper_tube_r, h = manifold_copper_tube_bc_z );

        // manifold c
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            0,
            preview_z + pvc_r
            ])
            cylinder( r = manifold_copper_tube_r, h = manifold_copper_tube_bc_z );
    }

    // bottles
    for( i = [ 0 : 3 ] )
    {
        // manifold a
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_ab_y + manifold_spacing_bc_y,
            preview_z + pvc_r + bottle_manifold_spacing_z
            ])
            BottlePreview( jar_small_sizes, false );

        // manifold b
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_bc_y,
            preview_z + pvc_r + bottle_manifold_spacing_z
            ])
            BottlePreview( jar_medium_sizes, false );

        // manifold c
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            0,
            preview_z + pvc_r + bottle_manifold_spacing_z
            ])
            BottlePreview( jar_large_sizes, false );
    }
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

module BottlePreview( measurements, inverted = true )
{
    translate([ 0, 0, inverted ? 0 : GetBottleHeight( measurements ) ])
        rotate([ inverted ? 0 : 180, 0, 0 ])
            rotate_extrude()
                polygon( points = GenerateBottlePolygonPoints( measurements ) );
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
