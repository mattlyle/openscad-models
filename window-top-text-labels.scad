////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/text-label.scad>
include <modules/trapezoidal-prism.scad>
include <modules/triangular-prism.scad>
include <modules/pinch-connector-tray.scad>
include <modules/command-strips.scad>
include <modules/utils.scad>

use <assets/PermanentMarker-Regular.ttf>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

window_y = 15;

sign_z_offset = 75.0;

cord_r = 3.6 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// TODO: vertical entry for cord somewhere
// TODO: command strip inset on the backs?

render_mode = "preview";
// render_mode = "print-bottom-tray";
// render_mode = "print-top-tray-0";
// render_mode = "print-top-tray-1";
// render_mode = "print-top-tray-2";
// render_mode = "print-top-tray-3";
// render_mode = "print-top-tray-4";
// render_mode = "print-top-tray-5";
// render_mode = "print-top-tray-6";
// render_mode = "print-top-tray-7";
// render_mode = "print-top-tray-8";
// render_mode = "print-top-tray-9";

bottom_tray_x = 250;
bottom_tray_y = 5.0;
bottom_tray_z = 6.0;
bottom_tray_offset_z = 9.0;
bottom_tray_junction_z = 2.2;

window_base_offset_y = 1.0;
window_base_offset_overlap_z = 1.0;

window_text_label_y = 3.0;

font = "PermanentMarker";
extra_text_descent = 0.3;

connector_angle = 45;

// for text under the sign
// font_size = 60;
// for_under_sign = true;

// for text to the side of the sign
font_size = 100;
font_y_scale = 1.2;
for_under_sign = false;

vertical_preview_section_spacing = 1;

// TODO: need to specify z offset for each set... R is bad!

