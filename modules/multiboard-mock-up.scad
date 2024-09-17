include <../../3rd-party/MCAD/regular_shapes.scad>

////////////////////////////////////////////////////////////////////////////////
// measurements

multiboard_cell_size = 25.0;
multiboard_wall_width = 2.0;
multiboard_screw_hole_radius = 3.0;
multiboard_cell_corner_width = 14.0;
multiboard_cell_height = 6.5;

////////////////////////////////////////////////////////////////////////////////
// calculated

cell_octagon_radius = multiboard_cell_size / ( 1 + sqrt( 2 ) ) * sqrt( 4 + 2 * sqrt( 2 ) ) / 2;

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
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
