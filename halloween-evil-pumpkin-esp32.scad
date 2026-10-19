include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

jackolantern_mount_r = 84.9 / 2;
jackolantern_mount_z = 2.5;

jackolantern_mount_screw_r = 3.0 / 2;
jackolantern_mount_screw_offset_r = 3.5;
jackolantern_mount_screw_count = 3;
// jackolantern_mount_base_z = 2.6;
jackolantern_mount_screw_flange_r = 8.8 / 2;
jackolantern_mount_screw_flange_z = 3.3;
jackolantern_mount_screw_head_r = 4.2 / 2;

esp32_x = 28.6;
esp32_y = 51.5;
esp32_z = 12.6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

stand_base_r = 100.0 / 2;
stand_z = 100.0;
stand_wall = 3.6;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

jackolantern_mount_screw_center_r = jackolantern_mount_r + jackolantern_mount_screw_offset_r;

// tall enough for a 45 degree support to reach from the rim out to the far edge of the flange
jackolantern_mount_screw_support_z = jackolantern_mount_screw_offset_r
    + jackolantern_mount_screw_flange_r;

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
                cylinder(
                    r1 = stand_base_r,
                    r2 = jackolantern_mount_r,
                    h = stand_z
                    );

                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder(
                        r1 = stand_base_r - stand_wall,
                        r2 = jackolantern_mount_r - stand_wall,
                        h = stand_z + DIFFERENCE_CLEARANCE * 2
                        );
            }

            _StandMountScrewFlanges();

            _StandMountScrewSupports();
        }

        _StandMountScrewHoles();

        _StandMountScrewHeadCutouts();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewFlanges()
{
    for( screw_index = [ 0 : jackolantern_mount_screw_count - 1 ] )
    {
        rotate([ 0, 0, screw_index * 360 / jackolantern_mount_screw_count ])
            translate([
                jackolantern_mount_screw_center_r,
                0,
                stand_z - jackolantern_mount_screw_flange_z
                ])
                cylinder(
                    r = jackolantern_mount_screw_flange_r,
                    h = jackolantern_mount_screw_flange_z
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewHoles()
{
    for( screw_index = [ 0 : jackolantern_mount_screw_count - 1 ] )
    {
        rotate([ 0, 0, screw_index * 360 / jackolantern_mount_screw_count ])
            translate([
                jackolantern_mount_screw_center_r,
                0,
                stand_z - jackolantern_mount_screw_flange_z - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = jackolantern_mount_screw_r,
                    h = jackolantern_mount_screw_flange_z + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _StandMountScrewSupports()
{
    for( screw_index = [ 0 : jackolantern_mount_screw_count - 1 ] )
    {
        // a 45 degree collar around the rim, cut down to this flange's footprint
        intersection()
        {
            translate([
                0,
                0,
                stand_z - jackolantern_mount_screw_flange_z - jackolantern_mount_screw_support_z
                ])
                cylinder(
                    r1 = jackolantern_mount_r,
                    r2 = jackolantern_mount_r + jackolantern_mount_screw_support_z,
                    h = jackolantern_mount_screw_support_z
                    );

            rotate([ 0, 0, screw_index * 360 / jackolantern_mount_screw_count ])
                translate([
                    jackolantern_mount_screw_center_r,
                    0,
                    stand_z - jackolantern_mount_screw_flange_z
                        - jackolantern_mount_screw_support_z
                    ])
                    cylinder(
                        r = jackolantern_mount_screw_flange_r,
                        h = jackolantern_mount_screw_support_z
                        );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// room under each flange for the screw head and a driver, up through the support
module _StandMountScrewHeadCutouts()
{
    for( screw_index = [ 0 : jackolantern_mount_screw_count - 1 ] )
    {
        rotate([ 0, 0, screw_index * 360 / jackolantern_mount_screw_count ])
            translate([
                jackolantern_mount_screw_center_r,
                0,
                stand_z - jackolantern_mount_screw_flange_z
                    - jackolantern_mount_screw_support_z - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = jackolantern_mount_screw_head_r,
                    h = jackolantern_mount_screw_support_z + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
