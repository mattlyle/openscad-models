include <modules/utils.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

evil_pumpkin_mount_r = 84.9 / 2;

evil_pumpkin_mount_screw_r = 3.0 / 2;
evil_pumpkin_mount_screw_offset_r = 3.5;
evil_pumpkin_mount_screw_count = 3;
evil_pumpkin_mount_screw_flange_r = 12.5 / 2;
evil_pumpkin_mount_screw_head_r = 4.2 / 2;

esp32_x = 28.6;
esp32_y = 51.5;
esp32_usb_x = 11.7;

// center of the usb socket above the top of the board
esp32_usb_offset_z = 1.5;
esp32_pcb_z = 1.6;

// M2x8 screws hold down the esp32, the proto board and the electronics holder
m2_screw_r = 1.98 / 2;

// mount hole centers from the board edges, from the DOIT DevKit V1 KiCad footprint
esp32_mount_hole_offset_x = 2.3;
esp32_mount_hole_offset_y = 2.0;

// VIN, GND and D13 at the usb end of the left header, the first one centered this far from the
// usb edge
esp32_pin_pitch = 2.54;
esp32_power_pin_count = 3;
esp32_power_pin_offset_y = 9.9;

proto_board_x = 38.1;
proto_board_y = 50.8;
proto_board_z = 1.6;
proto_board_mounting_hole_corner_offset = 3.25;

usb_cord_r = 4.15 / 2;

// from the board edge to where the plug's overmold ends and the cord starts
usb_plug_z = 30.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";
// render_mode = "print-electronics-holder";

stand_z = 140.0;
stand_wall = 3.6;

// the stand is a cone along its tilted axis, this wide at the bottom, square to the axis
stand_bottom_r = 90.0;

// the top of the stand, with everything on it, tips down toward -y, its center at stand_z; the
// stand is a cone that leans with it, square to the top all the way down so the screws can
// be driven straight up from below, so the top ends up off center toward -y over the base
stand_top_angle = 10;

// the collar is the top of the stand that retrofits the pumpkin's old mount: the ring plus the 3
// screw flanges, kept exactly as they were but only this tall
stand_collar_z = 2.0;

// under the collar the stand is wider than the screw circle, so the screw heads are inside it; this
// much room around each head for a driver
stand_screw_access_clearance = 2.0;

// preview-only screwdriver shafts, straight down each pumpkin mount screw from under the collar;
// the stand has to stay clear of these so the screws can be driven from below
stand_screw_driver_r = 6.0 / 2;
stand_screw_driver_z = 150.0;
stand_screw_driver_preview_color = "red";
stand_screw_driver_preview_alpha = 0.4;

// a separate disc that drops into the top of the stand onto a ledge, flush with the rim
electronics_holder_z = 3.0;
stand_ledge = 2.0;
electronics_holder_clearance = 0.3;

// how far above its seat the electronics holder floats in preview, to show how it fits
electronics_holder_preview_lift_z = 20;

// where the back of the esp32 holder stands, with the board facing the -y edge; the usb cord slides
// into a slot from that edge
electronics_holder_esp32_offset_y = -20;
electronics_holder_cord_clearance = 0.3;

// drains near the low (-y) edge, either side of the cord slot and clear of the esp32 riser, inside
// the stand's ledge so they empty straight down into the stand
electronics_holder_drain_angle_list = [ 220, 320 ];
electronics_holder_drain_r = 2.0;
electronics_holder_drain_ledge_clearance = 2.0;

// one M2 screw at the back (+y) holds the electronics holder down onto a pad in the stand, so it
// can't fall out when it's assembled upside down; far enough out to clear the proto board holder
electronics_holder_screw_angle = 90;
electronics_holder_screw_center_r = 34.0;

// the pad reaches this far in past the screw, and is this wide
stand_electronics_holder_pad_extra_r = 4.0;
stand_electronics_holder_pad_y = 8.0;

// strut braces the back of the esp32 holder to the disc, opposite the cord slot; steeper than 45
// degrees so it prints fine
electronics_holder_strut_x = 3.6;
electronics_holder_strut_y = 24.0;
electronics_holder_strut_z = 52.0;

