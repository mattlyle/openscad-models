////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

BUILD_PLATE_X = 256.0;
BUILD_PLATE_Y = 256.0;
BUILD_PLATE_Z = 256.0;

BUILD_PREVIEW_WIDTH = 0.01;

DIFFERENCE_CLEARANCE = 0.01;

DIFFERENCE_OFFSET = 0.1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// show a preview of the build plate

module BuildPlatePreview()
{
    % translate([ 0, 0, -BUILD_PREVIEW_WIDTH ])
        cube([ BUILD_PLATE_X, BUILD_PLATE_Y, BUILD_PREVIEW_WIDTH ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// list, sum and spacing functions

function Reverse( list ) = [ for( i = [ len( list ) - 1 : -1 : 0 ] ) list[ i ] ];

// sum up the values in the given list
function SumList( list ) = _SumListHelper( list, 0 );
function _SumListHelper( list, n ) = n >= len( list ) ? 0 : list[ n ] + _SumListHelper( list, n + 1 );

// sum up the values in the given list from indicies 0..i (inclusive)
function SumTo( list, i ) = _SumToHelper( list, i, 0 );
function _SumToHelper( list, i, n ) = n >= i || n >= len( list ) ? 0 : list[ n ] + _SumToHelper( list, i, n + 1 );

function GetListAtIndex( list, i ) = [ for ( entry = list ) entry[ i ] ];

// adds val_to_add to each index of the given list, returning a new list
function AddValueToEachIndex( list, val_to_add ) = [ for( entry = list ) entry + val_to_add ];

// for each size in list, adds up the size and the equally spaces them in the total_size with the given clearance factored in
function CalculateEquallySpacedOffset( list, total_size, clearance, i ) =
    let( sizes_with_clearance = AddValueToEachIndex( list, clearance * 2 ) )
    let( spacing = ( total_size - SumList( sizes_with_clearance ) ) / ( len( list ) + 1 ) )
    spacing * ( i + 1 ) + SumTo( sizes_with_clearance, i );

// like CalculateEquallySpacedOffset, but takes a list of radiuses and returns the center offset of item i
function CalculateEquallySpacedOffsetRadiuses( list, total_size, clearance, i ) =
    let( footprints = AddValueToEachIndex( list, clearance ) * 2 )
    let( spacing = ( total_size - SumList( footprints ) ) / ( len( list ) + 1 ) )
    spacing * ( i + 1 ) + SumTo( footprints, i ) + clearance + list[ i ];

// function calculateEquallySpacedOffset( total_size, count, i, item_size ) = ( i + 1 ) / ( count + 1 ) * total_size - item_size / 2;

function CalculateOffsetToCenter( total_size, item_size ) = total_size / 2 - item_size / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rotate so that we can draw an object from one point to the next

module RotateFromPointAtoB( a, b )
{
    // from: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations

    x = b[ 0 ] - a[ 0 ];
    y = b[ 1 ] - a[ 1 ];
    z = b[ 2 ] - a[ 2 ];

    length = norm([ x, y, z ]);
    b = acos( z / length );
    c = atan2( y, x );

    rotate([ 0, b, c ])
        children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function RotatePointAboutPoint( rotateThisPoint, aboutThisPoint, angle ) =
    let( xdiff = rotateThisPoint.x - aboutThisPoint.x )
    let( ydiff = rotateThisPoint.y - aboutThisPoint.y )
    [
        aboutThisPoint.x + xdiff * cos( angle ) - ydiff * sin( angle ),
        aboutThisPoint.y + xdiff * sin( angle ) + ydiff * cos( angle ),
    ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// returns [ m, b ] in slope intercept form y = mx + b

function FindSlopeIntercept( pointA, pointB ) =
    let( m = ( pointB.y - pointA.y ) / ( pointB.x - pointA.x ) )
    let( b = pointA.y - m * pointA.x )
    [ m, b ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OptionalColor( color = false )
{
    if( color )
    {
        color( color )
            children();
    }
    else
    {
        children();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
