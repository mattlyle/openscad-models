////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <../modules/network-rack-face.scad>
include <../modules/utils.scad>
include <../modules/cord-clip.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

acer_usb_hub_x = 106.2;
acer_usb_hub_y = 31.0;
acer_usb_hub_z = 10.2;

// measurements if cord is on right
usb_slot_left_offset_x = 14.7;
usb_slot_right_offset_x = 22.0;
usb_x = 12.9;
usb_slot_spacer_x = 5.6;
usb_z = 5.7;

cord_exit_r = 6.8 / 2;
cord_main_r = 4.1 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-face";
// render_mode = "print-text";

width_u = 2;

left_ear = true;
right_ear = false;
left_bracket = false;
right_bracket = true;

usb_preview_thickness = 0.01;

face_cutout_clearance_x = 6.0;
face_cutout_clearance_z = 2.0;

part_fit_clearance = 0.15;

cage_wall_width = 2.0;

preview_offset_x = 1.0;

// this cuts into the actual network mount around the hub
face_depth = 1.2;

finger_hole_r = 10.0;

cutout_offset_percent_x = 0.7;
text_lines = [ "Home", "Assistant", "USB Hub" ];
svg_path = "../assets/USB_icon.svg";
decoration_depth = 0.4;

manual_svg_offset_x = -30;
manual_svg_offset_z = -5;
svg_scale = 0.3;
svg_rotate = -45.0;

flip_usb_hub = true;

cord_clip_offset_x = 2.0;
cord_clip_offset_z = cage_wall_width ;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

usb_slot_offset_x = flip_usb_hub
    ? usb_slot_right_offset_x
    : usb_slot_left_offset_x;

face_cutout_x = face_cutout_clearance_x * 2
    + usb_x * 4
    + usb_slot_spacer_x * 3;
face_cutout_offset_x = ( NetworkRackFaceWidthU( width_u ) - face_cutout_x ) * cutout_offset_percent_x;

face_cutout_z = usb_z + face_cutout_clearance_z * 2;
face_cutout_offset_z = ( NetworkRackFaceZ() - face_cutout_z ) / 2;

