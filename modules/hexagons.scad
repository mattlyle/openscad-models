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

// how far to slide the pattern in x so a hexagon column lands in the middle of x; the pattern is
// mirror symmetric about every column, so this balances the partial hexagons on the left and right
// (columns repeat every half period because the odd rows sit halfway between the even ones)

function CalculateHexagonCenterShiftX( x, r, spacing ) =
    let ( half_period_x = ( 3 * CalculateHexagonR( r ) + 2 * spacing ) / 2 )
    ( ( x / 2 - CalculateHexagonR( r ) ) % half_period_x + half_period_x ) % half_period_x;

// how far to slide the pattern in y so a hexagon row lands in the middle of y; the pattern is
// mirror symmetric about every row, so this balances the partial hexagons on the top and bottom

function CalculateHexagonCenterShiftY( y, r, spacing ) =
    let ( period_y = r + spacing )
    ( ( y / 2 - r ) % period_y + period_y ) % period_y;

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
    bottom_edge = 0,
    center_x = false,
    center_y = false
    )
{
    shift_x = center_x ? CalculateHexagonCenterShiftX( x, r, spacing ) : 0;
    shift_y = center_y ? CalculateHexagonCenterShiftY( y, r, spacing ) : 0;

    union()
    {
        difference()
        {
            cube([ x, y, z ]);

            for ( row = [ -1 : y / ( r + spacing ) ] )
                for ( col = [ -1 : x / ( r + spacing ) / 2 ] )
                    translate( [
                        CalculateHexagonOffsetX( row, col, r, spacing ) + shift_x,
                        CalculateHexagonOffsetY( row, r, spacing ) + shift_y,
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
