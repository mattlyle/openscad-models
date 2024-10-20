
use <../3rd-party/MCAD/regular_shapes.scad>

use <modules/triangular-prism.scad>
use <modules/trapezoidal-prism.scad>
include <modules/screw-connectors.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

roll_length = 305.0;

small_roll_radius = 46.0 / 2;

large_roll_radius = 76.5 / 2;

roll_clearance = 2.5;

cube_shelf_size = 281;

holder_ring_depth = 20;
holder_ring_thickness = 1.5;

holder_base_clearance = 0.2;
holder_base_side_width = 20;

holder_base_spacing_y = roll_length * 0.50;
holder_base_vertical_support_z = 5;

preview_thickness = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "render-holder";
// render_mode = "render-base";

num_rows = 7;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "full-preview" || render_mode == "simple-preview")
{
    // PrinterBuildPlatePreview();

    translate([ 0, holder_ring_depth, 0 ])
        rotate([ 90, 0, 0 ])
            VinylRollHolder( small_roll_radius, cube_shelf_size, num_rows );
}

if( render_mode == "render-holder" )
{
    VinylRollHolder( small_roll_radius, cube_shelf_size, num_rows );
}

if( render_mode == "full-preview" || render_mode == "simple-preview" || render_mode == "render-base" )
{
    VinylRollHolderBase( small_roll_radius, cube_shelf_size, holder_base_spacing_y );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// formulas: https://www.gigacalculator.com/calculators/hexagon-calculator.php

// calculates the hexagon 'a'
function CalculateHexagonSideLength( r ) = r * 2 / sqrt( 3 );

// calculates the hexagon 'R'
function CalculateFaceSideLength( roll_radius ) = CalculateHexagonSideLength( roll_radius + roll_clearance + holder_ring_thickness );

// calculates the combined 'r'
function CalculateCombinedRadius( roll_radius ) = roll_radius + roll_clearance + holder_ring_thickness;

// calculates the x-offset for the row starting on row_num
function CalculateXOffset( roll_radius, is_even_row, i ) = CalculateFaceSideLength( roll_radius ) + 3 * CalculateFaceSideLength( roll_radius ) * i + ( is_even_row
    ? 0
    : CalculateFaceSideLength( small_roll_radius ) + CalculateFaceSideLength( small_roll_radius ) * cos( 60 ) );

// calculates the y-offset for the row at row_num
function CalculateYOffset( roll_radius, row_num ) = CalculateCombinedRadius( roll_radius ) + row_num * CalculateCombinedRadius( roll_radius );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VinylRollHolder( roll_radius, max_width, num_rows )
{
    assert( num_rows % 2 == 1, "Must be an odd number!" );

    outer_hexagon_side_length = CalculateFaceSideLength( roll_radius );

    max_rolls_even = floor( max_width / outer_hexagon_side_length / 3 );
    max_rolls_odd = floor( ( max_width - CalculateXOffset( roll_radius, 1, 0 ) ) / outer_hexagon_side_length / 3 );

    for( i = [ 0 : num_rows - 1 ] )
    {
        translate([ 0, CalculateYOffset( roll_radius, i ), 0 ])
            _VinylRollHolderRow(
                roll_radius = roll_radius,
                num_hexagons = i % 2 == 0 ? max_rolls_even : max_rolls_odd,
                is_even_row = i % 2 == 0,
                i == 0,
                i == num_rows - 1 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VinylRollHolderBase( roll_radius, max_width, y_offset )
{
    outer_hexagon_side_length = CalculateFaceSideLength( roll_radius );
    max_rolls_even = floor( max_width / outer_hexagon_side_length / 3 );
    max_rolls_odd = floor( ( max_width - CalculateXOffset( roll_radius, 1, 0 ) ) / outer_hexagon_side_length / 3 );

    base_x = max_rolls_even * CalculateFaceSideLength( roll_radius ) * 2 + max_rolls_odd * CalculateFaceSideLength( roll_radius );

    // front
    _VinylRollHolderBase( roll_radius, max_width );

    // rear
    translate([ 0, y_offset, 0 ])
        _VinylRollHolderBase( roll_radius, max_width );

    // left horizontal connector
    translate([ 0, holder_ring_depth + holder_base_clearance + holder_base_side_width, 0 ])
      cube([ holder_base_side_width, y_offset - holder_base_side_width * 2 - holder_base_clearance * 2 - holder_ring_depth, holder_ring_thickness ]);

    // center horizontal connector
    translate([ (base_x - holder_base_side_width ) / 2, holder_ring_depth + holder_base_clearance + holder_base_side_width, 0 ])
      cube([ holder_base_side_width, y_offset - holder_base_side_width * 2 - holder_base_clearance * 2 - holder_ring_depth, holder_ring_thickness ]);

    // right horizontal connector
    translate([ base_x - holder_base_side_width, holder_ring_depth + holder_base_clearance + holder_base_side_width, 0 ])
      cube([ holder_base_side_width, y_offset - holder_base_side_width * 2 - holder_base_clearance * 2 - holder_ring_depth, holder_ring_thickness ]);

    // left vertical support
    translate([ 0, -holder_base_side_width - holder_base_clearance, holder_ring_thickness ])
        cube([ holder_ring_thickness, holder_base_side_width * 2 + holder_base_clearance * 2 + holder_ring_depth + y_offset, holder_base_vertical_support_z ]);

    // right vertical support
    translate([ base_x - holder_ring_thickness, -holder_base_side_width - holder_base_clearance, holder_ring_thickness ])
        cube([ holder_ring_thickness, holder_base_side_width * 2 + holder_base_clearance * 2 + holder_ring_depth + y_offset, holder_base_vertical_support_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderBase( roll_radius, max_width, insert_on_front )
{
    outer_hexagon_side_length = CalculateFaceSideLength( roll_radius );
    max_rolls_even = floor( max_width / outer_hexagon_side_length / 3 );
    max_rolls_odd = floor( ( max_width - CalculateXOffset( roll_radius, 1, 0 ) ) / outer_hexagon_side_length / 3 );

    base_x = max_rolls_even * CalculateFaceSideLength( roll_radius ) * 2 + max_rolls_odd * CalculateFaceSideLength( roll_radius );

    // flat edge - front
    translate([ 0, -holder_ring_depth - holder_base_clearance, 0 ])
        cube([ base_x, holder_base_side_width, holder_ring_thickness ]);

    // flat edge - back
    translate([ 0, holder_ring_depth + holder_base_clearance , 0 ])
        cube([ base_x, holder_base_side_width, holder_ring_thickness ]);

    end_cap_x = CalculateFaceSideLength( small_roll_radius ) * cos( 60 );
    end_cap_y = CalculateCombinedRadius( roll_radius );
    
    // before first hexagon
    translate([ 0, holder_base_side_width + holder_base_clearance, 0 ])
        rotate([ 0, 0, -90 ])
            TriangularPrism( holder_base_side_width + holder_base_clearance * 2, end_cap_x, end_cap_y );

    // after last hexagon
    translate([ base_x, -holder_base_clearance, 0 ])
        rotate([ 0, 0, 90 ])
            TriangularPrism( holder_base_side_width + holder_base_clearance * 2, end_cap_x, end_cap_y );

    r = CalculateHexagonSideLength( roll_radius );
    R = CalculateFaceSideLength( roll_radius );

    // in between middle hexagons
    for( i = [ 0 : max_rolls_odd - 1 ] )
    {
        translate([ CalculateXOffset( roll_radius, true, i ) + R / 2 + holder_base_clearance, -holder_base_clearance, 0 ])
        {
            render()
            {
                difference()
                {
                    TrapezoidalPrism(
                        x_top = R - holder_base_clearance * 2,
                        x_bottom = R * 2 - holder_base_clearance * 2,
                        y = holder_ring_depth + holder_base_clearance - holder_ring_thickness,
                        z = r - holder_base_clearance,
                        center = false );

                    translate([ R, holder_ring_depth - holder_ring_thickness + holder_base_clearance, r / 2 ])
                        rotate([ 90, 0, 0 ])
                            HeatedInsert( M3x6_INSERT );
                }
            }
        }

        // smaller through supports
        // translate([ CalculateXOffset( roll_radius, true, i ) + R / 2 + holder_base_clearance + (R * 2 - holder_base_clearance * 2 - holder_ring_thickness)/2, -holder_base_clearance - holder_base_side_width, holder_ring_thickness ])
        //     cube([ holder_base_vertical_support_z, holder_base_side_width * 2 + holder_ring_depth + holder_base_clearance * 2, holder_base_vertical_support_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderRow( roll_radius, num_hexagons, is_even_row, add_screw_supports_bottom, add_screw_supports_top )
{
    outer_hexagon_side_length = CalculateFaceSideLength( roll_radius );

    R = CalculateFaceSideLength( roll_radius );
    r = CalculateCombinedRadius( roll_radius );
    a = CalculateHexagonSideLength( roll_radius );

    for( i = [ 0 : num_hexagons - 1 ] )
    {
        translate([ CalculateXOffset( roll_radius, is_even_row, i ), 0, 0 ])
            _VinylRollHolderHexagon( roll_radius );

        if( add_screw_supports_bottom && i > 0 )
        {
            translate([ CalculateXOffset( roll_radius, true, i - 1 ) + R / 2, -r, holder_ring_thickness ])
                rotate([ -90, 0, 0 ])
                    _VinylRollHolderRowScrewSupport( roll_radius );
        }

        if( add_screw_supports_top && i > 0 )
        {
            translate([ CalculateXOffset( roll_radius, true, i - 1 ) + R / 2, r, 0 ])
                rotate([ 90, 0, 0 ])
                    _VinylRollHolderRowScrewSupport( roll_radius );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderRowScrewSupport( roll_radius )
{
    R = CalculateFaceSideLength( roll_radius );
    r = CalculateCombinedRadius( roll_radius );
    a = CalculateHexagonSideLength( roll_radius );

    render()
    {
        difference()
        {
            TrapezoidalPrism(
                x_top = R,
                x_bottom = R * 2,
                y = holder_ring_thickness,
                z = r,
                center = false );

            translate([ R, holder_ring_thickness + 2, r / 2 ]) // TODO: fix... 2???
                rotate([ 90, 0, 0 ])
                    ScrewShaft( M3x8 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderHexagon( roll_radius )
{
    outer_radius = CalculateFaceSideLength( roll_radius );
    inner_radius = CalculateHexagonSideLength( roll_radius + roll_clearance );

    if( render_mode == "full-preview" )
    {
        % translate([ 0, 0, -roll_length + holder_base_side_width + holder_ring_depth ])
            cylinder( h = roll_length, r = small_roll_radius, $fn = 48 );
    }

    render()
    {
        difference()
        {
            // outer
            hexagon_prism( radius = outer_radius, height = holder_ring_depth );

            // inner
            hexagon_prism( radius = inner_radius, height = holder_ring_depth );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
module CubeShelfPreview( cube_size )
{
    // bottom
    % translate([ 0, 0, -preview_thickness ])
        cube([ cube_size, cube_size, preview_thickness ]);

    // right
    % translate([ cube_size, 0, 0 ])
        cube([ preview_thickness, cube_size, cube_size ]);

    // top
    % translate([ 0, 0, cube_size ])
        cube([ cube_size, cube_size, preview_thickness ]);

    // left
    % translate([ -preview_thickness, 0, 0 ])
        cube([ preview_thickness, cube_size, cube_size ]);
}
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
module PrinterBuildVolumePreview()
{
    // bottom
    # translate([ 0, 0, -preview_thickness ])
        cube([ build_volume_size, build_volume_size, preview_thickness ]);

    // right
    # translate([ build_volume_size, 0, 0 ])
        cube([ preview_thickness, build_volume_size, build_volume_size ]);

    // top
    # translate([ 0, 0, build_volume_size ])
        cube([ build_volume_size, build_volume_size, preview_thickness ]);

    // left
    # translate([ -preview_thickness, 0, 0 ])
        cube([ preview_thickness, build_volume_size, build_volume_size ]);
}
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
module PrinterBuildPlatePreview()
{
    # translate([ 0, 0, -preview_thickness ])
        cube([ build_volume_size, build_volume_size, preview_thickness ]);
}
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VinylRollPreview( r )
{
    % rotate([ -90, 0, 0 ])
        cylinder( h = roll_length, r = r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////