////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

gas_line_r = 13.9 / 2;
liquid_line_r = 11.9 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print-holder";

holder_back_y = 3.0;
holder_wraparound_y = 3.5;

holder_z = 40;

clearance = 0.4;

cutouts = [
    gas_line_r * 2 + clearance,
    gas_line_r * 2 + clearance,
    gas_line_r * 2 + clearance,
    liquid_line_r * 2 + clearance,
    liquid_line_r * 2 + clearance,
    liquid_line_r * 2 + clearance,
    ];

separator_thickness = 2.0;

corner_radius = 1.0;

preview_line_length = 100.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 128 : 256;

offsets_x = calculateOffsets( cutouts );

holder_x = sumList( cutouts ) + separator_thickness * ( len( cutouts ) + 1 );
holder_y = holder_back_y + max( cutouts ) / 2 + holder_wraparound_y;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function calculateOffsets( list ) = [
    for( i = [ 0 : len( list ) - 1 ] )
        sumTo( list, i )
            + separator_thickness * ( i + 1 )
            + list[ i ] / 2
    ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    PreviewLines();

    BeerLineHolder();
}
else if( render_mode == "print-holder" )
{
    translate([ 0, holder_wraparound_y, 0 ])
        BeerLineHolder();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewLines()
{
    for( i = [ 0 : len( cutouts ) - 1 ] )
        % translate([ offsets_x[ i ], 0, -preview_line_length / 3 ])
            cylinder( r = cutouts[ i ] / 2, h = preview_line_length );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeerLineHolder()
{
    difference()
    {
        translate([ 0, -holder_wraparound_y, 0 ])
            RoundedCubeAlt2( holder_x, holder_y, holder_z, corner_radius, round_top = false, round_bottom = false );

        for( i = [ 0 : len( cutouts ) - 1 ] )
            translate([ offsets_x[ i ], 0, -preview_line_length / 3 ])
                cylinder( r = cutouts[ i ] / 2, h = preview_line_length );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
