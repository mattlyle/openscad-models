////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>;
include <modules/pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

cup_top_r = 82.5 / 2;
cup_bottom_r = 56 / 2;
cup_z = 80;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

num_cups_x = 2;
num_cups_y = 2;

wall_width = 2.0;
wall_z = 10.0;

floor_z = 3.6;

cup_clearance = 1.0;
cup_spacing = 2.0;

cup_holder_z_percent = 90.0;

num_cup_arms = 4;
cup_holder_arch_top_r = 24;
cup_holder_arch_bottom_r = 16;
cup_hole_r = 4.0;
num_additional_holes = 6;
additional_hole_r = 14.0;

connector_width = 2.0;
connector_z = 6.0;

center_cutout_r = 20.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

cell_r = cup_top_r + cup_clearance + wall_width + cup_spacing;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    BuildPlatePreview();

    PlantingCupHolder();
}
else if( render_mode == "print" )
{
    PlantingCupHolder();
}
else
{
    assert( false, str( "Unknown render_mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlantingCupHolder()
{
    // base
    difference()
    {
        union()
        {
            hull()
            {
                for( x = [ 0 : num_cups_x - 1 ] )
                {
                    for( y = [ 0 : num_cups_y - 1 ] )
                    {
                        translate([
                            x * cell_r * 2 + cell_r,
                            y * cell_r * 2 + cell_r,
                            0
                            ])
                            cylinder( h = floor_z - DIFFERENCE_CLEARANCE, r = cell_r );
                    }
                }
            }

            // cups
            for( x = [ 0 : num_cups_x - 1 ] )
            {
                for( y = [ 0 : num_cups_y - 1 ] )
                {
                    translate([
                        x * cell_r * 2 + cell_r,
                        y * cell_r * 2 + cell_r,
                        0
                        ])
                    {
                        _PlantingCupHolder();
                    }
                }
            }
        }

        // remove the center cutout
        for( x = [ 1 : num_cups_x - 1 ] )
        {
            for( y = [ 1 : num_cups_y - 1 ] )
            {
                translate([
                    x * cell_r * 2,
                    y * cell_r * 2,
                    -DIFFERENCE_CLEARANCE
                    ])
                    cylinder( h = floor_z + DIFFERENCE_CLEARANCE * 2, r = center_cutout_r );

            }
        }


        // remove the holes at the bottom
        for( x = [ 0 : num_cups_x - 1 ] )
        {
            for( y = [ 0 : num_cups_y - 1 ] )
            {
                translate([
                    x * cell_r * 2 + cell_r,
                    y * cell_r * 2 + cell_r,
                    -DIFFERENCE_CLEARANCE
                    ])
                {
                    // center hole
                    cylinder( h = floor_z + DIFFERENCE_CLEARANCE * 2, r = cup_hole_r );

                    // additional holes
                    for( i = [ 0 : num_additional_holes - 1 ] )
                        rotate([ 0, 0, i * 360 / num_additional_holes ])
                            translate([ additional_hole_r, 0, 0 ])
                                cylinder( h = floor_z + DIFFERENCE_CLEARANCE * 2, r = cup_hole_r );
                }
            }
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

    holder_z = cup_z * cup_holder_z_percent / 100.0 + wall_width;

    difference()
    {
        // outer cup
        cylinder(
            r1 = cup_bottom_r + wall_width + cup_clearance,
            r2 = cup_top_r + wall_width + cup_clearance,
            h = holder_z + floor_z
            );

        // cut out the cup
        translate([ 0, 0, floor_z ])
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
                    translate([ 0, 0, holder_z + floor_z - cup_holder_arch_top_r - wall_z ])
                        rotate([ 0, 90, 0 ])
                            cylinder(
                                r = cup_holder_arch_top_r,
                                h = cup_top_r + floor_z + cup_clearance
                                );

                    // bottom arch
                    translate([ 0, 0, floor_z + cup_holder_arch_bottom_r + wall_z])
                        rotate([ 0, 90, 0 ])
                            cylinder(
                                r = cup_holder_arch_bottom_r,
                                h = cup_top_r + floor_z + cup_clearance
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