sections = [
    // 60 pt
    // [ "Caro", 20, 1, false, false ],
    // [ "lina", 1, 20, false, false ],
    // [ "Hurri", 20, 0, false, false ],
    // [ "canes", 4, 0, false, false ]

    // 100 pt
    [ "Ca", 30, 11, false, true ],
    [ "rol", 10, 10, true, true ],
    [ "ina", 10, 30, true, true ],

    [ "Hu", 30, 10, true, true ],
    [ "rr", 10, 10, true, true ],
    [ "ic", 10, 20, true, true ],
    [ "an", 10, 10, true, true ],
    [ "es", 10, 30, true, true ],

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 16 : 64;

cord_cutout_r = cord_r * 2;

section_sizes_x = [ for( section = sections ) CalculateSectionX( section ) ];

total_x = sumList( section_sizes_x );
echo();
echo( "Total X:" );
echo( str( total_x, " mm" ));
echo( str( total_x * 0.03937008, " in" ) );
echo();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

// translate([ 0, 0, bottom_tray_y ])
// rotate([ -90, 0, 0 ])
// WindowTextLabelBottom( 150 );

// translate([ 0, 25, 0 ])
// PinchConnectorTrayTop( 70, bottom_tray_z );

if( render_mode == "preview" )
{
    // preview the window edge
    % translate([ -100, 0, -0.11 ])
        cube([ 1000, window_y, 0.1 ]);

    // preview the LED strip
    // TODO: finish!

    // preview the sign bottom
    if( for_under_sign )
    {
        % translate([ -100, 0, sign_z_offset ])
            cube([ 1000, window_y, 0.1 ]);
    }

    // preview the cord
    % translate([ -100, window_y - cord_r - 2, bottom_tray_offset_z + bottom_tray_z / 2 + 3 ])
        rotate([ 0, 90, 0 ])
            scale([ 1, 0.8, 1 ])
                cylinder( r = cord_r, h = 1000 );

    // preview vertical version
    for( i = [ 0 : len( sections ) - 1 ] )
    {
        section = sections[ i ];

        x_offset = sumTo( section_sizes_x, i ) + i * vertical_preview_section_spacing;

        translate([ x_offset, window_y - bottom_tray_y, 0 ])
            WindowTextLabelTop( section );

        translate([ x_offset, window_y - bottom_tray_y, 0 ])
            WindowTextLabelBottom( CalculateSectionX( section ) );
    }

    // preview the build plates
    for( i = [ 0 : len( sections ) - 1 ] )
    {
        section = sections[ i ];

        x_offset = i * ( BUILD_PLATE_X + 10 );

        # translate([ x_offset, 100, -0.11 ])
            cube([ BUILD_PLATE_X, BUILD_PLATE_Y, 0.1 ]);

        translate([ x_offset, 100, bottom_tray_y ])
            rotate([ -90, 0, 0 ])
                WindowTextLabelBottom( CalculateSectionX( section ) );

        translate([ x_offset, 140, bottom_tray_y ])
            rotate([ -90, 0, 0 ])
                WindowTextLabelTop( section );
    }
}
else if( render_mode == "print-bottom-tray" )
{
    render()
        translate([ 0, 0, bottom_tray_y ])
            rotate([ -90, 0, 0 ])
                WindowTextLabelBottom( bottom_tray_x );
}
else if( render_mode == "print-top-tray-0" )
{
    PrintPlate( 0 );
}
else if( render_mode == "print-top-tray-1" )
{
    PrintPlate( 1 );
}
else if( render_mode == "print-top-tray-2" )
{
    PrintPlate( 2 );
}
else if( render_mode == "print-top-tray-3" )
{
    PrintPlate( 3 );
}
else if( render_mode == "print-top-tray-4" )
{
    PrintPlate( 4 );
}
else if( render_mode == "print-top-tray-5" )
{
    PrintPlate( 5 );
}
else if( render_mode == "print-top-tray-6" )
{
    PrintPlate( 6 );
}
else if( render_mode == "print-top-tray-7" )
{
    PrintPlate( 7 );
}
else if( render_mode == "print-top-tray-8" )
{
    PrintPlate( 8 );
}
else if( render_mode == "print-top-tray-9" )
{
    PrintPlate( 9 );
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

module WindowTextLabelTop( section_config )
{
    text_string = section_config[ 0 ];
    extra_base_left = section_config[ 1 ];
    extra_base_right = section_config[ 2 ];
    connector_left = section_config[ 3 ];
    connector_right = section_config[ 4 ];

    // text_string_metrics = textmetrics(
    //     text = text_string,
    //     size = font_size,
    //     font = font );

    // text_string_metrics_size = text_string_metrics.size;

    // font_metrics = fontmetrics( font = font, size = font_size);

    // TODO: technically some glyphs go below the baseline, but don't know how to handle?

    base_x = CalculateSectionX( section_config );

    assert( base_x < BUILD_PLATE_X, "TOO LONG!" );

    total_z = bottom_tray_offset_z
        + bottom_tray_z
        - extra_text_descent
        + textmetrics( text = section_config[ 0 ], size = font_size, font = font ).size[ 1 ];

    assert( total_z < sign_z_offset || !for_under_sign, "Warning!  Will not find under sign!!!" );

    connector_edge = bottom_tray_z + 0.5;

    // TODO: where is this 1.8 coming from?

    difference()
    {
        translate([
            0,
            -4,
            bottom_tray_offset_z + bottom_tray_junction_z - 1.8 + CalculatePinchConnectorTrayTopY( bottom_tray_y )
            ])
            rotate([ -90, 0, 0 ])
                PinchConnectorTrayTop( base_x, bottom_tray_z );

        if( connector_left )
        {
            translate([
                -DIFFERENCE_OFFSET,
                -4 - DIFFERENCE_OFFSET + connector_edge,
                0
                ])
                rotate([ 180, -90, 0 ])
                    TriangularPrism( 30, connector_edge, connector_edge );
        }

        if( connector_right )
        {
            // add the 0.9 so the sides meet better

            translate([
                base_x + DIFFERENCE_OFFSET,
                -4 - DIFFERENCE_OFFSET,
                0
                ])
                rotate([ 0, -90, 0 ])
                    TriangularPrism( 30, connector_edge, connector_edge  * 0.9 );
        }
    }

// TODO: must cut out inside the tray or the join can get blocked?!

    // TODO: extra 5?
    // text
    translate([
        extra_base_left,
        bottom_tray_y - 3,
        bottom_tray_offset_z + bottom_tray_z - extra_text_descent + 5
        ])
        rotate([ 90, 0, 0 ])
            scale([ 1, font_y_scale, 1 ])
            linear_extrude( window_text_label_y )
                text( text_string, size = font_size, font = font );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WindowTextLabelBottom( x )
{
    assert( x < BUILD_PLATE_X, "TOO LONG!" );

    // offset
    translate([ 0, bottom_tray_y - window_base_offset_y, 0 ])
        cube([
            x,
            window_base_offset_y,
            bottom_tray_offset_z  + window_base_offset_overlap_z + bottom_tray_junction_z
            ]);

    // connector top
    translate([
        0,
        bottom_tray_y,
        bottom_tray_offset_z
            + CalculatePinchConnectorTrayTopYOffset()
            ])
        rotate([ 90, 0, 0 ])
            PinchConnectorTrayBottom( x, bottom_tray_z, bottom_tray_y );

    // sloped section
    translate([ 0, 5, 2 ])
        rotate([ 135, 0, 0 ])
            cube([ x, bottom_tray_y + 4.4, 1.2 ]);
    // TODO: constants?!

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PrintPlate( i )
{
    render()
        translate([ 0, 0, bottom_tray_y ])
            rotate([ 90, 0, 180 ])
                WindowTextLabelTop( sections[ i ] );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
