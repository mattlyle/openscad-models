////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <../modules/network-rack-face.scad>
include <../modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

hue_bridge_x = 90.0;
hue_bridge_y = 90.0;
hue_bridge_z = 27.0;

face_cutout_x = 52.0;
face_cutout_z = 23.0;

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

// this cuts into the actual network mount around the hub
face_depth = 1.2;

finger_hole_r = 10.0;

cutout_offset_percent_x = 0.85;

preview_offset_x = 1.0;

text_lines = [ "Philips", "Hue Bridge" ];
svg_path = "../assets/philips-hue-simple.svg";
decoration_depth = 0.4;

manual_svg_offset_x = -40;
manual_svg_offset_z = 14;
svg_scale = 0.3;
svg_rotate = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

face_cutout_offset_x = ( NetworkRackFaceWidth( width_quarters ) - hue_bridge_x ) * cutout_offset_percent_x;
face_cutout_offset_z = ( NetworkRackFaceZ() - face_cutout_z ) / 2;

hue_bridge_offset_x = face_cutout_offset_x - ( hue_bridge_x - face_cutout_x ) / 2;
hue_bridge_offset_y = face_depth + part_fit_clearance;
hue_bridge_offset_z = face_cutout_offset_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), 0, 0 ])
    {
        translate([ hue_bridge_offset_x, hue_bridge_offset_y, hue_bridge_offset_z ])
            HueBridgePreview();

        HueBridgeNetworkRackFace();

        // show a preview of another face beside it
        // translate([ NetworkRackFaceWidth( width_quarters ) + preview_offset_x, 0, 0 ])
        //     NetworkRackFace1U(
        //         4 - width_quarters,
        //         false,
        //         true,
        //         true,
        //         false
        //         );
    }

    BuildPlatePreview();
}
else if( render_mode == "print-face" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            HueBridgeNetworkRackFace();
}
else if( render_mode == "print-text" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            HueBridgeNetworkRackFaceDecoration();
}
else
{
    assert( false, str( "unknown render_mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HueBridgePreview()
{
    RoundedCubeAlt2(
        hue_bridge_x,
        hue_bridge_y,
        hue_bridge_z,
        r = 10.0,
        round_top = false,
        round_bottom = false,
        round_left = true,
        round_right = true,
        center = false
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HueBridgeNetworkRackFace()
{
    difference()
    {
        NetworkRackHolder(
            width_quarters = width_quarters,
            cutout_x = face_cutout_x,
            cutout_z = face_cutout_z,
            cutout_offset_x = face_cutout_offset_x,
            cutout_offset_z = face_cutout_offset_z,
            object_x = hue_bridge_x,
            object_y = hue_bridge_y,
            object_z = hue_bridge_z,
            object_offset_x = hue_bridge_offset_x,
            object_offset_y = hue_bridge_offset_y,
            object_offset_z = hue_bridge_offset_z,
            part_fit_clearance = part_fit_clearance,
            left_ear = left_ear,
            right_ear = right_ear,
            left_bracket = left_bracket,
            right_bracket = right_bracket,
            include_cage = true,
            cage_finger_hole = true
            );

        // cut out the text / logo
        HueBridgeNetworkRackFaceDecoration();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HueBridgeNetworkRackFaceDecoration()
{
    // text
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
        scale_xy = svg_scale,
        rotate_degrees = svg_rotate
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

