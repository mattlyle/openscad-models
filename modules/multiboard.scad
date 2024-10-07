include <trapezoidal-prism.scad>
include <triangular-prism.scad>
include <rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////
// measurements

multiboard_cell_size = 25.0;
multiboard_wall_width = 2.0;
multiboard_screw_hole_radius = 3.0;
multiboard_cell_corner_width = 14.0;
multiboard_cell_height = 6.5;

multiboard_connector_back_connector_clearance = 0.05;
multiboard_connector_back_z = 6.5;
multiboard_connector_back_connector_inner_radius = 15.5 / 2 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_outer_radius = 20.0 / 2 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_height = 3 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_vertical_height = 1.5;
multiboard_connector_back_pin_size = 1.2;
multiboard_connector_back_connector_top_offset = 1.5;

workroom_multiboard_color = [ 112.0/255.0, 128.0/255.0, 144.0/255.0 ];

////////////////////////////////////////////////////////////////////////////////
// calculated

multiboard_cell_octagon_edge = multiboard_cell_size / ( 1 + sqrt( 2 ) );
multiboard_cell_octagon_radius = multiboard_cell_octagon_edge * sqrt( 4 + 2 * sqrt( 2 ) ) / 2;

multiboard_screw_hole_holder_cross = sqrt( multiboard_cell_octagon_edge * multiboard_cell_octagon_edge * 2 );

multiboard_connector_back_connector_wedge_size = multiboard_connector_back_connector_outer_radius - multiboard_connector_back_connector_inner_radius;

////////////////////////////////////////////////////////////////////////////////

module MultiboardMockUpTile( grid_cells_x, num_y )
{
    // % cube( [ multiboard_cell_size, multiboard_cell_size, multiboard_cell_height ] );

    render()
    {
        for( x = [ 0 : grid_cells_x - 1 ] )
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

module MultiboardConnectorBack( grid_cells_x, grid_cells_y )
{
    extra_x = 5;

    back_x = extra_x * 2 + grid_cells_x * multiboard_cell_size;
    back_y = multiboard_cell_size * grid_cells_y;

    MultiboardConnectorBackAlt( back_x, back_y );
}

////////////////////////////////////////////////////////////////////////////////

// Calculate the x-offset that will be used for a multiboard back with size 'size_x'
function MultiboardConnectorBackAltXOffset( size_x ) = ( size_x - floor( size_x / multiboard_cell_size ) * multiboard_cell_size ) / 2;

////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBackAlt( size_x, size_y )
{
    grid_cells_x = floor( size_x / multiboard_cell_size );
    grid_cells_y = floor( size_y / multiboard_cell_size );

    offset_x = MultiboardConnectorBackAltXOffset( size_x );

    echo( "multiboard back - grid cells X:", grid_cells_x );
    echo( "multiboard back - grid cells Y:", grid_cells_y );

    union()
    {
        render()
        {
            difference()
            {
                RoundedCube( size = [ size_x, size_y, multiboard_connector_back_z ], r = 1.0, fn = 36 );

                for( i = [ 0 : grid_cells_x - 1 ] )
                {
                    translate([ offset_x + multiboard_cell_size / 2 + i * multiboard_cell_size, 0, 0 ])
                        MultiboardConnectorBack_ConnectorCutoutToBottom( size_y );
                }
            }

            // add the divits back
            for( i = [ 0 : grid_cells_x - 1 ] )
            {
                // translate([ 0 , 30, 0 ])
                translate([ offset_x + multiboard_cell_size / 2 + i * multiboard_cell_size, 0, multiboard_connector_back_connector_height - multiboard_connector_back_pin_size ])
                    MultiboardConnectorBack_ConnectorDivit( size_y );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBackAlt2( size_x, size_y, connector_y_setup )
{
    for( setup = connector_y_setup )
    {
        echo( setup );
        if( len( setup ) == 2 )
        {
            echo("2...");
        }
        else if( len( setup ) == 1 )
        {
            echo("1...");
        }
        else
        {  
            echo("unknown");
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBack_ConnectorDivit( length_y )
{
    // it's really a tiny pyramid, so we set $fn to 4
    translate([ 0, length_y - multiboard_connector_back_connector_outer_radius - multiboard_connector_back_connector_top_offset, 0 ])
        cylinder( h = multiboard_connector_back_pin_size, r1 = 0, r2 = multiboard_connector_back_pin_size, $fn = 4 );
}

////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBack_ConnectorCutoutToBottom( length_y )
{
    cone_y = length_y - multiboard_connector_back_connector_outer_radius - multiboard_connector_back_connector_top_offset;

    MultiboardConnectorBack_ConnectorCutoutInterior( 0, cone_y );
}

////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBack_ConnectorCutoutInterior( y1, y2 )
{
    length_y = y2 - y1;

    union()
    {
        // cut out the cone
        translate([ 0, length_y, 0 ])
            cylinder(
                h = multiboard_connector_back_connector_height,
                r1 = multiboard_connector_back_connector_inner_radius,
                r2 = multiboard_connector_back_connector_outer_radius,
                $fn = 48 );

        // cut out from there to the bottom...

        // slanted top
        translate([ 0, length_y / 2, multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height ])
            TrapezoidalPrism(
                x_top = multiboard_connector_back_connector_outer_radius * 2,
                x_bottom = multiboard_connector_back_connector_inner_radius * 2,
                y = length_y,
                z = multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height );

        // also cut out the vertical section under the trapazoid
        translate([ -multiboard_connector_back_connector_outer_radius, 0, multiboard_connector_back_connector_vertical_height + multiboard_connector_back_connector_clearance ])
            cube([ multiboard_connector_back_connector_outer_radius * 2, length_y, multiboard_connector_back_connector_vertical_height ]);

        // near wedge
        translate([ -multiboard_connector_back_connector_outer_radius + multiboard_connector_back_connector_wedge_size, 0, 0 ])
            rotate([ 0, -90, 0 ])
                TriangularPrism(
                    x = multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height, // z
                                y = multiboard_connector_back_connector_wedge_size * 2,
                                z = multiboard_connector_back_connector_wedge_size // x
                );

        // far wedge
        translate([ multiboard_connector_back_connector_outer_radius - multiboard_connector_back_connector_wedge_size, 0, multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height ])
            rotate([ 0, 90, 0 ])
                TriangularPrism(
                    x = multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height, // z
                                y = multiboard_connector_back_connector_wedge_size * 2,
                                z = multiboard_connector_back_connector_wedge_size // x
                );
    }
}

////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBack_ConnectorCutoutHelper(  )
{

}

////////////////////////////////////////////////////////////////////////////////
