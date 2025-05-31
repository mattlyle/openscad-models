use <../../3rd-party/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <../../3rd-party/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>

use <rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GRIDFINITY_BASE_MAGNETS_NONE = 0;
GRIDFINITY_BASE_MAGNETS_CORNERS_ONLY = 1;
GRIDFINITY_BASE_MAGNETS_ALL = 2;

GRIDFINITY_BASE_Z = 4.75;
GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE = 0.4;

GRIDFINITY_ROUNDING_R = 3.7; // the radius of the rounded corners on the base

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateGridfinitySize( cells ) = 42.0 * cells - 0.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityBase(
    cells_x,
    cells_y,
    top_z = 1.0,
    center = true,
    magnets = GRIDFINITY_BASE_MAGNETS_CORNERS_ONLY,
    round_top = false
    )
{
    assert( cells_x > 0, "Cells X must be >0" );
    assert( cells_y > 0, "Cells Y must be >0" );
    assert( top_z >= 0, "Top Z must be >=0" );

    size_x = cells_x * 42.0 - 0.5;
    size_y = cells_y * 42.0 - 0.5;
    size_z = GRIDFINITY_BASE_Z;

    magnet_hole = magnets != GRIDFINITY_BASE_MAGNETS_NONE;
    only_corners = magnets != GRIDFINITY_BASE_MAGNETS_ALL;

    main_translate = ( center == true )
        ? [ 0, 0, 0 ]
        : [ size_x / 2, size_y / 2, 0 ];
    translate( main_translate )
    {
        render()
        {
            difference()
            {
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
                RoundedCubeAlt2(
                    size_x,
                    size_y,
                    top_z,
                    r = GRIDFINITY_ROUNDING_R,
                    round_top = round_top,
                    round_bottom = false
                    );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
