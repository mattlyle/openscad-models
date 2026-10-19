include <modules/utils.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

evil_pumpkin_mount_r = 84.9 / 2;
evil_pumpkin_mount_z = 2.5;

evil_pumpkin_mount_screw_r = 3.0 / 2;
evil_pumpkin_mount_screw_offset_r = 3.5;
evil_pumpkin_mount_screw_count = 3;
// evil_pumpkin_mount_base_z = 2.6;
evil_pumpkin_mount_screw_flange_r = 12.5 / 2;
evil_pumpkin_mount_screw_flange_z = 3.3;
evil_pumpkin_mount_screw_head_r = 4.2 / 2;

esp32_x = 28.6;
esp32_y = 51.5;
esp32_z = 12.6;
esp32_mount_holes_r = 3.0 / 2;
esp32_usb_x = 11.7;

// center of the usb socket above the top of the board
esp32_usb_offset_z = 1.5;
esp32_pcb_z = 1.6;

// M2x8 screws hold the board down
esp32_screw_r = 1.98 / 2;

// mount hole centers from the board edges, from the DOIT DevKit V1 KiCad footprint
esp32_mount_hole_offset_x = 2.3;
esp32_mount_hole_offset_y = 2.0;

// VIN, GND and D13 at the usb end of the left header, the first one centered this far from the
// usb edge
esp32_pin_pitch = 2.54;
esp32_power_pin_count = 3;
esp32_power_pin_offset_y = 9.9;

usb_plug_r = 10.6 / 2;
usb_cord_r = 4.15 / 2;

// from the board edge to where the plug's overmold ends and the cord starts
usb_plug_z = 30.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";
// render_mode = "print-electronics-holder";

stand_base_r = 100.0 / 2;
stand_z = 100.0;
stand_wall = 3.6;
stand_usb_hole_offset_z = 30;
stand_usb_hole_angle = 180;

// a separate disc that drops into the top of the stand onto a 45 degree ledge, flush with the rim
electronics_holder_z = 3.0;
stand_ledge = 2.0;
electronics_holder_clearance = 0.3;

// how far above its seat the electronics holder floats in preview, to show how it fits
electronics_holder_preview_lift_z = 20;

// where the back of the esp32 holder stands, with the board facing the -y edge; the usb cord slides
// into a slot from that edge
electronics_holder_esp32_offset_y = -20;
electronics_holder_cord_clearance = 0.3;

evil_pumpkin_mount_screw_clearance = 0.2;

base_board_screw_count = 4;
base_z = 4.0;
base_r = 120 / 2;
base_screw_r = 3.4 / 2;
base_screw_cone_z = 2.7;
base_screw_cone_top = 6.5 / 2;

// on top of the base, between the screws at 0 and 90 degrees
version_label_angle = 45;
version_label_font = "Liberation Sans:style=Bold";
version_label_font_size = 5;
version_label_depth = 0.5;
version_label_area_x = 20;
version_label_area_y = 8;

esp32_holder_base_z = 2.0;
esp32_holder_wall = 2.0;
esp32_holder_clearance = 0.3;

// lifts the board off the plate, clear of the solder joints on its back
esp32_holder_standoff_r = 3.0;
esp32_holder_standoff_z = 2.0;

// the board top sits this far below the top of the wall
esp32_holder_board_recess_z = 2.0;

// the screw pilot holes are this much smaller than the screw, per side, so it threads into the
// plastic; about the thread root for M2
esp32_holder_screw_bite = 0.175;

// THIS IS AUTO UPDATED BY THE BUILD SCRIPT - DO NOT EDIT
BUILD_SCRIPT_VERSION = "v1";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

evil_pumpkin_mount_screw_center_r = evil_pumpkin_mount_r + evil_pumpkin_mount_screw_offset_r;

// tall enough for a 45 degree support to reach from the rim out to the far edge of the flange
evil_pumpkin_mount_screw_support_z = evil_pumpkin_mount_screw_offset_r
    + evil_pumpkin_mount_screw_flange_r;

electronics_holder_seat_z = stand_z - electronics_holder_z;
stand_ledge_inner_r = evil_pumpkin_mount_r - stand_wall - stand_ledge;

// where the 45 degree underside of the ledge meets the sloped inside of the stand wall
stand_ledge_bottom_z = ( electronics_holder_seat_z + stand_ledge_inner_r - _StandInnerR( 0 ) )
    / ( 1 - ( _StandInnerR( 0 ) - _StandInnerR( stand_z ) ) / stand_z );

