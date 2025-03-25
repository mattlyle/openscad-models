////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>;
include <modules/pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

cup_top_r = 88 / 2;
cup_bottom_r = 56 / 2;
cup_z = 80;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";

num_cups_x = 2;
num_cups_y = 2;

wall_width = 2.0;
wall_z = 10.0;

cup_clearance = 1.0;

cup_holder_z_percent = 90.0;

num_cup_arms = 4;
cup_holder_arch_top_r = 24;
cup_holder_arch_bottom_r = 16;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

cell_r = cup_top_r * 2 + cup_clearance + wall_width * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    _PlantingCupHolder();
    // PlantingCupHolder();
}
else if( render_mode == "print" )
{
    // PlantingCupHolder();
}
else
{
    assert( false, str( "Unknown render_mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlantingCupHolder()
{
    for( x = [ 0 : num_cups_x - 1 ] )
    {
        for( y = [ 0 : num_cups_y - 1 ] )
        {
            echo( str( x, ",", y ) );
            // translate( [x * cup_top_r * 2, y * cup_top_r * 2, 0] )
            // {
            //     PlantingCup();
            // }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _PlantingCupHolder()
{
    // cup preview
    if( render_mode == "preview" )
    {
        translate([ 0, 0, wall_width + DIFFERENCE_CLEARANCE ])
            PlantingCupPreview();
    }

    holder_z = cup_z * cup_holder_z_percent / 100 + wall_width;

    difference()
    {
        // outer cup
        cylinder(
            r1 = cup_bottom_r + wall_width + cup_clearance,
            r2 = cup_top_r + wall_width + cup_clearance,
            h = holder_z + wall_width
            );

        // cut out the cup
        translate([ 0, 0, wall_width ])
            cylinder(
                r1 = cup_bottom_r + cup_clearance,
                r2 = cup_top_r + cup_clearance,
                h = holder_z + DIFFERENCE_CLEARANCE
                );

        // cup arms
        for( i = [ 0 : num_cup_arms - 1 ] )
        {
            angle = i * 360 / num_cup_arms;

            rotate([ 0, 0, angle ])
            {
                hull()
                {
                    // top cylinder
                    translate([ 0, 0, holder_z + wall_width - cup_holder_arch_top_r - wall_z ])
                        rotate([ 0, 90, 0 ])
                            cylinder(
                                r = cup_holder_arch_top_r,
                                h = cup_top_r + wall_width + cup_clearance
                                );

                    // bottom arch
                    translate([ 0, 0, wall_width + cup_holder_arch_bottom_r ])
                        rotate([ 0, 90, 0 ])
                            cylinder(
                                r = cup_holder_arch_bottom_r,
                                h = cup_top_r + wall_width + cup_clearance
                                );
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlantingCupPreview()
{
    % cylinder( r1 = cup_bottom_r, r2 = cup_top_r, h = cup_z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
