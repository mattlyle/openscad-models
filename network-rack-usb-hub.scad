////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/network-rack.scad>
include <modules/utils.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

acer_usb_hub_x = 106.2;
acer_usb_hub_y = 31.0;
acer_usb_hub_z = 10.2;

// cord is on right
usb_slot_offset_x = 14.7;
usb_x = 12.9;
usb_slot_spacer_x = 5.6;
usb_z = 5.7;

cord_r = 6.8 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

width_u = 2;

left_ear = true;
right_ear = false;

usb_preview_thickness = 0.01;

face_cutout_clearance_x = 6.0;
face_cutout_clearance_z = 2.0;

part_fit_clearance = 0.15;

cage_wall_width = 2.0;
cage_lip_overhang = 3.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

face_cutout_x = face_cutout_clearance_x * 2
    + usb_x * 4
    + usb_slot_spacer_x * 3;
face_cutout_offset_x = ( NetworkRackFaceWidthU( width_u ) - face_cutout_x ) / 2;

face_cutout_z = usb_z + face_cutout_clearance_z * 2;
face_cutout_offset_z = ( NetworkRackFaceZ() - face_cutout_z ) / 2;

usb_hub_offset_x = face_cutout_offset_x + face_cutout_clearance_x - usb_slot_offset_x;
usb_hub_offset_y = NetworkRackFaceY() + part_fit_clearance;
usb_hub_offset_z = face_cutout_offset_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // % cube([ 430, 150, 44.8 ]);

    translate([ NetworkRackFaceOffsetX( left_ear ), 0, 0 ])
    {
        translate([ usb_hub_offset_x, usb_hub_offset_y, usb_hub_offset_z ])
            AcerUsbHubPreview();

        AcerUsbHubNetworkRackFace();
    }

    BuildPlatePreview();
}
else if( render_mode == "print" )
{
    translate([ NetworkRackFaceOffsetX( left_ear ), 0, 0 ])
        rotate([ 90, 0, 0 ])
            AcerUsbHubNetworkRackFace();
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

    translate([ usb_slot_offset_x, -usb_preview_thickness, slot_offset_z ])
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
        translate([ acer_usb_hub_x - cord_r, acer_usb_hub_y / 2, acer_usb_hub_z / 2 ])
            rotate([ 0, 90, 0 ])
                cylinder( r1 = cord_r, r2 = cord_r * 0.8, h = 20 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AcerUsbHubNetworkRackFace()
{
    // face
    difference()
    {
        NetworkRackFace1U( width_u, left_ear, right_ear );

        // cut out the front
        translate([ face_cutout_offset_x, -DIFFERENCE_CLEARANCE, face_cutout_offset_z ])
            cube([ face_cutout_x, NetworkRackFaceY() + DIFFERENCE_CLEARANCE * 2, face_cutout_z ]);
    }

    cage_x = acer_usb_hub_x + cage_wall_width * 2 + part_fit_clearance * 2;
    cage_y = acer_usb_hub_y + cage_wall_width + part_fit_clearance * 2;
    cage_z = acer_usb_hub_z + cage_wall_width + part_fit_clearance * 2;
    overhang_size = cage_wall_width + cage_lip_overhang;

    cage_left_x = usb_hub_offset_x - cage_wall_width - part_fit_clearance;
    cage_right_x = cage_left_x + cage_x - cage_wall_width;

    cage_front_y = usb_hub_offset_y - part_fit_clearance;
    cage_back_y = usb_hub_offset_y + acer_usb_hub_y + part_fit_clearance;
    cage_right_cord_hole_y = acer_usb_hub_y / 2 - cord_r - part_fit_clearance;

    cage_bottom_z = usb_hub_offset_z - cage_wall_width - part_fit_clearance;

    // cage bottom
    translate([ cage_left_x, cage_front_y, cage_bottom_z ])
        cube([
            cage_x,
            cage_y,
            cage_wall_width
            ]);

    // cage left (full wall)
    translate([ cage_left_x, cage_front_y, cage_bottom_z ])
        cube([ cage_wall_width, cage_y, cage_z ]);

    // cage right (front)
    translate([ cage_right_x, cage_front_y, cage_bottom_z ])
        cube([ cage_wall_width, cage_right_cord_hole_y, cage_z ]);

    // cage back/bottom
    translate([ cage_left_x, cage_back_y, cage_bottom_z ])
        cube([ cage_x, cage_wall_width, overhang_size ]);

    // cage back/left
    translate([ cage_left_x, cage_back_y, cage_bottom_z ])
        cube([ overhang_size, cage_wall_width, cage_z ]);

    // TODO: text should be inset

    translate([ 0, -0.2, 0 ])
    {
        rotate([ 90, 0, 0 ])
        {
            MultilineTextLabel(
                [ "Home", "Assistant", "USB" ],
                face_cutout_offset_x,
                centered_in_area_y = NetworkRackFaceZ(),
                font_size = 10,
                font = "Liberation Sans:style=bold"
                );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
