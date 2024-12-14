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
// render_mode = "render-face-for-printing";
// render_mode = "render-base-for-printing";

selected_roll_radius = small_roll_radius;

// number of rows
num_rows = 9;

// number of columns on even rows (i.e. the number of colums in the bottommost (i.e. 0) row)
num_cols_even = 3;

// extra clearance from the measured roll to the hexagon wall
roll_clearance = 5.0;

// the wall width in the x-direction (z-direction is slightly different due to geometry)
wall_width_x = 2.0;

// the y-width of the hexagons
roll_holder_y = 20.0;

// the y-width of the brim at the bottom of the holder face
face_brim_y = 15.0;

// the y-offset to the back face
back_face_offset_y = 200;

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

// this is a different size because as the hexagon goes around
wall_width_z = wall_width_x * sqrt( 3 ) / 2;

// selected_roll_radius
hex_r = selected_roll_radius_with_clearance;
hex_R = hex_r * 2 / sqrt( 3 );
// hex_a = hex_R;

// calculate the total width of the hexagons
total_hex_x = hex_R * ( 3 * ( num_cols_even - 1 ) + 2 ) + wall_width_x * ( 2 * ( num_cols_even - 1 ) + 2 );

// calulate the total height of the hexagons
total_hex_z = ceil( num_rows / 2 ) * hex_r * 2 + ceil( num_rows / 2 + 1 ) * wall_width_z;

// center the hexagons in the face
x_offset = ( cube_x - total_hex_x ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "debug-preview" )
{
    translate([ x_offset + hex_R + wall_width_x, cube_y - roll_length, hex_r + wall_width_z ])
        RollPreview();

    // front

    translate([ 0, 0, 0 ])
        _HolderBase();

    translate([ 0, face_brim_y, 0 ])
        _HolderFace();

    // back

    translate([ 0, back_face_offset_y, 0 ])
        _HolderBase();

    translate([ 0, back_face_offset_y + face_brim_y, 0 ])
        _HolderFace();

    // BuildPlatePreview();

    CubePreview();

    // preview how a face will will print
    translate([ 350, 0, roll_holder_y ])
        rotate([ -90, 0, 0 ])
            _HolderFace();

    // preview how a base will print
    translate([ 700, 0, 0 ])
        _HolderBase();
}
else if( render_mode == "render-face-for-printing" )
{
    translate([ 0, 0, roll_holder_y ])
        rotate([ -90, 0, 0 ])
            _HolderFace();
}
else if( render_mode == "render-base-for-printing" )
{
    _HolderBase();
}
else
{
    echo( "Unknown render mode: ", render_mode );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderFace()
{
    translate([ hex_R + wall_width_x, 0, hex_r + wall_width_z ])
    {
        for( row = [ 0 : num_rows - 1 ] )
        {
            for( col = [ 0 : num_cols_even - 1 ] )
            {
                if( row <= num_rows - 1 && ( ( row % 2 == 0 && col <= num_cols_even - 1 ) || ( row % 2 == 1 && col <= num_cols_even - 2 ) ) )
                {
                    translate([ CalculateXOffset( row, col ), 0, CalculateZOffset( row, col ) ])
                        _RollHexHolderHexagon();
                }            
            }
        }
    }

    // left side
    cube([ wall_width_x, roll_holder_y, total_hex_z ]);

    // right side
    translate([ cube_x - wall_width_x, 0, 0 ])
        cube([ wall_width_x, roll_holder_y, total_hex_z ]);

    // side supports
    for( row = [ 1 : 2 : num_rows ] )
    {
        // left support
        translate([ 0, 0, CalculateZOffset( row, 0 ) ])
            cube([ x_offset + wall_width_x, roll_holder_y, wall_width_z ]);

        // right support
        translate([ cube_x - x_offset - wall_width_x, 0, CalculateZOffset( row, 0 ) ])
            cube([ x_offset + wall_width_x, roll_holder_y, wall_width_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderBase()
{
    // front brim
    translate([ 0, 0, 0 ])
        cube([ cube_x, face_brim_y, wall_width_z ]);

    // back brim
    translate([ 0, face_brim_y + roll_holder_y, 0 ])
        cube([ cube_x, face_brim_y, wall_width_z ]);

    render()
    {
        difference()
        {
            translate([ wall_width_x, face_brim_y, 0 ])
                cube([ cube_x - wall_width_x * 2, roll_holder_y, hex_R - wall_width_z * 2 ]);

            translate([ hex_R + wall_width_x, 0, hex_r + wall_width_z ])
            {
                for( col = [ 0 : num_cols_even - 1 ] )
                {
                    translate([ CalculateXOffset( 0, col ), face_brim_y, CalculateZOffset( 0, col ) ])
                        rotate([ -90, 0, 0 ])
                            hexagon_prism( radius = hex_R + wall_width_x, height = roll_holder_y );
                }
            }
        }
    }
}

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
                hexagon_prism( radius = hex_R + wall_width_x, height = roll_holder_y );

                // inner
                hexagon_prism( radius = hex_R, height = roll_holder_y );
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
