// include <../3rd-party/BOSL2/std.scad>
use <../3rd-party/MCAD/regular_shapes.scad>

include <modules/utils.scad>
include <modules/screw-connectors.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO small lip overlaps where the hexs meet

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

// num struts should be cols+1 so the struts are hidden behind the filled support hexs
num_base_struts = num_cols_even + 1;

// extra clearance from the measured roll to the hexagon wall
roll_clearance = 5.0;

// the wall width in the x-direction (z-direction is slightly different due to geometry)
wall_width_single_x = 1.2;

wall_width_screw_face_wall = 2.0;

// the y-width of the hexagons
roll_holder_y = 20.0;

// the y-width of the brim at the bottom of the holder face
base_brim_y = 15.0;

// the y-offset to the back face
back_face_offset_y = 200;

base_strut_x = 10;
base_strut_z = 5;

// Hex Groups:
// 2 3
// 0 1
rows_in_lower_hex_groups = 5;
cols_in_left_hex_groups = 2;

// screw and heated insert definitions
screw_def = M3x8;
heated_insert_def = M3x6_INSERT;

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
total_hex_x = hex_size_outer_x * num_cols_even + ( num_cols_even - 1 ) * hex_size_outer_x / 2;

// calulate the total height of the hexagons
total_hex_z = hex_size_outer_z * ceil( num_rows / 2 );

// center the hexagons in the face
center_in_cube_offset_x = ( cube_x - total_hex_x ) / 2;

base_cut_brim_offset_x = CalculateHexagonXOffset( -1, cols_in_left_hex_groups - 1 )
    - base_strut_x ;
