use <../../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityExtendedSolidCutoutBin( cells_x, cells_y, holder_z = gf_pitch )
{
    bin_inset_size = 0.15;
    corner_rounding_radius = 3.7;

    cells_z = ceil( holder_z / gf_pitch );

    gridfinity_base_x = cells_x * gf_pitch;
    gridfinity_base_y = cells_y * gf_pitch;
    gridfinity_base_z = gridfinity_base_height;

    holder_x = gridfinity_base_x - bin_inset_size * 2;
    holder_y = gridfinity_base_y - bin_inset_size * 2;

    union()
    {
        // base
        gridfinity_cup(
            width = cells_x,
            depth = cells_y,
            height = cells_z,
            position = "zero",
            filled_in = true,
            lip_style = "none"
            );

        render()
        {
            difference()
            {
                translate([ bin_inset_size, bin_inset_size, 0 ])
                    RoundedCube(
                        size = [ holder_x, holder_y, holder_z ],
                        r = corner_rounding_radius,
                        fn = 36
                        );

                // cut off the area the gridfinity base covers
                cube([ gridfinity_base_x, gridfinity_base_y, gridfinity_base_z ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
