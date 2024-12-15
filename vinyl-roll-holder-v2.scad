include <../3rd-party/BOSL2/std.scad>
// use <../3rd-party/MCAD/regular_shapes.scad>

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

// render_mode = "render-face-0-for-printing";
// render_mode = "render-face-1-for-printing";
// render_mode = "render-face-2-for-printing";
// render_mode = "render-face-3-for-printing";

// render_mode = "render-base-0-for-printing";
// render_mode = "render-base-1-for-printing";

selected_roll_radius = small_roll_radius;

// number of rows
num_rows = 9;

// number of columns on even rows (i.e. the number of colums in the bottommost (i.e. 0) row)
num_cols_even = 3;

// extra clearance from the measured roll to the hexagon wall
roll_clearance = 5.0;

// the wall width in the x-direction (z-direction is slightly different due to geometry)
wall_width_single_x = 1.2;

// the y-width of the hexagons
roll_holder_y = 20.0;

// the y-width of the brim at the bottom of the holder face
face_brim_y = 15.0;

// the y-offset to the back face
back_face_offset_y = 200;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

// formulas: https://www.gigacalculator.com/calculators/hexagon-calculator.php

selected_roll_radius_with_clearance = selected_roll_radius + roll_clearance;

// this is a different size because as the hexagon goes around
wall_width_single_z = wall_width_single_x * sqrt( 3 ) / 2;

// selected_roll_radius
hex_r = selected_roll_radius_with_clearance;
hex_R = hex_r * 2 / sqrt( 3 );
// hex_a = hex_R;

hex_size_outer_x = hex_R * 2 + wall_width_single_x * 2;
hex_size_outer_y = roll_holder_y;
hex_size_outer_z = hex_r * 2 + wall_width_single_z * 2;

// calculate the total width of the hexagons
// total_hex_x = hex_R * ( 3 * ( num_cols_even - 1 ) + 2 ) + wall_width_single_x * ( 2 * ( num_cols_even - 1 ) + 2 );
total_hex_x = hex_size_outer_x * num_cols_even + ( num_cols_even - 1 ) * hex_size_outer_x / 2;

// calulate the total height of the hexagons
total_hex_z = ceil( num_rows / 2 ) * hex_r * 2 + ceil( num_rows / 2 + 1 ) * wall_width_single_z;

