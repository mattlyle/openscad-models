////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/rounded-cube.scad>
include <modules/hexagons.scad>
include <modules/text-label.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

pvc_r = 26.7 / 2;

manifold_x = 570;
manifold_spacing_y = 105;
manifold_z = 280;
manifold_copper_tube_r = 6.5 / 2;
manifold_copper_tube_ab_z = 215;
manifold_copper_tube_c_z = 165;
manifold_copper_tube_offset_x = 105;
manifold_copper_tube_spacing_x = 115;
manifold_leg_spacing_y = 224;

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
// render_mode = "print-bottle-holder-support-structure";
// render_mode = "print-bottle-holder-support-structure-leg-test";
// render_mode = "print-bottle-holder-insert-small";
// render_mode = "print-bottle-holder-insert-small-text";
// render_mode = "print-bottle-holder-insert-medium";
// render_mode = "print-bottle-holder-insert-medium-text";
// render_mode = "print-bottle-holder-insert-large";
// render_mode = "print-bottle-holder-insert-large-text";

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

bottle_holder_support_structure_leg_extra_y = 4;
bottle_holder_support_structure_leg_scale_y = 1.2;
bottle_holder_support_structure_wall_z = 100;
bottle_holder_support_structure_leg_z = 40;
bottle_holder_support_structure_grid_xy = 7;
bottle_holder_support_structure_grid_z = 5;
bottle_holder_support_structure_hexagons_r = 5;
bottle_holder_support_structure_hexagons_spacing = 1.2;

bottle_holder_support_structure_insert_top_clearance_xy = 0.4;
bottle_holder_support_structure_insert_bottom_clearance_xy = 0.2;
bottle_holder_support_structure_insert_cutout_scale_factor = 1.02;
bottle_holder_support_structure_insert_min_throat_r = 55 / 2; // this to to allow the swing caps to pass through

// [ cone_top_r, cone_bottom_r, cone_z ]
bottle_holder_support_structure_insert_cone_small_config = [ 40, 25, 19 ];
bottle_holder_support_structure_insert_cone_medium_config = [ 45, 33, 30 ];
bottle_holder_support_structure_insert_cone_large_config = [ 35, 28, 15 ];

bottle_holder_support_structure_insert_label_depth = 0.4;
bottle_holder_support_structure_insert_label_font = "Liberation Sans:style=bold";;
bottle_holder_support_structure_insert_label_font_size = 6;
bottle_holder_support_structure_insert_label_offset_x = 2;
bottle_holder_support_structure_insert_label_offset_y = 2.5;
bottle_holder_support_structure_insert_label_lines_small = [ "Small", "Clear" ];
bottle_holder_support_structure_insert_label_lines_medium = [ "Medium", "Brown" ];
bottle_holder_support_structure_insert_label_lines_large = [ "Large", "Blue" ];

bottle_holder_support_structure_insert_preview_offset_z = 6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

cradle_riser_y = cradle_riser_extra_y + pvc_r * 2 + cradle_clearance_r * 2;
cradle_riser_z = cradle_riser_extra_z + pvc_r;

bottle_holder_support_structure_leg_y = pvc_r * 2 + bottle_holder_support_structure_leg_extra_y;

bottle_holder_support_structure_grid_x = manifold_copper_tube_spacing_x;
bottle_holder_support_structure_grid_y = manifold_spacing_y;

bottle_holder_support_structure_x = bottle_holder_support_structure_grid_x * 2;
bottle_holder_support_structure_y = bottle_holder_support_structure_grid_y * 3;
echo( str( ">>> Support Structure X: ", bottle_holder_support_structure_x ) );
echo( str( ">>> Support Structure Y: ", bottle_holder_support_structure_y ) );
assert( bottle_holder_support_structure_x <= 320, "Bottle holder support structure X is too wide to fit on a 320mm print bed" );
assert( bottle_holder_support_structure_y <= 320, "Bottle holder support structure Y is too deep to fit on a 320mm print bed" );

