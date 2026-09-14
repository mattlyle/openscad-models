include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// 2 = 50
// 3 = 75
// 4 = 100
// 5 = 125
// 6 = 150

multiboard_cell_size = 25.0;

// hole_r = 5.5 / 2; // multiboard hole size
// hole_r = 4.2 / 2; // screw diameter

// hole_r = 3.2 / 2 + 0.5; // pilot drill hole
hole_r = 6.4 / 2 + 0.5; // main drill bit

quad_center_r = 5.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

board_size_x = 10;
board_size_y = 10;

jig_z = 12;

// corner_r = 10;
corner_edge_length = 20;

strut_bottom_width = 6;
strut_bottom_height = 1.4;

num_mid_struts = 2;

top_struct_offset_y = 12;

vacuum_adapter_depth = 10.0;
vacuum_adapter_r1 = 31.1 / 2;
vacuum_adapter_r2 = 31.5 / 2;
vacuum_adapter_wall_width = 1.4;
vacuum_adapter_clearance = 0.15;
vacuum_adapter_chute_depth = 30;

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

    translate([ 0, -100, 0 ])
        rotate([ 0, 0, 45 ])
            MultiboardCombinedQuadSnap();

    #translate([ 125, 275, 18 ])
        rotate([ 180, 0, 0 ])
            import( file = "../assets/multiboard - 10x2 MU - Mounting Template.stl" );
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
    // bottom left corner
    translate([
        0,
        0,
        0
        ])
        _MultiboardDrillJigCorner();

    // bottom right corner
    translate([
        jig_x_on_center,
        0,
        0
        ])
        _MultiboardDrillJigCorner();

    // top left corner
    // translate([
    //     0,
    //     jig_y_on_center,
    //     0
    //     ])
    //     _MultiboardDrillJigCorner();

    // top right corner
    // translate([
    //     jig_x_on_center,
    //     jig_y_on_center,
    //     0
    //     ])
    //     _MultiboardDrillJigCorner();

    // bottom edge strut
    translate([
        0,
        0,
        0
        ])
        _MultiboardDrillJigStrut( jig_x_on_center, true );

    // right edge strut
    translate([
        jig_x_on_center,
        0,
        0
        ])
        rotate([ 0, 0, 90 ])
            _MultiboardDrillJigStrut(
                jig_y_on_center
                - top_struct_offset_y
                + strut_bottom_width / 2,
                true
                );

    // left edge strut
    translate([
        0,
        0,
        0
        ])
        rotate([ 0, 0, 90 ])
            _MultiboardDrillJigStrut(
                jig_y_on_center
                - top_struct_offset_y
                + strut_bottom_width / 2,
            true
            );

    // top strut
    translate([
        0,
        jig_y_on_center - top_struct_offset_y,
        0
        ])
        rotate([ 0, 0, 0 ])
            _MultiboardDrillJigStrut( jig_x_on_center, false );

    // mid horizontal and vertical stuts
    for( i = [ 1 : num_mid_struts ] )
    {
        location_percent = i / ( num_mid_struts + 1 );
        // echo( location_percent );

        // horizontal
        translate([
            0,
            jig_y_on_center * location_percent,
            0
            ])
            _MultiboardDrillJigStrut( jig_x_on_center, false );

        // vertical
        translate([
            jig_x_on_center * location_percent,
            0,
            0
            ])
            rotate([ 0, 0, 90 ])
                _MultiboardDrillJigStrut( jig_y_on_center - top_struct_offset_y, false );
    }

    // diagonal strust

    // cross_strut_angle = atan( board_size_y / board_size_x );
    // cross_strut_length = sqrt( jig_x_on_center * jig_x_on_center + jig_y_on_center * jig_y_on_center );

    // translate([
    //     0,
    //     0,
    //     0
    //     ])
    //     rotate([ 0, 0, cross_strut_angle ])
    //         translate([ 0, 0, 0 ])
    //             _MultiboardDrillJigStrut( cross_strut_length, true );

    // translate([
    //     0,
    //     jig_y_on_center,
    //     0
    //     ])
    //     rotate([ 0, 0, -cross_strut_angle ])
    //         translate([ 0, 0, 0 ])
    //             _MultiboardDrillJigStrut( cross_strut_length, true );

    // left
    translate([ 0, jig_y_on_center, 0 ])
        rotate([ 0, 0, 45 ])
            MultiboardCombinedQuadSnapCorner();

    // right
    translate([ jig_x_on_center, jig_y_on_center, 0 ])
        rotate([ 0, 0, 45 ])
            MultiboardCombinedQuadSnapCorner();
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
        // corner cube
        translate([
            -corner_edge_length / 2,
            -corner_edge_length / 2,
            0
            ])
            cube([
                corner_edge_length,
                corner_edge_length,
                jig_z
                ]);

        // cut out the drill hole
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                r = hole_r,
                h = jig_z * 2 + DIFFERENCE_CLEARANCE * 2
                );
    }

    // vacuum adapter
    translate([ 0, 0, vacuum_adapter_r2 + vacuum_adapter_clearance + vacuum_adapter_wall_width ])
    {
        difference()
        {
            // outside
            translate([ 0, -50, 0 ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r1 = vacuum_adapter_r1 + vacuum_adapter_clearance + vacuum_adapter_wall_width,
                        r2 = vacuum_adapter_r2 + vacuum_adapter_clearance + vacuum_adapter_wall_width,
                        h = vacuum_adapter_depth
                        );

            // remove inside
            translate([ 0, -50 + DIFFERENCE_CLEARANCE, 0 ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r1 = vacuum_adapter_r1 + vacuum_adapter_clearance,
                        r2 = vacuum_adapter_r2 + vacuum_adapter_clearance,
                        h = vacuum_adapter_depth + DIFFERENCE_CLEARANCE * 2
                        );
        }
    }

    // vacuum adapter chute
    // vacuum_adapter_chute_depth
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardDrillJigStrut( length, adjust_length = true )
{
    adjusted_length = adjust_length
        ? length - hole_r * 2
        : length;

    adjusted_start = adjust_length
        ? hole_r
        : 0;

    // flat bottom
    translate([
        adjusted_start,
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
        adjusted_start,
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

module MultiboardCombinedQuadSnapCorner()
{
    render()
    {
        difference()
        {
            MultiboardCombinedQuadSnap();

            // remove the bottom
            rotate([ 0, 0, -45 ])
                translate([ -40, -40, -DIFFERENCE_CLEARANCE ])
                    cube([ 80, 40, 14 ]);

            // remove the inside
            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                cylinder(
                    r = quad_center_r,
                    h = 10
                    );
        }

        // add the center back
        difference()
        {
            // replacement center
            rotate([ 0, 0, -45 ])
                translate([
                    -top_struct_offset_y,
                    -top_struct_offset_y,
                    0
                    ])
                    cube([
                        top_struct_offset_y * 2,
                        top_struct_offset_y + quad_center_r,
                        strut_bottom_height
                        ]);

            // remove the drill hole
            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                cylinder(
                    r = hole_r,
                    h = strut_bottom_height + DIFFERENCE_CLEARANCE * 2
                    );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardCombinedQuadSnap()
{
    union()
    {
        // bottom
        translate([ 0, 0, 4.67 ])
            rotate([ 0, -90, 0 ])
                import( file = "../assets/6.25 mm - Quad Offset Snaps (DS Part A) - Part 1.stl" );

        // top
        translate([ 0, 0, 4.70 ])
            rotate([ 0, 90, 90 ])
                import( file = "../assets/6.25 mm - Quad Offset Snaps (DS Part A) - Part 2.stl" );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
