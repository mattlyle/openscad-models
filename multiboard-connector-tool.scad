////////////////////////////////////////////////////////////////////////////////
// settings

box_x = 35;
box_y = 35;
box_z = 15;

measurement_tolerance = 0.5;

////////////////////////////////////////////////////////////////////////////////
// measurements

connector_diameter = 22.5;
connector_full_depth = 13.2;
connector_thread_depth = 6.0;
connector_handle_depth = connector_full_depth - connector_thread_depth;

peg_depth = 1.5;
peg_diameter = 5.7;
peg_offset = 5.0;

////////////////////////////////////////////////////////////////////////////////

corner_cutout_length = sqrt( 2 * connector_diameter * connector_diameter ) / 2;

////////////////////////////////////////////////////////////////////////////////

render()
{
    difference()
    {
        cube([ box_x, box_y, box_z ]);

        // cut out the cylinder
        translate([ box_x / 2, box_y / 2, box_z - connector_handle_depth ])
            cylinder( h = connector_handle_depth, r = connector_diameter / 2 + measurement_tolerance, $fn = 48 );
    }
}

color([ 0.5, 0, 0 ])
    translate([ box_x / 2 - peg_offset, box_y / 2, box_z - connector_handle_depth ])
        cylinder( h = peg_depth, r = peg_diameter / 2 - measurement_tolerance, $fn = 24 );

color([ 0, 0, 0.5 ])
    translate([ box_x / 2 + peg_offset, box_y / 2, box_z - connector_handle_depth ])
        cylinder( h = peg_depth, r = peg_diameter / 2 - measurement_tolerance, $fn = 24 );