// center the hexagons in the face
center_in_cube_offset_x = ( cube_x - total_hex_x ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function CalculateHexagonXOffset( row, col ) =
    row % 2 == 0
        ? center_in_cube_offset_x + hex_size_outer_x * ( 1 + col * 3 ) / 2
        : center_in_cube_offset_x + hex_size_outer_x * ( 5 + col * 6 ) / 4;

function CalculateHexagonZOffset( row ) =
    row % 2 == 0
        ? hex_size_outer_z * ( 1 + row ) / 2
        : hex_size_outer_z * ( 1 + row ) / 2;

function GetHexGroup( row, col ) =
    row < 5
        ? ( ( ( row % 2 == 0 && col < 2 ) || ( row % 2 == 1 && col == 0 ) ) ? 0 : 1 )
        : ( ( ( row % 2 == 0 && col < 2 ) || ( row % 2 == 1 && col == 0 ) ) ? 2 : 3 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "debug-preview" )
{
    translate([ CalculateHexagonXOffset( 0, 0 ), cube_y - roll_length, CalculateHexagonZOffset( 0 ) ])
        RollPreview();

    // front face

    translate([ 0, 0, 0 ])
        _HolderBase();

    translate([ 0, face_brim_y, 0 ])
        _HolderFace( colorize = true );

    // back base

    translate([ 0, back_face_offset_y, 0 ])
        _HolderBase();

    translate([ 0, back_face_offset_y + face_brim_y, 0 ])
        _HolderFace( colorize = true );

    CubePreview();

    translate([ 350, 0, 0 ])
    {
        // preview how a faces will will print

        // full face for reference
        translate([ 0, 0, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    _HolderFace();
        }

        // id=0
        translate([ 0, 350, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    _HolderFace( only_hex_group = 0 );
        }

        // id=1
        translate([ 0, 700, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    _HolderFace( only_hex_group = 1 );
        }

        // id=2
        translate([ 0, 1050, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    _HolderFace( only_hex_group = 2 );
        }

        // id=3
        translate([ 0, 1400, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    _HolderFace( only_hex_group = 3 );
        }
    }
    

    // preview how a base will print
    translate([ 700, 0, 0 ])
    {
        BuildPlatePreview();

        _HolderBase();
    }
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

module _HolderFace( only_hex_group = -1, colorize = false )
{
    for( row = [ 0 : num_rows - 1 ] )
    {
        for( col = [ 0 : num_cols_even - 1 ] )
        {
            if( row <= num_rows - 1 && ( ( row % 2 == 0 && col <= num_cols_even - 1 ) || ( row % 2 == 1 && col <= num_cols_even - 2 ) ) )
            {
                if( only_hex_group == -1 || only_hex_group == GetHexGroup( row, col ) )
                {
                    if( colorize )
                    {
                        SelectColorInPreview( row, col )
                            _PlaceHexagon( row, col );
                    }
                    else
                    {
                        _PlaceHexagon( row, col );
                    }
                }
            }            
        }
    }

    // left side
    translate([ 0, 0, 0 ])
        cube([ wall_width_single_x, roll_holder_y, total_hex_z ]);

    // right side
    translate([ cube_x - wall_width_single_x, 0, 0 ])
        cube([ wall_width_single_x, roll_holder_y, total_hex_z ]);

    // side supports
    for( row = [ 0 : 2 : num_rows ] )
    {
        // left support
        translate([ 0, 0, CalculateHexagonZOffset( row ) - wall_width_single_z / 2 ])
            cube([ center_in_cube_offset_x + wall_width_single_x, roll_holder_y, wall_width_single_z ]);

        // right support
        translate([ cube_x - center_in_cube_offset_x - wall_width_single_x, 0, CalculateHexagonZOffset( row ) - wall_width_single_z / 2 ])
            cube([ center_in_cube_offset_x + wall_width_single_x, roll_holder_y, wall_width_single_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderBase()
{
    // front brim
    translate([ 0, 0, 0 ])
        cube([ cube_x, face_brim_y, wall_width_single_z ]);

    // back brim
    translate([ 0, face_brim_y + roll_holder_y, 0 ])
        cube([ cube_x, face_brim_y, wall_width_single_z ]);

    render()
    {
        difference()
        {
            // first draw a block we will cut out of
            translate([ wall_width_single_x, face_brim_y, 0 ])
                cube([ cube_x - wall_width_single_x * 2, roll_holder_y, hex_size_outer_z / 2 ]);

            // now cut out all the hexagons
            for( col = [ 0 : num_cols_even - 1 ] )
            {
                translate([ 0, face_brim_y, 0 ])
                    _PlaceHexagon( 0, col, true );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _PlaceHexagon( row, col, draw_filled_hexagon = false )
{
    translate([ CalculateHexagonXOffset( row, col ), 0, CalculateHexagonZOffset( row )])
        _RollHexHolderHexagon( draw_filled_hexagon );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _RollHexHolderHexagon( draw_filled_hexagon = false )
{
    rotate([ -90, 0, 0 ])
    {
        render()
        {
            difference()
            {
                // outer
                regular_prism( n = 6, height = roll_holder_y, r = hex_R + wall_width_single_x, anchor = BOTTOM );

                // inner
                if( !draw_filled_hexagon )
                    regular_prism( n = 6, height = roll_holder_y, r = hex_R, anchor = BOTTOM );
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

module SelectColorInPreview( row, col )
{
    group_id = GetHexGroup( row, col );

    if( group_id == 0 )
    {
        color([ 0.4, 0, 0 ])
            children();
    }
    else if( group_id == 1 )
    {
        color([ 0, 0.4, 0 ])
            children();
    }
    else if( group_id == 2 )
    {
        color([ 0, 0, 0.4 ])
            children();
    }
    else if( group_id == 3 )
    {
        color([ 0.4, 0, 0.4 ])
            children();
    }
    else
    {
        assert( false, "Unknown group id: " + group_id );
    }
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

    // (leave the front open)
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
