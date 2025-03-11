////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/text-label.scad>
include <modules/trapezoidal-prism.scad>
include <modules/utils.scad>

use <assets/PermanentMarker-Regular.ttf>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

window_y = 15;

sign_z_offset = 75.0;

cord_diameter = 3.6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// TODO: vertical entry for cord somewhere

// render_mode = "preview";
render_mode = "print";

base_y = 6.0;
base_z = 10.0;

window_text_label_y = 3.0;

font = "PermanentMarker";
extra_text_descent = 0.3;

// for text under the sign
// font_size = 60;
// for_under_sign = true;

// for text to the side of the sign
font_size = 100;
for_under_sign = false;


sections = [
    // 60 pt
    // [ "Caro", 20, 1, false, false ],
    // [ "lina", 1, 20, false, false ],
    // [ "Hurri", 20, 0, false, false ],
    // [ "canes", 4, 0, false, false ]

    // 100 pt
    [ "Ca", 20, 1, false, true ],
    [ "rol", 0, 0, true, true ],
    [ "ina", 0, 20, true, true ],

    [ "Hu", 20, 0, true, true ],
    [ "rr", 0, 0, true, true ],
    [ "ic", 0, 0, true, true ],
    [ "an", 0, 0, true, true ],
    [ "es", 0, 0, true, true ],

    // 110 pt
    // [ "Ca", 20, 1, false, true ],
    // [ "ro", 0, 0, true, true ],
    // [ "li", 5, 0, true, true ],
    // [ "na", 4, 20, true, false ],
    // [ "Hu", 20, -2, false, true ],
    // [ "rr", 0, 2, true, true ],
    // [ "ic", 0, 6, true, true ],
    // [ "an", 6, -4, true, true ],
    // [ "es", 0, 20, true, false ]
];

vertical_preview_section_spacing = 1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 16 : 64;

cord_cutout_r = cord_diameter / 2 * 1.5;

section_sizes_x = [ for( section = sections ) CalculateSectionX( section ) ];

total_x = sumList( section_sizes_x );
echo();
echo( "Total X:" );
echo( str( total_x, " mm" ));
echo( str( total_x * 0.03937008, " in" ) );
echo();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // preview the window edge
    % translate([ -100, 0, -0.11 ])
        cube([ 1000, window_y, 0.1 ]);

    // preview the sign bottom
    if( for_under_sign )
    {
        % translate([ -100, 0, sign_z_offset ])
            cube([ 1000, window_y, 0.1 ]);
    }

    // preview the cord
    % translate([ -100, window_y - cord_diameter / 2, base_z / 2 ])
        rotate([ 0, 90, 0 ])
            scale([ 1, 0.8, 1 ])
                cylinder( r = cord_diameter / 2, h = 1000 );

    // preview vertical version
    for( i = [ 0 : len( sections ) - 1 ] )
    {
        x_offset = sumTo( section_sizes_x, i ) + i * vertical_preview_section_spacing;

        translate([ x_offset, window_y - base_y, 0 ])
            WindowTextLabel( sections[ i ] );
    }

    // preview the build plates
    for( i = [ 0 : len( sections ) - 1 ] )
    {
        section = sections[ i ];

        x_offset = i * ( BUILD_PLATE_X + 10 );

        # translate([ x_offset, 100, -0.11 ])
            cube([ BUILD_PLATE_X, BUILD_PLATE_Y, 0.1 ]);

        translate([ x_offset, 100, base_y ])
            rotate([ -90, 0, 0 ])
                WindowTextLabel( section );
    }
}
else if( render_mode == "print" )
{
    render()
    {
        translate([ 0, 0, base_y ])
            rotate([ -90, 0, 0 ])
                WindowTextLabel( sections[ 0 ] );
    }
}
else
{
    assert( false, "Unknown render mode" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateSectionX( section_config ) =
        + textmetrics( text = section_config[ 0 ], size = font_size, font = font ).size[ 0 ]
        + section_config[ 1 ]
        + section_config[ 2 ];

module WindowTextLabel( section_config )
{
    text_string = section_config[ 0 ];
    extra_base_left = section_config[ 1 ];
    extra_base_right = section_config[ 2 ];
    magnet_left = section_config[ 3 ];
    magnet_right = section_config[ 4 ];

    // text_string_metrics = textmetrics(
    //     text = text_string,
    //     size = font_size,
    //     font = font );

    // text_string_metrics_size = text_string_metrics.size;

    // font_metrics = fontmetrics( font = font, size = font_size);

    // TODO: technically some glyphs go below the baseline, but don't know how to handle?

    base_x = CalculateSectionX( section_config );

    assert( base_x < BUILD_PLATE_X, "TOO LONG!" );

    total_z = base_z
        - extra_text_descent
        + textmetrics( text = section_config[ 0 ], size = font_size, font = font ).size[ 1 ];

    assert( total_z < sign_z_offset || !for_under_sign, "Warning!  Will not find under sign!!!" );

    // base
    difference()
    {
        union()
        {
            // main block
            translate([ 0, base_y, base_z / 2 ])
                rotate([ 0, 90, 0 ])
                    scale([ 1, 0.9, 1 ])
                        cylinder( r = base_z / 2, h = base_x );

            // text
            translate([ extra_base_left, base_y, base_z - extra_text_descent ])
                rotate([ 90, 0, 0 ])
                    linear_extrude( window_text_label_y )
                        text( text_string, size = font_size, font = font );
        }

        // remove the back
        translate([ -DIFFERENCE_OFFSET, base_y, -DIFFERENCE_OFFSET ])
            cube([ base_x + DIFFERENCE_OFFSET * 2, base_y, base_z + DIFFERENCE_OFFSET * 2 ]);

        // remove the cord path
        translate([ -DIFFERENCE_OFFSET, base_y, base_z / 2 ])
            rotate([ 0, 90, 0 ])
                cylinder( r = cord_cutout_r, h = base_x + DIFFERENCE_OFFSET * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
