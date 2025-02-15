////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/elliptical-prism.scad>
include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

short_infuser_top_r = 58.6 / 2;
short_infuser_bottom_r = 51.1 / 2;
short_infuser_z = 57.1;
short_infuser_top_lip_z = 3.2;
short_infuser_top_lip_r = 67.3 / 2;

short_infuser_handle_full_x = 131.0;
short_infuser_handle_offset_x = 80.1 - short_infuser_top_lip_r * 2;
short_infuser_handle_y = 25.0;
short_infuser_handle_wire_d = 2.6;
short_infuser_handle_hook_z = 10.7;

tall_infuser_r = 59.3 / 2;
tall_infuser_z = 167;
tall_infuser_top_section_r = 74.8 / 2;
tall_infuser_top_section_z = 9.4;
tall_infuser_sloped_section_z = 17.0 - tall_infuser_top_section_z;
tall_infuser_lip_r = 86.0 / 2;
tall_infuser_lip_z = 0.8;
tall_infuser_handle_x = 6.1;
tall_infuser_handle_y = 21.9;
tall_infuser_handle_z = 60.2;
tall_infuser_handle_angle = 5;

spoon_handle_x = 96;
spoon_handle_y = 17.2;
spoon_handle_z = 2.5;
spoon_cup_r = 32 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";

wall_width = 2.0;

holder_base_x = 250;
holder_base_y = 125;
holder_base_lip_z = 5;

cup_padding = 1.8;

infuser_lift_short = 8.0;
infuser_lift_tall = 6.0;
infuser_lift_spoon = 4.0;

// cup config:
//  0   num cutout levels
//  1   num cutouts
//  2   cutout percent
//  3   cup bottom cone
cup_config_short = [ 2, 12, 0.6, true ];
cup_config_tall = [ 4, 12, 0.6, true ];
cup_config_spoon = [ 3, 6, 0.5, false ];

cup_cone_z = 6.0;

spoon_holder_scale_y = 0.8;

difference_calc_size = 0.01;

holder_offset_short_x = holder_base_x * 0.20;
holder_offset_tall_x = holder_base_x * 0.60;
holder_offset_spoon_x = holder_base_x * 0.90;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

holder_offset_y = holder_base_y / 2;

tall_infuser_slope_section_offset_z = tall_infuser_z
    - tall_infuser_lip_z
    - tall_infuser_top_section_z
    - tall_infuser_sloped_section_z;

tall_infuser_top_section_offset_z = tall_infuser_z
    - tall_infuser_lip_z
    - tall_infuser_top_section_z;

