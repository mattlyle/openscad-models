////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/text-label.scad>
include <modules/utils.scad>

use <assets/PermanentMarker-Regular.ttf>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

window_y = 15;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

base_y = 12.0;
base_z = 6.0;

window_text_label_y = 5.0;

text_string = "Carolina";

font = "PermanentMarker";

font_size = 10zgit0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 16 : 64;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models


if( render_mode == "preview" )
{
    // preview the window edge
    % translate([ 0, 0, -0.11 ])
        cube([ 1000, window_y, 0.1 ]);

    // vertical version
    translate([ 0, window_y - base_y, 0 ])
        WindowTextLabel();

    // preview the build plate
    # translate([ 0, 100, -0.11 ])
        cube([ BUILD_PLATE_X, BUILD_PLATE_Y, 0.1 ]);

    translate([ 0, 100, base_y ])
        rotate([ -90, 0, 0])
            WindowTextLabel();
}
else if( render_mode == "print" )
{
    WindowTextLabel();
}
else
{
    assert( false, "Unknown render mode" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO: how to hide the cord?
// TODO: how to hook together?

module WindowTextLabel()
{
    text_string_metrics_size = textmetrics(
        text = text_string,
        size = font_size,
        font = font ).size;

    // echo( text_string );
    // echo( text_string_metrics_size );

    base_x = text_string_metrics_size[ 0 ];

    if( base_x > BUILD_PLATE_X && render_mode == "print" )
    {
        assert( false, "TOO LONG!" );
    }

    // base
    cube([ base_x, base_y, base_z ]);

    // text
    translate([ 0, base_y, base_z ])
        rotate([ 90, 0, 0 ])
            linear_extrude( window_text_label_y )
                text( text_string, size = font_size, font = font );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
