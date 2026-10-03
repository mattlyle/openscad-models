include <../modules/gridfinity-base.scad>
include <../modules/rounded-cylinder.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

bottle_1_r = 45.2 / 2;
bottle_2_r = 50.7 / 2;
bottle_3_r = 38.9 / 2;
bottle_4_r = 50.9 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-model";

cells_x = 3;
cells_y = 3; // in grid cells

// the height to be added on top of the base
top_z = 20;

bottle_preview_z = 60;
bottle_rounding_r = 1.0;

bottle_clearance = 1.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

size_x = CalculateGridfinitySize( cells_x );
size_y = CalculateGridfinitySize( cells_y );

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

bottle_r = [ [ bottle_1_r, bottle_2_r ],[ bottle_3_r, bottle_4_r ] ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    MeghanPillBottleHolders();
}
else if( render_mode == "print-model" )
{
    MeghanPillBottleHolders();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MeghanPillBottleHolders()
{
    difference()
    {
        GridfinityBase(
            cells_x,
            cells_y,
            top_z,
            round_top = false,
            center = false
            );

        for( x = [ 1, 2 ] )
        {
            for( y = [ 1, 2 ] )
            {
                translate([
                    CalculateEquallySpacedOffsetRadiuses( [ bottle_1_r, bottle_2_r ], size_x, bottle_clearance, x - 1 ),
                    CalculateEquallySpacedOffsetRadiuses( [ bottle_1_r, bottle_2_r ], size_y, bottle_clearance, y - 1 ),
                    offset_z
                    ])
                    RoundedCylinder(
                        r = bottle_r[ x - 1 ][ y - 1 ] + bottle_clearance,
                        h = bottle_preview_z,
                        rounding_r = bottle_rounding_r,
                        round_top = false
                        );
            }
        }
    }

    for( x = [ 1, 2 ] )
    {
        for( y = [ 1, 2 ] )
        {
            if( render_mode == "preview" )
            {
                translate([
                    CalculateEquallySpacedOffsetRadiuses( [ bottle_1_r, bottle_2_r ], size_x, bottle_clearance, x - 1 ),
                    CalculateEquallySpacedOffsetRadiuses( [ bottle_1_r, bottle_2_r ], size_y, bottle_clearance, y - 1 ),
                    offset_z + DIFFERENCE_CLEARANCE
                    ])
                    BottlePreview( bottle_r[ x - 1 ][ y - 1 ] );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BottlePreview( bottle_preview_r )
{
    % RoundedCylinder(
        r = bottle_preview_r,
        h = bottle_preview_z,
        rounding_r = bottle_rounding_r,
        round_top = false
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
