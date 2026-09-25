include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/text-label.scad>
include <../modules/svg.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

original_caliper_box_x = 91.4;
original_caliper_box_y = 26.3;
original_caliper_box_z = 248;

larger_caliper_box_x = 127.2;
larger_caliper_box_y = 32.1;
larger_caliper_box_z = 425;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-original-holder";
// render_mode = "print-original-label";
// render_mode = "print-original-3mf";
// render_mode = "print-larger-holder";
// render_mode = "print-larger-label";
// render_mode = "print-larger-3mf";

holder_color = "white";
label_color = "black";

wall_width = 1.5;
clearance = 2.5;

// the height of each bin, including the floor its box rests on
original_holder_z = 70;
larger_holder_z = 90;

// where each one sits on the board in the preview
original_holder_cell_offset_x = 0;
larger_holder_cell_offset_x = 5;

label_text_line_1 = "Digital";
label_text_line_2 = "Calipers";
label_font = "Verdana:style=Bold";
label_font_size = 9;
label_depth = 0.5;

// the band along the bottom of the face the text sits in; the logo gets what is left above it
// it needs to clear the descenders on the bottom line, which are about a third of the font size
label_text_area_z = 34;

label_logo_path = "../assets/calipers-svgrepo-com.svg";

// the logo is placed by eye on each face - the larger holder has the room for a bigger one
// the offsets are where its own origin lands, so they want another look after changing an angle
original_label_logo_scale = 0.24;
original_label_logo_angle = -20;
original_label_logo_offset_x = 20;
original_label_logo_offset_y = 30;

larger_label_logo_scale = 0.40;
larger_label_logo_angle = -20;
larger_label_logo_offset_x = 18;
larger_label_logo_offset_y = 28;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

original_caliper_box_size_vector = [
    original_caliper_box_x,
    original_caliper_box_y,
    original_caliper_box_z
    ];

larger_caliper_box_size_vector = [
    larger_caliper_box_x,
    larger_caliper_box_y,
    larger_caliper_box_z
    ];

original_bin_size_vector = CaliperBinSizeVector(
    original_caliper_box_size_vector,
    original_holder_z
    );

