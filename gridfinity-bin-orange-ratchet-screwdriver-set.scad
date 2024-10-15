use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/triangular-prism.scad>
include <modules/rounded-cube.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

orange_ratchet_screwdriver_case_x = 111.0;
orange_ratchet_screwdriver_case_y = 41.6;
orange_ratchet_screwdriver_case_z = 203;

orange_ratchet_screwdriver_case_hinge_x = 115.3 - orange_ratchet_screwdriver_case_x;
orange_ratchet_screwdriver_case_hinge_y = 5.1;

orange_ratchet_screwdriver_case_hinge_y_offset = 12;
orange_ratchet_screwdriver_case_hinge_z_offset = 18;

orange_ratchet_screwdriver_case_sloped_corner_size = 10.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

cells_x = 3;
cells_y = 2;
cells_z = 1;

orange_ratchet_screwdriver_case_clearance = 0.5;

corner_rounding_radius = 3.7;
holder_clearance = 0.15;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cells_x * 42.0;
base_y = cells_y * 42.0;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cells_z * 42.0;

offset_x = ( gf_pitch * 3 - orange_ratchet_screwdriver_case_x - orange_ratchet_screwdriver_case_hinge_x + orange_ratchet_screwdriver_case_clearance * 2 ) / 2;
offset_y = ( gf_pitch * 2 - orange_ratchet_screwdriver_case_y + orange_ratchet_screwdriver_case_clearance * 2 ) / 2;
offset_z = 7.0 + orange_ratchet_screwdriver_case_clearance;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ offset_x, offset_y, offset_z + orange_ratchet_screwdriver_case_clearance ])
        OrangeRatchetScrewDriver( false );
}

if( render_mode == "preview" || render_mode == "bin-only" )
{
    OrangeRatchetScrewDriverHolder();
}

if( render_mode == "preview" || render_mode == "text-only" )
{
    text_area_x = base_x;
    text_area_y = ( base_y - orange_ratchet_screwdriver_case_y - orange_ratchet_screwdriver_case_clearance * 2 ) / 2;

    // # translate([ 0, 0, holder_z ])
    //     cube([ text_area_x, text_area_y, 0.1 ]);

    translate([ 0, orange_ratchet_screwdriver_case_clearance, holder_z ])
        CenteredTextLabel( "Orange Ratchet Screwdriver", 5.5, "Georgia:style=Bold", text_area_x, text_area_y );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OrangeRatchetScrewDriverHolder()
{
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
            translate([ holder_clearance, holder_clearance, 0 ])
                RoundedCube(
                    size = [ holder_x, holder_y, holder_z ],
                    r = corner_rounding_radius,
                    fn = 36
                    );

            // cut off the area the gridfinity base covers
            cube([ base_x, base_y, base_z ]);

            // cut out the screwdriver area
            translate([ offset_x, offset_y, offset_z ])
                OrangeRatchetScrewDriver( true );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OrangeRatchetScrewDriver( add_clearance )
{
    clearance_to_add = add_clearance ? orange_ratchet_screwdriver_case_clearance : 0;

    union()
    {
    color([ 0.3, 0.3, 0.3 ])
    {
        render()
        {
            difference()
            {
                translate([ orange_ratchet_screwdriver_case_hinge_x, 0, 0 ])
                    cube([ orange_ratchet_screwdriver_case_x + clearance_to_add * 2, orange_ratchet_screwdriver_case_y + clearance_to_add * 2, orange_ratchet_screwdriver_case_z ]);

                // bottom left
                translate([ orange_ratchet_screwdriver_case_hinge_x, orange_ratchet_screwdriver_case_y, 0 ])
                    rotate([ 0, 0, -90 ])
                        TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
                
                // bottom right
                translate([ orange_ratchet_screwdriver_case_hinge_x + orange_ratchet_screwdriver_case_x + clearance_to_add * 2, 0, 0 ])
                    rotate([ 0, 0, 90 ])
                        TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
                
                // top right
                translate([ orange_ratchet_screwdriver_case_hinge_x + orange_ratchet_screwdriver_case_x + clearance_to_add * 2, 0, orange_ratchet_screwdriver_case_z ])
                    rotate([ -90, 0, 90 ])
                        TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
                
                // top left
                translate([ orange_ratchet_screwdriver_case_hinge_x, orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_z ])
                    rotate([ -90, 0, -90 ])
                        TriangularPrism( orange_ratchet_screwdriver_case_y, orange_ratchet_screwdriver_case_sloped_corner_size, orange_ratchet_screwdriver_case_sloped_corner_size );
            }
        }
    }
    
    // hinge
    color([ 1.0, 0.4, 0.4 ])
        translate([ 0, orange_ratchet_screwdriver_case_hinge_y_offset, orange_ratchet_screwdriver_case_hinge_z_offset ])
            cube([ orange_ratchet_screwdriver_case_hinge_x, orange_ratchet_screwdriver_case_hinge_y, orange_ratchet_screwdriver_case_z - orange_ratchet_screwdriver_case_hinge_z_offset * 2 ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
