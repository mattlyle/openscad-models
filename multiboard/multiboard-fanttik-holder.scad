include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

fanttik_box_x = 116.0;
fanttik_box_y = 51.7;
fanttik_box_z = 245;

fanttik_screwdriver_r = 37.0 / 2;
fanttik_screwdriver_z = 200;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-text";
// render_mode = "print-3mf";

holder_color = "white";
label_color = "black";

// the height of the bin, including the floor the box and the screwdriver rest on
holder_z = 82;

wall_width = 2.0;
clearance = 1.5;

// the gap between the box and the screwdriver; the outside stays a wall_width all the way around
cutout_spacing = 10.0;

label_text = "Fanttik";
label_font = "DejaVu Sans:style=Bold";
label_font_size = 21;
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

// neither one is given a depth, so both run the whole way in and rest on the lip at the bottom
fanttik_cutout_list = [
    BinHelperCube( fanttik_box_x + clearance * 2, fanttik_box_y + clearance * 2 ),
    BinHelperCylinder( fanttik_screwdriver_r + clearance )
    ];

// the gap between them, plus a wall around the outside, sets the holder's x
// and its depth away from the board
fanttik_cutout_location_list = BinHelperEquallySpacedLocations(
    fanttik_cutout_list,
    cutout_spacing,
    wall_width
    );

holder_size_vector = MultiboardConnectorHelperBinSize(
    fanttik_cutout_list,
    holder_z,
    cutout_spacing,
    wall_width
    );

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
        FanttikHolder();

        FanttikLabel();

        FanttikPreviews();
    }
}
else if( render_mode == "print-holder" )
{
    FanttikHolder();
}
else if( render_mode == "print-text" )
{
    FanttikLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        FanttikHolder();

    color( label_color )
        FanttikLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanttikHolder()
{
    difference()
    {
        MultiboardConnectorHelperBin(
            holder_size_vector,
            fanttik_cutout_list,
            fanttik_cutout_location_list,
            wall_width
            );

        // remove the inset text
        FanttikLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label sitting in its recess on the face away from the board
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess
module FanttikLabel( is_cutout = false )
{
    // the text is drawn flat, so tip it onto the front face; it extrudes back out of the
    // holder, so both versions start at the bottom of the recess and the cut eats the extra
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

module FanttikPreviews()
{
    // the box sits inside its cutout by the clearance, the screwdriver is centered in its own,
    // and both lift off the floor they rest on so they don't fight with it in the preview
    offset_z = wall_width + DIFFERENCE_OFFSET;

    translate([
        fanttik_cutout_location_list[ 0 ].x + clearance,
        fanttik_cutout_location_list[ 0 ].y + clearance,
        offset_z
        ])
        FanttikBoxPreview();

    translate([
        fanttik_cutout_location_list[ 1 ].x,
        fanttik_cutout_location_list[ 1 ].y,
        offset_z
        ])
        FanttikScrewdriverPreview();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanttikBoxPreview()
{
    % cube([ fanttik_box_x, fanttik_box_y, fanttik_box_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanttikScrewdriverPreview()
{
    % cylinder(
        h = fanttik_screwdriver_z,
        r = fanttik_screwdriver_r
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
