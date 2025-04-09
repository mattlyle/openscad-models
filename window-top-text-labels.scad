////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/text-label.scad>
include <modules/trapezoidal-prism.scad>
include <modules/triangular-prism.scad>
include <modules/pinch-connector-tray.scad>
// include <modules/command-strips.scad>
include <modules/utils.scad>

use <assets/PermanentMarker-Regular.ttf>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

window_y = 15;

sign_z_offset = 75.0;

cord_r = 3.6 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// TODO: command strip inset on the backs?

render_mode = "preview";
// render_mode = "print-bottom-tray";
// render_mode = "print-top-tray-0"; // Ca
// render_mode = "print-top-tray-1"; // ro
// render_mode = "print-top-tray-2"; // li
// render_mode = "print-top-tray-3"; // na
// render_mode = "print-top-tray-4"; // Hu
// render_mode = "print-top-tray-5"; // rr
// render_mode = "print-top-tray-6"; // ic
// render_mode = "print-top-tray-7"; // an
// render_mode = "print-top-tray-8"; // es
// render_mode = "print-top-tray-9";

bottom_tray_x = 250;
// bottom_tray_cutout_start_x = 100;
// bottom_tray_cutout_end_x = 140;
bottom_tray_cutout_start_x = -1;
bottom_tray_cutout_end_x = -1;

bottom_tray_y = 5.0;
bottom_tray_z = 6.0;
bottom_tray_offset_z = 9.0;
bottom_tray_junction_z = 2.2;

window_base_offset_y = 1.0;
window_base_offset_overlap_z = 1.0;

window_text_label_y = 3.0;

font = "PermanentMarker";

connector_angle = 45;

// for text to the side of the sign
font_size_main = 120;
font_size_under_sign = 36;

// 0 = letter
// 1 = width adjustment (after the letter)
// 2 = height adjustment (under the letter)
// 3 = rotation
// 4 = scale adjustment (x only)
sections = [

    // carolina
    [ font_size_main, 30, 0, false, true, [
        [ "C", 2, 12, 8, 1.4 ],
        [ "a", 1, 6, 1, 1.2 ],
        ] ],
    [ font_size_main, 2, 0, true, true, [
        [ "r", 0, 5, -4, 1.2 ],
        [ "o", 3, 6, 0, 1.2 ],
        ] ],
    [ font_size_main, 5, 0, true, true, [
        [ "l", -5, 6, 0, 1.2 ],
        [ "i", 9, 6, 0, 1.2 ],
        ] ],
    [ font_size_main, 2, 20, true, true, [
        [ "n", -10, 2, 0, 1.2 ],
        [ "a", 1, 6, 1, 1.2 ],
        ] ],

    // hurricanes
    [ font_size_main, 30, 0, true, true, [
        [ "H", -4, 7, 5, 1.4 ],
        [ "u", 10, 5, 3, 1.2 ],
        ] ],
    [ font_size_main, 5, 0, true, true, [
        [ "r", 3, 5, -4, 1.2 ],
        [ "r", 6, 5, -4, 1.2 ],
        ] ],
    [ font_size_main, -6, 0, true, true, [
        [ "i", 5, 6, 0, 1.2 ],
        [ "c", 2, 5, 0, 1.2 ],
        ] ],
    [ font_size_main, 6, -8, true, true, [
        [ "a", -4, 6, 1, 1.2 ],
        [ "n", 2, 2, 0, 1.2 ],
        ] ],
    [ font_size_main, 0, 30, true, false, [
        [ "e", 0, 8, 5, 1.2 ],
        [ "s", 0, 8, 5, 1.2 ],
        ] ],

    // est 1997
    [ font_size_under_sign, 20, 20, true, false, [
        [ "e", 0, 6, 5, 1.2 ],
        [ "s", 1, 6, 5, 1.2 ],
        [ "t", 20, 6, 5, 1.2 ],

        [ "1", 1, 5, 5, 1.2 ],
        [ "9", 2, 6, 5, 1.2 ],
        [ "9", 1, 6, 5, 1.2 ],
        [ "7", 0, 5, 5, 1.2 ],
        ] ],
];
SECTION_INDEX_FONT_SIZE = 0;
SECTION_INDEX_PADDING_LEFT = 1;
SECTION_INDEX_PADDING_RIGHT = 2;
SECTION_INDEX_SLOPED_CONNECTOR_LEFT = 3;
SECTION_INDEX_SLOPED_CONNECTOR_RIGHT = 4;
SECTION_INDEX_LETTER_CONFIG = 5;

LETTER_INDEX_CHAR = 0;
LETTER_INDEX_ADJUSTMENT_X = 1;
LETTER_INDEX_ADJUSTMENT_Z = 2;
LETTER_INDEX_ROTATION = 3;
LETTER_INDEX_SCALE_Z = 4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function CalculateLetterX( letter_config, font_size ) =
    letter_config[ LETTER_INDEX_ADJUSTMENT_X ]
    + textmetrics(
        text = letter_config[ LETTER_INDEX_CHAR ],
        size = font_size,
        font = font
        ).size[ 0 ];

function GenerateSectionLetterSizesX( section_config ) =
    [
        for( letter_config = section_config[ SECTION_INDEX_LETTER_CONFIG ] )
            CalculateLetterX( letter_config, section_config[ SECTION_INDEX_FONT_SIZE ] )
        ];

