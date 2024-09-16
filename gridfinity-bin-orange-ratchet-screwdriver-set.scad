use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/triangular-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

cup_x = 3; // in grid cells
cup_y = 2; // in grid cells
cup_z = 7;

clearance_to_add = 0.5;

orange_ratchet_screwdriver_case_x = 111.0;
orange_ratchet_screwdriver_case_y = 41.6;
orange_ratchet_screwdriver_case_z = 203;

orange_ratchet_screwdriver_case_offset_z = 6.0;

orange_ratchet_screwdriver_case_hinge_x = 115.3 - orange_ratchet_screwdriver_case_x;
orange_ratchet_screwdriver_case_hinge_y = 5.1;

orange_ratchet_screwdriver_case_hinge_y_offset = 12;
orange_ratchet_screwdriver_case_hinge_z_offset = 18;

orange_ratchet_screwdriver_case_sloped_corner_size = 10.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// OrangeRatchetScrewDriver();

render()
{
    difference()
    {
        gridfinity_cup(
            width = cup_x,
            depth = cup_y,
            height = cup_z,
            position = "zero",
            filled_in = true
        );

        translate([ ( gf_pitch * 3 - orange_ratchet_screwdriver_case_x - orange_ratchet_screwdriver_case_hinge_x ) / 2, ( gf_pitch * 2 - orange_ratchet_screwdriver_case_y ) / 2, orange_ratchet_screwdriver_case_offset_z ])
            OrangeRatchetScrewDriver();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OrangeRatchetScrewDriver()
{
    render()
    {
        difference()
        {
            translate([ orange_ratchet_screwdriver_case_hinge_x, 0, 0 ])
                cube([ orange_ratchet_screwdriver_case_x, orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_z ]);

            translate([ orange_ratchet_screwdriver_case_hinge_x, orange_ratchet_screwdriver_case_y, 0 ])
                rotate([ 0, 0, -90 ])
                    TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
            translate([ orange_ratchet_screwdriver_case_hinge_x + orange_ratchet_screwdriver_case_x, 0, 0 ])
                rotate([ 0, 0, 90 ])
                    TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
            translate([ orange_ratchet_screwdriver_case_hinge_x + orange_ratchet_screwdriver_case_x, 0, orange_ratchet_screwdriver_case_z ])
                rotate([ -90, 0, 90 ])
                    TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
            translate([ orange_ratchet_screwdriver_case_hinge_x, orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_z ])
                rotate([ -90, 0, -90 ])
                    TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
        }
    }

    // hinge
    color([ 1.0, 0.4, 0.4 ])
    translate([ 0, orange_ratchet_screwdriver_case_hinge_y_offset, orange_ratchet_screwdriver_case_hinge_z_offset ])
        cube([ orange_ratchet_screwdriver_case_hinge_x, orange_ratchet_screwdriver_case_hinge_y, orange_ratchet_screwdriver_case_z - orange_ratchet_screwdriver_case_hinge_z_offset * 2 ]);

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
