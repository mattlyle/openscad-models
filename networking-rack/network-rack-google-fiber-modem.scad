////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <../modules/network-rack-face.scad>
include <../modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

google_fiber_modem_x = 82.90;
google_fiber_modem_y = 89.8;
google_fiber_modem_z = 27.0;

face_cutout_x = 72.0;
face_cutout_z = 21.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-face";
// render_mode = "print-text";

width_quarters = 2;

left_ear = false;
right_ear = true;
left_bracket = true;
right_bracket = false;

part_fit_clearance = 0.2;

cage_wall_width = 2.0;

// this cuts into the actual network mount around the hub
face_depth = 1.2;

finger_hole_r = 10.0;

preview_offset_x = 1.0;

cutout_offset_percent_x = 0.70;
text_lines = [ "Google", "Fiber", "Modem" ];
svg_path = "../assets/Google_Fiber_Logo.svg";
decoration_depth = 0.4;

// for some reason the text is not centered in the face
manual_text_z_offset = 1.8;

manual_svg_offset_x = -38;
manual_svg_offset_z = 6;
svg_scale = 0.12;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

face_cutout_offset_x = ( NetworkRackFaceWidth( width_quarters ) - google_fiber_modem_x ) * cutout_offset_percent_x;
face_cutout_offset_z = ( NetworkRackFaceZ() - face_cutout_z ) / 2;

google_fiber_modem_offset_x = face_cutout_offset_x - ( google_fiber_modem_x - face_cutout_x ) / 2;
google_fiber_modem_offset_y = face_depth + part_fit_clearance;
google_fiber_modem_offset_z = face_cutout_offset_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), 0, 0 ])
    {
        translate([ google_fiber_modem_offset_x, google_fiber_modem_offset_y, google_fiber_modem_offset_z ])
            GoogleFiberModemPreview();

        GoogleFiberModemNetworkRackFace();

        // show a preview of another face beside it
        // translate([ NetworkRackFaceWidth( width_quarters ) + preview_offset_x, 0, 0 ])
        //     NetworkRackFace1U(
        //         4 - width_quarters,
        //         false,
        //         true,
        //         true,
        //         false );
    }

    BuildPlatePreview();
}
else if( render_mode == "print-face" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            GoogleFiberModemNetworkRackFace();
}
else if( render_mode == "print-text" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            GoogleFiberModemNetworkRackFaceDecoration();
}
else
{
    assert( false, str( "unknown render_mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GoogleFiberModemPreview()
{
    RoundedCubeAlt2(
        google_fiber_modem_x,
        google_fiber_modem_y,
        google_fiber_modem_z,
        r = 4.0,
        round_top = false,
        round_bottom = false,
        round_left = true,
        round_right = true,
        center = false
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GoogleFiberModemNetworkRackFace()
{
    difference()
    {
        NetworkRackHolder(
            width_quarters = width_quarters,
            cutout_x = face_cutout_x,
            cutout_z = face_cutout_z,
            cutout_offset_x = face_cutout_offset_x,
            cutout_offset_z = face_cutout_offset_z,
            object_x = google_fiber_modem_x,
            object_y = google_fiber_modem_y,
            object_z = google_fiber_modem_z,
            object_offset_x = google_fiber_modem_offset_x,
            object_offset_y = google_fiber_modem_offset_y,
            object_offset_z = google_fiber_modem_offset_z,
            part_fit_clearance = part_fit_clearance,
            left_ear = left_ear,
            right_ear = right_ear,
            left_bracket = left_bracket,
            right_bracket = right_bracket,
            include_cage = true,
            cage_finger_hole = true
        );

        // cut out the text / logo
        GoogleFiberModemNetworkRackFaceDecoration();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GoogleFiberModemNetworkRackFaceDecoration()
{
    // text
    translate([ 0, -DIFFERENCE_CLEARANCE, manual_text_z_offset ])
        NetworkRackFaceLabel(
            text_lines,
            centered_in_area_x = face_cutout_offset_x,
            text_depth = decoration_depth
            );

    // logo svg
    NetworkRackFaceSVG(
        svg_path,
        NetworkRackFaceWidth( width_quarters ) + manual_svg_offset_x,
        manual_svg_offset_z,
        scale_xy = svg_scale
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

