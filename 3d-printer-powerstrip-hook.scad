include <modules/rounded-cube.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

powerstrip_x = 120;
powerstrip_y = 37;
powerstrip_z = 328;

powerstrip_cord_r = 10.0 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

wall_width = 3.6;
clearance = 0.4;

basket_z = 70;

hook_y = 16;
hook_z = 20;

cord_clip_z = 6;
cord_clip_wall_width = 2.0;
cord_clip_cutout_scale_y = 1.9;

powerstrip_cord_preview_z = 40;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

rounding_r = wall_width / 2 - DIFFERENCE_CLEARANCE;

back_total_x = powerstrip_x + clearance * 2 + wall_width * 2;

back_total_z = powerstrip_z
    + wall_width
    + clearance * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([
        wall_width + clearance,
        wall_width + clearance,
        wall_width + clearance
        ])
        PreviewPowerstrip();

    PowerstripHolder();
}
else if( render_mode == "print" )
{
    PowerstripHolder();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerstripHolder()
{
    difference()
    {
        union()
        {
            // basket
            RoundedCubeAlt2(
                powerstrip_x + clearance * 2 + wall_width * 2,
                powerstrip_y + clearance * 2 + wall_width * 2,
                basket_z,
                rounding_r
                );

            // back
            translate([
                0,
                powerstrip_y + clearance * 2 + wall_width,
                0
                ])
                RoundedCubeAlt2(
                    back_total_x,
                    wall_width,
                    back_total_z,
                    rounding_r
                    );
        }

        // cut out the powerstip
        translate([
            wall_width,
            wall_width,
            wall_width
            ])
            cube([
                powerstrip_x + clearance * 2,
                powerstrip_y + clearance * 2,
                powerstrip_z
                ]);
    }

    // hook top
    translate([
        0,
        powerstrip_y + clearance * 2 + wall_width,
        back_total_z - wall_width
        ])
        RoundedCubeAlt2(
            powerstrip_x + clearance * 2 + wall_width * 2,
            wall_width * 2 + hook_y,
            wall_width,
            rounding_r
            );

    // hook catch
    translate([
        0,
        powerstrip_y + clearance * 2 + wall_width + hook_y + wall_width,
        back_total_z - wall_width - hook_z
        ])
        RoundedCubeAlt2(
            powerstrip_x + clearance * 2 + wall_width * 2,
            wall_width,
            wall_width + hook_z,
            rounding_r
            );
    
    cord_hook_total_x = powerstrip_cord_r * 2
        + cord_clip_wall_width * 2
        + clearance * 2;
    
    cord_hook_total_y = powerstrip_y
        - powerstrip_cord_r * 2
        + cord_clip_wall_width * 2
        + clearance * 2;

    // cord hook
    difference()
    {
        translate([
            back_total_x / 2 - cord_hook_total_x / 2,
            powerstrip_y + wall_width * 2 + clearance * 2 - cord_hook_total_y,
            back_total_z
            ])
            RoundedCubeAlt2(
                cord_hook_total_x,
                cord_hook_total_y,
                cord_clip_z,
                round_bottom = false
                );

        translate([
            back_total_x / 2,
            powerstrip_y / 2 + wall_width + clearance,
            back_total_z - DIFFERENCE_CLEARANCE
            ])
            scale([
                1,
                cord_clip_cutout_scale_y,
                1
                ])
                cylinder(
                    r = powerstrip_cord_r + clearance,
                    h = cord_clip_z + DIFFERENCE_CLEARANCE * 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewPowerstrip()
{
    % cube([ powerstrip_x, powerstrip_y, powerstrip_z ]);

    % translate([
        powerstrip_x / 2,
        powerstrip_y / 2,
        powerstrip_z
        ])
        cylinder(
            r = powerstrip_cord_r,
            h = powerstrip_cord_preview_z
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
