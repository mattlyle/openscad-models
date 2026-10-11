include <../modules/gridfinity-base.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

kitchen_scale_x = 186.5;
kitchen_scale_y = 16.9;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";
// render_mode = "print-3mf";

label_text = "Kitchen Scale";
label_font = "Liberation Sans:style=Bold";
label_font_size = 5.5;
label_depth = 0.5;

bin_color = "white";
label_color = "black";

clearance = 1.5;

// the minimum material to leave around the scale cutout
min_wall = 3;

cells_z = 1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

cells_x = ceil( ( kitchen_scale_x + clearance * 2 + min_wall * 2 + 0.5 ) / 42.0 );
cells_y = ceil( ( kitchen_scale_y + clearance * 2 + min_wall * 2 + 0.5 ) / 42.0 );

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

holder_z = cells_z * 42.0;

top_z = holder_z - GRIDFINITY_BASE_Z;

cutout_x = kitchen_scale_x + clearance * 2;
cutout_y = kitchen_scale_y + clearance * 2;
cutout_z = top_z - GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

// the flat part of the wall between the front rounding and the scale cutout
label_area_y = CenterInGridfinityCell( cutout_y, cells_y ) - GRIDFINITY_ROUNDING_R;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ScaleBin();
    ScaleBinTextLabel( false );
}
else if( render_mode == "print-bin" )
{
    ScaleBin();
}
else if( render_mode == "print-text" )
{
    ScaleBinTextLabel( false );
}
else if( render_mode == "print-3mf" )
{
    color( bin_color )
        ScaleBin();
    color( label_color )
        ScaleBinTextLabel( false );
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleBin()
{
    render()
    {
        difference()
        {
            GridfinityBase( cells_x, cells_y, top_z, round_top = true, center = false );

            translate([ CenterInGridfinityCell( cutout_x, cells_x ), CenterInGridfinityCell( cutout_y, cells_y ), holder_z - cutout_z ])
                cube([ cutout_x, cutout_y, cutout_z + DIFFERENCE_CLEARANCE ]);

            // remove the label
            ScaleBinTextLabel( true );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleBinTextLabel( is_difference )
{
    translate([ 0, GRIDFINITY_ROUNDING_R, holder_z - label_depth ])
        CenteredTextLabel(
            label_text,
            font = label_font,
            font_size = label_font_size,
            centered_in_area_x = base_x,
            centered_in_area_y = label_area_y,
            depth = label_depth,
            color = is_difference ? undef : [ 0, 0, 0 ]
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