usb_hub_offset_x = face_cutout_offset_x + face_cutout_clearance_x - usb_slot_offset_x;
usb_hub_offset_y = face_depth + part_fit_clearance;
usb_hub_offset_z = face_cutout_offset_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), 0, 0 ])
    {
        PositionAcerUsbHub()
            AcerUsbHubPreview();

        AcerUsbHubNetworkRackFace();

        // show a preview of another face beside it
        translate([ NetworkRackFaceWidthU( width_u ) + preview_offset_x, 0, 0 ])
            NetworkRackFace1U(
                4 - width_u,
                false,
                true,
                true,
                false );
    }

    BuildPlatePreview();
}
else if( render_mode == "print-face" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            AcerUsbHubNetworkRackFace();
}
else if( render_mode == "print-text" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), NetworkRackFaceZ(), 0 ])
        rotate([ 90, 0, 0 ])
            AcerUsbHubNetworkRackFaceDecoration();
}
else
{
    assert( false, str( "unknown render_mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AcerUsbHubPreview()
{
    color([ 0.3, 0.3, 0.3 ])
        cube([ acer_usb_hub_x, acer_usb_hub_y, acer_usb_hub_z ]);

    slot_offset_z = ( acer_usb_hub_z - usb_z ) / 2;

    translate([ usb_slot_left_offset_x, -usb_preview_thickness, slot_offset_z ])
    {
        for( i = [ 0 : 3 ] )
        {
            color([ 0.8, 0.8, 0 ])
                translate([ i * ( usb_slot_spacer_x + usb_x ), 0, 0 ])
                    cube([ usb_x, usb_preview_thickness, usb_z ]);
        }
    }

    // cord
    color([ 0.3, 0.3, 0.3 ])
        translate([ acer_usb_hub_x - cord_exit_r, acer_usb_hub_y / 2, acer_usb_hub_z / 2 ])
            rotate([ 0, 90, 0 ])
                cylinder( r1 = cord_exit_r, r2 = cord_main_r, h = 20 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AcerUsbHubNetworkRackFace()
{
    difference()
    {
        NetworkRackHolder(
            width_u,
            cutout_x = face_cutout_x,
            cutout_z = face_cutout_z,
            cutout_offset_x = face_cutout_offset_x,
            cutout_offset_z = face_cutout_offset_z,
            object_x = acer_usb_hub_x,
            object_y = acer_usb_hub_y,
            object_z = acer_usb_hub_z,
            object_offset_x = usb_hub_offset_x,
            object_offset_y = usb_hub_offset_y,
            object_offset_z = usb_hub_offset_z,
            part_fit_clearance = part_fit_clearance,
            left_ear = left_ear,
            right_ear = right_ear,
            left_bracket = left_bracket,
            right_bracket = right_bracket
        );

        // cut out the text / logo
        AcerUsbHubNetworkRackFaceDecoration();

        cage_x = NetworkRackFaceCageX( acer_usb_hub_x, part_fit_clearance );
        cage_y = NetworkRackFaceCageY( acer_usb_hub_y, part_fit_clearance );
        cage_z = NetworkRackFaceCageZ( acer_usb_hub_z, part_fit_clearance );

        cage_left_x = NetworkRackFaceCageLeftX( usb_hub_offset_x, part_fit_clearance );
        cage_right_x = NetworkRackFaceCageRightX( acer_usb_hub_x, usb_hub_offset_x, part_fit_clearance );

        cage_front_y = NetworkRackFaceCageFrontY( usb_hub_offset_y, part_fit_clearance );
        cage_back_y = NetworkRackFaceCageBackY( usb_hub_offset_y, acer_usb_hub_y, part_fit_clearance );

        cage_bottom_z = NetworkRackFaceCageBottomZ( usb_hub_offset_z, part_fit_clearance );

        // cut out the cord exit
        translate([
            ( flip_usb_hub ? cage_left_x : cage_right_x ) - DIFFERENCE_CLEARANCE,
            cage_front_y + cage_y / 2 - face_depth,
            cage_bottom_z + cage_z
            ])
            rotate([ 0, 90, 0 ])
                cylinder(
                    r = cage_z - cord_exit_r,
                    h = cage_wall_width + DIFFERENCE_CLEARANCE * 2 );

        // remove the finger hole
        translate([ cage_left_x + cage_x / 2, cage_back_y - DIFFERENCE_CLEARANCE, cage_bottom_z + cage_z ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = finger_hole_r,
                    h = NetworkRackFaceCageWidth() + DIFFERENCE_CLEARANCE * 2);
    }


    // cord clip
    translate([
        cord_main_r + cage_wall_width + part_fit_clearance + cord_clip_offset_x,
        NetworkRackFaceY(),
        cage_wall_width + cord_clip_offset_z
        ])
        rotate([ -90, 0, 0 ])
            CordClip(
                inner_r = cord_main_r + part_fit_clearance,
                wall_thickness = cage_wall_width,
                length = cage_wall_width * 2,
                show_preview = render_mode == "preview" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AcerUsbHubNetworkRackFaceDecoration()
{
    // text
    NetworkRackFaceLabel(
        text_lines,
        centered_in_area_x = face_cutout_offset_x,
        text_depth = decoration_depth );

    // logo svg
    NetworkRackFaceSVG(
        svg_path,
        NetworkRackFaceWidthU( width_u ) + manual_svg_offset_x,
        manual_svg_offset_z,
        scale_xy = svg_scale,
        rotate_degrees = svg_rotate );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PositionAcerUsbHub()
{
    if( flip_usb_hub )
    {
        translate([
            usb_hub_offset_x + acer_usb_hub_x,
            usb_hub_offset_y,
            usb_hub_offset_z + acer_usb_hub_z
            ])
            rotate([ 0, 180, 0 ])
                children();
    }
    else
    {
        translate([ usb_hub_offset_x, usb_hub_offset_y, usb_hub_offset_z ])
            children();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