bottle_holder_support_structure_z = bottle_holder_support_structure_leg_z + bottle_holder_support_structure_wall_z + bottle_holder_support_structure_grid_z;

bottle_holder_support_structure_insert_x = bottle_holder_support_structure_grid_x - bottle_holder_support_structure_insert_top_clearance_xy * 2;
bottle_holder_support_structure_insert_y = bottle_holder_support_structure_grid_y - bottle_holder_support_structure_insert_top_clearance_xy * 2;

bottle_holder_support_structure_leg_x = bottle_holder_support_structure_grid_xy;
bottle_holder_support_structure_leg_near_y = ( manifold_spacing_y * 2 - manifold_leg_spacing_y ) / 2;
bottle_holder_support_structure_leg_far_y = bottle_holder_support_structure_leg_near_y + manifold_leg_spacing_y;


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

        translate([ manifold_copper_tube_offset_x - bottle_holder_support_structure_grid_x / 2, 0, 0 ])
            BottleHolderSupportStructure();

        translate([ manifold_copper_tube_offset_x + bottle_holder_support_structure_grid_x * 1.5 + 0.75, 0, 0 ])
            BottleHolderSupportStructure();
    }

    translate([ 900, 0, 0 ])
    {
        BottleHolderSupportStructure();

        // manifold A
        translate([
            0,
            bottle_holder_support_structure_grid_y * 3 / 2,
            bottle_holder_support_structure_z + bottle_holder_support_structure_insert_preview_offset_z
            ])
            BottleHolderSupportStructureInsert( jar_large_sizes, bottle_holder_support_structure_insert_cone_large_config, bottle_holder_support_structure_insert_label_lines_large );

        // manifold B
        translate([
            bottle_holder_support_structure_grid_x,
            bottle_holder_support_structure_grid_y / 2,
            bottle_holder_support_structure_z + bottle_holder_support_structure_insert_preview_offset_z
            ])
            BottleHolderSupportStructureInsert( jar_medium_sizes, bottle_holder_support_structure_insert_cone_medium_config, bottle_holder_support_structure_insert_label_lines_medium );

        // manifold C
        translate([
            0,
            -bottle_holder_support_structure_grid_y / 2,
            bottle_holder_support_structure_z + bottle_holder_support_structure_insert_preview_offset_z
            ])
            BottleHolderSupportStructureInsert( jar_small_sizes, bottle_holder_support_structure_insert_cone_small_config, bottle_holder_support_structure_insert_label_lines_small );
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
else if( render_mode == "print-bottle-holder-support-structure" )
{
    translate([ bottle_holder_support_structure_x, bottle_holder_support_structure_grid_y / 2, bottle_holder_support_structure_z ])
        rotate([ 0, 180, 0 ])
            BottleHolderSupportStructure();
}
else if( render_mode == "print-bottle-holder-insert-small" )
{
    translate([ bottle_holder_support_structure_grid_x, 0, bottle_holder_support_structure_grid_z ])
        rotate([ 0, 180, 0 ])
            BottleHolderSupportStructureInsert(
                jar_small_sizes,
                bottle_holder_support_structure_insert_cone_small_config,
                bottle_holder_support_structure_insert_label_lines_small,
                false
                );
}
else if( render_mode == "print-bottle-holder-insert-small-text" )
{
    translate([ bottle_holder_support_structure_grid_x, 0, bottle_holder_support_structure_grid_z ])
        rotate([ 0, 180, 0 ])
            BottleHolderSupportStructureInsertText( bottle_holder_support_structure_insert_label_lines_small );
}
else if( render_mode == "print-bottle-holder-insert-medium" )
{
    translate([ bottle_holder_support_structure_grid_x, 0, bottle_holder_support_structure_grid_z ])
        rotate([ 0, 180, 0 ])
            BottleHolderSupportStructureInsert(
                jar_medium_sizes,
                bottle_holder_support_structure_insert_cone_medium_config,
                bottle_holder_support_structure_insert_label_lines_medium,
                false
                );
}
else if( render_mode == "print-bottle-holder-insert-medium-text" )
{
    translate([ bottle_holder_support_structure_grid_x, 0, bottle_holder_support_structure_grid_z ])
        rotate([ 0, 180, 0 ])
            BottleHolderSupportStructureInsertText( bottle_holder_support_structure_insert_label_lines_medium );
}
else if( render_mode == "print-bottle-holder-insert-large" )
{
    translate([ bottle_holder_support_structure_grid_x, 0, bottle_holder_support_structure_grid_z ])
        rotate([ 0, 180, 0 ])
            BottleHolderSupportStructureInsert(
                jar_large_sizes,
                bottle_holder_support_structure_insert_cone_large_config,
                bottle_holder_support_structure_insert_label_lines_large,
                false
                );
}
else if( render_mode == "print-bottle-holder-insert-large-text" )
{
    translate([ bottle_holder_support_structure_grid_x, 0, bottle_holder_support_structure_grid_z ])
        rotate([ 0, 180, 0 ])
            BottleHolderSupportStructureInsertText( bottle_holder_support_structure_insert_label_lines_large );
}
else if( render_mode == "print-bottle-holder-support-structure-leg-test" )
{
    translate([ 0, 0, -bottle_holder_support_structure_wall_z - bottle_holder_support_structure_grid_z + bottle_holder_support_structure_grid_xy ])
    {
        difference()
        {
            translate([ bottle_holder_support_structure_x, bottle_holder_support_structure_grid_y / 2, bottle_holder_support_structure_z ])
                rotate([ 0, 180, 0 ])
                    BottleHolderSupportStructure();

            translate([
                -DIFFERENCE_CLEARANCE,
                -DIFFERENCE_CLEARANCE,
                -DIFFERENCE_CLEARANCE
                ])
                cube([
                    bottle_holder_support_structure_x + DIFFERENCE_CLEARANCE * 2,
                    bottle_holder_support_structure_y + DIFFERENCE_CLEARANCE * 2,
                    bottle_holder_support_structure_z - bottle_holder_support_structure_leg_z - bottle_holder_support_structure_grid_xy + DIFFERENCE_CLEARANCE * 2
                ]);
        }
    }
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
    % translate([ 0, manifold_spacing_y * 2, preview_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // manifold a
    % translate([ 0, manifold_spacing_y, preview_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // manifold c
    % translate([ 0, 0, preview_z ])
        rotate([ 0, 90, 0 ])
            cylinder( r = pvc_r, h = manifold_x );

    // left a-b
    % translate([ 0, manifold_spacing_y, preview_z ])
        rotate([ -90, 0, 0 ])
        cylinder( r = pvc_r, h = manifold_spacing_y );

    // left b-c
    % translate([ 0, 0, preview_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_y );

    // right a-b
    % translate([ manifold_x, manifold_spacing_y, preview_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_y );

    // right b-c
    % translate([ manifold_x, 0, preview_z ])
        rotate([ -90, 0, 0 ])
            cylinder( r = pvc_r, h = manifold_spacing_y );

    // copper tubes
    for( i = [ 0 : 3 ] )
    {
        // manifold a
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_y * 2,
            preview_z + pvc_r
            ])
            cylinder( r = manifold_copper_tube_r, h = manifold_copper_tube_ab_z );

        // manifold b
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_y,
            preview_z + pvc_r
            ])
            cylinder( r = manifold_copper_tube_r, h = manifold_copper_tube_ab_z );

        // manifold c
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            0,
            preview_z + pvc_r
            ])
            cylinder( r = manifold_copper_tube_r, h = manifold_copper_tube_c_z );
    }

    // bottles
    for( i = [ 0 : 3 ] )
    {
        // manifold a
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_y * 2,
            preview_z + pvc_r + bottle_manifold_spacing_z
            ])
            BottlePreview( jar_large_sizes, false );

        // manifold b
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            manifold_spacing_y,
            preview_z + pvc_r + bottle_manifold_spacing_z
            ])
            BottlePreview( jar_medium_sizes, false );

        // manifold c
        % translate([
            manifold_copper_tube_offset_x + i * manifold_copper_tube_spacing_x,
            0,
            preview_z + pvc_r + bottle_manifold_spacing_z
            ])
            BottlePreview( jar_small_sizes, false );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LegPreviews()
{
    // far leg
    % translate([ 0, manifold_spacing_y * 3 / 2, 0 ])
        cylinder( r = pvc_r, h = manifold_z );

    % translate([ 0, manifold_spacing_y / 2, 0 ])
        cylinder( r = pvc_r, h = manifold_z );
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

module BottleHolderSupportStructure()
{
    for( y = [ bottle_holder_support_structure_leg_near_y, bottle_holder_support_structure_leg_far_y ] )
    {
        // left leg
        translate([ 0, y, 0 ])
            _BottleHolderSupportStructureLeg( false );

        // middle leg
        translate([ bottle_holder_support_structure_grid_x - bottle_holder_support_structure_leg_x, y, 0 ])
            _BottleHolderSupportStructureLeg( true );

        // right leg
        translate([ bottle_holder_support_structure_grid_x * 2 - bottle_holder_support_structure_leg_x, y, 0 ])
            _BottleHolderSupportStructureLeg( false );
    }

    // near wall
    translate([
        0,
        -bottle_holder_support_structure_grid_y / 2 + bottle_holder_support_structure_grid_xy,
        bottle_holder_support_structure_leg_z
        ])
        rotate([ 90, 0, 0 ])
            HexagonCube(
                bottle_holder_support_structure_x,
                bottle_holder_support_structure_wall_z,
                bottle_holder_support_structure_grid_xy,
                bottle_holder_support_structure_hexagons_r,
                spacing = bottle_holder_support_structure_hexagons_spacing,
                left_edge = bottle_holder_support_structure_grid_xy,
                right_edge = bottle_holder_support_structure_grid_xy,
                bottom_edge = bottle_holder_support_structure_grid_xy,
                );

    // far wall
    translate([
        0,
        bottle_holder_support_structure_grid_y * 2 + bottle_holder_support_structure_grid_y / 2,
        bottle_holder_support_structure_leg_z
        ])
        rotate([ 90, 0, 0 ])
            HexagonCube(
                bottle_holder_support_structure_x,
                bottle_holder_support_structure_wall_z,
                bottle_holder_support_structure_grid_xy,
                bottle_holder_support_structure_hexagons_r,
                spacing = bottle_holder_support_structure_hexagons_spacing,
                left_edge = bottle_holder_support_structure_grid_xy,
                right_edge = bottle_holder_support_structure_grid_xy,
                bottom_edge = bottle_holder_support_structure_grid_xy
                );

    // left wall
    translate([
        0,
        -bottle_holder_support_structure_grid_y / 2,
        bottle_holder_support_structure_leg_z
        ])
        rotate([ 90, 0, 90 ])
            HexagonCube(
                bottle_holder_support_structure_y,
                bottle_holder_support_structure_wall_z,
                bottle_holder_support_structure_grid_xy,
                bottle_holder_support_structure_hexagons_r,
                spacing = bottle_holder_support_structure_hexagons_spacing,
                left_edge = bottle_holder_support_structure_grid_xy,
                right_edge = bottle_holder_support_structure_grid_xy,
                bottom_edge = bottle_holder_support_structure_grid_xy
                );

    // center wall
    translate([
        bottle_holder_support_structure_grid_x - bottle_holder_support_structure_grid_xy,
        -bottle_holder_support_structure_grid_y / 2,
        bottle_holder_support_structure_leg_z
        ])
        rotate([ 90, 0, 90 ])
            HexagonCube(
                bottle_holder_support_structure_y,
                bottle_holder_support_structure_wall_z,
                bottle_holder_support_structure_grid_xy * 2,
                bottle_holder_support_structure_hexagons_r,
                spacing = bottle_holder_support_structure_hexagons_spacing,
                left_edge = bottle_holder_support_structure_grid_xy,
                right_edge = bottle_holder_support_structure_grid_xy,
                bottom_edge = bottle_holder_support_structure_grid_xy
                );

    // right wall
    translate([
        bottle_holder_support_structure_grid_x * 2 - bottle_holder_support_structure_grid_xy,
        -bottle_holder_support_structure_grid_y / 2,
        bottle_holder_support_structure_leg_z
        ])
        rotate([ 90, 0, 90 ])
            HexagonCube(
                bottle_holder_support_structure_y,
                bottle_holder_support_structure_wall_z,
                bottle_holder_support_structure_grid_xy,
                bottle_holder_support_structure_hexagons_r,
                spacing = bottle_holder_support_structure_hexagons_spacing,
                left_edge = bottle_holder_support_structure_grid_xy,
                right_edge = bottle_holder_support_structure_grid_xy,
                bottom_edge = bottle_holder_support_structure_grid_xy
                );

    // cells
    for( x_i = [ 0 : 1 ] )
        for( y_i = [ 0 : 2 ] )
            translate([
                x_i * bottle_holder_support_structure_grid_x,
                y_i * bottle_holder_support_structure_grid_y - bottle_holder_support_structure_grid_y / 2,
                bottle_holder_support_structure_z - bottle_holder_support_structure_grid_z
                ])
                _BottleHolderSupportStructureCell();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _BottleHolderSupportStructureLeg( is_center )
{
    leg_x = is_center
        ? bottle_holder_support_structure_grid_xy * 2
        : bottle_holder_support_structure_grid_xy;

    difference()
    {
        translate([ 0, -bottle_holder_support_structure_leg_y / 2, 0 ])
            cube([
                leg_x,
                bottle_holder_support_structure_leg_y,
                bottle_holder_support_structure_leg_z
                ]);

        translate([ -DIFFERENCE_CLEARANCE, 0, 0 ])
            rotate([ 0, 90, 0 ])
                scale([ 1.0, bottle_holder_support_structure_leg_scale_y, 1.0 ])
                cylinder(
                    r = pvc_r,
                    h = leg_x + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _BottleHolderSupportStructureCell()
{
    // grid cell frame
    difference()
    {
        cube([
            bottle_holder_support_structure_grid_x,
            bottle_holder_support_structure_grid_y,
            bottle_holder_support_structure_grid_z
            ]);

        translate([
            bottle_holder_support_structure_grid_xy,
            bottle_holder_support_structure_grid_xy,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                bottle_holder_support_structure_grid_x - bottle_holder_support_structure_grid_xy * 2,
                bottle_holder_support_structure_grid_y - bottle_holder_support_structure_grid_xy * 2,
                bottle_holder_support_structure_grid_z + DIFFERENCE_CLEARANCE * 2
                ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BottleHolderSupportStructureInsert( measurements, cone_config, label_lines, show_preview = true )
{
    assert( len( cone_config ) == 3, "cone_config must be an array of [ cone_top_r, cone_bottom_r, cone_z ]" );
    assert( len( label_lines ) == 2, "label_lines must be 2 strings" );

    cone_top_r = cone_config[ 0 ];
    cone_bottom_r = cone_config[ 1 ];
    cone_z = cone_config[ 2 ];

    difference()
    {
        union()
        {
            // top outer cube
            cube([
                bottle_holder_support_structure_insert_x,
                bottle_holder_support_structure_insert_y,
                bottle_holder_support_structure_grid_z
                ]);

            // bottom inner cube
            translate([
                bottle_holder_support_structure_grid_xy + bottle_holder_support_structure_insert_bottom_clearance_xy,
                bottle_holder_support_structure_grid_xy + bottle_holder_support_structure_insert_bottom_clearance_xy,
                -bottle_holder_support_structure_grid_z
                ])
                cube([
                    bottle_holder_support_structure_grid_x - bottle_holder_support_structure_grid_xy * 2 - bottle_holder_support_structure_insert_bottom_clearance_xy * 2,
                    bottle_holder_support_structure_grid_y - bottle_holder_support_structure_grid_xy * 2 - bottle_holder_support_structure_insert_bottom_clearance_xy * 2,
                    bottle_holder_support_structure_grid_z
                    ]);

            // lower support cone
            translate([
                bottle_holder_support_structure_insert_x / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
                bottle_holder_support_structure_insert_y / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
                -cone_z - bottle_holder_support_structure_grid_z
                ])
                cylinder(
                    r1 = cone_bottom_r,
                    r2 = cone_top_r,
                    h = cone_z
                    );
        }

        // cut out the bottle shape
        translate([
            bottle_holder_support_structure_insert_x / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
            bottle_holder_support_structure_insert_y / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
            -bottle_holder_support_structure_z + pvc_r + bottle_manifold_spacing_z
            ])
            scale([
                bottle_holder_support_structure_insert_cutout_scale_factor,
                bottle_holder_support_structure_insert_cutout_scale_factor,
                1.0
                ])
                BottlePreview( measurements, false );

        // cut out the min throat to make sure the swing caps can fit through
        translate([
            bottle_holder_support_structure_insert_x / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
            bottle_holder_support_structure_insert_y / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
            -cone_z - bottle_holder_support_structure_grid_z - DIFFERENCE_CLEARANCE
            ])
            cylinder(
                r = bottle_holder_support_structure_insert_min_throat_r,
                h = cone_z + bottle_holder_support_structure_grid_z * 2 + DIFFERENCE_CLEARANCE * 2
                );

        // left label
        translate([
            bottle_holder_support_structure_insert_label_offset_x,
            bottle_holder_support_structure_insert_label_offset_y,
            bottle_holder_support_structure_grid_z - bottle_holder_support_structure_insert_label_depth,
            ])
            TextLabel(
                label_lines[ 0 ],
                depth = bottle_holder_support_structure_insert_label_depth + DIFFERENCE_CLEARANCE,
                bottle_holder_support_structure_insert_label_font_size,
                bottle_holder_support_structure_insert_label_font,
                color = undef
                );

        // right label
        translate([
            bottle_holder_support_structure_insert_x - bottle_holder_support_structure_insert_label_offset_x,
            bottle_holder_support_structure_insert_label_offset_y,
            bottle_holder_support_structure_grid_z - bottle_holder_support_structure_insert_label_depth,
            ])
            TextLabel(
                label_lines[ 1 ],
                depth = bottle_holder_support_structure_insert_label_depth + DIFFERENCE_CLEARANCE,
                bottle_holder_support_structure_insert_label_font_size,
                bottle_holder_support_structure_insert_label_font,
                color = undef,
                halign = "right"
                );
    }

    if( show_preview )
        % translate([
            bottle_holder_support_structure_insert_x / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
            bottle_holder_support_structure_insert_y / 2 + bottle_holder_support_structure_insert_top_clearance_xy,
            -bottle_holder_support_structure_z + pvc_r + bottle_manifold_spacing_z
            ])
            BottlePreview( measurements, false );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BottleHolderSupportStructureInsertText( label_lines )
{
    // left label
    translate([
        bottle_holder_support_structure_insert_label_offset_x,
        bottle_holder_support_structure_insert_label_offset_y,
        bottle_holder_support_structure_grid_z - bottle_holder_support_structure_insert_label_depth,
        ])
        TextLabel(
            label_lines[ 0 ],
            depth = bottle_holder_support_structure_insert_label_depth + DIFFERENCE_CLEARANCE,
            bottle_holder_support_structure_insert_label_font_size,
            bottle_holder_support_structure_insert_label_font,
            color = undef
            );

    // right label
    translate([
        bottle_holder_support_structure_insert_x - bottle_holder_support_structure_insert_label_offset_x,
        bottle_holder_support_structure_insert_label_offset_y,
        bottle_holder_support_structure_grid_z - bottle_holder_support_structure_insert_label_depth,
        ])
        TextLabel(
            label_lines[ 1 ],
            depth = bottle_holder_support_structure_insert_label_depth + DIFFERENCE_CLEARANCE,
            bottle_holder_support_structure_insert_label_font_size,
            bottle_holder_support_structure_insert_label_font,
            color = undef,
            halign = "right"
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