base_cut_hex_offset_x = CalculateHexagonXOffset( -1, cols_in_left_hex_groups - 1 )
    - hex_size_outer_x / 2;

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
    row < rows_in_lower_hex_groups
        ? ( ( ( row % 2 == 0 && col < cols_in_left_hex_groups ) || ( row % 2 == 1 && col < cols_in_left_hex_groups - 1 ) ) ? 0 : 1 )
        : ( ( ( row % 2 == 0 && col < cols_in_left_hex_groups ) || ( row % 2 == 1 && col < cols_in_left_hex_groups - 1 ) ) ? 2 : 3 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "debug-preview" )
{
    translate([ CalculateHexagonXOffset( 0, 0 ), cube_y - roll_length, CalculateHexagonZOffset( 0 ) ])
        RollPreview();

    // front face
    translate([ 0, base_brim_y, 0 ])
        HolderFace( colorize = true );

    // back face
    translate([ 0, back_face_offset_y + base_brim_y, 0 ])
        HolderFace( colorize = true );

    // base
    translate([ 0, 0, 0 ])
        HolderBase();

    // top
    translate([ cube_x, 0, total_hex_z ])
        rotate([ 0, 180, 0 ])
            HolderBase();

    // show a preview of the cube walls
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
                    HolderFace();
        }

        // id=0
        translate([ 0, 350, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    HolderFace( only_hex_group = 0 );
        }

        // id=1
        translate([ 0, 700, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    HolderFace( only_hex_group = 1 );
        }

        // id=2
        translate([ 0, 1050, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    HolderFace( only_hex_group = 2 );
        }

        // id=3
        translate([ 0, 1400, 0 ])
        {
            BuildPlatePreview();
            translate([ 0, 0, roll_holder_y ])
                rotate([ -90, 0, 0 ])
                    HolderFace( only_hex_group = 3 );
        }
    }

    // left side screw conection
    translate([ 0, 700, roll_holder_y ])
    {
        translate([ 0, 0, 0 ])
            rotate([ -90, 0, 0 ])
                HolderFace( only_hex_group = 0 );

        translate([ 0, 40, 0 ]) // TODO not sure where this approx 40 comes from... should be calculated with CalculateHexagonZOffset
            rotate([ -90, 0, 0 ])
                HolderFace( only_hex_group = 2 );
    }


    // preview how a base will print
    translate([ 700, 0, 0 ])
    {
        // full holder for reference
        translate([ 0, 0, 0 ])
        {
            BuildPlatePreview();
            HolderBase();
        }

        // id=0
        translate([ 0, 350, 0 ])
        {
            BuildPlatePreview();
            HolderBase( id = 0 );
        }

        // id=1
        translate([ 0, 700, 0 ])
        {
            BuildPlatePreview();
            HolderBase( id = 1 );
        }
    }
}
else if( render_mode == "render-face-0-for-printing" )
{
    translate([ 0, 0, roll_holder_y ])
        rotate([ -90, 0, 0 ])
            HolderFace( only_hex_group = 0 );
}
else if( render_mode == "render-face-1-for-printing" )
{
    translate([ 0, 0, roll_holder_y ])
        rotate([ -90, 0, 0 ])
            HolderFace( only_hex_group = 1 );
}
else if( render_mode == "render-face-2-for-printing" )
{
    translate([ 0, 0, roll_holder_y ])
        rotate([ -90, 0, 0 ])
            HolderFace( only_hex_group = 2 );
}
else if( render_mode == "render-face-3-for-printing" )
{
    translate([ 0, 0, roll_holder_y ])
        rotate([ -90, 0, 0 ])
            HolderFace( only_hex_group = 3 );
}
else if( render_mode == "render-base-0-for-printing" )
{
    HolderBase( 0 );
}
else if( render_mode == "render-base-1-for-printing" )
{
    HolderBase( 1 );
}
else
{
    echo( "Unknown render mode: ", render_mode );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HolderFace( only_hex_group = -1, colorize = false )
{
    hex_group_offset_x =
        only_hex_group == 1 || only_hex_group == 3
            ? -cube_x + BUILD_PLATE_X
            : 0;
    hex_group_offset_z =
        only_hex_group == 2 || only_hex_group == 3
            ? -cube_z + BUILD_PLATE_Z
            : 0;

    translate([ hex_group_offset_x, 0, hex_group_offset_z ])
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

        // when trimming the hex's, we need to expand the cube so there isn't a small gap
        hex_trim_overlap = 0.1;

        // left side wall - lower half
        if( only_hex_group == 0 || only_hex_group == -1 )
        {
            translate([ 0, 0, 0 ])
                cube([ wall_width_single_x, roll_holder_y, CalculateHexagonZOffset( rows_in_lower_hex_groups - 1 ) ]);

            // add the partial hexagons that connect to the wall
            for( row = [ 1 : 2 : rows_in_lower_hex_groups - 1 ] )
            {
                render()
                {
                    difference()
                    {
                        _PlaceHexagon( row, -1 );

                        // trim off the side
                        translate([ -hex_size_outer_x, 0, CalculateHexagonZOffset( row - 1 ) - hex_trim_overlap ])
                            cube([ hex_size_outer_x, roll_holder_y, hex_size_outer_z + hex_trim_overlap * 2 ]);

                        // remove the screw shaft
                        if( row == rows_in_lower_hex_groups - 2 )
                        {
                            translate([ CalculateSideWallHeadedInsertXOffset( true ), roll_holder_y / 2, CalculateHexagonZOffset( row + 1 ) - wall_width_single_z ])
                                ScrewShaft( screw_def );
                        }
                    }

                    if( row == rows_in_lower_hex_groups - 2 )
                    {
                        _HolderSideWallConnection( false, true );
                    }
                }
            }
        }

        // left side wall - upper half
        if( only_hex_group == 2 || only_hex_group == -1 )
        {
            upper_start = CalculateHexagonZOffset( rows_in_lower_hex_groups - 1 ) + wall_width_single_x / 2;

            translate([ 0, 0, upper_start ])
                cube([ wall_width_single_x, roll_holder_y, total_hex_z - upper_start ]);

            // add the partial hexagons that connect to the wall
            for( row = [ rows_in_lower_hex_groups : 2 : num_rows - 1 ] )
            {
                render()
                {
                    difference()
                    {
                        _PlaceHexagon( row, -1 );

                        // trim off the side
                        translate([ -hex_size_outer_x, 0, CalculateHexagonZOffset( row - 1 ) - hex_trim_overlap ])
                            cube([ hex_size_outer_x, roll_holder_y, hex_size_outer_z + hex_trim_overlap * 2 ]);

                        // cut out the heated insert
                        if( row == rows_in_lower_hex_groups )
                        {
                            translate([ CalculateSideWallHeadedInsertXOffset( true ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) ])
                                HeatedInsert( heated_insert_def );
                        }
                    }

                    if( row == rows_in_lower_hex_groups )
                    {
                        _HolderSideWallConnection( true, true );
                    }
                }
            }
        }

        // right side wall - lower half
        if( only_hex_group == 1 || only_hex_group == -1 )
        {
            translate([ cube_x - wall_width_single_x, 0, 0 ])
                cube([ wall_width_single_x, roll_holder_y, CalculateHexagonZOffset( rows_in_lower_hex_groups - 1 ) ]);

            // add the partial hexagons that connect to the wall
            for( row = [ 1 : 2 : rows_in_lower_hex_groups - 1 ] )
            {
                render()
                {
                    difference()
                    {
                        _PlaceHexagon( row, num_cols_even - 1 );

                        // trim off the side
                        translate([ cube_x, 0, CalculateHexagonZOffset( row - 1 ) - hex_trim_overlap ])
                            cube([ hex_size_outer_x, roll_holder_y, hex_size_outer_z + hex_trim_overlap * 2 ]);

                        // remove the screw shaft
                        if( row == rows_in_lower_hex_groups - 2 )
                        {
                            translate([ CalculateSideWallHeadedInsertXOffset( false ), roll_holder_y / 2, CalculateHexagonZOffset( row + 1 ) - wall_width_single_z ])
                                ScrewShaft( screw_def );
                        }
                    }

                    if( row == rows_in_lower_hex_groups - 2 )
                    {
                        _HolderSideWallConnection( false, false );
                    }
                }
            }
        }

        // right side wall - upper half
        if( only_hex_group == 3 || only_hex_group == -1 )
        {
            upper_start = CalculateHexagonZOffset( rows_in_lower_hex_groups - 1 ) + wall_width_single_x / 2;
            translate([ cube_x - wall_width_single_x, 0, upper_start ])
                cube([ wall_width_single_x, roll_holder_y, total_hex_z - upper_start ]);

            // add the partial hexagons that connect to the wall
            for( row = [ rows_in_lower_hex_groups : 2 : num_rows - 1 ] )
            {
                render()
                {
                    difference()
                    {
                        _PlaceHexagon( row, num_cols_even - 1 );

                        // trim off the side
                        translate([ cube_x, 0, CalculateHexagonZOffset( row - 1 ) - hex_trim_overlap ])
                            cube([ hex_size_outer_x, roll_holder_y, hex_size_outer_z + hex_trim_overlap * 2 ]);

                        // cut out the heated insert
                        if( row == rows_in_lower_hex_groups )
                        {
                            translate([ CalculateSideWallHeadedInsertXOffset( false ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) ])
                                HeatedInsert( heated_insert_def );
                        }
                    }

                    if( row == rows_in_lower_hex_groups )
                    {
                        _HolderSideWallConnection( true, false );
                    }
                }
            }

            // TODO add the screw connection
        }

        // hex faces on bottom
        for( col = [ 0 : cols_in_left_hex_groups - 1 ])
        {
            // lower left
            if( only_hex_group == -1 || ( only_hex_group == 0 && col < cols_in_left_hex_groups - 1 ) )
            {
                _HolderBaseFaceConnection( -1, col, true );
            }

            // lower right
            if( only_hex_group == -1 || ( only_hex_group == 1 && col >= cols_in_left_hex_groups - 1 ) )
            {
                _HolderBaseFaceConnection( -1, col, true );
            }

            // upper left
            if( only_hex_group == -1 || ( only_hex_group == 2 && col < cols_in_left_hex_groups - 1 ) )
            {
                _HolderBaseFaceConnection( num_rows, col, false );
            }

            // upper right
            if( only_hex_group == -1 || ( only_hex_group == 3 && col >= cols_in_left_hex_groups - 1 ) )
            {
                _HolderBaseFaceConnection( num_rows, col, false );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderBaseFaceConnection( row, col, draw_as_top )
{
    render()
    {
        difference()
        {
            _PlaceHexagon( row, col, true );

            // cut off the back
            translate([ 0, -wall_width_screw_face_wall, 0 ])
                _PlaceHexagon( row, col, true );

            if( draw_as_top )
            {
                // cut off the bottom
                translate([ CalculateHexagonXOffset( row, col ) - hex_size_outer_x / 2, 0, CalculateHexagonZOffset( row - 1 ) ])
                    cube([ hex_size_outer_x, hex_size_outer_y, hex_size_outer_z / 2 ]);

                // remove the screw hole
                translate([ CalculateHexagonXOffset( row, col ), hex_size_outer_y, hex_size_outer_z / 4 ])
                    rotate([ 90, 0, 0 ])
                        ScrewShaft( screw_def );
            }
            else
            {
                // cut off the top
                translate([ CalculateHexagonXOffset( row, col ) - hex_size_outer_x / 2, 0, CalculateHexagonZOffset( row ) ])
                    cube([ hex_size_outer_x, hex_size_outer_y, hex_size_outer_z / 2 ]);

                translate([ CalculateHexagonXOffset( row, col ), hex_size_outer_y, CalculateHexagonZOffset( row ) - hex_size_outer_z / 4 ])
                    rotate([ 90, 0, 0 ])
                        ScrewShaft( screw_def );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HolderBase( id = -1 )
{
    if( id == -1 )
    {
        _HolderBase();
    }
    else if( id == 0 )
    {
        render()
        {
            difference()
            {
                _HolderBase();

                // front brim
                translate([ base_cut_brim_offset_x, 0, 0 ])
                    cube([ cube_x - base_cut_brim_offset_x, base_brim_y, hex_size_outer_z / 2 ]);

                // center
                translate([ base_cut_brim_offset_x, base_brim_y + hex_size_outer_y, 0 ])
                    cube([ cube_x - base_cut_brim_offset_x, back_face_offset_y - hex_size_outer_y, hex_size_outer_z / 2 ]);

                // front brim
                translate([ base_cut_brim_offset_x, base_brim_y + back_face_offset_y + hex_size_outer_y, 0 ])
                    cube([ cube_x - base_cut_brim_offset_x, base_brim_y, hex_size_outer_z / 2 ]);

                // front base hex
                translate([ base_cut_hex_offset_x, base_brim_y, 0 ])
                    cube([ cube_x - base_cut_hex_offset_x, hex_size_outer_y, hex_size_outer_z / 2 ]);

                // back base hex
                translate([ base_cut_hex_offset_x, base_brim_y + back_face_offset_y, 0 ])
                    cube([ cube_x - base_cut_hex_offset_x, hex_size_outer_y, hex_size_outer_z / 2 ]);
            }
        }
    }
    else if( id == 1 )
    {
        // translate([ -cube_x + BUILD_PLATE_X, 0, 0])
        {
            render()
            {
                difference()
                {
                    _HolderBase();

                    // front brim
                    translate([ 0, 0, 0 ])
                        cube([ base_cut_brim_offset_x, base_brim_y, hex_size_outer_z / 2 ]);

                    // center
                    translate([ 0, base_brim_y + hex_size_outer_y, 0 ])
                        cube([ base_cut_brim_offset_x, back_face_offset_y - hex_size_outer_y, hex_size_outer_z / 2 ]);

                    // front brim
                    translate([ 0, base_brim_y + back_face_offset_y + hex_size_outer_y, 0 ])
                        cube([ base_cut_brim_offset_x, base_brim_y, hex_size_outer_z / 2 ]);

                    // front base hex
                    translate([ 0, base_brim_y, 0 ])
                        cube([ base_cut_hex_offset_x, hex_size_outer_y, hex_size_outer_z / 2 ]);

                    // back base hex
                    translate([ 0, base_brim_y + back_face_offset_y, 0 ])
                        cube([ base_cut_hex_offset_x, hex_size_outer_y, hex_size_outer_z / 2 ]);
                }
            }
        }
    }
    else
    {
        assert( false, "Unknown base id: " + id );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderBase()
{
    _HolderBaseSingle();

    translate([ 0, back_face_offset_y, 0 ])
        _HolderBaseSingle();

    for( i = [ 0 : num_base_struts - 1] )
    {
        translate([ ( cube_x - base_strut_x ) / ( num_base_struts - 1 ) * i, base_brim_y * 2 + hex_size_outer_y, 0 ])
            _HolderBaseStrut();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderBaseSingle()
{
    // front brim
    translate([ 0, 0, 0 ])
        cube([ cube_x, base_brim_y, wall_width_single_z ]);

    // back brim
    translate([ 0, base_brim_y + roll_holder_y, 0 ])
        cube([ cube_x, base_brim_y, wall_width_single_z ]);

    // front connector
    translate([ base_cut_brim_offset_x, base_brim_y + hex_size_outer_y, wall_width_single_z ])
        _HolderBaseLeftRightConnection();

    render()
    {
        difference()
        {
            // first draw a block we will cut out of
            translate([ wall_width_single_x, base_brim_y, 0 ])
                cube([ cube_x - wall_width_single_x * 2, roll_holder_y, hex_size_outer_z / 2 ]);

            // now cut out all the hexagons
            for( col = [ 0 : num_cols_even - 1 ] )
            {
                // cut out the hexagon the face will be in
                translate([ 0, base_brim_y, 0 ])
                    _PlaceHexagon( 0, col, true );

                // also cut out the fronts where the connector will be
                if( col < num_cols_even - 1 )
                {
                    translate([ CalculateHexagonXOffset( -1, col ) - hex_size_outer_x / 2, base_brim_y + hex_size_outer_y - wall_width_screw_face_wall, wall_width_single_z ])
                        cube([ hex_size_outer_x, wall_width_screw_face_wall, hex_size_outer_z]);

                    // cut out the screw hole
                    translate([ CalculateHexagonXOffset( -1, col ), base_brim_y + hex_size_outer_y, hex_size_outer_z / 4 ])
                        rotate([ 90, 0, 0 ])
                            HeatedInsert( heated_insert_def );
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderBaseStrut()
{
    // flat bottom
    cube([ base_strut_x, back_face_offset_y - base_brim_y * 2 - hex_size_outer_y, wall_width_single_z ]);

    // vertical strut
    translate([ base_strut_x / 2 - wall_width_single_x / 2, -base_brim_y, wall_width_single_z ])
        cube([ wall_width_single_x, back_face_offset_y - hex_size_outer_y, base_strut_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderBaseLeftRightConnection()
{
    connection_front_x = wall_width_screw_face_wall;
    connection_back_x = heated_insert_def[ INSERT_LENGTH ] * 2;

    connection_z = heated_insert_def[ INSERT_OUTER_DIAMETER ] * 2;

    // front (screw side)
    render()
    {
        difference()
        {
            // front wall
            translate([ -connection_front_x, 0, 0 ])
                cube([ connection_front_x, base_brim_y, connection_z ]);

            // remove the screw shaft
            translate([ -connection_front_x, base_brim_y / 2, connection_z / 2 ])
                rotate([ 0, 90, 0 ])
                    ScrewShaft( screw_def );
        }
    }

    // back (insert side)
    render()
    {
        difference()
        {
            // back block
            cube([ connection_back_x, base_brim_y, connection_z]);

            // remove the insert
            translate([ 0, base_brim_y / 2, connection_z / 2])
                rotate([ 0, 90, 0 ])
                    HeatedInsert( heated_insert_def );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateSideWallHeadedInsertXOffset( is_left ) =
    is_left
        ? wall_width_single_x * 1.5 + M3_WASHER[ WASHER_OUTER_DIAMETER ] / 2
        : cube_x - CalculateSideWallHeadedInsertXOffset( true );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _HolderSideWallConnection( is_top, is_left )
{
    connection_z = wall_width_single_z * 2 + heated_insert_def[ INSERT_LENGTH ];

    row = rows_in_lower_hex_groups;

    connection_left_offset_x = CalculateHexagonXOffset( row, -1 ) - hex_R - wall_width_single_x;
    connection_right_offset_x = CalculateHexagonXOffset( row, cols_in_left_hex_groups ) - hex_R - wall_width_single_x;

    if( is_top )
    {
        if( is_left )
        {
            render()
            {
                difference()
                {
                    // start with the hexagon in this spot
                    translate([ CalculateHexagonXOffset( row, -1 ), 0, CalculateHexagonZOffset( row ) ])
                        _RollHexHolderHexagon( true );

                    // cut off top
                    translate([ connection_left_offset_x, 0, CalculateHexagonZOffset( row - 1 ) + connection_z ])
                        cube([ hex_R * 2 + wall_width_single_x * 2, roll_holder_y, hex_R * 2 ]);

                    // cut off left
                    translate([ connection_left_offset_x, 0, CalculateHexagonZOffset( row - 1 ) ])
                        cube([ -connection_left_offset_x, roll_holder_y, hex_R ]);

                    // cut out the heated insert
                    translate([ CalculateSideWallHeadedInsertXOffset( is_left ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) ])
                        HeatedInsert( heated_insert_def );
                }
            }

            // translate([ CalculateSideWallHeadedInsertXOffset( is_left ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) - M3_WASHER[ WASHER_HEIGHT ] + screw_def[ SCREW_SHAFT_LENGTH ] * 0.9 ])
            //     rotate([ 180, 0, 0 ])
            //         PreviewScrew( screw_def, M3_WASHER );
        }
        else
        {
            render()
            {
                difference()
                {
                    // // start with the hexagon in this spot
                    translate([ CalculateHexagonXOffset( row, cols_in_left_hex_groups ), 0, CalculateHexagonZOffset( row ) ])
                        _RollHexHolderHexagon( true );

                    // cut off top
                    translate([ connection_right_offset_x, 0, CalculateHexagonZOffset( row - 1 ) + connection_z ])
                        cube([ hex_R * 2 + wall_width_single_x * 2, roll_holder_y, hex_R * 2 ]);

                    // cut off right
                    translate([ cube_x, 0, CalculateHexagonZOffset( row - 1 ) ])
                        cube([ -connection_left_offset_x, roll_holder_y, hex_R ]);

                    // cut out the heated insert
                    translate([ CalculateSideWallHeadedInsertXOffset( is_left ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) ])
                        HeatedInsert( heated_insert_def );
                }
            }
        }
    }
    else
    {
        if( is_left )
        {
            render()
            {
                difference()
                {
                    // TODO should put a face in front to cover the screw, but would need to slope in order to not have an overhang?

                    // on the bottom, just create a flat wall
                    translate([ wall_width_single_x, 0, CalculateHexagonZOffset( row - 1 ) - wall_width_single_z * 2 ])
                        cube([ -CalculateHexagonXOffset( row, -1 ), roll_holder_y, wall_width_single_z ]);

                    // cut out the heated insert
                    translate([ CalculateSideWallHeadedInsertXOffset( is_left ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) - screw_def[ SCREW_SHAFT_LENGTH ] + wall_width_single_z * 2 ])
                        ScrewShaft( screw_def );
                }
            }

            if( render_mode == "preview" )
            {
                translate([ CalculateSideWallHeadedInsertXOffset( is_left ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) - wall_width_single_z - M3_WASHER[ WASHER_HEIGHT ] + screw_def[ SCREW_SHAFT_LENGTH ] * 0.9 ])
                    rotate([ 180, 0, 0 ])
                        PreviewScrew( screw_def, M3_WASHER );
            }
        }
        else
        {
            render()
            {
                difference()
                {
                    // TODO should put a face in front to cover the screw, but would need to slope in order to not have an overhang?

                    // on the bottom, just create a flat wall
                    translate([ cube_x + CalculateHexagonXOffset( row, -1 ) - wall_width_single_x, 0, CalculateHexagonZOffset( row - 1 ) - wall_width_single_z * 2 ])
                        cube([ -CalculateHexagonXOffset( row, -1 ), roll_holder_y, wall_width_single_z ]);

                    // cut out the heated insert
                    translate([ CalculateSideWallHeadedInsertXOffset( is_left ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) - screw_def[ SCREW_SHAFT_LENGTH ] + wall_width_single_z * 2 ])
                        ScrewShaft( screw_def );
                }
            }

            if( render_mode == "preview" )
            {
                translate([ CalculateSideWallHeadedInsertXOffset( is_left ), roll_holder_y / 2, CalculateHexagonZOffset( row - 1 ) - wall_width_single_z - M3_WASHER[ WASHER_HEIGHT ] + screw_def[ SCREW_SHAFT_LENGTH ] * 0.9 ])
                    rotate([ 180, 0, 0 ])
                        PreviewScrew( screw_def, M3_WASHER );
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
                hexagon_prism( radius = hex_R + wall_width_single_x, height = roll_holder_y );
                // regular_prism( n = 6, height = roll_holder_y, r = hex_R + wall_width_single_x, anchor = BOTTOM );

                // inner
                if( !draw_filled_hexagon )
                    // regular_prism( n = 6, height = roll_holder_y, r = hex_R, anchor = BOTTOM );
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
