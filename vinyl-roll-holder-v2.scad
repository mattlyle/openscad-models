use <../3rd-party/MCAD/regular_shapes.scad>

use <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

roll_length = 305;

small_roll_radius = 46.0 / 2;
large_roll_radius = 76.5 / 2;

cube_x = 286;
cube_y = 286;
cube_z = 295;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "debug-preview";

roll_clearance = 5.0;

selected_roll_radius = small_roll_radius;

wall_width = 2.0;

roll_holder_size = 20.0;

num_rows = 8;
num_cols_even = 2; // i.e. the number of colums in the bottommost (i.e. 0) row

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function CalculateXOffset( row, col ) =
    row % 2 == 0
        ? x_offset + hex_R * ( 3 * col ) + wall_width * ( 2 * col )
        : x_offset + hex_R * ( 3 * col + 1 ) + hex_R / 2 + wall_width * ( 2 * col + 1 );

function CalculateZOffset( row, col ) =
    row % 2 == 0
        ? hex_r * row + wall_width / 2 * row
        : hex_r * row + wall_width / 2 * row;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

// formulas: https://www.gigacalculator.com/calculators/hexagon-calculator.php

selected_roll_radius_with_clearance = selected_roll_radius + roll_clearance;

// selected_roll_radius
hex_r = selected_roll_radius_with_clearance;
hex_R = hex_r * 2 / sqrt( 3 );
// hex_a = hex_R;

