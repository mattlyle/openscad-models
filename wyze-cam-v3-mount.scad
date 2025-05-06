////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/rounded-cube.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

wyze_cam_v3_base_x = 45.0;
wyze_cam_v3_base_y = 45.0;
wyze_cam_v3_base_z = 9.5;

wyze_cam_v3_base_top_overlap_x = 10.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-mount";

wall_width = 1.4;
clearance = 0.1;

back_cutout_r = 8;

mount_rounding_r = 0.2;

mount_overhang_percent = 0.6;

bumper_r = clearance * 2 * 0.8;

preview_inner_wall_width = 2.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

mount_base_x = wyze_cam_v3_base_x + ( wall_width + clearance ) * 2;
mount_base_y = wyze_cam_v3_base_y + ( wall_width + clearance ) * 2;
mount_base_z = wyze_cam_v3_base_z + ( wall_width + clearance ) * 2;
mount_overhang_x = wyze_cam_v3_base_top_overlap_x * mount_overhang_percent + wall_width + clearance;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ wall_width + clearance, wall_width + clearance, wall_width + clearance ])
        WyzeCamV3BasePreview();

    WyzeCamV3Mount();
}
else if( render_mode == "print-mount" )
{
    translate([ mount_base_x, mount_base_z, mount_base_y ])
        rotate([ -90, 0, 180 ])
            WyzeCamV3Mount();
}
else
{
    assert( false, str( "Invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WyzeCamV3BasePreview()
{
    cutout_x = wyze_cam_v3_base_x - wyze_cam_v3_base_top_overlap_x * 2;
    cutout_y = wyze_cam_v3_base_y - preview_inner_wall_width * 2;
    cutout_z = wyze_cam_v3_base_z - preview_inner_wall_width;

    difference()
    {
        RoundedCubeAlt2(
            x = wyze_cam_v3_base_x,
            y = wyze_cam_v3_base_y,
            z = wyze_cam_v3_base_z,
            r = wall_width,
            round_top = true,
            round_bottom = true
            );

        translate( [ wyze_cam_v3_base_top_overlap_x, preview_inner_wall_width, preview_inner_wall_width ] )
            cube([ cutout_x, cutout_y + DIFFERENCE_CLEARANCE, cutout_z]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WyzeCamV3Mount()
{
    bumper_bottom_h = mount_base_x - wall_width * 2;
    bumper_top_h = mount_overhang_x - wall_width - mount_rounding_r;
    bumper_offset_y = wall_width + clearance + bumper_r;

    // base
    RoundedCubeAlt2(
        x = mount_base_x,
        y = mount_base_y,
        z = wall_width,
        r = mount_rounding_r,
        round_top = true,
        round_bottom = true
        );

    // left
    RoundedCubeAlt2(
        x = wall_width,
        y = mount_base_y,
        z = mount_base_z,
        r = mount_rounding_r,
        round_top = true,
        round_bottom = true
        );

    // right
    translate([ mount_base_x - wall_width, 0, 0 ])
        RoundedCubeAlt2(
            x = wall_width,
            y = mount_base_y,
            z = mount_base_z,
            r = mount_rounding_r,
            round_top = true,
            round_bottom = true
            );

    // back
    difference()
    {
        translate([ 0, mount_base_y - wall_width, 0 ])
            RoundedCubeAlt2(
                x = mount_base_x,
                y = wall_width,
                z = mount_base_z,
                r = mount_rounding_r,
                round_top = true,
                round_bottom = true
                );
        
        translate([ mount_base_x / 2, mount_base_y + DIFFERENCE_CLEARANCE, mount_base_z ])
            rotate([ 90, 0, 0 ])
                cylinder( h = wall_width + DIFFERENCE_CLEARANCE * 2, r = back_cutout_r );
    }

    // top - left
    translate([ 0, 0, mount_base_z - wall_width ])
        RoundedCubeAlt2(
            x = mount_overhang_x,
            y = mount_base_y,
            z = wall_width,
            r = mount_rounding_r,
            round_top = true,
            round_bottom = true
            );

    // top - right
    translate([ mount_base_x - mount_overhang_x, 0, mount_base_z - wall_width ])
        RoundedCubeAlt2(
            x = mount_overhang_x,
            y = mount_base_y,
            z = wall_width,
            r = mount_rounding_r,
            round_top = true,
            round_bottom = true
            );

    // bumper - bottom
    translate([ wall_width, bumper_offset_y, wall_width ])
        rotate([ 0, 90, 0 ])
            cylinder(
                h = bumper_bottom_h,
                r = bumper_r
                );

    // bumper - top - left
    translate([ wall_width, bumper_offset_y, mount_base_z - wall_width ])
        rotate([ 0, 90, 0 ])
            cylinder(
                h = bumper_top_h,
                r = bumper_r
                );

    // bumper - top - right
    translate([
        mount_base_x - wall_width - bumper_top_h,
        bumper_offset_y,
        mount_base_z - wall_width
        ])
        rotate([ 0, 90, 0 ])
            cylinder(
                h = bumper_top_h,
                r = bumper_r
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

