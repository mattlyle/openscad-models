////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";

wall_width = 2.0;

holder_base_x = 200;
holder_base_y = 100;
holder_base_lip_z = 5;

cup_padding = 1.5;

infuser_lift = 8.0;

num_cutouts = 12;
cutout_percent = 0.6;

num_cutout_levels_small = 2;
num_cutout_levels_tall = 4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

holder_offset_small_x = holder_base_x * 0.30;
holder_offset_tall_x = holder_base_x * 0.70;
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

    translate([ holder_offset_small_x, holder_offset_y, wall_width * 2 + infuser_lift ])
        ShortInfuserPreview();

    translate([ holder_offset_tall_x, holder_offset_y, wall_width * 2 + infuser_lift ])
        TallInfuserPreview();
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
    scale_x = holder_base_x / holder_base_y;

    // base
    translate([ holder_base_x / 2, holder_base_y / 2, 0 ])
    {
        scale([ holder_base_x / holder_base_y, 1, 1 ])
        {
            difference()
            {
                cylinder( h = wall_width + holder_base_lip_z, r = holder_base_y / 2 );

                translate([ 0, 0, wall_width ])
                    cylinder( h = holder_base_lip_z + 0.01, r = holder_base_y / 2 - wall_width /scale_x);
            }
        }
    }

    translate([ holder_offset_small_x, holder_offset_y, wall_width ])
        HolderCup( tall_infuser_r, tall_infuser_r, short_infuser_z + infuser_lift, num_cutout_levels_small );

    translate([ holder_offset_tall_x, holder_offset_y, wall_width ])
        HolderCup( tall_infuser_r, tall_infuser_r, tall_infuser_slope_section_offset_z + infuser_lift, num_cutout_levels_tall );
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
        translate([ 0, 0, tall_infuser_top_section_offset_z])
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

module HolderCup( bottom_r, top_r, h, num_cutout_levels )
{
    outer_bottom_r = bottom_r + wall_width + cup_padding;
    outer_top_r = top_r + wall_width + cup_padding;

    inner_bottom_r = bottom_r + cup_padding;
    inner_top_r = top_r + cup_padding;

    // cutout_r = 5;
    cutout_r = ( PI * outer_bottom_r * cutout_percent ) / num_cutouts;

    cutout_section_z = h / num_cutout_levels;

    difference()
    {
        // outer cylinder
        cylinder( r1 = outer_bottom_r, r2 = outer_top_r, h = h );

        // cut out the inside
        translate([ 0, 0, wall_width ])
            cylinder( r1 = inner_bottom_r, r2 = inner_top_r, h = h );

        // level = 1;
        for( level = [ 0 : num_cutout_levels - 1 ] )
        {
            cutout_section_offset_z = cutout_section_z * level;


            for( i = [ 0 : num_cutouts - 1 ] )
            {
                // bottom arch
                translate([ 0, 0, cutout_section_offset_z + wall_width + cutout_r ])
                {
                    rotate([ 90, 0, i * 360 / num_cutouts ])
                    {
                        cylinder( h = outer_bottom_r * 2, r = cutout_r, center = true );
                    }
                }

                // top arch
                translate([ 0, 0, cutout_section_offset_z + cutout_section_z - wall_width - cutout_r ])
                {
                    rotate([ 90, 0, i * 360 / num_cutouts ])
                    {
                        cylinder( h = outer_bottom_r * 2, r = cutout_r, center = true );
                    }
                }

                translate([ 0, 0, cutout_section_offset_z + cutout_section_z / 2 ])
                    rotate([ 0, 0, i * 360 / num_cutouts ])
                        cube([ outer_bottom_r * 2, cutout_r * 2, cutout_section_z - cutout_r * 2 - wall_width * 2 ], center = true );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