// on top of the disc at 9 o'clock, clear of the esp32 holder and strut, opposite the breadboard
electronics_holder_version_label_angle = 180;
electronics_holder_version_label_center_r = 32;

// the proto board stands opposite the esp32 with its back this far out toward +y, facing out so
// the screws can go in, braced from behind by a strut toward the center
electronics_holder_proto_board_offset_y = 15;
electronics_holder_proto_board_strut_x = 3.6;
electronics_holder_proto_board_strut_y = 24.0;
electronics_holder_proto_board_strut_z = 52.0;

evil_pumpkin_mount_screw_clearance = 0.2;

// the first pumpkin mount screw is on -y, the low side of the tilted top
evil_pumpkin_mount_screw_angle = 90;

base_board_screw_count = 4;
base_z = 7.0;

// how far the base flange reaches out past the foot of the stand; the base screws are centered in
// that ring, so the flange grows with stand_bottom_r
base_extra_r = 19.0;

base_screw_r = 3.4 / 2;
base_screw_cone_z = 2.7;
base_screw_cone_top = 6.5 / 2;

// channels across the underside, from the hollow inside out past the base flange, so any water
// that gets in can run out; clear of the base screws and the version label
stand_drain_count = 2;
stand_drain_angle = 135;
stand_drain_y = 4.0;

// straight sides this tall, then a pointed 45 degree roof so the channel prints without bridging
stand_drain_z = 0.5;

// the usb cord runs out under the base through a teardrop channel, under the version label
stand_usb_channel_clearance = 0.3;

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
m2_screw_bite = 0.175;

// held on with the same M2x8 screws as the esp32, walls down the sides only, so wires can come off
// the top and bottom
proto_board_holder_base_z = 2.0;
proto_board_holder_border = 3.0;
proto_board_holder_wall = 2.0;
proto_board_holder_standoff_r = 3.0;

// room for the solder joints and leads on the back of the board
proto_board_holder_standoff_z = 3.0;

// the board top sits this far below the top of the side walls
proto_board_holder_board_recess_z = 2.0;

// THIS IS AUTO UPDATED BY THE BUILD SCRIPT - DO NOT EDIT
BUILD_SCRIPT_VERSION = "v4";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

evil_pumpkin_mount_screw_center_r = evil_pumpkin_mount_r + evil_pumpkin_mount_screw_offset_r;

// overhangs at the top are this steep against the tilted top, so the low side still prints at 45
stand_top_overhang_angle = 45 + stand_top_angle;

// the bores up to the screw heads fit the head and the driver shaft
stand_screw_bore_r = max(
    evil_pumpkin_mount_screw_head_r + evil_pumpkin_mount_screw_clearance,
    stand_screw_driver_r
    );

// outside of the cone at the top, wide enough that the screw bores and driver shafts run down
// inside it; the cone only gets wider going down, so they stay clear
stand_r = evil_pumpkin_mount_screw_center_r + stand_screw_bore_r + stand_screw_access_clearance
    + stand_wall;

// down the tilted cone from the top until all of it is below the floor, where it gets cut off flat
stand_tube_z = ( stand_z + stand_bottom_r * sin( stand_top_angle ) ) / cos( stand_top_angle );

// the cone cut flat at the floor is an oval, no longer than this from the center toward +/-y
stand_footprint_r = stand_bottom_r / cos( stand_top_angle );

base_r = stand_footprint_r + base_extra_r;

stand_usb_channel_r = usb_cord_r + stand_usb_channel_clearance;
base_screw_center_r = stand_footprint_r + base_extra_r / 2;

stand_ledge_inner_r = evil_pumpkin_mount_r - stand_wall - stand_ledge;

// under the collar the inside slopes from the ledge out to the cone's inner wall; this is how far
// down from the top, square to it, the slope meets the wall
stand_shoulder_z = (
    stand_ledge_inner_r - electronics_holder_z / tan( stand_top_overhang_angle )
        - _StandInnerR( 0 )
    ) / (
    ( _StandInnerR( 0 ) - _StandInnerR( 1 ) ) - 1 / tan( stand_top_overhang_angle )
    );

electronics_holder_drain_center_r = stand_ledge_inner_r - electronics_holder_drain_r
    - electronics_holder_drain_ledge_clearance;

