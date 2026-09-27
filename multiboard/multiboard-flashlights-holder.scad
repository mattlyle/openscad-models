include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/text-label.scad>
include <../modules/svg.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

black_flashlight_r = 37.5 / 2;

pen_flashlight_r = 14.2 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-text";
// render_mode = "print-3mf";

holder_color = "white";
label_color = "black";

bin_z = 70;

// they are all round, so each entry is just a radius
bin_list = [
    black_flashlight_r,
    black_flashlight_r,
    pen_flashlight_r,
    pen_flashlight_r
    ];

bin_spacing = 8;

wall_width = 2.0;
clearance = 1.5;

label_text = "Flashlights";
label_font = "DejaVu Sans:style=Bold";
label_font_size = 14;
label_depth = 0.4;

label_logo_path = "../assets/flashlight-outline.svg";
label_logo_scale = 1.92;

// where the svg's own ink sits within its own units, so it can be placed by its middle rather
// than by its origin
label_logo_center_vector = [ 11.2, 59.2 ];

// the band along the bottom of the face the text sits in; the logo gets what is left above it
label_text_area_z = 26;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

// none of them are given a depth, so they all run down to the floor
flashlight_cutout_list = [
    for( bin_r = bin_list )
        BinHelperCylinder( bin_r + clearance )
    ];

flashlight_cutout_location_list = BinHelperEquallySpacedLocations(
    flashlight_cutout_list,
    bin_spacing,
    wall_width
    );

holder_size_vector = MultiboardConnectorHelperBinSize(
    flashlight_cutout_list,
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
        FlashlightHolder();

        FlashlightHolderLabel();
    }
}
else if( render_mode == "print-holder" )
{
    FlashlightHolder();
}
else if( render_mode == "print-text" )
{
    FlashlightHolderLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        FlashlightHolder();

    color( label_color )
        FlashlightHolderLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FlashlightHolder()
{
    difference()
    {
        MultiboardConnectorHelperBin(
            holder_size_vector,
            flashlight_cutout_list,
            flashlight_cutout_location_list,
            wall_width
            );

        // remove the inset text and logos
        FlashlightHolderLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the text and logos sitting in their recess on the front of the bins
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess

module FlashlightHolderLabel( is_cutout = false )
{
    cut_depth = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth;
    cut_color = is_cutout ? undef : label_color;

    // the svg's own ink sits off its origin, so place it by its middle
    ink_offset_vector = label_logo_center_vector * label_logo_scale;

    logo_center_z = label_text_area_z + ( holder_size_vector.z - label_text_area_z ) / 2;

    translate([ 0, label_depth, 0 ])
        rotate([ 90, 0, 0 ])
        {
            // the text sits in a band along the bottom
            CenteredTextLabel(
                label_text,
                centered_in_area_x = holder_size_vector.x,
                centered_in_area_y = label_text_area_z,
                depth = cut_depth,
                font_size = label_font_size,
                font = label_font,
                color = cut_color
                );

            // and the logo centers in what is left above it
            color( cut_color )
                translate([
                    holder_size_vector.x / 2 - ink_offset_vector.x,
                    logo_center_z - ink_offset_vector.y,
                    0
                    ])
                    scale([ label_logo_scale, label_logo_scale, 1.0 ])
                        SVG( label_logo_path, cut_depth );
        }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
