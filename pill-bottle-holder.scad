use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/gridfinity-extended-solid-cutout-bin.scad>
include <modules/gridfinity-helpers.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

aleve_diameter = 66.3;
aleve_y = 129.8;

shave_gel_diameter = 53.3;
shave_gel_y = 182;

ibuprofen_diameter = 52.8;
ibuprofen_y = 100.2;

meg_1_diameter = 54.3;
meg_1_y = 92.9;

meg_2_diameter = 56.1;
meg_2_y = 102.7;

meg_3_diameter = 38.6;
meg_3_y = 102.6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
// render_mode = "bin-only";
render_mode = "text-only";

min_holder_z = 20;

bottle_clearance = 1.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

translate([ 0, 0, 0 ])
    PillBottleHolder( aleve_diameter, aleve_y, "Aleve", 9 );

// translate([ 100, 0, 0 ])
//     PillBottleHolder( shave_gel_diameter, shave_gel_y, "Shave Gel", 7 );

// translate([ 200, 0, 0 ])
//     PillBottleHolder( ibuprofen_diameter, ibuprofen_y, "Ibuprofen", 5.5 );

// translate([ 300, 0, 0 ])
//     PillBottleHolder( meg_1_diameter, meg_1_y, "", 0 );
// translate([ 400, 0, 0 ])
//     PillBottleHolder( meg_2_diameter, meg_2_y, "", 0 );
// translate([ 500, 0, 0 ])
//     PillBottleHolder( meg_3_diameter, meg_3_y, "", 0 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PillBottleHolder( diameter, y, text_label, font_size )
{
    cells_x = MinGridfinityCells( diameter + bottle_clearance * 4 );
    cells_y = MinGridfinityCells( y + bottle_clearance * 4 );

    holder_x = GridfinityCellsToLength( cells_x );
    holder_y = GridfinityCellsToLength( cells_y );
    holder_z = max( min_holder_z, diameter / 2 ) + bottle_clearance;

    union()
    {
        if( render_mode == "preview" || render_mode == "bin-only" )
        {
            render()
            {
                difference()
                {
                    GridfinityExtendedSolidCutoutBin( cells_x, cells_y, holder_z );
                    
                    // cut out the bottle
                    translate([ x_offset, y_offset - bottle_clearance, z_offset ])
                        rotate([ -90, 0, 0 ])
                            cylinder( h = y + bottle_clearance * 2, r = diameter / 2 + bottle_clearance, $fn = 60 );
                }
            }

            x_offset = holder_x / 2;
            y_offset = ( holder_y - y - bottle_clearance * 2 ) / 2 + bottle_clearance;
            z_offset = gridfinity_base_height + diameter / 2;

            if( render_mode == "preview" )
            {
                % translate([ x_offset, y_offset, z_offset ])
                    rotate([ -90, 0, 0 ])
                        cylinder( h = y, r = diameter / 2, $fn = 48 );
            }
        }

        if( render_mode == "preview" || render_mode == "text-only" )
        {
            if( text_label != "" && font_size > 0 )
            {
                translate([ 0, 5, holder_z ])
                    CenteredTextLabel( text_label, font_size, font = "Liberation Sans:style=bold", centered_in_area_x = holder_x );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