esp32_holder_x = esp32_x + ( esp32_holder_clearance + esp32_holder_wall ) * 2;
esp32_holder_y = esp32_y + ( esp32_holder_clearance + esp32_holder_wall ) * 2;

esp32_holder_z = esp32_holder_base_z + esp32_holder_standoff_z + esp32_pcb_z
    + esp32_holder_board_recess_z;

proto_board_holder_x = proto_board_x + proto_board_holder_border * 2;
proto_board_holder_y = proto_board_y + proto_board_holder_border * 2;
proto_board_holder_z = proto_board_holder_base_z + proto_board_holder_standoff_z + proto_board_z
    + proto_board_holder_board_recess_z;

echo( str( ">>> Base: ", base_r * 2, " mm across, bed is ", BUILD_PLATE_X, " x ", BUILD_PLATE_Y ) );

assert(
    base_r * 2 <= min( BUILD_PLATE_X, BUILD_PLATE_Y ),
    "base flange is wider than the build plate"
    );

assert(
    stand_footprint_r < base_screw_center_r - base_screw_cone_top,
    "base_extra_r is too small to fit the base screws outside the stand"
    );

assert(
    stand_drain_z + stand_drain_y / 2 < base_z,
    "drain channel's pointed roof cuts through the base flange"
    );

