////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <utils.scad>
include <pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CordClip( inner_r, wall_thickness, length, show_preview = true )
{
    outer_r = inner_r + wall_thickness;
    cutout_angle = 100;

    difference()
    {
        union()
        {
            // outer cylinder
            translate([ 0, wall_thickness, outer_r ])
                rotate([ 90, 0, 0 ])
                    cylinder( r = outer_r, h = length );

            // bottom
            translate([ -outer_r, 0, 0 ])
                cube([ outer_r * 2, wall_thickness, outer_r ]);
        }

        // cut out inner cylinder
        translate([ 0, wall_thickness + DIFFERENCE_CLEARANCE, outer_r ])
            rotate([ 90, 0, 0 ])
                cylinder( r = inner_r, h = length + DIFFERENCE_CLEARANCE * 2 );

        // cut out the top
        translate([ 0, wall_thickness + DIFFERENCE_CLEARANCE, outer_r ])
            rotate([ 90, -( 180 - cutout_angle ) / 2, 0 ])
                PieSlicePrism(
                    outer_r + DIFFERENCE_CLEARANCE * 2,
                    wall_thickness + DIFFERENCE_CLEARANCE * 2,
                    cutout_angle
                    );
    }

    if( show_preview )
    {
        preview_length = outer_r * 8;

        % translate([ 0, preview_length / 2, outer_r ])
            rotate([ 90, 0, 0 ])
                cylinder( r = inner_r, h = preview_length );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
