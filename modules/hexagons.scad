use <../../3rd-party/MCAD/regular_shapes.scad>

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
    hexagon_prism( radius = CalculateHexagonR( r ), height = z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
