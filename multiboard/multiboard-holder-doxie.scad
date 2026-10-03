include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

doxie_x = 57.9;
doxie_y = 43.8;
doxie_z = 310;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";

// the height of the bin, including the floor the doxie rests on
holder_z = 82;

wall_width = 2.0;
clearance = 1.5;

label_text = "Doxie";
label_font = "DejaVu Sans:style=Bold";
label_font_size = 13;
label_color = [ 0.1, 0.1, 0.1 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

doxie_cutout_y = doxie_y + clearance * 2;

// the bin is sized around the doxie itself
holder_size_vector = MultiboardConnectorHelperBinSize(
    [ BinHelperCube( doxie_x + clearance * 2, doxie_cutout_y ) ],
    holder_z,
    wall_width
    );

// but the cut runs out through the back of the bin, where the plate closes it off, so the two
// share no face; it is not given a depth either, so it also runs down to the floor
doxie_cutout_list = [
    BinHelperCube( doxie_x + clearance * 2, doxie_cutout_y + DIFFERENCE_OFFSET )
    ];

// the doxie sits back against the plate, which puts the leftover wall on the outside
doxie_cutout_location_list = [
    [ wall_width, holder_size_vector.y - doxie_cutout_y ]
    ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // the board stands behind the holder, so tip it up too
    translate([ 0, holder_size_vector.y + multiboard_connector_back_z + multiboard_cell_height, 0 ])
        rotate([ 90, 0, 0 ])
            color( workroom_multiboard_color )
                MultiboardMockUpTile( 12, 4 );

    translate([
        multiboard_cell_size - MultiboardConnectorBackAltXOffset( holder_size_vector.x ),
        0,
        0
        ])
    {
        DoxieMultiboardHolder();

        DoxiePreview();
    }
}
else if( render_mode == "print-holder" )
{
    DoxieMultiboardHolder();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// doxie module

module DoxieMultiboardHolder()
{
    MultiboardConnectorHelperBin(
        holder_size_vector,
        doxie_cutout_list,
        doxie_cutout_location_list,
        wall_width
        );

    // add the text, raised off the face away from the board
    translate([ -1.5, 0, 0 ]) // for some reason the textmetrics are broken?
        rotate([ 90, 0, 0 ])
            CenteredTextLabel(
                label_text,
                centered_in_area_x = holder_size_vector.x,
                centered_in_area_y = holder_size_vector.z,
                font_size = label_font_size,
                font = label_font,
                color = label_color
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// doxie preview

module DoxiePreview()
{
    // it sits inside its cutout by the clearance, and lifts off the floor it rests on so it
    // doesn't fight with it in the preview
    translate([
        doxie_cutout_location_list[ 0 ].x + clearance,
        doxie_cutout_location_list[ 0 ].y + clearance,
        wall_width + DIFFERENCE_OFFSET
        ])
        % cube([ doxie_x, doxie_y, doxie_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
