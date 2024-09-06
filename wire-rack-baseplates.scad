use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_baseplate.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

wire_diameter = 2.6; // measured from 2.5 to 2.75
wire_separation = 28.0 - wire_diameter; // outside to outside was 27 - 28.5

max_y = 402;

wire_floor_depth = 1.5;

under_magnet_y = 14.0;

grid_cells_x = 3;
grid_cells_y = 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated vars

total_size_x = gf_pitch * grid_cells_x;
total_size_y = gf_pitch * grid_cells_y;

echo( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> total_size_x", total_size_x );
echo( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> total_size_y", total_size_y );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw wires

// for( wire_n = [ -1 : 1 : 50 ] )
// {
//     translate([ wire_n * wire_separation + wire_separation / 2, -max_y / 4, 0 ])
//         rotate([ -90, 0, 0 ])
//             cylinder( h = max_y, r = wire_diameter/2, $fn=8 );
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw wire rack base

// top

color([ 0.1, 0.3, 0.1 ])
{
    for( grid_y =[ 0 : 1 : grid_cells_y - 1 ])
    {
        // near bar
        translate([ 0, grid_y * gf_pitch, wire_diameter / 2 ])
            cube([ total_size_x, under_magnet_y, wire_floor_depth ]);

        // far bar
        translate([ 0, ( grid_y + 1 ) * gf_pitch - under_magnet_y, wire_diameter / 2 ])
            cube([ total_size_x, under_magnet_y, wire_floor_depth ]);
    }
}

// translate([ 0, 0, wire_diameter / 2 ])
//     cube([ total_size_x, total_size_y, wire_floor_depth ]);

// ribs in between wires
color([ 0.5, 0, 0 ])
{
    render()
    {
        for( grid_y =[ 0 : 1 : grid_cells_y - 1 ])
        {
            translate([ 0, grid_y * gf_pitch, 0 ])
            {
                difference()
                {
                    cube([ total_size_x, under_magnet_y, wire_diameter / 2 ]);

                    for( wire_n = [ -1 : 1 : 50 ] )
                    {
                        translate([ wire_n * wire_separation + wire_separation / 4, 0, 0 ])
                            cube([ wire_separation / 2 , under_magnet_y, wire_diameter / 2 ]);
                    }
                }
            }

            translate([ 0, ( grid_y + 1 ) * gf_pitch - under_magnet_y, 0 ])
            {
                difference()
                {
                    cube([ total_size_x, under_magnet_y, wire_diameter / 2 ]);

                    for( wire_n = [ -1 : 1 : 50 ] )
                    {
                        translate([ wire_n * wire_separation + wire_separation / 4, 0, 0 ])
                            cube([ wire_separation / 2 , under_magnet_y, wire_diameter / 2 ]);
                    }
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw gridfinity baseplates

translate([ 0, 0, wire_floor_depth + wire_diameter / 2 ])
{
    gridfinity_baseplate(
        num_x = grid_cells_x,
        num_y = grid_cells_y,
        oversizeMethod = "fill",
        plateStyle = "base",
        plateOptions = "magnet",
        lidOptions = "",
        customGridEnabled = false,
        gridPositions = "",
        cutx = 0,
        cuty = 0
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
