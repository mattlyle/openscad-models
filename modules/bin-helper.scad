include <utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// cutout definitions
//
// a cutout is a vector whose first entry marks the shape: [ true, x, y, z ] for a cube,
// [ false, r, h ] for a cylinder
//
// the z / h is how deep to cut, measured down from the top of the bin; 0 cuts all the
// way through the bottom

function BinHelperCube( x, y, z = 0 ) = [ true, x, y, z ];

function BinHelperCylinder( r, h = 0 ) = [ false, r, h ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// cutout accessors

function BinHelperCutoutIsCube( cutout ) = cutout[ 0 ];

// the [ x, y ] the cutout takes up on the bin floor
function BinHelperCutoutFootprint( cutout ) =
    BinHelperCutoutIsCube( cutout )
        ? [ cutout[ 1 ], cutout[ 2 ] ]
        : [ cutout[ 1 ] * 2, cutout[ 1 ] * 2 ];

// how deep to cut; 0 means all the way through the bottom of the bin
function BinHelperCutoutDepth( cutout ) =
    BinHelperCutoutIsCube( cutout )
        ? cutout[ 3 ]
        : cutout[ 2 ];

// the [ x, y ] lower-left corner of the cutout's footprint when placed at the given location
// (cubes are located by that corner, cylinders by their center)
function BinHelperCutoutCorner( cutout, location ) =
    BinHelperCutoutIsCube( cutout )
        ? location
        : [ location[ 0 ] - cutout[ 1 ], location[ 1 ] - cutout[ 1 ] ];

// the same cutout cut to a new depth, for bins that set the depth themselves
function BinHelperCutoutWithDepth( cutout, z ) =
    BinHelperCutoutIsCube( cutout )
        ? BinHelperCube( cutout[ 1 ], cutout[ 2 ], z )
        : BinHelperCylinder( cutout[ 1 ], z );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// equally spaced layout: a single row along x, with 'spacing' between the cutouts and
// 'margin' around the outside

// leaving margin off gives an even gap all the way around
function BinHelperEquallySpacedMargin( spacing, margin ) = is_undef( margin ) ? spacing : margin;

// the [ x, y ] bin size needed to hold the cutouts
function BinHelperEquallySpacedSize( cutouts, spacing, margin ) =
    let( edge_margin = BinHelperEquallySpacedMargin( spacing, margin ) )
    let( footprints = [ for( cutout = cutouts ) BinHelperCutoutFootprint( cutout ) ] )
    let( footprints_total_x = SumList( GetListAtIndex( footprints, 0 ) ) )
    let( gaps_x = spacing * ( len( cutouts ) - 1 ) )
    [
        footprints_total_x + gaps_x + edge_margin * 2,
        max( GetListAtIndex( footprints, 1 ) ) + edge_margin * 2
        ];

// the location of each cutout, centered in y
// (cubes by their lower-left corner, cylinders by their center)
function BinHelperEquallySpacedLocations( cutouts, spacing, margin ) =
    let( edge_margin = BinHelperEquallySpacedMargin( spacing, margin ) )
    let( footprints = [ for( cutout = cutouts ) BinHelperCutoutFootprint( cutout ) ] )
    let( footprints_x = GetListAtIndex( footprints, 0 ) )
    let( bin_y = BinHelperEquallySpacedSize( cutouts, spacing, margin )[ 1 ] )
    [
        for( i = [ 0 : len( cutouts ) - 1 ] )
            let( offset_x = edge_margin + spacing * i + SumTo( footprints_x, i ) )
            BinHelperCutoutIsCube( cutouts[ i ] )
                ? [ offset_x, ( bin_y - footprints[ i ][ 1 ] ) / 2 ]
                : [ offset_x + footprints[ i ][ 0 ] / 2, bin_y / 2 ]
        ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// the cutouts for a bin sized by BinHelperEquallySpacedSize()
// meant to be used inside a difference()

module BinHelperEquallySpaced( bin_z, cutouts, spacing, margin )
{
    bin_size = BinHelperEquallySpacedSize( cutouts, spacing, margin );

    BinHelper(
        bin_x = bin_size[ 0 ],
        bin_y = bin_size[ 1 ],
        bin_z = bin_z,
        cutouts = cutouts,
        cutout_locations = BinHelperEquallySpacedLocations( cutouts, spacing, margin )
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// the cutouts at the given locations; meant to be used inside a difference()
// bin_x / bin_y are only used to check that everything fits - leave them 0 to skip the check

module BinHelper( bin_x = 0, bin_y = 0, bin_z, cutouts, cutout_locations )
{
    assert(
        len( cutouts ) == len( cutout_locations ),
        str( "got ", len( cutouts ), " cutouts but ", len( cutout_locations ), " locations" )
        );

    if( bin_x > 0 && bin_y > 0 )
    {
        for( i = [ 0 : len( cutouts ) - 1 ] )
        {
            corner = BinHelperCutoutCorner( cutouts[ i ], cutout_locations[ i ] );
            footprint = BinHelperCutoutFootprint( cutouts[ i ] );

            assert(
                corner[ 0 ] >= 0 && corner[ 1 ] >= 0,
                str( "cutout ", i, " starts outside the bin" )
                );
            assert(
                corner[ 0 ] + footprint[ 0 ] <= bin_x,
                str( "cutout ", i, " is too wide for the bin" )
                );
            assert(
                corner[ 1 ] + footprint[ 1 ] <= bin_y,
                str( "cutout ", i, " is too deep for the bin" )
                );
        }
    }

    for( i = [ 0 : len( cutouts ) - 1 ] )
    {
        _BinHelperCutout( cutouts[ i ], cutout_locations[ i ], bin_z );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _BinHelperCutout( cutout, location, bin_z )
{
    cutout_z = BinHelperCutoutDepth( cutout );

    cut_through = cutout_z == 0;

    cut_z = cut_through ? bin_z + DIFFERENCE_OFFSET * 2 : cutout_z + DIFFERENCE_OFFSET;
    offset_z = cut_through ? -DIFFERENCE_OFFSET : bin_z - cutout_z;

    translate([ location[ 0 ], location[ 1 ], offset_z ])
    {
        if( BinHelperCutoutIsCube( cutout ) )
        {
            cube([ cutout[ 1 ], cutout[ 2 ], cut_z ]);
        }
        else
        {
            cylinder( r = cutout[ 1 ], h = cut_z );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
