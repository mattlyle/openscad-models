include <../modules/gridfinity-base.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// straight tweezers
tweezers_1_x = 7.1;
tweezers_1_y = 6.8;

// curved tweezers
tweezers_2_x = 5.1;
tweezers_2_y = 18.5;

// green pry tool
green_pry_tool_x = 10.0;
green_pry_tool_y = 5.5;

// tiny black screwdriver
// tiny_black_screwdriver_shaft_diameter = 2.1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

cells_x = 1;
cells_y = 1;

// the height to be added on top of the base
top_z = 42.0;

clearance = 1.0;

holder_clearance = 0.15;

// offset away from the curve on the top of the bin
text_area_offset_y = 3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

item_sizes = [ tweezers_1_x, tweezers_2_x, green_pry_tool_x ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

TweezersBin();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TweezersBin()
{
    offsets_x = [
        calculateEquallySpacedOffset( item_sizes, base_x, clearance, 0 ),
        calculateEquallySpacedOffset( item_sizes, base_x, clearance, 1 ),
        calculateEquallySpacedOffset( item_sizes, base_x, clearance, 2 )
    ];

    offsets_y = [
        calculateOffsetToCenter( base_y, tweezers_1_y + clearance * 2 ),
        calculateOffsetToCenter( base_y, tweezers_2_y + clearance * 2 ),
        calculateOffsetToCenter( base_y, green_pry_tool_y + clearance * 2 )
    ];


    text_area_y = min( offsets_y ) - text_area_offset_y;

    // #translate([ 0, text_area_offset_y, holder_z ])
    //     cube([ base_x, text_area_y, 0.1 ]);

    // #translate([ base_x, base_y - text_area_offset_y, holder_z ])
    //     rotate([ 0, 0, 180 ])
    //         cube([ base_x, text_area_y, 0.1 ]);

    if( render_mode == "preview" || render_mode == "bin-only" )
    {
        render()
        {
            difference()
            {
                GridfinityBase( cells_x, cells_y, top_z, round_top = true, center = false );

                // left = straight tweezers
                translate([ offsets_x[ 0 ], offsets_y[ 0 ], offset_z ])
                    cube([ tweezers_1_x + clearance * 2, tweezers_1_y + clearance * 2, holder_z - offset_z ]);

                // center = curved tweezers
                translate([ offsets_x[ 1 ], offsets_y[ 1 ], offset_z ])
                    cube([ tweezers_2_x + clearance * 2, tweezers_2_y + clearance * 2, holder_z - offset_z ]);

                // right = green pry tool
                translate([ offsets_x[ 2 ], offsets_y[ 2 ], offset_z ])
                    cube([ green_pry_tool_x + clearance * 2, green_pry_tool_y + clearance * 2, holder_z - offset_z ]);
            }
        }
    }

    if( render_mode == "preview" || render_mode == "text-only" )
    {
        color([ 0.9, 0.9, 0 ])
        {
            translate([ 0, text_area_offset_y, holder_z ])
                CenteredTextLabel( "Tweezers", centered_in_area_x = base_x, centered_in_area_y = text_area_y, font_size = 5 );

            translate([ base_x, base_y - text_area_offset_y, holder_z ])
                rotate([ 0, 0, 180 ])
                    CenteredTextLabel( "Tweezers", centered_in_area_x = base_x, centered_in_area_y = text_area_y, font_size = 5 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