tall_infuser_lip_offset_z = tall_infuser_z
    - tall_infuser_lip_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    TeaInfuserHolder();

    translate([ holder_offset_short_x, holder_offset_y, wall_width + short_infuser_top_lip_z + infuser_lift_short ])
        ShortInfuserPreview();

    translate([ holder_offset_tall_x, holder_offset_y, wall_width + infuser_lift_tall ])
        TallInfuserPreview();

    translate([ holder_offset_spoon_x, holder_offset_y, wall_width + infuser_lift_spoon ])
        SpoonPreview();
}
else if( render_mode == "print-holder" )
{
    TeaInfuserHolder();
}
else
{
    assert( false, "Unknown render mode" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TeaInfuserHolder()
{
    // base
    difference()
    {
        RoundedCubeAlt2(
            x = holder_base_x,
            y = holder_base_y,
            z = wall_width + holder_base_lip_z,
            r = wall_width,
            round_top = true,
            round_bottom = true,
            center = true
            );

        translate([ wall_width, wall_width, wall_width ])
            RoundedCubeAlt2(
                x = holder_base_x - wall_width * 2,
                y = holder_base_y - wall_width * 2,
                z = holder_base_lip_z,
                r = 1.0,
                round_top = false,
                round_bottom = true,
                center = true
                );
    }

    // short infuser cup
    translate([ holder_offset_short_x, holder_offset_y, wall_width ])
        HolderCup(
            bottom_r = short_infuser_bottom_r,
            top_r = short_infuser_top_r,
            h = short_infuser_z + infuser_lift_short,
            num_cutout_levels = cup_config_short[ 0 ],
            num_cutouts = cup_config_short[ 1 ],
            cutout_percent = cup_config_short[ 2 ],
            cup_bottom_cone = cup_config_short[ 3 ]
            );

    // tall infuser cup
    translate([ holder_offset_tall_x, holder_offset_y, wall_width ])
        HolderCup(
            bottom_r = tall_infuser_r,
            top_r = tall_infuser_r,
            h = tall_infuser_slope_section_offset_z + infuser_lift_tall,
            num_cutout_levels = cup_config_tall[ 0 ],
            num_cutouts = cup_config_tall[ 1 ],
            cutout_percent = cup_config_tall[ 2 ],
            cup_bottom_cone = cup_config_tall[ 3 ]
            );

    // spoon holder
    spoon_handle_cup_r = max( spoon_handle_y, spoon_handle_z ) / 2;
    translate([ holder_offset_spoon_x, holder_offset_y, wall_width ])
        scale([ 1.0, spoon_holder_scale_y, 1.0 ])
            HolderCup(
                bottom_r = spoon_handle_cup_r,
                top_r = spoon_handle_cup_r,
                h = spoon_handle_x + infuser_lift_spoon,
                num_cutout_levels = cup_config_spoon[ 0 ],
                num_cutouts = cup_config_spoon[ 1 ],
                cutout_percent = cup_config_spoon[ 2 ],
                cup_bottom_cone = cup_config_spoon[ 3 ]
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ShortInfuserPreview( )
{
    % rotate([ 0, 0, -90 ])
    {
        union()
        {
            cylinder( r1 = short_infuser_bottom_r, r2 = short_infuser_top_r, h = short_infuser_z - short_infuser_top_lip_z);

            translate([ 0, 0, short_infuser_z - short_infuser_top_lip_z ])
                cylinder( r = short_infuser_top_lip_r, h = short_infuser_top_lip_z );

            handle_offset_x = -short_infuser_handle_offset_x - short_infuser_top_lip_r;

            translate([ handle_offset_x, -short_infuser_handle_y / 2, short_infuser_z - short_infuser_handle_wire_d ])
                cube([ short_infuser_handle_full_x, short_infuser_handle_y, short_infuser_handle_wire_d ]);

            translate([ handle_offset_x, -short_infuser_handle_y / 2, short_infuser_z - short_infuser_handle_hook_z ])
                cube([ short_infuser_handle_wire_d, short_infuser_handle_y, short_infuser_handle_hook_z ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TallInfuserPreview()
{
    % union()
    {
        // main body
        cylinder( r = tall_infuser_r, h = tall_infuser_slope_section_offset_z );

        // sloped section
        translate([ 0, 0, tall_infuser_slope_section_offset_z ])
            cylinder( r1 = tall_infuser_r, r2 = tall_infuser_top_section_r, h = tall_infuser_sloped_section_z );

        // top section
        translate([ 0, 0, tall_infuser_top_section_offset_z ])
            cylinder( r = tall_infuser_top_section_r, h = tall_infuser_top_section_z );

        // lip
        translate([ 0, 0, tall_infuser_lip_offset_z ])
            cylinder( r = tall_infuser_lip_r, h = tall_infuser_lip_z );

        // handle
        translate([ tall_infuser_lip_r - tall_infuser_handle_x / 2, -tall_infuser_handle_y / 2, tall_infuser_z - tall_infuser_lip_z ])
            rotate([ 0, tall_infuser_handle_angle, 0 ])
                cube([ tall_infuser_handle_x, tall_infuser_handle_y, tall_infuser_handle_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpoonPreview()
{
    % union()
    {
        // handle
        translate([ 0, spoon_handle_z, spoon_handle_x / 2 ])
            rotate([ 90, 90, 0 ])
                EllipticalPrism( spoon_handle_x, spoon_handle_y, spoon_handle_z );

        // cup
        difference()
        {
            translate([ 0, 0, spoon_handle_x + spoon_cup_r ])
                sphere( r = spoon_cup_r );

            translate([ -spoon_cup_r - difference_calc_size, -spoon_cup_r - difference_calc_size, spoon_handle_x - difference_calc_size ])
                cube([ spoon_cup_r * 2 + difference_calc_size * 2, spoon_cup_r + difference_calc_size, spoon_cup_r * 2 + difference_calc_size * 2 ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HolderCup( bottom_r, top_r, h, num_cutout_levels, num_cutouts, cutout_percent, cup_bottom_cone = false )
{
    outer_bottom_r = bottom_r + wall_width + cup_padding;
    outer_top_r = top_r + wall_width + cup_padding;

    inner_bottom_r = bottom_r + cup_padding;
    inner_top_r = top_r + cup_padding;

    cutout_r = ( 2 * PI * outer_bottom_r ) * cutout_percent / num_cutouts / 2;

    cutout_section_z = h / num_cutout_levels;

    // bottom cone
    if( cup_bottom_cone )
    {
        translate([ 0, 0, wall_width ])
            cylinder( r1 = inner_bottom_r, r2 = 0, h = cup_cone_z );
    }

    difference()
    {
        // outer cylinder
        cylinder( r1 = outer_bottom_r, r2 = outer_top_r, h = h );

        // cut out the inside
        translate([ 0, 0, wall_width ])
            cylinder( r1 = inner_bottom_r, r2 = inner_top_r, h = h );

        for( level = [ 0 : num_cutout_levels - 1 ] )
        {
            cutout_section_offset_z = cutout_section_z * level;

            for( i = [ 0 : num_cutouts - 1 ] )
            {
                // bottom arch
                translate([ 0, 0, cutout_section_offset_z + wall_width + cutout_r ])
                    rotate([ 90, 0, i * 360 / num_cutouts ])
                        cylinder( h = outer_bottom_r * 4, r = cutout_r, center = true );

                // top arch
                translate([ 0, 0, cutout_section_offset_z + cutout_section_z - wall_width - cutout_r ])
                    rotate([ 90, 0, i * 360 / num_cutouts ])
                        cylinder( h = outer_bottom_r * 4, r = cutout_r, center = true );

                // main vertical cutout
                translate([ 0, 0, cutout_section_offset_z + cutout_section_z / 2 ])
                    rotate([ 0, 0, i * 360 / num_cutouts ])
                        cube([ cutout_r * 2, outer_bottom_r * 4, cutout_section_z - cutout_r * 2 - wall_width * 2 ], center = true );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
