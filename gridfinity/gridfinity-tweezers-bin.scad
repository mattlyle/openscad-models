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

// NARZ Tweezers
tweezers_3_xy = 8.6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin-1";
// render_mode = "print-text-1";
// render_mode = "print-bin-2";
// render_mode = "print-text-2";
// render_mode = "print-3mf-1";
// render_mode = "print-3mf-2";

bin_color = "white";
label_color = "black";

bin_1_label_text = "Tweezers";
bin_2_label_text = "NARZ";
bin_2_label_font = "Georgia:style=Bold";
label_font_size = 5;

// TODO: The NARZ text should be bold

cells_x = 1;
cells_y = 1;

// the height to be added on top of the base
top_z = 42.0;

clearance = 1.0;

holder_clearance = 0.15;

// offset away from the curve on the top of the bin
bin_1_text_area_offset_y = 3;

bin_2_offset_x = 50; // bin 2 sits beside bin 1

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

bin_1_item_sizes = [ tweezers_1_x, tweezers_2_x, green_pry_tool_x ];

bin_2_item_sizes = [ tweezers_3_xy, tweezers_3_xy ];

bin_1_offsets_x = [
    CalculateEquallySpacedOffset( bin_1_item_sizes, base_x, clearance, 0 ),
    CalculateEquallySpacedOffset( bin_1_item_sizes, base_x, clearance, 1 ),
    CalculateEquallySpacedOffset( bin_1_item_sizes, base_x, clearance, 2 )
];

bin_1_offsets_y = [
    CalculateOffsetToCenter( base_y, tweezers_1_y + clearance * 2 ),
    CalculateOffsetToCenter( base_y, tweezers_2_y + clearance * 2 ),
    CalculateOffsetToCenter( base_y, green_pry_tool_y + clearance * 2 )
];

bin_1_text_area_y = min( bin_1_offsets_y ) - bin_1_text_area_offset_y;

bin_2_offsets_x = [
    CalculateEquallySpacedOffset( bin_2_item_sizes, base_x, clearance, 0 ),
    CalculateEquallySpacedOffset( bin_2_item_sizes, base_x, clearance, 1 ),
];

bin_2_offsets_y = [
    CalculateEquallySpacedOffset( bin_2_item_sizes, base_x, clearance, 0 ),
    CalculateEquallySpacedOffset( bin_2_item_sizes, base_x, clearance, 1 ),
];

bin_2_text_offset_y = bin_2_offsets_y[ 0 ] + bin_2_item_sizes[ 0 ];
bin_2_text_area_y = bin_2_offsets_y[ 1 ] - bin_2_text_offset_y;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    TweezersBin1();
    TweezersBin1TextLabels();

    translate([ bin_2_offset_x, 0, 0 ])
    {
        TweezersBin2();
        TweezersBin2TextLabel();
    }
}
else if( render_mode == "print-bin-1" )
{
    TweezersBin1();
}
else if( render_mode == "print-text-1" )
{
    TweezersBin1TextLabels();
}
else if( render_mode == "print-bin-2" )
{
    translate([ bin_2_offset_x, 0, 0 ])
        TweezersBin2();
}
else if( render_mode == "print-text-2" )
{
    translate([ bin_2_offset_x, 0, 0 ])
        TweezersBin2TextLabel();
}
else if( render_mode == "print-3mf-1" )
{
    color( bin_color )
        TweezersBin1();
    color( label_color )
        TweezersBin1TextLabels();
}
else if( render_mode == "print-3mf-2" )
{
    color( bin_color )
        translate([ bin_2_offset_x, 0, 0 ])
            TweezersBin2();
    color( label_color )
        translate([ bin_2_offset_x, 0, 0 ])
            TweezersBin2TextLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TweezersBin1()
{
    render()
    {
        difference()
        {
            GridfinityBase( cells_x, cells_y, top_z, round_top = true, center = false );

            // left = straight tweezers
            translate([ bin_1_offsets_x[ 0 ], bin_1_offsets_y[ 0 ], offset_z ])
                cube([ tweezers_1_x + clearance * 2, tweezers_1_y + clearance * 2, holder_z - offset_z ]);

            // center = curved tweezers
            translate([ bin_1_offsets_x[ 1 ], bin_1_offsets_y[ 1 ], offset_z ])
                cube([ tweezers_2_x + clearance * 2, tweezers_2_y + clearance * 2, holder_z - offset_z ]);

            // right = green pry tool
            translate([ bin_1_offsets_x[ 2 ], bin_1_offsets_y[ 2 ], offset_z ])
                cube([ green_pry_tool_x + clearance * 2, green_pry_tool_y + clearance * 2, holder_z - offset_z ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label is repeated on both ends of bin 1
module TweezersBin1TextLabels()
{
    // #translate([ 0, bin_1_text_area_offset_y, holder_z ])
    //     cube([ base_x, bin_1_text_area_y, 0.1 ]);

    // #translate([ base_x, base_y - bin_1_text_area_offset_y, holder_z ])
    //     rotate([ 0, 0, 180 ])
    //         cube([ base_x, bin_1_text_area_y, 0.1 ]);

    translate([ 0, bin_1_text_area_offset_y, holder_z ])
        CenteredTextLabel( bin_1_label_text, centered_in_area_x = base_x, centered_in_area_y = bin_1_text_area_y, font_size = label_font_size );

    translate([ base_x, base_y - bin_1_text_area_offset_y, holder_z ])
        rotate([ 0, 0, 180 ])
            CenteredTextLabel( bin_1_label_text, centered_in_area_x = base_x, centered_in_area_y = bin_1_text_area_y, font_size = label_font_size );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TweezersBin2()
{
    render()
    {
        difference()
        {
            GridfinityBase( cells_x, cells_y, top_z, round_top = true, center = false );

            translate([ bin_2_offsets_x[ 0 ], bin_2_offsets_y[ 0 ], offset_z ])
                cube([ tweezers_1_x + clearance * 2, tweezers_1_y + clearance * 2, holder_z - offset_z ]);
            translate([ bin_2_offsets_x[ 0 ], bin_2_offsets_y[ 1 ], offset_z ])
                cube([ tweezers_1_x + clearance * 2, tweezers_1_y + clearance * 2, holder_z - offset_z ]);
            translate([ bin_2_offsets_x[ 1 ], bin_2_offsets_y[ 0 ], offset_z ])
                cube([ tweezers_1_x + clearance * 2, tweezers_1_y + clearance * 2, holder_z - offset_z ]);
            translate([ bin_2_offsets_x[ 1 ], bin_2_offsets_y[ 1 ], offset_z ])
                cube([ tweezers_1_x + clearance * 2, tweezers_1_y + clearance * 2, holder_z - offset_z ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TweezersBin2TextLabel()
{
    // #translate([ 0, bin_2_text_offset_y, holder_z ])
    //     cube([ base_x, bin_2_text_area_y, 0.1 ]);

    translate([ 0, bin_2_text_offset_y, holder_z ])
        CenteredTextLabel( bin_2_label_text, font = bin_2_label_font, centered_in_area_x = base_x, centered_in_area_y = bin_2_text_area_y, font_size = label_font_size );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
