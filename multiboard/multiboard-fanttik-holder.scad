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

// the height of the bin as it prints, standing on the lip the box and the screwdriver rest on
holder_z = 80;

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
fanttik_cutouts = [
    BinHelperCube( fanttik_box_x + clearance * 2, fanttik_box_y + clearance * 2 ),
    BinHelperCylinder( fanttik_screwdriver_r + clearance )
    ];

// the gap between them, plus a wall around the outside, sets the holder's x
// and its depth away from the board
fanttik_cutout_locations = BinHelperEquallySpacedLocations(
    fanttik_cutouts,
    cutout_spacing,
    wall_width
    );

holder_size_vector = MultiboardConnectorHelperBinSize(
    fanttik_cutouts,
    holder_z,
    cutout_spacing,
    wall_width
    );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    FanttikStanding()
    {
        translate([ 0, 0, -multiboard_cell_height ])
            color( workroom_multiboard_color )
                MultiboardMockUpTile( 12, 4 );

        translate([
            multiboard_cell_size - MultiboardConnectorBackAltXOffset( holder_size_vector[ 0 ] ),
            0,
            0
            ])
        {
            FanttikHolder();

            FanttikLabel();

            FanttikPreviews();
        }
    }
}
else if( render_mode == "print-holder" )
{
    FanttikStanding()
        FanttikHolder();
}
else if( render_mode == "print-text" )
{
    FanttikStanding()
        FanttikLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        FanttikStanding()
            FanttikHolder();

    color( label_color )
        FanttikStanding()
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
            fanttik_cutouts,
            fanttik_cutout_locations,
            wall_width
            );

        // remove the inset text
        FanttikLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label sitting in its recess, in the holder's own orientation
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess
module FanttikLabel( is_cutout = false )
{
    translate([
        0,
        0,
        multiboard_connector_back_z + holder_size_vector[ 2 ] - label_depth
        ])
        CenteredTextLabel(
            label_text,
            centered_in_area_x = holder_size_vector[ 0 ],
            centered_in_area_y = holder_size_vector[ 1 ],
            depth = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth,
            font_size = label_font_size,
            font = label_font,
            color = is_cutout ? undef : label_color
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// everything is modelled lying on its back, but it prints standing on its lip - preview it
// that way too, so holder_z reads as the height it really is
module FanttikStanding()
{
    translate([ 0, holder_size_vector[ 2 ] + multiboard_connector_back_z, 0 ])
        rotate([ 90, 0, 0 ])
            children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanttikPreviews()
{
    // the box sits inside its cutout by the clearance, the screwdriver is centered in its own,
    // and both lift off the lip they rest on so they don't fight with it in the preview
    box_offset_x = fanttik_cutout_locations[ 0 ][ 0 ] + clearance;
    box_offset_z = multiboard_connector_back_z + fanttik_cutout_locations[ 0 ][ 1 ] + clearance;

    screwdriver_offset_x = fanttik_cutout_locations[ 1 ][ 0 ];
    screwdriver_offset_z = multiboard_connector_back_z + fanttik_cutout_locations[ 1 ][ 1 ];

    offset_y = wall_width + DIFFERENCE_OFFSET;

    // both are drawn standing up their own z, so tip them over to lie along the holder's y
    // the box swings down as it tips, so lift it back up by the depth it takes up
    translate([ box_offset_x, offset_y, box_offset_z + fanttik_box_y ])
        rotate([ -90, 0, 0 ])
            FanttikBoxPreview();

    translate([ screwdriver_offset_x, offset_y, screwdriver_offset_z ])
        rotate([ -90, 0, 0 ])
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