function CalculateSectionX( section_config ) =
        sumList( GenerateSectionLetterSizesX( section_config ) )
        + section_config[ SECTION_INDEX_PADDING_LEFT ]
        + section_config[ SECTION_INDEX_PADDING_RIGHT ];

function CalculateLetterOffsetX( section_config, i ) =
    section_config[ SECTION_INDEX_PADDING_LEFT ]
    + sumTo( GenerateSectionLetterSizesX( section_config ), i );

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

if( render_mode == "preview" )
{
    // preview the window edge
    % translate([ -100, 0, -0.11 ])
        cube([ 1000, window_y, 0.1 ]);

    // preview the cord
    % translate([ -100, window_y - cord_r - 2, bottom_tray_offset_z + bottom_tray_z / 2 + 3 ])
        rotate([ 0, 90, 0 ])
            scale([ 1, 0.8, 1 ])
                cylinder( r = cord_r, h = 1000 );

    // preview vertical version
    for( i = [ 0 : len( sections ) - 1 ] )
    {
        section = sections[ i ];

        x_offset = sumTo( section_sizes_x, i ) + i * -5.1;

        translate([ x_offset, window_y - bottom_tray_y, 0 ])
            WindowTextLabelTop( section );

        // translate([ x_offset, window_y - bottom_tray_y, 0 ])
        //     WindowTextLabelBottom( CalculateSectionX( section ) );
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
                WindowTextLabelBottom(
                    bottom_tray_x,
                    bottom_tray_cutout_start_x,
                    bottom_tray_cutout_end_x
                    );
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
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WindowTextLabelTop( section_config )
{
    font_size = section_config[ SECTION_INDEX_FONT_SIZE ];
    extra_base_left = section_config[ SECTION_INDEX_PADDING_LEFT ];
    extra_base_right = section_config[ SECTION_INDEX_PADDING_RIGHT ];
    connector_left = section_config[ SECTION_INDEX_SLOPED_CONNECTOR_LEFT ];
    connector_right = section_config[ SECTION_INDEX_SLOPED_CONNECTOR_RIGHT ];
    letter_config = section_config[ SECTION_INDEX_LETTER_CONFIG ];

    base_x = CalculateSectionX( section_config );

    assert( base_x < BUILD_PLATE_X, "TOO LONG!" );
/*
    total_z = bottom_tray_offset_z
        + bottom_tray_z
        // - extra_text_descent
        + textmetrics( text = section_config[ 0 ], size = font_size, font = font ).size[ 1 ];

    assert( total_z < sign_z_offset || !for_under_sign, "Warning!  Will not find under sign!!!" );
*/
    connector_edge = bottom_tray_z + 0.5;

    // TODO: sooo many constants?!

    difference()
    {
        translate([
            0,
            -4,
            bottom_tray_offset_z
                + bottom_tray_junction_z
                - 1.8
                + CalculatePinchConnectorTrayTopY( bottom_tray_y )
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

    letter_sizes = GenerateSectionLetterSizesX( section_config );

    for( i = [ 0 : len( letter_config ) - 1 ] )
    {
        letter = letter_config[ i ][ LETTER_INDEX_CHAR ];
        letter_adjustment_x = letter_config[ i ][ LETTER_INDEX_ADJUSTMENT_X ];
        letter_adjustment_z = letter_config[ i ][ LETTER_INDEX_ADJUSTMENT_Z ];
        letter_rotation = letter_config[ i ][ LETTER_INDEX_ROTATION ];
        letter_scale_z = letter_config[ i ][ LETTER_INDEX_SCALE_Z ];

        difference()
        {
            translate([
                CalculateLetterOffsetX( section_config, i ),
                bottom_tray_y - 6,
                bottom_tray_offset_z
                    + bottom_tray_z
                    // - extra_text_descent
                    + letter_adjustment_z
                ])
                rotate([ 90, letter_rotation, 0 ])
                    scale([ 1, letter_scale_z, 1 ])
                        linear_extrude( window_text_label_y )
                            text( letter, size = font_size, font = font );

        translate([
            0,
            -PINCH_CONNECTOR_OVERLAP_STOPPER_Y - PINCH_CONNECTOR_OVERLAP_Y,
            bottom_tray_offset_z + PINCH_CONNECTOR_WALL_THICKNESS
            ])
            cube([
                base_x,
                2.5,
                9.65
                ]);
        translate([
            0,
            -PINCH_CONNECTOR_OVERLAP_STOPPER_Y - PINCH_CONNECTOR_OVERLAP_Y,
            bottom_tray_offset_z + PINCH_CONNECTOR_WALL_THICKNESS + 7
            ])
            rotate([ 45, 0, 0 ])
                cube([
                    base_x,
                    1.72,
                    1.72
                    ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WindowTextLabelBottom( x, cutout_start_x = -1, cutout_end_x = -1 )
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
    difference()
    {
        translate([
            0,
            bottom_tray_y,
            bottom_tray_offset_z + CalculatePinchConnectorTrayTopYOffset()
            ])
            rotate([ 90, 0, 0 ])
                PinchConnectorTrayBottom( x, bottom_tray_z, bottom_tray_y );

        if( cutout_start_x >= 0 && cutout_end_x >=0 )
        {
            translate([ cutout_start_x, -2, bottom_tray_offset_z + bottom_tray_z - 2 ])
                cube([ cutout_end_x - cutout_start_x, 5.6, 8 ]);
        }
    }

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
