include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// 2 = 50
// 3 = 75
// 4 = 100
// 5 = 125
// 6 = 150

multiboard_cell_size = 25.0;

// hole_r = 5.5 / 2; // multiboard hole size
hole_r = 4.2 / 2 + 0.5; // screw diameter

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

board_size_x = 10;
board_size_y = 10;

jig_z = 3;

corner_r = 10;

strut_bottom_width = 6;
strut_bottom_height = 1.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

jig_x_on_center = board_size_x * multiboard_cell_size;
jig_y_on_center = board_size_y * multiboard_cell_size;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    MultiboardDrillJig();
}
else if( render_mode == "print" )
{
    translate([ corner_r, corner_r, 0 ])
        MultiboardDrillJig();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardDrillJig()
{
    translate([
        0,
        0,
        0
        ])
        _MultiboardDrillJigCorner();

    translate([
        jig_x_on_center,
        0,
        0
        ])
        _MultiboardDrillJigCorner();

    translate([
        0,
        jig_y_on_center,
        0
        ])
        _MultiboardDrillJigCorner();

    translate([
        jig_x_on_center,
        jig_y_on_center,
        0
        ])
        _MultiboardDrillJigCorner();

    translate([
        0,
        0,
        0
        ])
        _MultiboardDrillJigStrut( jig_x_on_center );

    translate([
        jig_x_on_center,
        0,
        0
        ])
        rotate([ 0, 0, 90 ])
            _MultiboardDrillJigStrut( jig_y_on_center );

    translate([
        0,
        0,
        0
        ])
        rotate([ 0, 0, 90 ])
            _MultiboardDrillJigStrut( jig_y_on_center );

    translate([
        0,
        jig_y_on_center,
        0
        ])
        rotate([ 0, 0, 0 ])
            _MultiboardDrillJigStrut( jig_x_on_center );

    cross_strut_angle = atan( board_size_y / board_size_x );
    cross_strut_length = sqrt( jig_x_on_center * jig_x_on_center + jig_y_on_center * jig_y_on_center );

    translate([
        0,
        0,
        0
        ])
        rotate([ 0, 0, cross_strut_angle ])
            translate([ 0, 0, 0 ])
                _MultiboardDrillJigStrut( cross_strut_length );

    translate([
        0,
        jig_y_on_center,
        0
        ])
        rotate([ 0, 0, -cross_strut_angle ])
            translate([ 0, 0, 0 ])
                _MultiboardDrillJigStrut( cross_strut_length );

    echo( "", atan( board_size_y / board_size_x ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardDrillJigCorner()
{
    if( render_mode == "preview" )
    {
        # translate([
            0,
            0,
            -jig_z / 2
            ])
            cylinder(
                r = hole_r,
                h = jig_z * 2
                );
    }

    difference()
    {
        cylinder(
            r = corner_r,
            h = jig_z
            );

        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                r = hole_r,
                h = jig_z * 2 + DIFFERENCE_CLEARANCE * 2
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardDrillJigStrut( length )
{
    adjusted_length = length - hole_r * 2;

    // flat bottom
    translate([
        hole_r,
        -strut_bottom_width / 2,
        0
        ])
        cube([
            adjusted_length,
            strut_bottom_width,
            strut_bottom_height
            ]);

    // vertical strut
    translate([
        hole_r,
        -strut_bottom_height / 2,
        0
        ])
        cube([
            adjusted_length,
            strut_bottom_height,
            jig_z
            ]);

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