assert(
    stand_usb_channel_r * ( 1 + sqrt( 2 ) ) < base_z,
    "usb cord channel's pointed roof cuts through the base flange"
    );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    EvilPumpkinStand();

    color( stand_screw_driver_preview_color, stand_screw_driver_preview_alpha )
        _AtStandTop()
            _StandMountScrewDrivers();

    _AtStandTop()
        translate([ 0, 0, -electronics_holder_z + electronics_holder_preview_lift_z ])
            ElectronicsHolder();

    translate([ -base_r * 2, 0, 0 ])
        ElectronicsHolder();

    translate([ base_r + esp32_holder_x, 0, 0 ])
        ESP32Holder();

    translate([ base_r + esp32_holder_x * 2 + proto_board_holder_x / 2, 0, 0 ])
        ProtoBoardHolder();
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
            // cone, leaning with the top and cut off flat at the floor
            intersection()
            {
                _AtStandTop()
                    translate([ 0, 0, -stand_tube_z ])
                        cylinder(
                            r1 = stand_bottom_r,
                            r2 = _StandOuterR( -stand_collar_z ),
                            h = stand_tube_z - stand_collar_z
                            );

                translate([ -BUILD_PLATE_X, -BUILD_PLATE_Y, 0 ])
                    cube([ BUILD_PLATE_X * 2, BUILD_PLATE_Y * 2, BUILD_PLATE_Z ]);
            }

            // collar, the ring and the 3 screw flanges
            _AtStandTop()
            {
                translate([ 0, 0, -stand_collar_z - DIFFERENCE_CLEARANCE ])
                    cylinder(
                        r = evil_pumpkin_mount_r,
                        h = stand_collar_z + DIFFERENCE_CLEARANCE
                        );

                _StandMountScrewFlanges();
            }

            // base flange
            cylinder(
                r = base_r,
                h = base_z
                );
        }

        // hollow inside, leaving the ledge and the screw pad for the electronics holder
        difference()
        {
            _StandHollow();

            _AtStandTop()
                _StandElectronicsHolderScrewPad();
        }

        // electronics holder screw pilot hole, down through the pad
        _AtStandTop()
            rotate([ 0, 0, electronics_holder_screw_angle ])
                translate([
                    electronics_holder_screw_center_r,
                    0,
                    -stand_shoulder_z - DIFFERENCE_CLEARANCE
                    ])
                    cylinder(
                        r = m2_screw_r - m2_screw_bite,
                        h = stand_shoulder_z - electronics_holder_z + DIFFERENCE_CLEARANCE * 2
                        );

        // pumpkin mount screws
        _AtStandTop()
        {
            _StandMountScrewHoles();

            _StandMountScrewHeadCutouts();
        }

        // base screws
        _BaseScrewHoles();

        // usb cord
        _StandUSBChannel();

        // drains
        _StandDrains();
    }

    // raised, reading along the base with the bottom of the text toward the stand
    rotate([ 0, 0, version_label_angle + 90 ])
        translate([ 0, -base_screw_center_r, base_z - DIFFERENCE_CLEARANCE ])
            _VersionLabel( version_label_depth + DIFFERENCE_CLEARANCE );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewFlanges()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        rotate([
            0,
            0,
            evil_pumpkin_mount_screw_angle
                + screw_index * 360 / evil_pumpkin_mount_screw_count
            ])
            translate([
                evil_pumpkin_mount_screw_center_r,
                0,
                -stand_collar_z - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = evil_pumpkin_mount_screw_flange_r,
                    h = stand_collar_z + DIFFERENCE_CLEARANCE
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewHoles()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        rotate([
            0,
            0,
            evil_pumpkin_mount_screw_angle
                + screw_index * 360 / evil_pumpkin_mount_screw_count
            ])
            translate([
                evil_pumpkin_mount_screw_center_r,
                0,
                -stand_collar_z - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = evil_pumpkin_mount_screw_r + evil_pumpkin_mount_screw_clearance,
                    h = stand_collar_z + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a screwdriver shaft straight down each screw from the screw head, under the collar
module _StandMountScrewDrivers()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        rotate([
            0,
            0,
            evil_pumpkin_mount_screw_angle
                + screw_index * 360 / evil_pumpkin_mount_screw_count
            ])
            translate([
                evil_pumpkin_mount_screw_center_r,
                0,
                -stand_collar_z - stand_screw_driver_z
                ])
                cylinder(
                    r = stand_screw_driver_r,
                    h = stand_screw_driver_z
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// room for each screw head and a driver, all the way down the stand to the underside of the collar,
// so nothing inside the stand ever ends up in a driver's way
module _StandMountScrewHeadCutouts()
{
    for( screw_index = [ 0 : evil_pumpkin_mount_screw_count - 1 ] )
    {
        rotate([
            0,
            0,
            evil_pumpkin_mount_screw_angle
                + screw_index * 360 / evil_pumpkin_mount_screw_count
            ])
            translate([
                evil_pumpkin_mount_screw_center_r,
                0,
                -stand_tube_z - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = stand_screw_bore_r,
                    h = stand_tube_z - stand_collar_z + DIFFERENCE_CLEARANCE * 2
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
            translate([ base_screw_center_r, 0, 0 ])
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

// out from the center, which is already hollow, under the wall and the base flange
module _StandDrains()
{
    for( drain_index = [ 0 : stand_drain_count - 1 ] )
    {
        rotate([ 0, 0, stand_drain_angle + drain_index * 360 / stand_drain_count ])
            rotate([ 90, 0, 90 ])
                linear_extrude( base_r + DIFFERENCE_CLEARANCE )
                    polygon([
                        [ -stand_drain_y / 2, -DIFFERENCE_CLEARANCE ],
                        [ stand_drain_y / 2, -DIFFERENCE_CLEARANCE ],
                        [ stand_drain_y / 2, stand_drain_z ],
                        [ 0, stand_drain_z + stand_drain_y / 2 ],
                        [ -stand_drain_y / 2, stand_drain_z ]
                        ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// out from the center, which is already hollow, under the wall and the base flange and the
// version label; the cord lies on the floor with a teardrop roof over it
module _StandUSBChannel()
{
    rotate([ 0, 0, version_label_angle ])
        rotate([ 90, 0, 90 ])
            linear_extrude( base_r + DIFFERENCE_CLEARANCE )
            {
                translate([ 0, stand_usb_channel_r ])
                    Teardrop( stand_usb_channel_r );

                translate([ -stand_usb_channel_r, -DIFFERENCE_CLEARANCE ])
                    square([ stand_usb_channel_r * 2, stand_usb_channel_r + DIFFERENCE_CLEARANCE ]);
            }
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

        // screw pilot holes, all the way through so the screw tips can poke out the back; teardrops
        // pointing at the antenna end, which is up when the holder stands on the electronics holder
        _ESP32HolderAtMountHoles()
            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                linear_extrude(
                    esp32_holder_base_z + esp32_holder_standoff_z + DIFFERENCE_CLEARANCE * 2
                    )
                    Teardrop( m2_screw_r - m2_screw_bite );

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

// centered on the board, the side that ends up on top when standing toward +y
module ProtoBoardHolder()
{
    difference()
    {
        union()
        {
            // plate
            translate([ -proto_board_holder_x / 2, -proto_board_holder_y / 2, 0 ])
                cube([ proto_board_holder_x, proto_board_holder_y, proto_board_holder_base_z ]);

            // side walls
            for( side_x = [ -1, 1 ] )
            {
                translate([
                    side_x * ( proto_board_holder_x - proto_board_holder_wall ) / 2
                        - proto_board_holder_wall / 2,
                    -proto_board_holder_y / 2,
                    0
                    ])
                    cube([ proto_board_holder_wall, proto_board_holder_y, proto_board_holder_z ]);
            }

            // standoffs
            _ProtoBoardHolderAtMountHoles()
                translate([ 0, 0, proto_board_holder_base_z - DIFFERENCE_CLEARANCE ])
                    cylinder(
                        r = proto_board_holder_standoff_r,
                        h = proto_board_holder_standoff_z + DIFFERENCE_CLEARANCE
                        );
        }

        // screw pilot holes, all the way through; teardrops pointing +y, which is up when it stands
        // on the electronics holder
        _ProtoBoardHolderAtMountHoles()
            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                linear_extrude(
                    proto_board_holder_base_z + proto_board_holder_standoff_z
                        + DIFFERENCE_CLEARANCE * 2
                    )
                    Teardrop( m2_screw_r - m2_screw_bite );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _ProtoBoardHolderAtMountHoles()
{
    for( side_x = [ -1, 1 ] )
    {
        for( side_y = [ -1, 1 ] )
        {
            translate([
                side_x * ( proto_board_x / 2 - proto_board_mounting_hole_corner_offset ),
                side_y * ( proto_board_y / 2 - proto_board_mounting_hole_corner_offset ),
                0
                ])
                children();
        }
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

            // strut up the back of the riser
            translate([ -electronics_holder_strut_x / 2, 0, 0 ])
                rotate([ 90, 0, 90 ])
                    linear_extrude( electronics_holder_strut_x )
                        polygon([
                            [
                                electronics_holder_esp32_offset_y - DIFFERENCE_CLEARANCE,
                                electronics_holder_z - DIFFERENCE_CLEARANCE
                            ],
                            [
                                electronics_holder_esp32_offset_y + electronics_holder_strut_y,
                                electronics_holder_z - DIFFERENCE_CLEARANCE
                            ],
                            [
                                electronics_holder_esp32_offset_y - DIFFERENCE_CLEARANCE,
                                electronics_holder_z + electronics_holder_strut_z
                            ]
                            ]);

            // esp32 holder, standing up with the usb end down and the board facing -y
            translate([
                0,
                electronics_holder_esp32_offset_y,
                electronics_holder_z + usb_plug_z
                ])
                rotate([ 90, 0, 0 ])
                    translate([ 0, esp32_holder_y / 2, 0 ])
                        ESP32Holder();

            // proto board riser, the back and side walls of the proto board holder carried down to
            // the disc, open in front, so the board lines up with the esp32
            translate([
                -proto_board_holder_x / 2,
                electronics_holder_proto_board_offset_y,
                electronics_holder_z - DIFFERENCE_CLEARANCE
                ])
                difference()
                {
                    cube([
                        proto_board_holder_x,
                        proto_board_holder_z,
                        usb_plug_z + DIFFERENCE_CLEARANCE * 2
                        ]);

                    translate([
                        proto_board_holder_wall,
                        proto_board_holder_base_z,
                        -DIFFERENCE_CLEARANCE
                        ])
                        cube([
                            proto_board_holder_x - proto_board_holder_wall * 2,
                            proto_board_holder_z - proto_board_holder_base_z + DIFFERENCE_CLEARANCE,
                            usb_plug_z + DIFFERENCE_CLEARANCE * 4
                            ]);
                }

            // proto board holder, standing up opposite the esp32 with the board facing out, +y
            translate([
                0,
                electronics_holder_proto_board_offset_y,
                electronics_holder_z + usb_plug_z
                ])
                rotate([ 0, 0, 180 ])
                    rotate([ 90, 0, 0 ])
                        translate([ 0, proto_board_holder_y / 2, 0 ])
                            ProtoBoardHolder();

            // strut up the back of the proto board holder, on the center side
            translate([ -electronics_holder_proto_board_strut_x / 2, 0, 0 ])
                rotate([ 90, 0, 90 ])
                    linear_extrude( electronics_holder_proto_board_strut_x )
                        polygon([
                            [
                                electronics_holder_proto_board_offset_y + DIFFERENCE_CLEARANCE,
                                electronics_holder_z - DIFFERENCE_CLEARANCE
                            ],
                            [
                                electronics_holder_proto_board_offset_y
                                    - electronics_holder_proto_board_strut_y,
                                electronics_holder_z - DIFFERENCE_CLEARANCE
                            ],
                            [
                                electronics_holder_proto_board_offset_y + DIFFERENCE_CLEARANCE,
                                electronics_holder_z + electronics_holder_proto_board_strut_z
                            ]
                            ]);
        }

        // screw down into the pad in the stand
        rotate([ 0, 0, electronics_holder_screw_angle ])
            translate([ electronics_holder_screw_center_r, 0, -DIFFERENCE_CLEARANCE ])
                cylinder(
                    r = m2_screw_r + electronics_holder_clearance,
                    h = electronics_holder_z + DIFFERENCE_CLEARANCE * 2
                    );

        // drains
        for( drain_angle = electronics_holder_drain_angle_list )
        {
            rotate([ 0, 0, drain_angle ])
                translate([ electronics_holder_drain_center_r, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder(
                        r = electronics_holder_drain_r,
                        h = electronics_holder_z + DIFFERENCE_CLEARANCE * 2
                        );
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

    // raised, reading along the edge with the bottom of the text toward the center
    rotate([ 0, 0, electronics_holder_version_label_angle + 90 ])
        translate([
            0,
            -electronics_holder_version_label_center_r,
            electronics_holder_z - DIFFERENCE_CLEARANCE
            ])
            _VersionLabel( version_label_depth + DIFFERENCE_CLEARANCE );
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

// radius of the cone at z, square to the tilted top with z = 0 at the top and negative going down
function _StandOuterR( z ) = stand_r + ( stand_bottom_r - stand_r ) * -z / stand_tube_z;
function _StandInnerR( z ) = _StandOuterR( z ) - stand_wall;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// places children square to the tilted top of the stand, with z = 0 at the top; the top sits off
// center toward -y so the leaning tube under it lands centered on the base
module _AtStandTop()
{
    translate([ 0, -stand_z * tan( stand_top_angle ), stand_z ])
        rotate([ stand_top_angle, 0, 0 ])
            children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// in the frame of the tilted top: a block under the ledge at the back, its top level with the
// ledge, reaching in past the screw, with a sloped underside running back out into the wall
module _StandElectronicsHolderScrewPad()
{
    inner_r = electronics_holder_screw_center_r - stand_electronics_holder_pad_extra_r;

    rotate([ 0, 0, electronics_holder_screw_angle ])
        translate([ 0, stand_electronics_holder_pad_y / 2, 0 ])
            rotate([ 90, 0, 0 ])
                linear_extrude( stand_electronics_holder_pad_y )
                    polygon([
                        [ inner_r, -electronics_holder_z ],
                        [ stand_r, -electronics_holder_z ],
                        [
                            stand_r,
                            -electronics_holder_z
                                - ( stand_r - inner_r ) * tan( stand_top_overhang_angle )
                        ]
                        ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandHollow()
{
    // down the cone and out the bottom, sloping in under the ledge, then straight up through the
    // recess the electronics holder sits in and out through the collar
    _AtStandTop()
        rotate_extrude()
            polygon([
                [ 0, -stand_tube_z - DIFFERENCE_CLEARANCE ],
                [
                    _StandInnerR( -stand_tube_z - DIFFERENCE_CLEARANCE ),
                    -stand_tube_z - DIFFERENCE_CLEARANCE
                ],
                [ _StandInnerR( -stand_shoulder_z ), -stand_shoulder_z ],
                [ stand_ledge_inner_r, -electronics_holder_z ],
                [ evil_pumpkin_mount_r - stand_wall, -electronics_holder_z ],
                [ evil_pumpkin_mount_r - stand_wall, DIFFERENCE_CLEARANCE ],
                [ 0, DIFFERENCE_CLEARANCE ]
                ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
