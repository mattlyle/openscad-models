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

// magnet_diameter = 6.0;
// magnet_height = 2.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// TODO: vertical entry for cord somewhere
// TODO: needs to hide less of the LED strip under

// render_mode = "preview";
render_mode = "print";

base_y = 6.0;
base_z = 7.0;

window_text_label_y = 3.0;

font = "PermanentMarker";
font_size = 60;

difference_offset = 0.1;

extra_text_descent = 0.3;

// magnet_clearance = 0.2;

sections = [
    [ "Caro", 20, 1, false, false ],
    [ "lina", 1, 20, false, false ],

    [ "Hurri", 20, 0, false, false ],
    [ "canes", 4, 0, false, false ]
];

vertical_preview_section_spacing = 1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 16 : 64;

cord_cutout_r = cord_diameter * 1.5;

section_sizes_x = [ for( section = sections ) CalculateSectionX( section ) ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // preview the window edge
    % translate([ -100, 0, -0.11 ])
        cube([ 1000, window_y, 0.1 ]);

    // preview the cord
    % translate([ -100, window_y - cord_diameter / 2, cord_diameter / 2 ])
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

    assert(
        base_z
        - extra_text_descent
        + textmetrics( text = section_config[ 0 ], size = font_size, font = font ).size[ 1 ]
        < sign_z_offset,
        "TOO TALL!" );

    // magnet_offset = ( base_z - magnet_diameter - magnet_clearance * 2 ) / 2;

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
                scale([ 0.8, 1, 1 ])
                    cylinder( r = cord_cutout_r, h = base_x + difference_offset * 2 );

        // if( magnet_left )
        // {
        //     translate([
        //         -difference_offset,
        //         magnet_diameter / 2 + magnet_offset,
        //         magnet_diameter / 2 + magnet_offset
        //         ])
        //         rotate([ 0, 90, 0 ])
        //             cylinder( r = magnet_diameter / 2 + magnet_clearance, h = magnet_height + difference_offset);
        // }

        // if( magnet_right )
        // {
        //     translate([
        //         base_x - magnet_height,
        //         magnet_diameter / 2 + magnet_offset,
        //         magnet_diameter / 2 + magnet_offset
        //         ])
        //         rotate([ 0, 90, 0 ])
        //             cylinder( r = magnet_diameter / 2 + magnet_clearance, h = magnet_height + difference_offset );
        // }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
