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

// esp32_x = 28.6;
// esp32_y = 51.5;
// esp32_z = 12.6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

stand_base_r = 100.0 / 2;
stand_z = 100.0;
stand_wall = 3.6;

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

// THIS IS AUTO UPDATED BY THE BUILD SCRIPT - DO NOT EDIT
BUILD_SCRIPT_VERSION = "v0";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

evil_pumpkin_mount_screw_center_r = evil_pumpkin_mount_r + evil_pumpkin_mount_screw_offset_r;

// tall enough for a 45 degree support to reach from the rim out to the far edge of the flange
evil_pumpkin_mount_screw_support_z = evil_pumpkin_mount_screw_offset_r
    + evil_pumpkin_mount_screw_flange_r;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    EvilPumpkinStand();
}
else if( render_mode == "print" )
{
    EvilPumpkinStand();
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
                    cylinder(
                        r1 = stand_base_r,
                        r2 = evil_pumpkin_mount_r,
                        h = stand_z
                        );

                    cylinder(
                        r = base_r,
                        h = base_z
                        );
                }

                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder(
                        r1 = stand_base_r - stand_wall,
                        r2 = evil_pumpkin_mount_r - stand_wall,
                        h = stand_z + DIFFERENCE_CLEARANCE * 2
                        );
            }

            _StandMountScrewFlanges();

            _StandMountScrewSupports();
        }

        _StandMountScrewHoles();

        _StandMountScrewHeadCutouts();

        _BaseScrewHoles();
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
