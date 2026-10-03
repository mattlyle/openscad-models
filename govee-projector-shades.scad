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

star_base_width = 10.0;

star_cutout_scale = [ 2.4, 1.5, 2.0 ];

// H2D build volume
plate_x = 325.0;
plate_y = 320.0;
plate_z = 325.0;

// galaxy shade: an elliptical tube with a flared top like the star shade. the tube radii are the
// inside of the tube and must contain the whole box of the projector, it is checked. the flare
// radii are how far it opens out in x and y, and how high it rises
galaxy_tube_r_vector = [ 148.0, 120.0 ];
galaxy_flare_start_z = 90.0;
galaxy_flare_r_vector = [ 20.0, 70.0, 75.0 ];
galaxy_flare_max_angle = 60.0;
galaxy_num_flare_levels = 30;
galaxy_base_width = 5.0;
galaxy_floor_ring_width = 10.0;
galaxy_floor_bar_width = 10.0;

// the cutout is an ellipsoid, scaled from a sphere of the projector's y radius like the star shade
galaxy_cutout_scale = [ 3.2, 1.8, 2.6 ];
galaxy_cutout_position = [ 0, 70, 120 ];
galaxy_cutout_rotation = [ 0, 0, 0 ];

flare_max_angle = 60;
flare_extra_r = 75.0;
num_flare_levels = 60;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

star_footprint_x = star_projector_x + wall_width * 2 + star_base_width * 2 + clearance * 2;

galaxy_wall_r_vector = galaxy_tube_r_vector + [ wall_width, wall_width ];
galaxy_base_r_vector = galaxy_wall_r_vector + [ galaxy_base_width, galaxy_base_width ];
galaxy_hole_r_vector = galaxy_tube_r_vector - [ galaxy_floor_ring_width, galaxy_floor_ring_width ];

// the projector is a box on the floor, with clearance on all sides but the floor
galaxy_box_x = galaxy_projector_x / 2 + clearance;
galaxy_box_y = galaxy_projector_y / 2 + clearance;
galaxy_box_bottom_z = wall_width;
galaxy_box_top_z = wall_width + galaxy_projector_z + clearance;

// the tube is vertical and the flare only opens it out, so the box corners are all that need checking
galaxy_box_fits = pow( galaxy_box_x / galaxy_tube_r_vector.x, 2 )
    + pow( galaxy_box_y / galaxy_tube_r_vector.y, 2 ) <= 1;

galaxy_flare_top_z = galaxy_flare_start_z
    + CalculateFlareZ(
        galaxy_num_flare_levels,
        galaxy_num_flare_levels,
        galaxy_flare_r_vector.z,
        galaxy_flare_max_angle
        );

galaxy_flare_top_r_vector = galaxy_wall_r_vector + [
    CalculateFlareExtraR(
        galaxy_num_flare_levels,
        galaxy_num_flare_levels,
        galaxy_flare_r_vector.x,
        galaxy_flare_max_angle
        ),
    CalculateFlareExtraR(
        galaxy_num_flare_levels,
        galaxy_num_flare_levels,
        galaxy_flare_r_vector.y,
        galaxy_flare_max_angle
        )
    ];

// the origin is the center of the floor, the footprint is measured from there
galaxy_footprint_x = max( galaxy_base_r_vector.x, galaxy_flare_top_r_vector.x ) * 2;
galaxy_footprint_y = max( galaxy_base_r_vector.y, galaxy_flare_top_r_vector.y );
galaxy_height_z = galaxy_flare_top_z;

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

                        translate([ 0, 0, level_z_offset - DIFFERENCE_CLEARANCE])
                            scale([ 1, scale_y, 1 ])
                                cylinder(
                                    r1 = inner_r + level_extra_r_bottom,
                                    r2 = inner_r + level_extra_r_top,
                                    h = level_z + DIFFERENCE_CLEARANCE * 2 );
                    }
                }
            }
        }

        // remove the center of the main cylinder
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            scale([ 1, scale_y, 1 ])
                cylinder(
                    r = inner_r,
                    h = star_projector_z - flare_z + DIFFERENCE_CLEARANCE * 2 );

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
    // the projector, a box resting on the floor
    % translate([
        galaxy_footprint_x / 2 - galaxy_projector_x / 2,
        galaxy_footprint_y - galaxy_projector_y / 2,
        galaxy_box_bottom_z + DIFFERENCE_CLEARANCE
        ])
        cube([ galaxy_projector_x, galaxy_projector_y, galaxy_projector_z ]);

    % translate([ galaxy_footprint_x / 2, galaxy_footprint_y, 0 ])
        GalaxyCutout();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// origin at the center of the floor; the open side faces +y
