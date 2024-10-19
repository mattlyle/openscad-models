
use <../3rd-party/MCAD/regular_shapes.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

roll_length = 305.0;

small_roll_radius = 46.0 / 2;

large_roll_radius = 76.5 / 2;

roll_clearance = 2.5;
// roll_clearance=0;

cube_shelf_size = 281;

holder_ring_depth = 10;
holder_ring_thickness = 1.5;
// holder_ring_thickness = 0.1;

holder_back_ring_offset = roll_length * 2/3;

build_volume_size = 255;

preview_thickness = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
render_mode = "render";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

// if( render_mode == "preview" )
// {
//     CubeShelfPreview( cube_shelf_size );

//     PrinterBuildVolumePreview();
// }

// % cylinder(h = preview_thickness, r = small_roll_radius, $fn = 100);
// _VinylRollHolderHexagon( small_roll_radius );

if( render_mode == "preview" )
{
    PrinterBuildPlatePreview();
}

// row 0
// offset_y0 = CalculateYOffset(small_roll_radius,0);
// translate([0, offset_y0, 0]) 
//     _VinylRollHolderRow(small_roll_radius, 3, false);

// row 1
// a = CalculateCombinedRadius(small_roll_radius);
// R = CalculateFaceSideLength(small_roll_radius);
// offset_x = CalculateXOffset(small_roll_radius);
// offset_y1 = CalculateYOffset(small_roll_radius,1);
// translate([ offset_x, offset_y1, 0 ])
//     _VinylRollHolderRow(small_roll_radius, 3, false);

// row 2
// offset_y2 = CalculateYOffset(small_roll_radius,2);
// translate([ 0, offset_y2, 0 ])
//     _VinylRollHolderRow(small_roll_radius, 3, false);

VinylRollHolderFace( small_roll_radius, cube_shelf_size, 2 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// formulas: https://www.gigacalculator.com/calculators/hexagon-calculator.php

// r = roll radius

// calculates the hexagon 'a'
function CalculateHexagonSideLength( r ) = r * 2 / sqrt( 3 );

function CalculateFaceSideLength( roll_radius ) = CalculateHexagonSideLength( roll_radius + roll_clearance + holder_ring_thickness );

function CalculateCombinedRadius( roll_radius ) = roll_radius + roll_clearance + holder_ring_thickness;

function CalculateXOffset( roll_radius, row_num ) = row_num % 2 == 0 ? 0 : CalculateFaceSideLength( small_roll_radius ) + CalculateFaceSideLength( small_roll_radius ) * cos( 60 );
function CalculateYOffset( roll_radius, row_num ) = CalculateCombinedRadius( roll_radius ) + row_num * CalculateCombinedRadius( roll_radius );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VinylRollHolderFace( roll_radius, max_width, num_rows )
{
    outer_hexagon_side_length = CalculateFaceSideLength( roll_radius );

    max_rolls_even = floor( max_width / outer_hexagon_side_length / 3 );
    max_rolls_odd = floor( ( max_width - CalculateXOffset( roll_radius, 1 ) ) / outer_hexagon_side_length / 3 );

    for( i = [ 0: num_rows - 1 ] )
    {
        translate([ CalculateXOffset( roll_radius, i ), CalculateYOffset( roll_radius, i ), 0 ])
            _VinylRollHolderRow(
                roll_radius = roll_radius,
                num_rolls = i % 2 == 0 ? max_rolls_even : max_rolls_odd,
                is_even_row = i % 2 == 0 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderRow( roll_radius, num_rolls, is_even_row )
{
    x_offset = is_even_row ? 0 : 0; // TODO: finish!

    outer_hexagon_side_length = CalculateFaceSideLength( roll_radius );

    for( i = [ 0 : num_rolls - 1 ] )
    {
        translate([ x_offset + outer_hexagon_side_length + 3 * outer_hexagon_side_length * i, 0, 0 ])
            _VinylRollHolderHexagon( roll_radius );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// module _VinylRollHolder( roll_radius )
// {
//     // near holder
//     rotate([ -90, 0, 0 ])
//         _VinylRollHolderHexagon();

//     // far holder
//     translate([ 0, holder_back_ring_offset, 0 ])
//         rotate([ -90, 0, 0 ])
//             _VinylRollHolderHexagon();
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderHexagon( roll_radius )
{
    outer_radius = CalculateFaceSideLength( roll_radius );
    inner_radius = CalculateHexagonSideLength( roll_radius + roll_clearance );

    if( render_mode == "preview" )
    {
        % cylinder(h = preview_thickness, r = small_roll_radius, $fn = 100);
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PrinterBuildPlatePreview()
{
    # translate([ 0, 0, -preview_thickness ])
        cube([ build_volume_size, build_volume_size, preview_thickness ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VinylRollPreview( r )
{
    % rotate([ -90, 0, 0 ])
        cylinder( h = roll_length, r = r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
