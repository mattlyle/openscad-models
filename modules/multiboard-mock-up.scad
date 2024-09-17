// include <../../3rd-party/MCAD/regular_shapes.scad>

////////////////////////////////////////////////////////////////////////////////
// measurements

multiboard_cell_size = 25.0;
multiboard_wall_width = 2.0;
multiboard_screw_hole_radius = 3.0;
multiboard_cell_corner_width = 14.0;
multiboard_cell_height = 6.5;

////////////////////////////////////////////////////////////////////////////////
// calculated

cell_octagon_edge = multiboard_cell_size / ( 1 + sqrt( 2 ) );
cell_octagon_radius = cell_octagon_edge * sqrt( 4 + 2 * sqrt( 2 ) ) / 2;

screw_hole_holder_cross = sqrt( cell_octagon_edge * cell_octagon_edge * 2 );

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
                        rotate([ 0, 0, 360/16 ])
                            cylinder( h = multiboard_cell_height, r = cell_octagon_radius, $fn = 8 );
                        rotate([ 0, 0, 360/16 ])
                            cylinder( h = multiboard_cell_height, r = cell_octagon_radius - multiboard_wall_width / 2, $fn = 8 );
                    }
                }

                if( x > 0 && y > 0 )
                {
                    difference()
                    {
                        translate([ multiboard_cell_size * x, multiboard_cell_size * y, multiboard_cell_height / 2 ])
                            rotate([ 0, 0, 45 ])
                                cube([ cell_octagon_edge, cell_octagon_edge, multiboard_cell_height ], center = true );
                            
                        translate([ multiboard_cell_size * x, multiboard_cell_size * y, 0 ])
                            cylinder( h = multiboard_cell_height, r = multiboard_screw_hole_radius, $fn = 16 );
                    }
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