module GalaxyShade()
{
    assert( galaxy_box_fits, "The projector box does not fit inside the tube!" );
    assert( galaxy_box_top_z <= galaxy_height_z, "The shade is lower than the projector!" );
    assert( galaxy_footprint_x <= plate_x, "TOO WIDE!" );
    assert( galaxy_footprint_y * 2 <= plate_y, "TOO DEEP!" );
    assert( galaxy_height_z <= plate_z, "TOO TALL!" );

    union()
    {
        // tube and flare
        difference()
        {
            GalaxyBody( r_vector = galaxy_wall_r_vector, extra_z = 0 );

            GalaxyBody( r_vector = galaxy_tube_r_vector, extra_z = DIFFERENCE_CLEARANCE );

            // open side, the base is left whole
            GalaxyCutout();
        }

        // base, a ring with a cross through the middle that the projector rests on
        difference()
        {
            GalaxyFloorEllipse( r_vector = galaxy_base_r_vector, z = wall_width );

            difference()
            {
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    GalaxyFloorEllipse(
                        r_vector = galaxy_hole_r_vector,
                        z = wall_width + DIFFERENCE_CLEARANCE * 2
                        );

                // cross bars
                translate([
                    -galaxy_hole_r_vector.x,
                    -galaxy_floor_bar_width / 2,
                    -DIFFERENCE_CLEARANCE * 2
                    ])
                    cube([
                        galaxy_hole_r_vector.x * 2,
                        galaxy_floor_bar_width,
                        wall_width + DIFFERENCE_CLEARANCE * 4
                        ]);

                translate([
                    -galaxy_floor_bar_width / 2,
                    -galaxy_hole_r_vector.y,
                    -DIFFERENCE_CLEARANCE * 2
                    ])
                    cube([
                        galaxy_floor_bar_width,
                        galaxy_hole_r_vector.y * 2,
                        wall_width + DIFFERENCE_CLEARANCE * 4
                        ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a solid tube with the flare on top, extra_z pokes both ends out so it cuts clean
module GalaxyBody( r_vector, extra_z )
{
    translate([ 0, 0, -extra_z ])
        linear_extrude( height = galaxy_flare_start_z + extra_z + DIFFERENCE_CLEARANCE )
            GalaxyEllipse( r_vector = r_vector );

    for( i = [ 0 : galaxy_num_flare_levels - 1 ] )
    {
        hull()
        {
            GalaxyFlareSlab( r_vector = r_vector, level = i, extra_z = 0 );

            GalaxyFlareSlab( r_vector = r_vector, level = i + 1, extra_z = extra_z );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GalaxyFlareSlab( r_vector, level, extra_z )
{
    level_r_vector = r_vector + [
        CalculateFlareExtraR(
            level,
            galaxy_num_flare_levels,
            galaxy_flare_r_vector.x,
            galaxy_flare_max_angle
            ),
        CalculateFlareExtraR(
            level,
            galaxy_num_flare_levels,
            galaxy_flare_r_vector.y,
            galaxy_flare_max_angle
            )
        ];

    level_z = galaxy_flare_start_z
        + CalculateFlareZ(
            level,
            galaxy_num_flare_levels,
            galaxy_flare_r_vector.z,
            galaxy_flare_max_angle
            );

    translate([ 0, 0, level_z ])
        linear_extrude( height = DIFFERENCE_CLEARANCE + extra_z )
            GalaxyEllipse( r_vector = level_r_vector );
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

module GalaxyFloorEllipse( r_vector, z )
{
    linear_extrude( height = z )
        GalaxyEllipse( r_vector = r_vector );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GalaxyEllipse( r_vector )
{
    scale( r_vector )
        circle( r = 1 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
