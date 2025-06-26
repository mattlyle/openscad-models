use <../../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_baseplate.scad>
include <../../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

GRIDFINITY_BASEPLATE_Z = 5.8; // from https://gridfinity.xyz/specification/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityBaseplate( grid_cells_x, grid_cells_y )
{
    assert( grid_cells_x > 0 && grid_cells_x, "Invalid x cells count" );
    assert( grid_cells_y > 0 && grid_cells_y, "Invalid y cells count" );

    gridfinity_baseplate(
        num_x = grid_cells_x,
        num_y = grid_cells_y,
        oversizeMethod = "fill"
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityBaseplateSnugFitInto( max_x, max_y, grid_cells_x, grid_cells_y )
{
    // from https://gridfinity.xyz/specification/
    extension_z = 4.0;
    extension_width = 2.15 + 0.8;
    extension_merge_overlap = 2.15 + 0.8;

    grid_plate_size_x = gf_pitch * grid_cells_x;
    grid_plate_size_y = gf_pitch * grid_cells_y;
    extension_size_x = max_x > 0 ? max_x - grid_plate_size_x : 0;
    extension_size_y = max_y > 0 ? max_y - grid_plate_size_y : 0;

    echo( "##################################################  grid_plate_size_x:", grid_plate_size_x );
    echo( "##################################################  grid_plate_size_y:", grid_plate_size_y );
    echo( "##################################################  extension_x:", extension_size_x );
    echo( "##################################################  extension_y:", extension_size_y );

    // draw the gridfinity extended base plate
    gridfinity_baseplate(
        num_x = grid_cells_x,
        num_y = grid_cells_y,
        oversizeMethod = "fill",
        plateStyle = "base",
        plateOptions = "default",
        lidOptions = "",
        customGridEnabled = false,
        gridPositions = "",
        cutx = 0,
        cuty = 0
        );

    // add the extensions...

    // near
    render()
    {
        difference()
        {
            translate([ grid_plate_size_x - extension_merge_overlap, 0, 0 ])
                cube([ extension_size_x + extension_merge_overlap, extension_width, extension_z ]);
            translate([ grid_plate_size_x - extension_merge_overlap - 1, 3 - 0.2, 0 ])
                cylinder( r = 3, h = extension_z, $fn = 30 ); // TODO: This isn't correct and overlaps?!
        }
    }

    // right
    translate([ max_x - extension_width, extension_width, 0 ])
        cube([ extension_width, grid_plate_size_y + extension_size_y - extension_width * 2, extension_z ]);

    // far
    render()
    {
        difference()
        {
            translate([ grid_plate_size_x - extension_merge_overlap, grid_plate_size_y + extension_size_y - extension_width, 0 ])
                cube([ extension_size_x + extension_merge_overlap, extension_width, extension_z ]);
            translate([ grid_plate_size_x - 3.5, grid_plate_size_y + extension_size_y - extension_width - 0.2, 0 ])
                cylinder( r = 3, h = extension_z, $fn = 30 ); // TODO: This isn't correct and overlaps?!
        }
    }

    if( max_y > 0 )
    {
        // far, above grid
        translate([ 0, grid_plate_size_y + extension_size_y - extension_width, 0 ])
            cube([ grid_plate_size_x, extension_width, extension_z ]);

        // left
        render()
        {
            difference()
            {
                translate([ 0, grid_plate_size_y - extension_merge_overlap, 0 ])
                    cube([ extension_width, extension_size_y, extension_z ]);

                translate([ 3, grid_plate_size_y - 3.6, 0 ])
                    cylinder( r = 3, h = extension_z, $fn = 30 ); // TODO: This isn't correct and overlaps?!
            }
        }

        // extra support in the mdddle
        render()
        {
            difference()
            {
                translate([ grid_plate_size_x - extension_merge_overlap, grid_plate_size_y - extension_merge_overlap, 0 ])
                    cube([ extension_width, extension_size_y, extension_z ]);
                translate([ grid_plate_size_x - extension_merge_overlap - 0.7, grid_plate_size_y - extension_merge_overlap, 0 ])
                    cylinder( r = 3, h = extension_z, $fn = 30 ); // TODO: This isn't correct and overlaps?!
            }
        }

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