esp32_holder_x = esp32_x + ( esp32_holder_clearance + esp32_holder_wall ) * 2;
esp32_holder_y = esp32_y + ( esp32_holder_clearance + esp32_holder_wall ) * 2;

esp32_holder_z = esp32_holder_base_z + esp32_holder_standoff_z + esp32_pcb_z
    + esp32_holder_board_recess_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    EvilPumpkinStand();

    translate([ 0, 0, electronics_holder_seat_z + electronics_holder_preview_lift_z ])
        ElectronicsHolder();

    translate([ -base_r * 2, 0, 0 ])
        ElectronicsHolder();

    translate([ base_r + esp32_holder_x, 0, 0 ])
        ESP32Holder();
}
else if( render_mode == "print" )
{
    EvilPumpkinStand();
}
else if( render_mode == "print-electronics-holder" )
{
    ElectronicsHolder();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EvilPumpkinStand()
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    // stand cone
                    cylinder(
                        r1 = stand_base_r,
                        r2 = evil_pumpkin_mount_r,
                        h = stand_z
                        );

                    // base flange
                    cylinder(
                        r = base_r,
                        h = base_z
                        );
                }

                // hollow inside, leaving the ledge for the electronics holder
                _StandHollow();
            }

            // pumpkin mount screw flanges
            _StandMountScrewFlanges();

            _StandMountScrewSupports();
        }

        // pumpkin mount screws
        _StandMountScrewHoles();

        _StandMountScrewHeadCutouts();

        // base screws
        _BaseScrewHoles();

        // usb cord
        _StandUSBHole();
    }

    // raised, reading along the base with the bottom of the text toward the stand
    rotate([ 0, 0, version_label_angle + 90 ])
        translate([ 0, -( stand_base_r + base_r ) / 2, base_z - DIFFERENCE_CLEARANCE ])
            _VersionLabel( version_label_depth + DIFFERENCE_CLEARANCE );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewFlanges()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        rotate([ 0, 0, screw_index * 360 / evil_pumpkin_mount_screw_count ])
            translate([
                evil_pumpkin_mount_screw_center_r,
                0,
                stand_z - evil_pumpkin_mount_screw_flange_z
                ])
                cylinder(
                    r = evil_pumpkin_mount_screw_flange_r,
                    h = evil_pumpkin_mount_screw_flange_z
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewHoles()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        rotate([ 0, 0, screw_index * 360 / evil_pumpkin_mount_screw_count ])
            translate([
                evil_pumpkin_mount_screw_center_r,
                0,
                stand_z - evil_pumpkin_mount_screw_flange_z - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = evil_pumpkin_mount_screw_r + evil_pumpkin_mount_screw_clearance,
                    h = evil_pumpkin_mount_screw_flange_z + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewSupports()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        // a 45 degree collar around the rim, cut down to this flange's footprint
        intersection()
        {
            translate([
                0,
                0,
                stand_z - evil_pumpkin_mount_screw_flange_z - evil_pumpkin_mount_screw_support_z
                ])
                cylinder(
                    r1 = evil_pumpkin_mount_r,
                    r2 = evil_pumpkin_mount_r + evil_pumpkin_mount_screw_support_z,
                    h = evil_pumpkin_mount_screw_support_z
                    );

            rotate([ 0, 0, screw_index * 360 / evil_pumpkin_mount_screw_count ])
                translate([
                    evil_pumpkin_mount_screw_center_r,
                    0,
                    stand_z - evil_pumpkin_mount_screw_flange_z
                        - evil_pumpkin_mount_screw_support_z
                    ])
                    cylinder(
                        r = evil_pumpkin_mount_screw_flange_r,
                        h = evil_pumpkin_mount_screw_support_z
                        );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// room under each flange for the screw head and a driver, up through the support
module _StandMountScrewHeadCutouts()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        rotate([ 0, 0, screw_index * 360 / evil_pumpkin_mount_screw_count ])
            translate([
                evil_pumpkin_mount_screw_center_r,
                0,
                stand_z - evil_pumpkin_mount_screw_flange_z
                    - evil_pumpkin_mount_screw_support_z - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = evil_pumpkin_mount_screw_head_r + evil_pumpkin_mount_screw_clearance,
                    h = evil_pumpkin_mount_screw_support_z + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// countersunk from the top, centered in the base between the stand and the edge
module _BaseScrewHoles()
{
    for( screw_index = [ 0 : base_board_screw_count - 1 ] )
    {
        rotate([ 0, 0, screw_index * 360 / base_board_screw_count ])
            translate([ ( stand_base_r + base_r ) / 2, 0, 0 ])
            {
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder(
                        r = base_screw_r,
                        h = base_z - base_screw_cone_z + DIFFERENCE_CLEARANCE * 2
                        );

                translate([ 0, 0, base_z - base_screw_cone_z ])
                    cylinder(
                        r1 = base_screw_r,
                        r2 = base_screw_cone_top,
                        h = base_screw_cone_z + DIFFERENCE_CLEARANCE
                        );
            }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VersionLabel( depth )
{
    translate([
        -version_label_area_x / 2,
        -version_label_area_y / 2,
        0
        ])
        CenteredTextLabel(
            BUILD_SCRIPT_VERSION,
            centered_in_area_x = version_label_area_x,
            centered_in_area_y = version_label_area_y,
            depth = depth,
            font_size = version_label_font_size,
            font = version_label_font,
            color = undef
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// out through the wall from the center, which is already hollow
module _StandUSBHole()
{
    rotate([ 0, 0, stand_usb_hole_angle ])
        translate([ 0, 0, stand_usb_hole_offset_z ])
            rotate([ 90, 0, 90 ])
                linear_extrude( stand_base_r + DIFFERENCE_CLEARANCE )
                    Teardrop( usb_plug_r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// centered on the board, usb end toward -y, power pins on the -x side
module ESP32Holder()
{
    difference()
    {
        union()
        {
            difference()
            {
                translate([ -esp32_holder_x / 2, -esp32_holder_y / 2, 0 ])
                    cube([ esp32_holder_x, esp32_holder_y, esp32_holder_z ]);

                translate([
                    -esp32_x / 2 - esp32_holder_clearance,
                    -esp32_y / 2 - esp32_holder_clearance,
                    esp32_holder_base_z
                    ])
                    cube([
                        esp32_x + esp32_holder_clearance * 2,
                        esp32_y + esp32_holder_clearance * 2,
                        esp32_holder_z
                        ]);
            }

            // standoffs
            _ESP32HolderAtMountHoles()
                translate([ 0, 0, esp32_holder_base_z - DIFFERENCE_CLEARANCE ])
                    cylinder(
                        r = esp32_holder_standoff_r,
                        h = esp32_holder_standoff_z + DIFFERENCE_CLEARANCE
                        );
        }

        // screw pilot holes, all the way through so the screw tips can poke out the back
        _ESP32HolderAtMountHoles()
            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                cylinder(
                    r = esp32_screw_r - esp32_holder_screw_bite,
                    h = esp32_holder_base_z + esp32_holder_standoff_z + DIFFERENCE_CLEARANCE * 2
                    );

        // usb plug, through the -y wall down to the plate
        translate([
            -esp32_usb_x / 2,
            -esp32_holder_y / 2 - DIFFERENCE_CLEARANCE,
            esp32_holder_base_z
            ])
            cube([
                esp32_usb_x,
                esp32_holder_clearance + esp32_holder_wall + DIFFERENCE_CLEARANCE * 2,
                esp32_holder_z
                ]);

        // wires off the power pins, through the -x wall down to the plate
        translate([
            -esp32_holder_x / 2 - DIFFERENCE_CLEARANCE,
            -esp32_y / 2 + esp32_power_pin_offset_y - esp32_pin_pitch / 2,
            esp32_holder_base_z
            ])
            cube([
                esp32_holder_clearance + esp32_holder_wall + DIFFERENCE_CLEARANCE * 2,
                esp32_pin_pitch * esp32_power_pin_count,
                esp32_holder_z
                ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _ESP32HolderAtMountHoles()
{
    for( side_x = [ -1, 1 ] )
    {
        for( side_y = [ -1, 1 ] )
        {
            translate([
                side_x * ( esp32_x / 2 - esp32_mount_hole_offset_x ),
                side_y * ( esp32_y / 2 - esp32_mount_hole_offset_y ),
                0
                ])
                children();
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ElectronicsHolder()
{
    difference()
    {
        union()
        {
            // disc
            cylinder(
                r = evil_pumpkin_mount_r - stand_wall - electronics_holder_clearance,
                h = electronics_holder_z
                );

            // riser, the back and sides of the esp32 holder carried down to the disc, open in front
            // for the usb plug
            translate([
                -esp32_holder_x / 2,
                electronics_holder_esp32_offset_y - esp32_holder_z,
                electronics_holder_z - DIFFERENCE_CLEARANCE
                ])
                difference()
                {
                    cube([
                        esp32_holder_x,
                        esp32_holder_z,
                        usb_plug_z + DIFFERENCE_CLEARANCE * 2
                        ]);

                    translate([ esp32_holder_wall, -DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE ])
                        cube([
                            esp32_holder_x - esp32_holder_wall * 2,
                            esp32_holder_z - esp32_holder_base_z + DIFFERENCE_CLEARANCE,
                            usb_plug_z + DIFFERENCE_CLEARANCE * 4
                            ]);
                }

            // 45 degree supports under the esp32 holder bottom wall, either side of the usb gap
            for( side_x = [ 0, 1 ] )
            {
                mirror([ side_x, 0, 0 ])
                    translate([
                        0,
                        electronics_holder_esp32_offset_y - esp32_holder_base_z
                            + DIFFERENCE_CLEARANCE,
                        0
                        ])
                        rotate([ 90, 0, 0 ])
                            linear_extrude(
                                esp32_holder_z - esp32_holder_base_z + DIFFERENCE_CLEARANCE
                                )
                                _ESP32HolderBottomSupport();
            }

            // esp32 holder, standing up with the usb end down and the board facing -y
            translate([
                0,
                electronics_holder_esp32_offset_y,
                electronics_holder_z + usb_plug_z
                ])
                rotate([ 90, 0, 0 ])
                    translate([ 0, esp32_holder_y / 2, 0 ])
                        ESP32Holder();
        }

        // usb cord slot, in from the -y edge to under the usb socket
        translate([
            0,
            electronics_holder_esp32_offset_y - esp32_holder_base_z - esp32_holder_standoff_z
                - esp32_pcb_z - esp32_usb_offset_z,
            -DIFFERENCE_CLEARANCE
            ])
        {
            cylinder(
                r = usb_cord_r + electronics_holder_cord_clearance,
                h = electronics_holder_z + DIFFERENCE_CLEARANCE * 2
                );

            translate([
                -usb_cord_r - electronics_holder_cord_clearance,
                -evil_pumpkin_mount_r,
                0
                ])
                cube([
                    ( usb_cord_r + electronics_holder_cord_clearance ) * 2,
                    evil_pumpkin_mount_r,
                    electronics_holder_z + DIFFERENCE_CLEARANCE * 2
                    ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 2D profile in x / z, from the inside of the +x riser wall out to the usb gap, under the bottom
// wall of the standing esp32 holder
module _ESP32HolderBottomSupport()
{
    wall_x = esp32_holder_x / 2 - esp32_holder_wall + DIFFERENCE_CLEARANCE;
    gap_x = esp32_usb_x / 2;
    top_z = electronics_holder_z + usb_plug_z + DIFFERENCE_CLEARANCE;

    polygon([
        [ wall_x, top_z ],
        [ gap_x, top_z ],
        [ wall_x, top_z - ( wall_x - gap_x ) ]
        ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function _StandInnerR( z ) = stand_base_r - stand_wall
    + ( evil_pumpkin_mount_r - stand_base_r ) * z / stand_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// up the inside of the wall, in at 45 degrees under the ledge, then straight up through the
// recess the electronics holder sits in
module _StandHollow()
{
    rotate_extrude()
        polygon([
            [ 0, -DIFFERENCE_CLEARANCE ],
            [ _StandInnerR( -DIFFERENCE_CLEARANCE ), -DIFFERENCE_CLEARANCE ],
            [ _StandInnerR( stand_ledge_bottom_z ), stand_ledge_bottom_z ],
            [ stand_ledge_inner_r, electronics_holder_seat_z ],
            [ evil_pumpkin_mount_r - stand_wall, electronics_holder_seat_z ],
            [ evil_pumpkin_mount_r - stand_wall, stand_z + DIFFERENCE_CLEARANCE ],
            [ 0, stand_z + DIFFERENCE_CLEARANCE ]
            ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
