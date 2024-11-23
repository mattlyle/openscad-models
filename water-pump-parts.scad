
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

outer_ring_inner_radius = 22.2 / 2;
wall_thickness = 1.0;
outer_ring_top_radius = 26.1 / 2;

inlet_radius = 10.2 / 2;

top_radius = 12.9 / 2;

nozzle_top_radius = 9.6;
nozzle_radius = 8.0;

total_width_at_bottom = 35.6;

lower_height = 8.5;
total_height = 13.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

$fn = 48;

// outer ring
render()
{
    difference()
    {
        cylinder( h = lower_height, r = outer_ring_inner_radius + wall_thickness );

        // remove the inside
        cylinder( h = lower_height, r = outer_ring_inner_radius );
    }

    // add the top
    translate([ 0, 0, lower_height - wall_thickness ])
    {
        difference()
        {
            cylinder( h = wall_thickness, r = outer_ring_top_radius );

            // remove the inlet
            cylinder( h = wall_thickness, r = inlet_radius );
        }

        // add the half top
        difference()
        {
            cylinder( h = total_height - lower_height, r = inlet_radius + wall_thickness );

            // remove the center
            cylinder( h = total_height - lower_height, r = inlet_radius );

            // remove the side
            translate([ 0, - inlet_radius - wall_thickness, 0 ])
                cube([ inlet_radius + wall_thickness, inlet_radius * 2 + wall_thickness * 2, total_height - lower_height ]);
        }

        // add little hook by the top half
        difference()
        {
            translate([ -wall_thickness * 2, inlet_radius + wall_thickness, wall_thickness ])
                cube([ wall_thickness * 2, wall_thickness * 2, wall_thickness ]);

            translate([ -wall_thickness * 2, inlet_radius + wall_thickness, wall_thickness ])
                cube([ wall_thickness, wall_thickness, wall_thickness ]);
        }
    }
}

// nozzle
translate([ total_width_at_bottom - outer_ring_inner_radius - nozzle_radius - wall_thickness, -nozzle_radius / 2, 0 ])
{
    render()
    {
        // nozzle
        difference()
        {
            cylinder( h = lower_height, r = nozzle_radius );

            // remove left
            translate([ -nozzle_radius, -nozzle_radius, 0 ])
                cube([ nozzle_radius, nozzle_radius * 2, lower_height ]);
            
            // remove bottom
            translate([ -nozzle_radius, -nozzle_radius, 0 ])
                cube([ nozzle_radius * 2, nozzle_radius, lower_height ]);

            // // remove inside
            cylinder( h = lower_height, r = nozzle_radius - wall_thickness );
        }

        // nozzle top
        translate([ 0, 0, lower_height - wall_thickness ])
        {
            difference()
            {
                cylinder( h = wall_thickness, r = nozzle_top_radius );

                // remove left
                translate([ -nozzle_top_radius, -nozzle_top_radius, 0 ])
                    cube([ nozzle_top_radius, nozzle_top_radius * 2, wall_thickness ]);

                // remove bottom
                translate([ -nozzle_top_radius, -nozzle_top_radius, 0 ])
                    cube([ nozzle_top_radius * 2, nozzle_top_radius, wall_thickness ]);
            }
        }

        // add inner vane
        // TODO finish
    }
}

# translate([ -outer_ring_inner_radius - wall_thickness, -1, 0 ]) cube([ total_width_at_bottom, 2, 1 ]); // end to end check

// % cylinder( h = 0.1, r = 24.22/2 ); // outer diameter check

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
