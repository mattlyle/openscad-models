include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

blue_utility_knife_x = 12.6;
blue_utility_knife_y = 31.5;

black_utility_knife_x = 21.4;
black_utility_knife_y = 38.5;

pen_knife_r = 12.9 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-text";
// render_mode = "print-3mf";

holder_color = "white";
label_color = "black";

// a two part entry is a rectangle, a one part entry is a circle
bin_list = [
    [ blue_utility_knife_x, blue_utility_knife_y ],
    [ black_utility_knife_x, black_utility_knife_y ],
    [ black_utility_knife_x, black_utility_knife_y ],
    [ black_utility_knife_x, black_utility_knife_y ],
    [ black_utility_knife_x, black_utility_knife_y ],
    [ pen_knife_r ]
    ];

bin_spacing = 8;

bin_z = 60;

wall_width = 2.0;
clearance = 1.5;

label_text_line_1 = "Utility";
label_text_line_2 = "Knives";
label_font = "DejaVu Sans:style=Bold";
label_font_size = 16;
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

// none of them are given a depth, so they all run down to the floor
utility_knife_cutout_list = [ for( bin = bin_list ) UtilityKnifeCutout( bin ) ];

utility_knife_cutout_location_list = BinHelperEquallySpacedLocations(
    utility_knife_cutout_list,
    bin_spacing,
    wall_width
    );

holder_size_vector = MultiboardConnectorHelperBinSize(
    utility_knife_cutout_list,
    bin_z,
    bin_spacing,
    wall_width
    );

echo( str( "Holder Size: ", holder_size_vector ) );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // the board stands behind the holder, so tip it up too
    translate([
        0,
        holder_size_vector.y + multiboard_connector_back_z + multiboard_cell_height,
        0
        ])
        rotate([ 90, 0, 0 ])
            color( workroom_multiboard_color )
                MultiboardMockUpTile( 12, 4 );

    translate([
        multiboard_cell_size - MultiboardConnectorBackAltXOffset( holder_size_vector.x ),
        0,
        0
        ])
    {
        UtilityKnifeHolder();

        UtilityKnifeHolderLabel();
    }
}
else if( render_mode == "print-holder" )
{
    UtilityKnifeHolder();
}
else if( render_mode == "print-text" )
{
    UtilityKnifeHolderLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        UtilityKnifeHolder();

    color( label_color )
        UtilityKnifeHolderLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// a two part entry is a rectangle, a one part entry is a circle

function UtilityKnifeCutout( bin ) =
    len( bin ) == 2
        ? BinHelperCube( bin.x + clearance * 2, bin.y + clearance * 2 )
        : BinHelperCylinder( bin.x + clearance );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module UtilityKnifeHolder()
{
    difference()
    {
        MultiboardConnectorHelperBin(
            holder_size_vector,
            utility_knife_cutout_list,
            utility_knife_cutout_location_list,
            wall_width
            );

        // remove the inset text
        UtilityKnifeHolderLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label sitting in its recess on the front of the bins
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess

module UtilityKnifeHolderLabel( is_cutout = false )
{
    translate([ 0, label_depth, 0 ])
        rotate([ 90, 0, 0 ])
            MultilineTextLabel(
                [ label_text_line_1, label_text_line_2 ],
                centered_in_area_x = holder_size_vector.x,
                centered_in_area_y = holder_size_vector.z,
                depth = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth,
                font_size = label_font_size,
                font = label_font,
                color = is_cutout ? undef : label_color
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
