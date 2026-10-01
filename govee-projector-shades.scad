////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

star_projector_x = 170;
star_projector_y = 180;
star_projector_z = 190;

galaxy_projector_x = 230;
galaxy_projector_y = 140;
galaxy_projector_z = 145;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-star";
// render_mode = "print-galaxy";

wall_width = 2.0;
clearance = 2.0;

difference_offset = 0.01;

star_base_width = 10.0;

star_cutout_scale = [ 2.4, 1.5, 2.0 ];

// galaxy shade: an ellipsoid dome around the projector, cut open on the projection side
galaxy_base_width = 5.0;

// the cutout is an ellipsoid, scaled from a sphere of the projector's y radius like the star shade
galaxy_cutout_scale = [ 1.8, 1.4, 1.4 ];
galaxy_cutout_position = [ 0, 70, 100 ];
galaxy_cutout_rotation = [ 0, 0, 0 ];


flare_max_angle = 60;
flare_extra_r = 75.0;
num_flare_levels = 60;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

star_footprint_x = star_projector_x + wall_width * 2 + star_base_width * 2 + clearance * 2;

// the projector is a half ellipsoid, x and y are the full width and depth and z is the height
galaxy_projector_r_vector = [ galaxy_projector_x / 2, galaxy_projector_y / 2, galaxy_projector_z ];
galaxy_inner_r_vector = galaxy_projector_r_vector + [ clearance, clearance, clearance ];
galaxy_outer_r_vector = galaxy_inner_r_vector + [ wall_width, wall_width, wall_width ];

galaxy_footprint_x = galaxy_outer_r_vector.x * 2 + galaxy_base_width * 2;
galaxy_footprint_y = galaxy_outer_r_vector.y + galaxy_base_width;

function CalculateFlareExtraR( i, num_levels, extra_r, max_angle ) =
    extra_r - cos( max_angle / num_levels * i ) * extra_r;

function CalculateFlareZ( i, num_levels, extra_r, max_angle ) =
    sin( max_angle / num_levels * i ) * extra_r;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    StarShadePositioned();
    StarShadePreview();

    translate([ 500, 0, 0 ])
    {
        GalaxyShadePositioned();
        GalaxyShadePreview();
    }
}
else if( render_mode == "print-star" )
{
    StarShadePositioned();
}
else if( render_mode == "print-galaxy" )
{
    GalaxyShadePositioned();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module StarShadePositioned()
{
    translate([
        star_projector_x / 2 + wall_width + star_base_width + clearance,
        star_projector_y / 2 + wall_width + star_base_width + clearance,
        0
        ])
        StarShade();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module StarShadePreview()
{
    % cube([
        star_projector_x + wall_width * 2 + star_base_width * 2 + clearance * 2,
        star_projector_y + wall_width * 2 + star_base_width * 2 + clearance * 2,
        0.1
        ]);

    % translate([
        0,
        0,
        star_projector_z
        ])
        cube([
            star_projector_x + wall_width * 2 + star_base_width * 2 + clearance * 2,
            star_projector_y + wall_width * 2 + star_base_width * 2 + clearance * 2,
            0.1
            ]);

    % translate([
        star_projector_x / 2 + wall_width + star_base_width,
        star_projector_y + wall_width + star_base_width,
        star_projector_z
        ])
        scale( star_cutout_scale )
            sphere( r = star_projector_y / 2 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module StarShade()
{
    // use x for the radius, then scale to y
    inner_r = star_projector_x / 2 + clearance;
    outer_r = star_projector_x / 2 + clearance + wall_width;

    scale_y = star_projector_y / star_projector_x;

    flare_z = flare_extra_r * sin( flare_max_angle );

    difference()
    {
        union()
        {
            // main cylinder
            scale([ 1, scale_y, 1 ])
                cylinder(
                    r = outer_r,
                    h = star_projector_z - flare_z );

            // base
            scale([ 1, scale_y, 1 ])
                cylinder(
                    r = outer_r + star_base_width,
                    h = wall_width );

            // flare
            for( i = [ 0 : num_flare_levels - 1 ])
            {
                level_z_offset = CalculateFlareZ( i, num_flare_levels, flare_extra_r, flare_max_angle );
                level_z = CalculateFlareZ( i + 1, num_flare_levels, flare_extra_r, flare_max_angle )
                    - CalculateFlareZ( i, num_flare_levels, flare_extra_r, flare_max_angle );

                level_extra_r_bottom = CalculateFlareExtraR( i, num_flare_levels, flare_extra_r, flare_max_angle );
                level_extra_r_top = CalculateFlareExtraR( i + 1, num_flare_levels, flare_extra_r, flare_max_angle );

                assert( ( outer_r + level_extra_r_top ) * 2 < BUILD_PLATE_X, "TOO WIDE!" );

                translate([ 0, 0, star_projector_z - flare_z ])
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
                    h = star_projector_z - flare_z + difference_offset * 2 );

        // remove the back
        translate([
            0,
            star_projector_y / 2,
            star_projector_z
            ])
            scale( star_cutout_scale )
                sphere( r = star_projector_y / 2 );
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GalaxyShadePositioned()
{
    translate([ galaxy_footprint_x / 2, galaxy_footprint_y, 0 ])
        GalaxyShade();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GalaxyShadePreview()
{
    assert( galaxy_footprint_x < BUILD_PLATE_X, "TOO WIDE!" );

    // the projector, a half ellipsoid resting on the base
    % translate([ galaxy_footprint_x / 2, galaxy_footprint_y, wall_width ])
        intersection()
        {
            GalaxyEllipsoid( r_vector = galaxy_projector_r_vector );

            translate([ -galaxy_projector_x, -galaxy_projector_x, 0 ])
                cube([ galaxy_projector_x * 2, galaxy_projector_x * 2, galaxy_projector_x ]);
        }

    % translate([ galaxy_footprint_x / 2, galaxy_footprint_y, 0 ])
        GalaxyCutout();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// origin at the center of the ellipse on the floor; the open side faces +y and up
module GalaxyShade()
{
    difference()
    {
        union()
        {
            // dome
            difference()
            {
                GalaxyEllipsoid( r_vector = galaxy_outer_r_vector );

                GalaxyEllipsoid( r_vector = galaxy_inner_r_vector );

                // open side, the base is left whole
                GalaxyCutout();
            }

            // base
            scale([ 1, galaxy_outer_r_vector.y / galaxy_outer_r_vector.x, 1 ])
                cylinder( r = galaxy_outer_r_vector.x + galaxy_base_width, h = wall_width );
        }

        // below the floor
        translate([ -galaxy_footprint_x, -galaxy_footprint_x, -galaxy_footprint_x ])
            cube([ galaxy_footprint_x * 2, galaxy_footprint_x * 2, galaxy_footprint_x ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GalaxyCutout()
{
    translate( galaxy_cutout_position )
        rotate( galaxy_cutout_rotation )
            scale( galaxy_cutout_scale )
                sphere( r = galaxy_projector_y / 2 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GalaxyEllipsoid( r_vector )
{
    scale( r_vector )
        sphere( r = 1 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
