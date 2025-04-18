////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <../modules/network-rack-face.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

odroid_n2plus_x = 96.0;
odroid_n2plus_y = 90.0;
odroid_n2plus_z = 27.0;

odroid_n2plus_face_cutout_x = 52.0;
odroid_n2plus_face_cutout_z = 23.0;

hard_drive_x = 64.0;
hard_drive_y = 69.0;
hard_drive_z = 11.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-face";
// render_mode = "print-text";

width_quarters = 2;

left_ear = true;
right_ear = false;
left_bracket = false;
right_bracket = true;

part_fit_clearance = 0.2;

// this cuts into the actual network mount around the hub
face_depth = 1.2;

finger_hole_r = 10.0;

odroid_n2plus_cutout_offset_percent_x = 0.60;

preview_offset_x = 1.0;

text_lines = [ "Home", "Assistant" ];
svg_path = "../assets/Home_Assistant_logo_simple.svg";
decoration_depth = 0.4;

manual_svg_offset_x = -40;
manual_svg_offset_z = 14;
svg_scale = 0.3;
svg_rotate = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

odroid_n2plus_face_cutout_offset_x = ( NetworkRackFaceWidth( width_quarters ) - odroid_n2plus_x ) * odroid_n2plus_cutout_offset_percent_x;
odroid_n2plus_face_cutout_offset_z = ( NetworkRackFaceZ() - odroid_n2plus_face_cutout_z ) / 2;

odroid_n2plus_offset_x = face_cutout_offset_x - ( odroid_n2plus_x - face_cutout_x ) / 2;
odroid_n2plus_offset_y = face_depth + part_fit_clearance;
odroid_n2plus_offset_z = face_cutout_offset_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), 0, 0 ])
    {
        translate([ odroid_n2plus_offset_x, odroid_n2plus_offset_y, odroid_n2plus_offset_z ])
            OdroidN2PlusPreview();

        OdroidN2PlusNetworkRackFace();

        // show a preview of another face beside it
        translate([ NetworkRackFaceWidth( width_quarters ) + preview_offset_x, 0, 0 ])
            NetworkRackFace1U(
                4 - width_quarters,
                false,
                true,
                true,
                false
                );
    }

    BuildPlatePreview();
}
else if( render_mode == "print-face" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            OdroidN2PlusNetworkRackFace();
}
else if( render_mode == "print-text" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            OdroidN2PlusNetworkRackFaceDecoration();
}
else
{
    assert( false, str( "unknown render_mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OdroidN2PlusPreview()
{
    %cube([ odroid_n2plus_x, odroid_n2plus_y, odroid_n2plus_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OdroidN2PlusNetworkRackFace()
{
    difference()
    {
        NetworkRackHolder(
            width_quarters = width_quarters,
            cutout_x = face_cutout_x,
            cutout_z = face_cutout_z,
            cutout_offset_x = face_cutout_offset_x,
            cutout_offset_z = face_cutout_offset_z,
            object_x = odroid_n2plus_x,
            object_y = odroid_n2plus_y,
            object_z = odroid_n2plus_z,
            object_offset_x = odroid_n2plus_offset_x,
            object_offset_y = odroid_n2plus_offset_y,
            object_offset_z = odroid_n2plus_offset_z,
            part_fit_clearance = part_fit_clearance,
            left_ear = left_ear,
            right_ear = right_ear,
            left_bracket = left_bracket,
            right_bracket = right_bracket
        );

        // cut out the text / logo
        OdroidN2PlusNetworkRackFaceDecoration();
/*
        // remove a finger hole to help removing the object
        cage_x = NetworkRackFaceCageX( odroid_n2plus_x, part_fit_clearance );
        cage_y = NetworkRackFaceCageY( odroid_n2plus_y, part_fit_clearance );
        cage_z = NetworkRackFaceCageZ( odroid_n2plus_z, part_fit_clearance );

        cage_left_x = NetworkRackFaceCageLeftX( odroid_n2plus_offset_x, part_fit_clearance );
        cage_right_x = NetworkRackFaceCageRightX( odroid_n2plus_x, odroid_n2plus_offset_x, part_fit_clearance );

        cage_back_y = NetworkRackFaceCageBackY( odroid_n2plus_offset_y, odroid_n2plus_y, part_fit_clearance );

        cage_bottom_z = NetworkRackFaceCageBottomZ( odroid_n2plus_offset_z, part_fit_clearance );

        // remove the finger hole
        translate([
            cage_left_x + cage_x / 2,
            cage_back_y - DIFFERENCE_CLEARANCE,
            cage_bottom_z + cage_z
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = finger_hole_r,
                    h = NetworkRackFaceCageWidth() + DIFFERENCE_CLEARANCE * 2
                    );
*/
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OdroidN2PlusNetworkRackFaceDecoration()
{
    // text
    // NetworkRackFaceLabel(
    //     text_lines,
    //     centered_in_area_x = face_cutout_offset_x,
    //     text_depth = decoration_depth );

    // logo svg
    NetworkRackFaceSVG(
        svg_path,
        NetworkRackFaceWidth( width_quarters ) + manual_svg_offset_x,
        manual_svg_offset_z,
        scale_xy = svg_scale,
        rotate_degrees = svg_rotate
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

