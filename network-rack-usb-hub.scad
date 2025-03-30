////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/network-rack.scad>
include <modules/utils.scad>
include <modules/text-label.scad>
include <modules/cord-clip.scad>

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

usb_preview_thickness = 0.01;

face_cutout_clearance_x = 6.0;
face_cutout_clearance_z = 2.0;

part_fit_clearance = 0.15;

cage_wall_width = 2.0;

// this cuts into the actual network mount around the hub
face_depth = 1.2;

flip_usb_hub = true;

cord_clip_offset_x = 2.0;
cord_clip_offset_z = 2.0;

cutout_offset_percent_x = 0.7;

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

back_offset_y = NetworkRackFaceY();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), 0, 0 ])
    {
        PositionAcerUsbHub()
            AcerUsbHubPreview();

        AcerUsbHubNetworkRackFace();
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
            AcerUsbHubNetworkRackFaceText();
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
    // face
    difference()
    {
        NetworkRackFace1U( width_u, left_ear, right_ear );

        // cut out the front where the USBs show
        translate([ face_cutout_offset_x, -DIFFERENCE_CLEARANCE, face_cutout_offset_z ])
            cube([ face_cutout_x, back_offset_y + DIFFERENCE_CLEARANCE * 2, face_cutout_z ]);

        // cut out more of the front so it fits more snug
        translate([ -part_fit_clearance, 0, -part_fit_clearance ])
            PositionAcerUsbHub()
                cube([
                    acer_usb_hub_x + part_fit_clearance * 2,
                    acer_usb_hub_y,
                    acer_usb_hub_z + part_fit_clearance * 2
                    ]);

        // cut out the text
        NetoworkRackFaceLabel( face_cutout_offset_x, color = false );
    }

    cage_x = acer_usb_hub_x + cage_wall_width * 2 + part_fit_clearance * 2;
    cage_y = acer_usb_hub_y + cage_wall_width + part_fit_clearance * 2;
    cage_z = acer_usb_hub_z + cage_wall_width + part_fit_clearance * 2;

    cage_left_x = usb_hub_offset_x - cage_wall_width - part_fit_clearance;
    cage_right_x = cage_left_x + cage_x - cage_wall_width;

    cage_front_y = usb_hub_offset_y - part_fit_clearance;
    cage_back_y = usb_hub_offset_y + acer_usb_hub_y + part_fit_clearance;
    cage_right_cord_hole_y = acer_usb_hub_y / 2 - cord_exit_r - part_fit_clearance;

    cage_bottom_z = usb_hub_offset_z - cage_wall_width - part_fit_clearance;

    // cage bottom
    translate([ cage_left_x, cage_front_y, cage_bottom_z ])
        cube([ cage_x, cage_y, cage_wall_width ]);

    // cage full side
    translate([ flip_usb_hub ? cage_right_x : cage_left_x, cage_front_y, cage_bottom_z ])
        cube([ cage_wall_width, cage_y, cage_z ]);

    // cage side with cord cutout
    difference()
    {
        translate([ flip_usb_hub ? cage_left_x : cage_right_x, cage_front_y, cage_bottom_z ])
            cube([ cage_wall_width, cage_y, cage_z ]);

        translate([
            ( flip_usb_hub ? cage_left_x : cage_right_x ) - DIFFERENCE_CLEARANCE,
            cage_front_y + cage_y / 2 - face_depth,
            cage_bottom_z + cage_z
            ])
            rotate([ 0, 90, 0 ])
                cylinder( r = cage_z - cord_exit_r, h = cage_wall_width + DIFFERENCE_CLEARANCE * 2 );
    }

    // cage back/bottom
    translate([ cage_left_x, cage_back_y, cage_bottom_z ])
        cube([ cage_x, cage_wall_width, cage_z ]);

    // cord clip
    translate([
        cord_main_r + cage_wall_width + part_fit_clearance + cord_clip_offset_x,
        back_offset_y,
        cage_wall_width + cord_clip_offset_z
        ])
        rotate([ -90, 0, 0 ])
            CordClip(
                inner_r = cord_main_r + part_fit_clearance,
                wall_thickness = cage_wall_width,
                length = cage_wall_width,
                show_preview = render_mode == "preview"
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AcerUsbHubNetworkRackFaceText()
{
    translate([ 0, -DIFFERENCE_CLEARANCE, 0 ])
        NetoworkRackFaceLabel( face_cutout_offset_x );
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
