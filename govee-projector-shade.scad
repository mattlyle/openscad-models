////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

govee_projector_shade_x = 170;
govee_projector_shade_y = 180;
govee_projector_shade_z = 220;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

wall_width = 2.0;
clearance = 2.0;

difference_offset = 0.01;

base_width = 10.0;

cutout_scale = [ 1.8, 1.5, 2.2 ];

flare_max_angle = 60;
flare_extra_r = 80.0;
num_flare_levels = 24;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

function CalculateFlareExtraR( i, num_levels, extra_r, max_angle ) =
    extra_r - cos( max_angle / num_levels * i ) * extra_r;

function CalculateFlareZ( i, num_levels, extra_r, max_angle ) =
    sin( max_angle / num_levels * i ) * extra_r;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

translate([
    govee_projector_shade_x / 2 + wall_width + base_width + clearance,
    govee_projector_shade_y / 2 + wall_width + base_width + clearance,
    0
    ])
    GoveeProjectorShade();

if( render_mode == "preview" )
{
    % cube([
        govee_projector_shade_x + wall_width * 2 + base_width * 2 + clearance * 2,
        govee_projector_shade_y + wall_width * 2 + base_width * 2 + clearance * 2,
        0.1
        ]);

    % translate([
        0,
        0,
        govee_projector_shade_z
        ])
        cube([
            govee_projector_shade_x + wall_width * 2 + base_width * 2 + clearance * 2,
            govee_projector_shade_y + wall_width * 2 + base_width * 2 + clearance * 2,
            0.1
            ]);

    % translate([
        govee_projector_shade_x / 2 + wall_width + base_width,
        govee_projector_shade_y + wall_width + base_width,
        govee_projector_shade_z
        ])
        scale( cutout_scale )
            sphere( r = govee_projector_shade_y / 2 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GoveeProjectorShade()
{
    // use x for the radius, then scale to y
    inner_r = govee_projector_shade_x / 2 + clearance;
    outer_r = govee_projector_shade_x / 2 + clearance + wall_width;

    scale_y = govee_projector_shade_y / govee_projector_shade_x;

    flare_z = flare_extra_r * sin( flare_max_angle );

    difference()
    {
        union()
        {
            // main cylinder
            scale([ 1, scale_y, 1 ])
                cylinder(
                    r = outer_r,
                    h = govee_projector_shade_z - flare_z );

            // base
            scale([ 1, scale_y, 1 ])
                cylinder(
                    r = outer_r + base_width,
                    h = wall_width );

            // flare
            for( i = [ 0 : num_flare_levels - 1 ])
            {
                level_z_offset = CalculateFlareZ( i, num_flare_levels, flare_extra_r, flare_max_angle );
                level_z = CalculateFlareZ( i + 1, num_flare_levels, flare_extra_r, flare_max_angle )
                    - CalculateFlareZ( i, num_flare_levels, flare_extra_r, flare_max_angle );

                level_extra_r_bottom = CalculateFlareExtraR( i, num_flare_levels, flare_extra_r, flare_max_angle );
                level_extra_r_top = CalculateFlareExtraR( i + 1, num_flare_levels, flare_extra_r, flare_max_angle );

                translate([ 0, 0, govee_projector_shade_z - flare_z ])
                {
                    difference()
                    {
                        translate([ 0, 0, level_z_offset ])
                            scale([ 1, scale_y, 1 ])
                                cylinder(
                                    r1 = outer_r + level_extra_r_bottom,
                                    r2 = outer_r + level_extra_r_top,
                                    h = level_z );

                        translate([ 0, 0, level_z_offset - difference_offset])
                            scale([ 1, scale_y, 1 ])
                                cylinder(
                                    r1 = inner_r + level_extra_r_bottom,
                                    r2 = inner_r + level_extra_r_top,
                                    h = level_z + difference_offset * 2 );
                    }
                }
            }
        }

        // remove the center of the main cylinder
        translate([ 0, 0, -difference_offset ])
            scale([ 1, scale_y, 1 ])
                cylinder(
                    r = inner_r,
                    h = govee_projector_shade_z - flare_z + difference_offset * 2 );

        // remove the back
        translate([
            0,
            govee_projector_shade_y / 2,
            govee_projector_shade_z
            ])
            scale( cutout_scale )
                sphere( r = govee_projector_shade_y / 2 );
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
