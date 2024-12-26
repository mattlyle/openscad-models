use <../../3rd-party/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <../../3rd-party/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>

use <rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GRIDFINITY_BASE_MAGNETS_NONE = 0;
GRIDFINITY_BASE_MAGNETS_CORNERS_ONLY = 1;
GRIDFINITY_BASE_MAGNETS_ALL = 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityBase( cells_x, cells_y, top_z = 1, magnets = GRIDFINITY_BASE_MAGNETS_CORNERS_ONLY )
{
    assert( cells_x > 0, "Cells X must be >0" );
    assert( cells_y > 0, "Cells Y must be >0" );
    assert( top_z >= 0, "Top Z must be >=0" );

    size_x = cells_x * 42.0 - 0.5;
    size_y = cells_y * 42.0 - 0.5;
    size_z = 4.75;

    magnet_hole = magnets != GRIDFINITY_BASE_MAGNETS_NONE;
    only_corners = magnets != GRIDFINITY_BASE_MAGNETS_ALL;
    render()
    {
        difference()
        {
            echo($preview);
            gridfinityBase(
                [ cells_x, cells_y ],
                hole_options = bundle_hole_options( magnet_hole = magnet_hole ),
                only_corners = only_corners,
                thumbscrew = false,
                $fn = $preview ? 32 : 128
                );

            translate([ -size_x / 2, -size_y / 2, size_z ])
                cube([ size_x, size_y, 5 ]);
        }
    }

    if( top_z > 0 )
    {
        translate([ -size_x / 2 , -size_y / 2, size_z ])
            RoundedCubeAlt2( size_x, size_y, top_z, r = 3.7, round_top = false, round_bottom = false );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
