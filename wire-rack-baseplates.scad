use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_baseplate.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

wire_diameter = 2.6; // measured from 2.5 to 2.75
wire_separation = 28.0 - wire_diameter; // outside to outside was 27 - 28.5

max_y = 402;

// wire_floor_depth = 1.5;

under_magnet_y = 14.0;

grid_cells_x = 2;
grid_cells_y = 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated vars

total_size_x = gf_pitch * grid_cells_x;
total_size_y = gf_pitch * grid_cells_y;

echo( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> total_size_x", total_size_x );
echo( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> total_size_y", total_size_y );

wire_cutout_extra = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw wires

num_wire_to_draw = ceil( total_size_x / wire_separation );

// for( wire_n = [ -1 : 1 : num_wire_to_draw ] )
// {
//     translate([ wire_n * wire_separation + wire_separation / 2, -max_y / 4, 0 ])
//         rotate([ -90, 0, 0 ])
//             cylinder( h = max_y, r = wire_diameter/2, $fn = 16 );
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw wire rack base

cutout_side = wire_diameter + wire_cutout_extra * 2;
cutout_diagonal = sqrt( ( cutout_side / 2 ) * ( cutout_side / 2 ) * 2 );

// v3
render()
{
    difference()
    {
        cube([ total_size_x, total_size_y, cutout_diagonal ]);

        for( wire_n = [ -1 : 1 : num_wire_to_draw ] )
        {
            translate([ wire_n * wire_separation + wire_separation / 2, 0, 0 ])
                translate([ -cutout_diagonal, 0, 0 ])
                rotate([ 0, 45, 0 ])
                    cube([ cutout_side, total_size_y, cutout_side ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw gridfinity baseplates

translate([ 0, 0, cutout_diagonal ])
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