// calculate the total width of the hexagons so we can center it in the cube
total_hex_x = hex_R * ( 3 * num_cols_even + 2 ) + wall_width * ( 2 * num_cols_even + 2 );
x_offset = ( cube_x - total_hex_x ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

translate([ hex_R + wall_width, 0, hex_r + wall_width ])
{
    RollPreview( selected_roll_radius );

    for( row = [ 0 : 9 ] )
    {
        for( col = [ 0 : 3 ] )
        {
            if( row <= num_rows && ( ( row % 2 == 0 && col <= num_cols_even ) || ( row % 2 == 1 && col <= num_cols_even - 1 ) ) )
            {
                translate([ CalculateXOffset( row, col ), 0, CalculateZOffset( row, col ) ])
                    _RollHexHolderHexagon();
            }            
        }
    }


/*
    // row 0

    translate([ CalculateXOffset( 0, 0 ), 0, CalculateZOffset( 0, 0 ) ])
        _RollHexHolderHexagon();

    // translate([ hex_R * 3 + wall_width * 2, 0, 0 ])
    translate([ CalculateXOffset( 0, 1 ), 0, CalculateZOffset( 0, 1 ) ])
        _RollHexHolderHexagon();

    // translate([ hex_R * 6 + wall_width * 4, 0, 0 ])
    translate([ CalculateXOffset( 0, 2 ), 0, CalculateZOffset( 0, 2 ) ])
        _RollHexHolderHexagon();

    // translate([ hex_R * 9 + wall_width * 6, 0, 0 ])
    translate([ CalculateXOffset( 0, 3 ), 0, CalculateZOffset( 0, 3 ) ])
        _RollHexHolderHexagon();

    // row 1

    // translate([ hex_R + hex_R / 2 + wall_width, 0, hex_r + wall_width / 2 ])
    translate([ CalculateXOffset( 1, 0 ), 0, CalculateZOffset( 1, 0 ) ])
        _RollHexHolderHexagon();

    // translate([ hex_R * 4 + hex_R / 2 + wall_width * 3, 0, hex_r + wall_width / 2 ])
    translate([ CalculateXOffset( 1, 1 ), 0, CalculateZOffset( 1, 1 ) ])
        _RollHexHolderHexagon();

    // translate([ hex_R * 7 + hex_R / 2 + wall_width * 5, 0, hex_r + wall_width / 2 ])
    translate([ CalculateXOffset( 1, 2 ), 0, CalculateZOffset( 1, 2 ) ])
        _RollHexHolderHexagon();

    // row 2
    translate([ CalculateXOffset( 2, 0 ), 0, CalculateZOffset( 2, 0 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 2, 1 ), 0, CalculateZOffset( 2, 1 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 2, 2 ), 0, CalculateZOffset( 2, 2 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 2, 3 ), 0, CalculateZOffset( 2, 3 ) ])
        _RollHexHolderHexagon();

    // row 3
    translate([ CalculateXOffset( 3, 0 ), 0, CalculateZOffset( 3, 0 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 3, 1 ), 0, CalculateZOffset( 3, 1 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 3, 2 ), 0, CalculateZOffset( 3, 2 ) ])
        _RollHexHolderHexagon();

    // row 4
    translate([ CalculateXOffset( 4, 0 ), 0, CalculateZOffset( 4, 0 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 4, 1 ), 0, CalculateZOffset( 4, 1 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 4, 2 ), 0, CalculateZOffset( 4, 2 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 4, 3 ), 0, CalculateZOffset( 4, 3 ) ])
        _RollHexHolderHexagon();

    // row 5
    translate([ CalculateXOffset( 5, 0 ), 0, CalculateZOffset( 5, 0 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 5, 1 ), 0, CalculateZOffset( 5, 1 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 5, 2 ), 0, CalculateZOffset( 5, 2 ) ])
        _RollHexHolderHexagon();

    // row 6
    translate([ CalculateXOffset( 6, 0 ), 0, CalculateZOffset( 6, 0 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 6, 1 ), 0, CalculateZOffset( 6, 1 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 6, 2 ), 0, CalculateZOffset( 6, 2 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 6, 3 ), 0, CalculateZOffset( 6, 3 ) ])
        _RollHexHolderHexagon();

    // row 7
    translate([ CalculateXOffset( 7, 0 ), 0, CalculateZOffset( 7, 0 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 7, 1 ), 0, CalculateZOffset( 7, 1 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 7, 2 ), 0, CalculateZOffset( 7, 2 ) ])
        _RollHexHolderHexagon();

    // row 8
    translate([ CalculateXOffset( 8, 0 ), 0, CalculateZOffset( 8, 0 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 8, 1 ), 0, CalculateZOffset( 8, 1 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 8, 2 ), 0, CalculateZOffset( 8, 2 ) ])
        _RollHexHolderHexagon();
    translate([ CalculateXOffset( 8, 3 ), 0, CalculateZOffset( 8, 3 ) ])
        _RollHexHolderHexagon();
*/
}

// BuildPlatePreview();

CubePreview();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _RollHexHolderHexagon()
{
    rotate([ -90, 0, 0 ])
    {
        render()
        {
            difference()
            {
                // outer
                hexagon_prism( radius = hex_R + wall_width, height = roll_holder_size );

                // inner
                hexagon_prism( radius = hex_R, height = roll_holder_size );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// module _RollOddRow( n )
// {
//     for( i : [ 0, n ])
//     {
//         echo( i );
//     }
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RollPreview( r_without_clearance )
{
    % rotate([ -90, 0, 0 ])
        cylinder( h = roll_length, r = r_without_clearance, $fn = 48 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CubePreview()
{
    preview_size = 0.01;

    // bottom
    % translate([ 0, 0, -preview_size ])
        cube([ cube_x, cube_y, preview_size ]);

    // top
    % translate([ 0, 0, cube_z + preview_size ])
        cube([ cube_x, cube_y, preview_size ]);

    // left
    % translate([ -preview_size, 0, 0 ])
        cube([ preview_size, cube_y, cube_z ]);

    // right
    % translate([ cube_x, 0, 0 ])
        cube([ preview_size, cube_y, cube_z ]);

    // back
    % translate([ 0, cube_y, 0 ])
        cube([ cube_x, preview_size, cube_z ]);

    // (skip front)
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
