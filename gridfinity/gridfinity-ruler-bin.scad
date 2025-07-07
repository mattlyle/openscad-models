include <../modules/gridfinity-base.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// short 20cm ruler
ruler_a_x = 0.7;
ruler_a_y = 26.1;

// long 38cm ruler
ruler_b_x = 1.8;
ruler_b_y = 30.0;

// long 46cm cork-backed ruler (2x of these)
ruler_c_x = 1.4;
ruler_c_y = 32.4;

// tri-ruler
ruler_d_arm_x = 3.5;
ruler_d_arm_y = 16.6;

// angle calipers
angle_calipers_x = 2.7;
angle_calipers_y = 35.3;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print-bin";
// render_mode = "print-text";

cells_x = 2;

cells_bottom_y = 2;
cells_top_y = 1;

back_bin_z = 80;
front_bin_z = 40;

// the height to be added on top of the base
top_min_z = 1;

clearance_x = 0.3;
clearance_y = 0.4;

cutouts = [
    // ===== back row =====

    // ruler c #1
    [ 2, ruler_c_x, ruler_c_y, 0.2, 1 ],

    // ruler c #2
    [ 2, ruler_c_x, ruler_c_y, 0.4, 1 ],

    // angle calipers
    [ 2, angle_calipers_x, angle_calipers_y, 0.70, 1 ],

    // ===== front row =====

    // ruler_a
    [ 2, ruler_a_x, ruler_a_y, 0.2, 0 ],

    // ruler_b
    [ 2, ruler_b_x, ruler_b_y, 0.4, 0 ],

    // tri-ruler
    [ 3, ruler_d_arm_x, ruler_d_arm_y, 0.75, 0 ],
];

preview_z = 200;

label_font = "Georgia:style=Bold";
label_font_size = 14;
label_depth = 0.5;
label_offset_z = 58;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

base_x = CalculateGridfinitySize( cells_x );
base_bottom_y = CalculateGridfinitySize( cells_bottom_y );
base_top_y = CalculateGridfinitySize( cells_top_y );

back_row_offset_y = base_bottom_y - CalculateGridfinitySize( 1 );

base_offset_z = GRIDFINITY_BASE_Z + top_min_z;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if ( render_mode == "preview" )
{
}
else if ( render_mode == "print-bin" )
{
    RulerBin();
}
else if ( render_mode == "print-text" )
{
    RulerBinTextLabel( false );
}
else
{
    echo( str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module RulerBin()
{
    difference()
    {
        union()
        {
            // base
            GridfinityBase( cells_x, cells_bottom_y, top_min_z, center = false );

            // bottom level
            translate([ 0, 0, base_offset_z ])
                RoundedCubeAlt2(
                    base_x,
                    base_bottom_y,
                    front_bin_z,
                    r = GRIDFINITY_ROUNDING_R,
                    round_top = true,
                    round_bottom = false,
                    round_left = true,
                    round_right = true,
                    round_front = true,
                    round_back = true
                    );

            // top bin
            translate([ 0, back_row_offset_y, base_offset_z + front_bin_z - GRIDFINITY_ROUNDING_R ])
                RoundedCubeAlt2(
                    base_x,
                    base_top_y,
                    front_bin_z + GRIDFINITY_ROUNDING_R,
                    r = GRIDFINITY_ROUNDING_R,
                    round_top = true,
                    round_bottom = false,
                    round_left = true,
                    round_right = true,
                    round_front = true,
                    round_back = true
                    );
        }

        for( cutout = cutouts )
        {
            cutout_type = cutout[ 0 ];
            x = cutout[ 1 ];
            y = cutout[ 2 ];
            offset_x = cutout[ 3 ] * base_x;

            if( cutout_type == 2 )
            {
                offset_y = cutout[ 4 ] * CalculateGridfinitySize( 1 )
                    + CenterInGridfinityCell( y, 1 )
                    + 0.25;

                translate([ offset_x, offset_y, base_offset_z + DIFFERENCE_CLEARANCE ])
                    Ruler2Cutout( x, y );
            }
            else if( cutout_type == 3 )
            {
                offset_y = cutout[ 4 ] * CalculateGridfinitySize( 1 )
                    + CalculateGridfinitySize( 0.5 );

                translate([ offset_x, offset_y, base_offset_z + DIFFERENCE_CLEARANCE ])
                    Ruler3Cutout( x, y );
            }
        }

        // remove the label
        RulerBinTextLabel( true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module RulerBinTextLabel( is_difference )
{
    translate([ 0, back_row_offset_y + label_depth, label_offset_z ])
        rotate([ 90, 0, 0 ])
            CenteredTextLabel(
                "Rulers",
                font = label_font,
                font_size = label_font_size,
                centered_in_area_x = base_x,
                centered_in_area_y = -1,
                depth = label_depth,
                color = is_difference ? undef : [ 0, 0, 0 ]
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module Ruler2Cutout( x, y )
{
    cube([ x + clearance_x * 2, y + clearance_y * 2, preview_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module Ruler3Cutout( arm_x, arm_y )
{
    with_clearance_x = arm_x + clearance_x * 2;
    with_clearance_y = arm_y + clearance_y * 2;

    cylinder( h = preview_z, r = with_clearance_x );

    for( i = [ 0 : 2 ] )
        rotate([ 0, 0, i * 120 + 90 ])
            translate([ -with_clearance_x / 2, -0, 0 ])
                cube([ with_clearance_x, with_clearance_y, preview_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