larger_bin_size_vector = CaliperBinSizeVector(
    larger_caliper_box_size_vector,
    larger_holder_z
    );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // the board stands behind the holders, so tip it up too
    translate([
        0,
        larger_bin_size_vector.y + multiboard_connector_back_z + multiboard_cell_height,
        0
        ])
        rotate([ 90, 0, 0 ])
            color( workroom_multiboard_color )
                MultiboardMockUpTile( 12, 6 );

    CaliperHolderPlaced( original_bin_size_vector, original_holder_cell_offset_x )
    {
        OriginalCaliperBoxHolder();

        OriginalCaliperBoxHolderLabel();

        CaliperBoxPreview( original_caliper_box_size_vector, original_bin_size_vector );
    }

    CaliperHolderPlaced( larger_bin_size_vector, larger_holder_cell_offset_x )
    {
        LargerCaliperBoxHolder();

        LargerCaliperBoxHolderLabel();

        CaliperBoxPreview( larger_caliper_box_size_vector, larger_bin_size_vector );
    }
}
else if( render_mode == "print-original-holder" )
{
    OriginalCaliperBoxHolder();
}
else if( render_mode == "print-original-label" )
{
    OriginalCaliperBoxHolderLabel();
}
else if( render_mode == "print-original-3mf" )
{
    color( holder_color )
        OriginalCaliperBoxHolder();

    color( label_color )
        OriginalCaliperBoxHolderLabel();
}
else if( render_mode == "print-larger-holder" )
{
    LargerCaliperBoxHolder();
}
else if( render_mode == "print-larger-label" )
{
    LargerCaliperBoxHolderLabel();
}
else if( render_mode == "print-larger-3mf" )
{
    color( holder_color )
        LargerCaliperBoxHolder();

    color( label_color )
        LargerCaliperBoxHolderLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// the bin size for a box, with a wall either side of it and the box's own clearance front to back

function CaliperBinSizeVector( box_size_vector, holder_z ) =
    [
        box_size_vector.x + wall_width * 2 + clearance * 2,
        box_size_vector.y + clearance * 2,
        holder_z
        ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// the cutout for a box, cut out through the back of the bin where the plate closes it off

function CaliperCutoutList( box_size_vector ) =
    [
        BinHelperCube(
            box_size_vector.x + clearance * 2,
            box_size_vector.y + clearance + DIFFERENCE_OFFSET
            )
        ];

// the box sits back against the plate, which leaves its one clearance on the outside
function CaliperCutoutLocationList( box_size_vector, bin_size_vector ) =
    [
        [ wall_width, bin_size_vector.y - ( box_size_vector.y + clearance ) ]
        ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// stands a holder on the board where the preview wants it
module CaliperHolderPlaced( bin_size_vector, cell_offset_x )
{
    translate([
        ( cell_offset_x + 1 ) * multiboard_cell_size
            - MultiboardConnectorBackAltXOffset( bin_size_vector.x ),
        0,
        0
        ])
        children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalCaliperBoxHolder()
{
    CaliperBoxHolder(
        original_caliper_box_size_vector,
        original_bin_size_vector,
        original_label_logo_scale,
        original_label_logo_angle,
        original_label_logo_offset_x,
        original_label_logo_offset_y
        );
}

module LargerCaliperBoxHolder()
{
    CaliperBoxHolder(
        larger_caliper_box_size_vector,
        larger_bin_size_vector,
        larger_label_logo_scale,
        larger_label_logo_angle,
        larger_label_logo_offset_x,
        larger_label_logo_offset_y
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalCaliperBoxHolderLabel()
{
    CaliperBoxHolderLabel(
        original_bin_size_vector,
        original_label_logo_scale,
        original_label_logo_angle,
        original_label_logo_offset_x,
        original_label_logo_offset_y
        );
}

module LargerCaliperBoxHolderLabel()
{
    CaliperBoxHolderLabel(
        larger_bin_size_vector,
        larger_label_logo_scale,
        larger_label_logo_angle,
        larger_label_logo_offset_x,
        larger_label_logo_offset_y
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CaliperBoxHolder(
    box_size_vector,
    bin_size_vector,
    logo_scale,
    logo_angle,
    logo_offset_x,
    logo_offset_y
    )
{
    difference()
    {
        MultiboardConnectorHelperBin(
            bin_size_vector,
            CaliperCutoutList( box_size_vector ),
            CaliperCutoutLocationList( box_size_vector, bin_size_vector ),
            wall_width
            );

        // remove the inset text and logo
        CaliperBoxHolderLabel(
            bin_size_vector,
            logo_scale,
            logo_angle,
            logo_offset_x,
            logo_offset_y,
            is_cutout = true
            );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the text and logo, sitting in their recess in the face away from the board
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess

module CaliperBoxHolderLabel(
    bin_size_vector,
    logo_scale,
    logo_angle,
    logo_offset_x,
    logo_offset_y,
    is_cutout = false
    )
{
    cut_depth = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth;
    cut_color = is_cutout ? undef : label_color;

    translate([ 0, label_depth, 0 ])
        rotate([ 90, 0, 0 ])
        {
            // the two lines sit in a band along the bottom
            MultilineTextLabel(
                [ label_text_line_1, label_text_line_2 ],
                centered_in_area_x = bin_size_vector.x,
                centered_in_area_y = label_text_area_z,
                depth = cut_depth,
                font_size = label_font_size,
                font = label_font,
                color = cut_color
                );

            // and the logo sits above them, placed by eye
            SVGLabel(
                label_logo_path,
                svg_scale = logo_scale,
                rotation_angle = logo_angle,
                offset_x = logo_offset_x,
                offset_y = logo_offset_y,
                depth = cut_depth,
                color = cut_color
                );
        }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CaliperBoxPreview( box_size_vector, bin_size_vector )
{
    // it sits inside its cutout by the clearance, and lifts off the floor it rests on so it
    // doesn't fight with it in the preview
    location = CaliperCutoutLocationList( box_size_vector, bin_size_vector )[ 0 ];

    % translate([
        location.x + clearance,
        location.y,
        wall_width + DIFFERENCE_OFFSET
        ])
        cube( box_size_vector );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
