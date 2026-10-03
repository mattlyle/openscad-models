include <utils.scad>
include <rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// cutout definitions
//
// a cutout is [ is_cube, size ], where size is [ x, y, z ] for a cube and [ r, h ] for a cylinder
//
// the z / h is how deep to cut, measured down from the top of the bin; 0 cuts all the
// way through the bottom

function BinHelperCube( x, y, z = 0 ) = [ true, [ x, y, z ] ];

function BinHelperCylinder( r, h = 0 ) = [ false, [ r, h ] ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// cutout accessors

function BinHelperCutoutIsCube( cutout ) = cutout[ 0 ];

function BinHelperCutoutSize( cutout ) = cutout[ 1 ];

// the [ x, y ] the cutout takes up on the bin floor
function BinHelperCutoutFootprint( cutout ) =
    let( size = BinHelperCutoutSize( cutout ) )
    BinHelperCutoutIsCube( cutout )
        ? [ size.x, size.y ]
        : [ size.x * 2, size.x * 2 ];

// how deep to cut; 0 means all the way through the bottom of the bin
function BinHelperCutoutDepth( cutout ) =
    let( size = BinHelperCutoutSize( cutout ) )
    BinHelperCutoutIsCube( cutout )
        ? size.z
        : size.y;

// the [ x, y ] lower-left corner of the cutout's footprint when placed at the given location
// (cubes are located by that corner, cylinders by their center)
function BinHelperCutoutCorner( cutout, location ) =
    let( size = BinHelperCutoutSize( cutout ) )
    BinHelperCutoutIsCube( cutout )
        ? location
        : [ location.x - size.x, location.y - size.x ];

// the same cutout cut to a new depth, for bins that set the depth themselves
function BinHelperCutoutWithDepth( cutout, z ) =
    let( size = BinHelperCutoutSize( cutout ) )
    BinHelperCutoutIsCube( cutout )
        ? BinHelperCube( size.x, size.y, z )
        : BinHelperCylinder( size.x, z );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// equally spaced layout: a single row along x, with 'spacing' between the cutouts and
// 'margin' around the outside

// leaving margin off gives an even gap all the way around
function BinHelperEquallySpacedMargin( spacing, margin ) = is_undef( margin ) ? spacing : margin;

// the [ x, y ] bin size needed to hold the cutouts
function BinHelperEquallySpacedSize( cutout_list, spacing, margin ) =
    let( edge_margin = BinHelperEquallySpacedMargin( spacing, margin ) )
    let( footprint_list = [ for( cutout = cutout_list ) BinHelperCutoutFootprint( cutout ) ] )
    let( footprint_total_x = SumList( GetListAtIndex( footprint_list, 0 ) ) )
    let( gaps_x = spacing * ( len( cutout_list ) - 1 ) )
    [
        footprint_total_x + gaps_x + edge_margin * 2,
        max( GetListAtIndex( footprint_list, 1 ) ) + edge_margin * 2
        ];

// the location of each cutout, centered in y
// (cubes by their lower-left corner, cylinders by their center)
function BinHelperEquallySpacedLocations( cutout_list, spacing, margin ) =
    let( edge_margin = BinHelperEquallySpacedMargin( spacing, margin ) )
    let( footprint_list = [ for( cutout = cutout_list ) BinHelperCutoutFootprint( cutout ) ] )
    let( footprint_x_list = GetListAtIndex( footprint_list, 0 ) )
    let( bin_y = BinHelperEquallySpacedSize( cutout_list, spacing, margin ).y )
    [
        for( i = [ 0 : len( cutout_list ) - 1 ] )
            let( offset_x = edge_margin + spacing * i + SumTo( footprint_x_list, i ) )
            BinHelperCutoutIsCube( cutout_list[ i ] )
                ? [ offset_x, ( bin_y - footprint_list[ i ].y ) / 2 ]
                : [ offset_x + footprint_list[ i ].x / 2, bin_y / 2 ]
        ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// a bin of the given size with the cutouts taken out of it
//
// everything cuts down the z, so the bin stands the way it prints: open at the top, sat on a
// floor_z thick floor that a cutout with no depth of its own stops at

module BinHelperBin(
    size_vector,
    cutout_list,
    cutout_location_list,
    corner_rounding_r,
    floor_z = 0,
    round_back = true
    )
{
    bin_cutout_list = [
        for( cutout = cutout_list )
            BinHelperCutoutDepth( cutout ) == 0
                ? BinHelperCutoutWithDepth( cutout, size_vector.z - floor_z )
                : cutout
        ];

    difference()
    {
        RoundedCube(
            x = size_vector.x,
            y = size_vector.y,
            z = size_vector.z,
            r = corner_rounding_r,
            round_back = round_back
            );

        BinHelper(
            bin_x = size_vector.x,
            bin_y = size_vector.y,
            bin_z = size_vector.z,
            cutout_list = bin_cutout_list,
            cutout_location_list = cutout_location_list
            );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// the cutouts at the given locations; meant to be used inside a difference()
// bin_x / bin_y are only used to check that everything fits - leave them 0 to skip the check

module BinHelper( bin_x = 0, bin_y = 0, bin_z, cutout_list, cutout_location_list )
{
    assert(
        len( cutout_list ) == len( cutout_location_list ),
        str( "got ", len( cutout_list ), " cutouts but ",
            len( cutout_location_list ), " locations" )
        );

    if( bin_x > 0 && bin_y > 0 )
    {
        for( i = [ 0 : len( cutout_list ) - 1 ] )
        {
            corner = BinHelperCutoutCorner( cutout_list[ i ], cutout_location_list[ i ] );
            footprint = BinHelperCutoutFootprint( cutout_list[ i ] );

            // a cutout that runs out through a wall overshoots it, so allow that much slack
            assert(
                corner.x >= -DIFFERENCE_OFFSET && corner.y >= -DIFFERENCE_OFFSET,
                str( "cutout ", i, " starts outside the bin" )
                );
            assert(
                corner.x + footprint.x <= bin_x + DIFFERENCE_OFFSET,
                str( "cutout ", i, " is too wide for the bin" )
                );
            assert(
                corner.y + footprint.y <= bin_y + DIFFERENCE_OFFSET,
                str( "cutout ", i, " is too deep for the bin" )
                );
        }
    }

    for( i = [ 0 : len( cutout_list ) - 1 ] )
    {
        _BinHelperCutout( cutout_list[ i ], cutout_location_list[ i ], bin_z );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _BinHelperCutout( cutout, location, bin_z )
{
    size = BinHelperCutoutSize( cutout );

    cutout_z = BinHelperCutoutDepth( cutout );

    cut_through = cutout_z == 0;

    cut_z = cut_through ? bin_z + DIFFERENCE_OFFSET * 2 : cutout_z + DIFFERENCE_OFFSET;
    offset_z = cut_through ? -DIFFERENCE_OFFSET : bin_z - cutout_z;

    translate([ location.x, location.y, offset_z ])
    {
        if( BinHelperCutoutIsCube( cutout ) )
        {
            cube([ size.x, size.y, cut_z ]);
        }
        else
        {
            cylinder( r = size.x, h = cut_z );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
