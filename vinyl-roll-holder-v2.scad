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

wall_width_x = 2.0;

roll_holder_size = 20.0;

num_rows = 8;
num_cols_even = 2; // i.e. the number of colums in the bottommost (i.e. 0) row

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function CalculateXOffset( row, col ) =
    row % 2 == 0
        ? x_offset + hex_R * ( 3 * col ) + wall_width_x * ( 2 * col )
        : x_offset + hex_R * ( 3 * col + 1 ) + hex_R / 2 + wall_width_x * ( 2 * col + 1 );

function CalculateZOffset( row, col ) =
    row % 2 == 0
        ? hex_r * row + wall_width_z / 2 * row
        : hex_r * row + wall_width_z / 2 * row;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

// formulas: https://www.gigacalculator.com/calculators/hexagon-calculator.php

selected_roll_radius_with_clearance = selected_roll_radius + roll_clearance;

// selected_roll_radius
hex_r = selected_roll_radius_with_clearance;
hex_R = hex_r * 2 / sqrt( 3 );
// hex_a = hex_R;

// calculate the total width of the hexagons so we can center it in the cube
total_hex_x = hex_R * ( 3 * num_cols_even + 2 ) + wall_width_x * ( 2 * num_cols_even + 2 );
x_offset = ( cube_x - total_hex_x ) / 2;

wall_width_z = wall_width_x * sqrt( 3 ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

translate([ hex_R + wall_width_x, 0, hex_r + wall_width_z ])
{
    translate([ x_offset, 0, 0 ])
        RollPreview();

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
                hexagon_prism( radius = hex_R + wall_width_x, height = roll_holder_size );

                // inner
                hexagon_prism( radius = hex_R, height = roll_holder_size );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RollPreview()
{
    % rotate([ -90, 0, 0 ])
        cylinder( h = roll_length, r = selected_roll_radius, $fn = 48 );
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
