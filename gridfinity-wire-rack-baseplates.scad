use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_baseplate.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

wire_diameter = 2.6; // measured from 2.5 to 2.75
wire_separation = 28.0 - wire_diameter; // outside to outside was 27 - 28.5

max_y = 402;

// wire_floor_depth = 1.5;

under_magnet_y = 14.0;

grid_cells_x = 5;
grid_cells_y = 6;

offset_x_grid_cells = 6;

// TODO: How to 'resume' with one to the side so that the bars still line up... will need an x-offset or just X grid cells X-to-the-left

wire_cutout_extra = 0.4;

wire_floor_extra = 0.25;

render_for_printing = true;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated vars

total_size_x = gf_pitch * grid_cells_x;
total_size_y = gf_pitch * grid_cells_y;

offset_size_x = gf_pitch * offset_x_grid_cells;

echo( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> total_size_x", total_size_x );
echo( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> total_size_y", total_size_y );
echo( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> offset_size_x", offset_size_x );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw wires

num_wires_to_draw = ceil( ( total_size_x + offset_size_x ) / wire_separation );

if( !render_for_printing )
{
    for( wire_n = [ -1 : 1 : num_wires_to_draw ] )
    {
        translate([ wire_n * wire_separation + wire_separation / 2, -max_y / 4, 0 ])
            rotate([ -90, 0, 0 ])
                cylinder( h = max_y, r = wire_diameter/2, $fn = 50 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw the offset

if( offset_x_grid_cells > 0 && !render_for_printing )
{
    # cube([ offset_size_x, total_size_y, cutout_diagonal + wire_floor_extra ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw wire rack base

cutout_side = wire_diameter + wire_cutout_extra * 2;
cutout_diagonal = sqrt( ( cutout_side / 2 ) * ( cutout_side / 2 ) * 2 );

// v3
render()
{
    difference()
    {
        translate([ offset_size_x, 0, 0 ])
        {
            union()
            {
                difference()
                {
                    cube([ total_size_x, total_size_y, cutout_diagonal + wire_floor_extra ]);

                    // remove the corner cutouts
                    translate([ 0, 0, 0 ]) cube([ 4, 4, cutout_diagonal + wire_floor_extra ]);
                    translate([ total_size_x - 4, 0, 0 ]) cube([ 4, 4, cutout_diagonal + wire_floor_extra ]);
                    translate([ total_size_x - 4, total_size_y - 4, 0 ]) cube([ 4, 4, cutout_diagonal + wire_floor_extra ]);
                    translate([ 0, total_size_y - 4, 0 ]) cube([ 4, 4, cutout_diagonal + wire_floor_extra ]);
                }

                // add the rounded corners back
                translate([ 4, 4, 0 ] ) cylinder( h = cutout_diagonal + wire_floor_extra, r = 4, $fn = 50 );
                translate([ total_size_x - 4, 4, 0 ] ) cylinder( h = cutout_diagonal + wire_floor_extra, r = 4, $fn = 50 );
                translate([ total_size_x - 4, total_size_y - 4, 0 ] ) cylinder( h = cutout_diagonal + wire_floor_extra, r = 4, $fn = 50 );
                translate([ 4, total_size_y - 4, 0 ] ) cylinder( h = cutout_diagonal + wire_floor_extra, r = 4, $fn = 50 );
            }
        }

        // remove the wire cutouts
        for( wire_n = [ -1 : 1 : num_wires_to_draw ] )
        {
            translate([ wire_n * wire_separation + wire_separation / 2 - cutout_diagonal, 0, 0 ])
                    rotate([ 0, 45, 0 ])
                        cube([ cutout_side, total_size_y, cutout_side ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// draw gridfinity baseplates

translate([ offset_size_x, 0, cutout_diagonal + wire_floor_extra ])
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
