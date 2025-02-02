include <../../modules/multiboard.scad>
include <../../modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// power_strip_x = 326.0;
// power_strip_y = 105.0;
// power_strip_left_z = 26.2;
// power_strip_right_z = 33.9;
// power_strip_left_right_crossover_x = 230.0;

// power_strip_peg_left_offset_x = 66.0;
// power_strip_peg_right_offset_x = 192.0;
// power_strip_peg_offset_y = 66.0;
// power_strip_peg_outside_r = 3.0 / 2;
// power_strip_peg_inside_r = 7.0 / 2;
// power_strip_peg_hole_x = 8.0;
// power_strip_peg_hole_z = 3.0;

power_strip_x = 105.0;
power_strip_y = 326.0;
power_strip_bottom_z = 26.2;
power_strip_top_z = 33.9;
power_strip_left_right_crossover_y = 230.0;
power_strip_coax_cutout_x = 62.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

wall_width = 2.2;
wall_clearance = 0.75;

difference_overlap_offset = 0.01;

power_strip_front_bottom_y = 30;

holder_connector_row_setups = [ [ 10, 9 ], [ 7, 6 ], [ 4, 3 ], [ 1 ] ];

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

holder_x = wall_width * 2 + wall_clearance * 2 + power_strip_x;
holder_y = 254;

holder_z_offset = multiboard_connector_back_z;

power_strip_front_top_size = holder_y - power_strip_left_right_crossover_y - wall_width;

$fn = $preview ? 32 : 64;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color( workroom_multiboard_color)
            MultiboardMockUpTile( 6, 15 );

    BelkinPowerStripHolder();

    translate([ wall_width + wall_clearance, wall_width, holder_z_offset ])
        BelkinPowerStripPreview();
}
else if( render_mode == "print" )
{
    rotate([ 90, 0, 0 ])
        BelkinPowerStripHolder();
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BelkinPowerStripHolder()
{
    // back
    MultiboardConnectorBackAlt2( holder_x, holder_y, holder_connector_row_setups );

    top_z = power_strip_top_z + wall_width + wall_clearance;
    bottom_z = power_strip_bottom_z + wall_width + wall_clearance;

    top_side_corner_offset = power_strip_top_z - power_strip_bottom_z;
    top_side_corner_edge = sqrt( top_side_corner_offset * top_side_corner_offset * 2 ) + 2;

    top_front_edge = sqrt( power_strip_front_top_size * power_strip_front_top_size * 2 ) + 0.5;

    // left - bottom
    translate([ 0, 0, multiboard_connector_back_z ])
        RoundedCubeAlt2( wall_width, holder_y, bottom_z, round_bottom = false, round_top = true );

    // right - bottom
    translate([ holder_x - wall_width, 0, multiboard_connector_back_z ])
        RoundedCubeAlt2( wall_width, holder_y, bottom_z, round_bottom = false, round_top = true );

    // bottom
    difference()
    {
        translate([ 0, 0, multiboard_connector_back_z ])
            RoundedCubeAlt2( holder_x, wall_width, bottom_z, round_bottom = false, round_top = true );

        // cut out the right side where the coax cable comes out
        translate([ power_strip_coax_cutout_x, -difference_overlap_offset, multiboard_connector_back_z ])
            cube([ holder_x - wall_width - power_strip_coax_cutout_x, wall_width + difference_overlap_offset * 2, bottom_z - wall_width]);
    }

    // front bottom
    translate([ 0, 0, multiboard_connector_back_z + bottom_z - wall_width ])
        RoundedCubeAlt2( holder_x, power_strip_front_bottom_y, wall_width, round_bottom = false, round_top = true );

    // I can't figure out the math for this, so hack it
    hack_y = 1.0;
    hack_z = -2.4;

    // top left corner
    union()
    {
        // across the front at the top
        translate([ 0, holder_y - power_strip_front_top_size, multiboard_connector_back_z + top_z - wall_width ])
            RoundedCubeAlt2( power_strip_front_top_size, power_strip_front_top_size, wall_width, round_bottom = false, round_top = true );

        // corner to connect the front to the side
        difference()
        {
            translate([ 0, holder_y - power_strip_front_top_size * 2, multiboard_connector_back_z + top_z ])
                rotate([ 0, 90, 45 ])
                    RoundedCubeAlt2( wall_width, top_front_edge, top_front_edge, round_bottom = true, round_top = true, center = true );

            translate([ -power_strip_front_top_size, holder_y - power_strip_front_top_size * 2, multiboard_connector_back_z + top_z - wall_width - difference_overlap_offset ])
                cube([ power_strip_front_top_size + wall_width / 2, power_strip_front_top_size * 2 + 1, wall_width + difference_overlap_offset * 2 ]);
        }

        // side on top of the main part
        translate([ 0, holder_y - power_strip_front_top_size - power_strip_front_top_size, multiboard_connector_back_z ])
            RoundedCubeAlt2( wall_width, power_strip_front_top_size * 2, top_z, round_bottom = false, round_top = true );

        // corner to connect this extension to the main part
        translate([ 0, holder_y - power_strip_front_top_size - power_strip_front_top_size + hack_y, multiboard_connector_back_z + top_z - top_side_corner_offset * 2 + hack_z ])
            rotate([ 45, 0, 0 ])
                RoundedCubeAlt2( wall_width, top_side_corner_edge, top_side_corner_edge, round_bottom = false, round_top = true, center = true );
    }

    // front top - right
    union()
    {
        // across the front at the top
        translate([ holder_x - power_strip_front_top_size, holder_y - power_strip_front_top_size, multiboard_connector_back_z + top_z - wall_width ])
            RoundedCubeAlt2( power_strip_front_top_size, power_strip_front_top_size, wall_width, round_bottom = false, round_top = true );

        // corner to connect the front to the side
        difference()
        {
            translate([ holder_x, holder_y - power_strip_front_top_size * 2, multiboard_connector_back_z + top_z ])
                rotate([ 0, 90, 45 ])
                    RoundedCubeAlt2( wall_width, top_front_edge, top_front_edge, round_bottom = true, round_top = true, center = true );

            translate([ holder_x - wall_width / 2, holder_y - power_strip_front_top_size * 2, multiboard_connector_back_z + top_z - wall_width - difference_overlap_offset ])
                cube([ power_strip_front_top_size + wall_width / 2, power_strip_front_top_size * 2 + 1, wall_width + difference_overlap_offset * 2 ]);
        }

        // side on top of the main part
        translate([ holder_x - wall_width, holder_y - power_strip_front_top_size - power_strip_front_top_size, multiboard_connector_back_z ])
            RoundedCubeAlt2( wall_width, power_strip_front_top_size * 2, top_z, round_bottom = false, round_top = true );

        // corner to connect this extension to the main part
        translate([ holder_x - wall_width, holder_y - power_strip_front_top_size - power_strip_front_top_size + hack_y, multiboard_connector_back_z + top_z - top_side_corner_offset * 2 + hack_z ])
            rotate([ 45, 0, 0 ])
                RoundedCubeAlt2( wall_width, top_side_corner_edge, top_side_corner_edge, round_bottom = false, round_top = true, center = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BelkinPowerStripPreview()
{
    % cube([ power_strip_x, power_strip_y, power_strip_bottom_z ]);

    % translate([ 0, power_strip_left_right_crossover_y, power_strip_bottom_z ])
        cube([ power_strip_x, power_strip_y - power_strip_left_right_crossover_y, power_strip_top_z - power_strip_bottom_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
