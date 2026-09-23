include <../modules/utils.scad>
include <../modules/rounded-cube.scad>

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
hole_r = 6.35 / 2 + 0.35; // main drill bit

quad_center_r = 5.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";
// render_mode = "print-corner";

board_size_x = 10;
board_size_y = 10;

jig_z = 22;

corner_edge_length = 20;

strut_bottom_width = 8;
strut_bottom_height = 1.4;

num_mid_struts = 2;

top_struct_offset_y = 12;

vacuum_adapter_depth = 12.0;
vacuum_adapter_r1 = 31.1 / 2;
vacuum_adapter_r2 = 31.5 / 2;
vacuum_adapter_wall_width = 1.4;
vacuum_adapter_clearance = 0.08;
vacuum_adapter_chute_depth = 30;
vacuum_adapter_drill_cutout_z = 6;
vacuum_adapter_top_notch_edge_length = 0.8;
vacuum_adapter_top_notch_edge_scale = 2.0;
vacuum_adapter_rounding_r = 1.0;
vacuum_adapter_extra_width = 0.5;
vacuum_adapter_air_inlet_r = 2.2;
vacuum_adapter_air_inlet_offset_z = 1.0;
vacuum_adapter_air_inlet_z_angle = 30;
vacuum_adapter_air_inlet_x_angle = 10;

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

    # translate([ -100, 0, 0 ])
        rotate([ 0, 0, 45 ])
            MultiboardCombinedQuadSnap();

    # translate([ 125, 275, 18 ])
        rotate([ 180, 0, 0 ])
            import( file = "../assets/multiboard - 10x2 MU - Mounting Template.stl" );
}
else if( render_mode == "print" )
{
    MultiboardDrillJig();
}
else if( render_mode == "print-corner" )
{
    _MultiboardDrillJigCorner();
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

    // bottom edge strut
    translate([
        corner_edge_length / 2,
        0,
        0
        ])
        _MultiboardDrillJigStrut( jig_x_on_center - corner_edge_length, false );

    // right edge strut
    translate([
        jig_x_on_center,
        corner_edge_length / 2,
        0
        ])
        rotate([ 0, 0, 90 ])
            _MultiboardDrillJigStrut(
                jig_y_on_center
                - top_struct_offset_y / 2
                + strut_bottom_width / 2
                + strut_bottom_height / 2
                - corner_edge_length,
                false
                );

    // left edge strut
    translate([
        0,
        corner_edge_length / 2,
        0
        ])
        rotate([ 0, 0, 90 ])
            _MultiboardDrillJigStrut(
                jig_y_on_center
                - top_struct_offset_y / 2
                + strut_bottom_width / 2
                + strut_bottom_height / 2
                - corner_edge_length,
                false
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
        union()
        {
            // corner cube
            translate([
                -corner_edge_length / 2,
                -corner_edge_length / 2,
                0
                ])
                RoundedCubeAlt2(
                    corner_edge_length,
                    corner_edge_length,
                    jig_z,
                    r = vacuum_adapter_rounding_r,
                    round_bottom = false,
                    round_top = true,
                    round_front = false
                    );

            // chute outside
            _VacuumAdapterChuteOutside();

            // adapter outside
            translate([
                -vacuum_adapter_r2 - vacuum_adapter_clearance - vacuum_adapter_wall_width,
                -vacuum_adapter_chute_depth - vacuum_adapter_depth,
                0
                ])
                RoundedCubeAlt2(
                    ( vacuum_adapter_r2 + vacuum_adapter_clearance + vacuum_adapter_wall_width ) * 2,
                    vacuum_adapter_depth,
                    ( vacuum_adapter_r2 + vacuum_adapter_clearance + vacuum_adapter_wall_width ) * 2,
                    r = vacuum_adapter_rounding_r,
                    round_bottom = false,
                    round_top = true,
                    round_back = false
                    );
        }

        // cut out the drill hole
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                r = hole_r,
                h = jig_z + DIFFERENCE_CLEARANCE * 2
                );

        // expand the bottom so vacuum has more room to pull air through
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                r1 = hole_r + vacuum_adapter_extra_width,
                r2 = hole_r,
                h = vacuum_adapter_drill_cutout_z
                );

        // cut out the inner chute
        _VacuumAdapterChuteInside();

        // adapter inside
        translate([
            0,
            -vacuum_adapter_chute_depth + DIFFERENCE_CLEARANCE,
            vacuum_adapter_r2
                + vacuum_adapter_clearance
                + vacuum_adapter_wall_width
            ])
            rotate([ 90, 0, 0 ])
                cylinder(
                    r1 = vacuum_adapter_r1 + vacuum_adapter_clearance,
                    r2 = vacuum_adapter_r2 + vacuum_adapter_clearance,
                    h = vacuum_adapter_depth + DIFFERENCE_CLEARANCE * 2
                    );

        // top notch because vertical circles don't print well
        translate([
            -sqrt( 2 * vacuum_adapter_top_notch_edge_length * vacuum_adapter_top_notch_edge_length ) / 2 * vacuum_adapter_top_notch_edge_scale,
            -vacuum_adapter_chute_depth - vacuum_adapter_depth - DIFFERENCE_CLEARANCE,
            vacuum_adapter_r2 * 2 + vacuum_adapter_clearance + vacuum_adapter_wall_width
            ])
            scale([ vacuum_adapter_top_notch_edge_scale, 1, 1 ])
                rotate([ 0, 45, 0 ])
                    cube([
                        vacuum_adapter_top_notch_edge_length,
                        vacuum_adapter_depth,
                        vacuum_adapter_top_notch_edge_length
                        ]);

        // left air inlet
        translate([ 0, 0, vacuum_adapter_air_inlet_r + vacuum_adapter_air_inlet_offset_z ])
            rotate([ -90 + vacuum_adapter_air_inlet_x_angle, 0, vacuum_adapter_air_inlet_z_angle ])
                cylinder( r = vacuum_adapter_air_inlet_r, h = corner_edge_length );

        // right air inlet
        translate([ 0, 0, vacuum_adapter_air_inlet_r + vacuum_adapter_air_inlet_offset_z ])
            rotate([ -90 + vacuum_adapter_air_inlet_x_angle, 0, -vacuum_adapter_air_inlet_z_angle ])
                cylinder( r = vacuum_adapter_air_inlet_r, h = corner_edge_length );

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VacuumAdapterChuteOutside()
{
    hull()
    {
        _VacuumAdapterChuteOutsidePoint( true, true, true );
        _VacuumAdapterChuteOutsidePoint( true, true, false );
        _VacuumAdapterChuteOutsidePoint( false, true, false );
        _VacuumAdapterChuteOutsidePoint( false, true, true );

        _VacuumAdapterChuteOutsidePoint( true, false, true );
        _VacuumAdapterChuteOutsidePoint( true, false, false );
        _VacuumAdapterChuteOutsidePoint( false, false, false );
        _VacuumAdapterChuteOutsidePoint( false, false, true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VacuumAdapterChuteOutsidePoint( is_near, is_left, is_bottom )
{
    small_edge = corner_edge_length / 2;
    big_edge = vacuum_adapter_r2 + vacuum_adapter_clearance + vacuum_adapter_wall_width;

    r = is_bottom
        ? DIFFERENCE_CLEARANCE
        : vacuum_adapter_rounding_r;

    x = is_near
        ? ( is_left ? -small_edge : -big_edge ) + r
        : ( is_left ? small_edge : big_edge ) - r;

    y = is_left
        ? -small_edge
        : -vacuum_adapter_chute_depth;

    z = is_bottom
        ? r
        : ( is_left ? jig_z : big_edge * 2 ) - r;

    // TODO: we should remove the left or right side of the sphere appropriately

    translate([ x, y, z ])
        sphere( r = r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VacuumAdapterChuteInside()
{
    n = $fn;

    angles = [ for( i = [ 0 : n - 1 ] ) i * 360 / n ];

    drill_bit_cutout_pts = [
        for( angle = angles )
            let( x = vacuum_adapter_drill_cutout_z * cos( angle ) )
            let( y = -DIFFERENCE_CLEARANCE )
            let( z = angle < 180 ? vacuum_adapter_drill_cutout_z * sin( angle ) : 0 )
            [ x, y, z ]
    ];

    vacuum_adapter_pts = [
        for( angle = angles )
        let( x = vacuum_adapter_r1 * cos( angle ) )
        let( y = -vacuum_adapter_chute_depth - DIFFERENCE_CLEARANCE )
        let( z = vacuum_adapter_r1 * sin( angle )
                + vacuum_adapter_r1
                + vacuum_adapter_clearance
                + vacuum_adapter_wall_width
                )
        [ x, y, z ]
    ];

    points = concat( drill_bit_cutout_pts, vacuum_adapter_pts );
    faces = concat(
        [[ for( i = [ 0 : n - 1 ] ) i ]],                                            // cutout cap
        [[ for( i = [ n - 1 : -1 : 0 ] ) n + i ]],                                   // adapter cap (reversed)
        [ for( i = [ 0 : n - 1 ] ) [ i, n + i, n + ( i + 1 ) % n, ( i + 1 ) % n ] ]  // side quads
        );

    polyhedron( points = points, faces = faces, convexity = 1 );
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
