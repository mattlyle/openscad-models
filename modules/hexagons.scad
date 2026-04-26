////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// formulas: https://www.gigacalculator.com/calculators/hexagon-calculator.php

function CalculateHexagonR( r ) = r * 2 / sqrt( 3 );

// hex_a = hex_R;

function CalculateHexagonOffsetX( row, col, r, spacing ) =
    let ( spacing_index = row % 2 == 0
            ? ( col * 2 )
            : ( col * 2 + 1 ) )
    row % 2 == 0
        ? ( 2 * CalculateHexagonR( r ) * ( 1 + col * 3 ) / 2 + spacing_index * spacing )
        : ( 2 * CalculateHexagonR( r ) * ( 5 + col * 6 ) / 4 + spacing_index * spacing );

function CalculateHexagonOffsetY( row, r, spacing ) =
    row % 2 == 0
        ? ( 2 * r * ( 1 + row ) / 2 + spacing * row )
        : ( 2 * r * ( 1 + row ) / 2 + spacing * row );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Hexagon( r, z )
{
    cylinder( r = CalculateHexagonR( r ), h = z, $fn = 6 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HexagonCube(
    x,
    y,
    z,
    r,
    spacing = 1,
    left_edge = 0,
    right_edge = 0,
    top_edge = 0,
    bottom_edge = 0
    )
{
    union()
    {
        difference()
        {
            cube([ x, y, z ]);

            for ( row = [ -1 : y / ( r + spacing ) ] )
                for ( col = [ -1 : x / ( r + spacing ) / 2 ] )
                    translate( [
                        CalculateHexagonOffsetX( row, col, r, spacing ),
                        CalculateHexagonOffsetY( row, r, spacing ),
                        -DIFFERENCE_CLEARANCE
                        ] )
                        Hexagon( r, z + DIFFERENCE_CLEARANCE * 2 );
        }

        // add left edge
        if( left_edge > 0 )
            translate([ 0, 0, 0 ])
                cube([ left_edge, y, z ]);

        // add right edge
        if( right_edge > 0 )
            translate([ x - right_edge, 0, 0 ])
                cube([ right_edge, y, z ]);

        // add bottom edge
        if( bottom_edge > 0 )
            translate([ 0, 0, 0 ])
                cube([ x, bottom_edge, z ]);

        // add top edge
        if( top_edge > 0 )
            translate([ 0, y - top_edge, 0 ])
                cube([ x, top_edge, z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
