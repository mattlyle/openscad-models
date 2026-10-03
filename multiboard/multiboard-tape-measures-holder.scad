include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

tape_measure_x = 50;
tape_measure_y = 108;
tape_measure_z = 85;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-text";
// render_mode = "print-3mf";

holder_color = "white";
label_color = "black";

num_tape_measures = 5;

// the bins only cradle the bottom of each tape measure, so the rest of it stands proud
bin_z = 30;

// they sit further apart than a wall would put them, to get a hand in beside each one
bin_spacing = 12;

// the back reaches well above the bins, so it takes a decent bite of the board
back_cells_z = 3;

wall_width = 2.0;
clearance = 1.5;

label_text = "Tape Measures";
label_font = "DejaVu Sans:style=Bold";
label_font_size = 14;
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

tape_measure_size_vector = [ tape_measure_x, tape_measure_y, tape_measure_z ];

// one pocket per tape measure, none of them given a depth so they all run down to the floor
tape_measure_cutout_list = [
    for( i = [ 0 : num_tape_measures - 1 ] )
        BinHelperCube(
            tape_measure_x + clearance * 2,
            tape_measure_y + clearance * 2
            )
    ];

tape_measure_cutout_location_list = BinHelperEquallySpacedLocations(
    tape_measure_cutout_list,
    bin_spacing,
    wall_width
    );

holder_size_vector = MultiboardConnectorHelperBinSize(
    tape_measure_cutout_list,
    bin_z,
    bin_spacing,
    wall_width
    );

back_z = back_cells_z * multiboard_cell_size;

echo( str( "Holder Size: ", holder_size_vector, "  back z: ", back_z ) );

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
        TapeMeasureHolder();

        TapeMeasureHolderLabel();

        TapeMeasurePreviews();
    }
}
else if( render_mode == "print-holder" )
{
    TapeMeasureHolder();
}
else if( render_mode == "print-text" )
{
    TapeMeasureHolderLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        TapeMeasureHolder();

    color( label_color )
        TapeMeasureHolderLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TapeMeasureHolder()
{
    difference()
    {
        MultiboardConnectorHelperBin(
            holder_size_vector,
            tape_measure_cutout_list,
            tape_measure_cutout_location_list,
            wall_width,
            back_z = back_z
            );

        // remove the inset text
        TapeMeasureHolderLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label sitting in its recess on the front of the bins
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess

module TapeMeasureHolderLabel( is_cutout = false )
{
    translate([ 0, label_depth, 0 ])
        rotate([ 90, 0, 0 ])
            CenteredTextLabel(
                label_text,
                centered_in_area_x = holder_size_vector.x,
                centered_in_area_y = holder_size_vector.z,
                depth = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth,
                font_size = label_font_size,
                font = label_font,
                color = is_cutout ? undef : label_color
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TapeMeasurePreviews()
{
    // each one sits inside its pocket by the clearance, and lifts off the floor it rests on so
    // it doesn't fight with it in the preview
    for( i = [ 0 : num_tape_measures - 1 ] )
    {
        translate([
            tape_measure_cutout_location_list[ i ].x + clearance,
            tape_measure_cutout_location_list[ i ].y + clearance,
            wall_width + DIFFERENCE_OFFSET
            ])
            TapeMeasurePreview();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TapeMeasurePreview()
{
    % cube( tape_measure_size_vector );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
