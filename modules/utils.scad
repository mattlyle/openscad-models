////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

BUILD_PLATE_X = 256.0;
BUILD_PLATE_Y = 256.0;
BUILD_PLATE_Z = 256.0;

BUILD_PREVIEW_WIDTH = 0.01;

DIFFERENCE_CLEARANCE = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// show a preview of the build plate

module BuildPlatePreview()
{
    % translate([ 0, 0, -BUILD_PREVIEW_WIDTH ])
        cube([ BUILD_PLATE_X, BUILD_PLATE_Y, BUILD_PREVIEW_WIDTH ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// list, sum and spacing functions

// sum up the values in the given list
function sumList( list ) = _sumListHelper( list, 0 );
function _sumListHelper( list, n ) = n >= len( list ) ? 0 : list[ n ] + _sumListHelper( list, n + 1 );

// sum up the values in the given list from indicies 0..i (inclusive)
function sumTo( list, i ) = _sumToHelper( list, i, 0 );
function _sumToHelper( list, i, n ) = n >= i || n >= len( list ) ? 0 : list[ n ] + _sumToHelper( list, i, n + 1 );

// adds val_to_add to each index of the given list, returning a new list
function addValueToEachIndex( list, val_to_add ) = [ for( entry = list ) entry + val_to_add ];

// for each size in list, adds up the size and the equally spaces them in the total_size with the given clearance factored in
function calculateEquallySpacedOffset( list, total_size, clearance, i ) =
    let( sizes_with_clearance = addValueToEachIndex( list, clearance * 2 ) )
    let( spacing = ( total_size - sumList( sizes_with_clearance ) ) / ( len( list ) + 1 ) )
    spacing * ( i + 1 ) + sumTo( sizes_with_clearance, i );

// function calculateEquallySpacedOffset( total_size, count, i, item_size ) = ( i + 1 ) / ( count + 1 ) * total_size - item_size / 2;

function calculateOffsetToCenter( total_size, item_size ) = total_size / 2 - item_size / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rotate so that we can draw an object from one point to the next

module RotateFromPointAtoB( a, b )
{
    // from: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations

    x = b[ 0 ]- a[ 0 ];
    y = b[ 1 ]- a[ 1 ];
    z = b[ 2 ]- a[ 2 ];

    length = norm([ x, y, z ]);
    b = acos( z / length );
    c = atan2( y, x );

    rotate([ 0, b, c ])
        children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
