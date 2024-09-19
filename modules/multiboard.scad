include <trapezoidal-prism.scad>

////////////////////////////////////////////////////////////////////////////////
// measurements

multiboard_cell_size = 25.0;
multiboard_wall_width = 2.0;
multiboard_screw_hole_radius = 3.0;
multiboard_cell_corner_width = 14.0;
multiboard_cell_height = 6.5;

multiboard_connector_back_connector_clearance = 0.15;
multiboard_connector_back_z = 6.5;
multiboard_connector_back_connector_inner_radius = 15.5 / 2 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_outer_radius = 20.0 / 2 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_height = 3 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_vertical_height = 1.5;
multiboard_connector_back_edge_overlap = 5.0;
multiboard_connector_back_pin_size = 1.0;

////////////////////////////////////////////////////////////////////////////////
// calculated

multiboard_cell_octagon_edge = multiboard_cell_size / ( 1 + sqrt( 2 ) );
multiboard_cell_octagon_radius = multiboard_cell_octagon_edge * sqrt( 4 + 2 * sqrt( 2 ) ) / 2;

multiboard_screw_hole_holder_cross = sqrt( multiboard_cell_octagon_edge * multiboard_cell_octagon_edge * 2 );

////////////////////////////////////////////////////////////////////////////////

module MultiboardMockUpTile( num_x, num_y )
{
    // % cube( [ multiboard_cell_size, multiboard_cell_size, multiboard_cell_height ] );

    render()
    {
        for( x = [ 0 : num_x - 1 ] )
        {
            for( y = [ 0 : num_y - 1 ] )
            {
                translate([ multiboard_cell_size / 2 + multiboard_cell_size * x, multiboard_cell_size / 2 + multiboard_cell_size * y, 0 ])
                {
                    difference()
                    {
                        rotate([ 0, 0, 360 / 16 ])
                            cylinder( h = multiboard_cell_height, r = multiboard_cell_octagon_radius, $fn = 8 );
                        rotate([ 0, 0, 360 / 16 ])
                            cylinder( h = multiboard_cell_height, r = multiboard_cell_octagon_radius - multiboard_wall_width / 2, $fn = 8 );
                    }
                }

                if( x > 0 && y > 0 )
                {
                    difference()
                    {
                        translate([ multiboard_cell_size * x, multiboard_cell_size * y, multiboard_cell_height / 2 ])
                            rotate([ 0, 0, 45 ])
                                cube([ multiboard_cell_octagon_edge, multiboard_cell_octagon_edge, multiboard_cell_height ], center = true );
                            
                        translate([ multiboard_cell_size * x, multiboard_cell_size * y, 0 ])
                            cylinder( h = multiboard_cell_height, r = multiboard_screw_hole_radius, $fn = 16 );
                    }
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBack( num_x, num_y )
{
    back_x = multiboard_connector_back_edge_overlap * 2 + num_x * multiboard_cell_size;
    back_y = multiboard_cell_size * num_y;

    render()
    {
        difference()
        {
            cube([ back_x, back_y, multiboard_connector_back_z ]);

            for( x = [ 0 : num_x - 1 ] )
            {
                union()
                {
                    // // cut out the cone
                    translate([ multiboard_connector_back_edge_overlap + multiboard_cell_size / 2 + x * multiboard_cell_size, multiboard_cell_size / 2 + ( num_y - 1 ) * multiboard_cell_size, 0 ])
                        cylinder(
                            h = multiboard_connector_back_connector_height,
                            r1 = multiboard_connector_back_connector_inner_radius,
                            r2 = multiboard_connector_back_connector_outer_radius, $fn = 48 );

                    // cut out from there to the bottom...

                    // slanted top
                    translate([ multiboard_connector_back_edge_overlap + multiboard_cell_size / 2 + x * multiboard_cell_size, ( back_y - multiboard_cell_size / 2 ) / 2, multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height ])
                        TrapezoidalPrism(
                            x_top = multiboard_connector_back_connector_outer_radius * 2,
                            x_bottom = multiboard_connector_back_connector_inner_radius * 2,
                            y = back_y - multiboard_cell_size / 2,
                            z = multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height );

                    // vertical underneath
                    // also cut out the vertical section under the trapazoid
                    translate([ multiboard_connector_back_edge_overlap + multiboard_cell_size / 2 + x * multiboard_cell_size - multiboard_connector_back_connector_outer_radius, 0, multiboard_connector_back_connector_vertical_height + multiboard_connector_back_connector_clearance ])
                        cube([ multiboard_connector_back_connector_outer_radius * 2, back_y - multiboard_cell_size / 2, multiboard_connector_back_connector_vertical_height ]);
                }
            }
        }

        // add the divits
        for( x = [ 0 : num_x - 1 ] )
        {
            translate([ multiboard_connector_back_edge_overlap + multiboard_cell_size / 2 + x * multiboard_cell_size, multiboard_cell_size / 2 + ( num_y - 1 ) * multiboard_cell_size, multiboard_connector_back_connector_height - multiboard_connector_back_pin_size ])
                cylinder( h = multiboard_connector_back_pin_size, r1 = 0, r2 = multiboard_connector_back_pin_size, $fn = 4 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
