////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/text-label.scad>
include <modules/utils.scad>

use <assets/PermanentMarker-Regular.ttf>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

window_y = 15;

cord_diameter = 3.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

base_y = 12.0;
base_z = 6.0;

window_text_label_y = 5.0;

// text_string = "Carolina";
// extra_base_left = 0;
// extra_base_right = 0;

text_string = "Car";
extra_base_left = 10;
extra_base_right = 0;

// text_string = "oli";
// extra_base_left = 0;
// extra_base_right = 0;

// text_string = "na";
// extra_base_left = 0;
// extra_base_right = 10;

font = "PermanentMarker";
font_size = 100;

difference_offset = 0.01;

extra_text_descent = 0.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 16 : 64;

cord_cutout_r = cord_diameter * 1.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models


if( render_mode == "preview" )
{
    // preview the window edge
    % translate([ -100, 0, -0.11 ])
        cube([ 1000, window_y, 0.1 ]);

    // preview the cord
    % translate([ -100, base_y + cord_diameter / 2, cord_diameter / 2 ])
        rotate([ 0, 90, 0 ])
            cylinder( r = cord_diameter / 2, h = 1000 );

    // vertical version
    translate([ 0, window_y - base_y, 0 ])
        WindowTextLabel();

    // preview the build plate
    # translate([ 0, 100, -0.11 ])
        cube([ BUILD_PLATE_X, BUILD_PLATE_Y, 0.1 ]);

    // preview the print version
    translate([ 0, 100, base_y ])
        rotate([ -90, 0, 0])
            WindowTextLabel();
}
else if( render_mode == "print" )
{
    translate([ 0, 0, base_y ])
        rotate([ -90, 0, 0])
            WindowTextLabel();
}
else
{
    assert( false, "Unknown render mode" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO need a vertical access for the cord
// TODO: how to hook together?

module WindowTextLabel()
{
    text_string_metrics = textmetrics(
        text = text_string,
        size = font_size,
        font = font );

    text_string_metrics_size = text_string_metrics.size;

    // font_metrics = fontmetrics( font = font, size = font_size);

    // TODO: technically some glyphs can go below the baseline, but not sure how to handle?

    base_x = extra_base_left + text_string_metrics_size[ 0 ] + extra_base_right;

    if( base_x > BUILD_PLATE_X && render_mode == "print" )
    {
        assert( false, "TOO LONG!" );
    }

    // base
    difference()
    {
        union()
        {
            // main block
            cube([ base_x, base_y, base_z ]);

            // text
            translate([ extra_base_left, base_y, base_z - extra_text_descent ])
                rotate([ 90, 0, 0 ])
                    linear_extrude( window_text_label_y )
                        text( text_string, size = font_size, font = font );
        }

        // remove the cord path
        translate([ -difference_offset, base_y, 0 ])
            rotate([ 0, 90, 0 ])
                cylinder( r = cord_cutout_r, h = base_x + difference_offset * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
