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
            translate([ 0, 0, outer_r ])
                rotate([ -90, 0, 0 ])
                    cylinder( r = outer_r, h = length );

            // bottom
            translate([ -outer_r, 0, 0 ])
                cube([ outer_r * 2, length, outer_r ]);
        }

        // cut out inner cylinder
        translate([ 0, length + DIFFERENCE_CLEARANCE, outer_r ])
            rotate([ 90, 0, 0 ])
                cylinder( r = inner_r, h = length + DIFFERENCE_CLEARANCE * 2 );

        // cut out the top
        translate([ 0, length + DIFFERENCE_CLEARANCE, outer_r ])
            rotate([ 90, -( 180 - cutout_angle ) / 2, 0 ])
                PieSlicePrism(
                    outer_r * 2,
                    length + DIFFERENCE_CLEARANCE * 2,
                    cutout_angle
                    );
    }

    if( show_preview )
    {
        preview_length = length * 8;

        % translate([ 0, preview_length / 2, outer_r ])
            rotate([ 90, 0, 0 ])
                cylinder( r = inner_r, h = preview_length );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a small L-shaped hook that pins a flat cord down against the surface it stands on. the cord runs
// along y, centered on x, and is pressed in sideways under the arm. the post stands on the +x side
module CordHook(
    cord_width,
    cord_z,
    wall_thickness,
    length,
    show_preview = true,
    clearance = 0.2,
    arm_extra = 0
    )
{
    inner_x = cord_width / 2 + clearance;
    arm_z = cord_z + clearance;

    // post
    translate([ inner_x, 0, 0 ])
        cube([ wall_thickness, length, arm_z + wall_thickness ]);

    // arm, reaching across the whole cord, and arm_extra past it
    translate([ -inner_x - arm_extra, 0, arm_z ])
        cube([ inner_x * 2 + wall_thickness + arm_extra, length, wall_thickness ]);

    if( show_preview )
        _CordPreview( cord_width, cord_z, length, length / 2 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// two hooks along the cord, the second turned around so the cord can't slip out of either side
module CordHookPair(
    cord_width,
    cord_z,
    wall_thickness,
    length,
    spacing,
    show_preview = true
    )
{
    CordHook( cord_width, cord_z, wall_thickness, length, show_preview = false );

    translate([ 0, length + spacing + length / 2, 0 ])
        rotate([ 0, 0, 180 ])
            translate([ 0, -length / 2, 0 ])
                CordHook( cord_width, cord_z, wall_thickness, length, show_preview = false );

    if( show_preview )
        _CordPreview( cord_width, cord_z, length * 2 + spacing, ( length * 2 + spacing ) / 2 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ghost of the cord, an ellipse in section, much longer than the hooks it passes through
module _CordPreview( cord_width, cord_z, hooks_length, center_y )
{
    preview_length = hooks_length * 4;

    % translate([ 0, center_y + preview_length / 2, cord_z / 2 ])
        rotate([ 90, 0, 0 ])
            scale([ cord_width / 2, cord_z / 2, 1 ])
                cylinder( r = 1, h = preview_length );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
