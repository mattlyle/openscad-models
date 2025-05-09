////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <utils.scad>
include <pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateCordClipBaseWidth( inner_r, wall_thickness ) = ( inner_r + wall_thickness ) * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CordClip(
    inner_r,
    wall_thickness,
    length,
    show_preview = true,
    left_support_size = -1,
    right_support_size = -1,
    cutout_angle = 100
    )
{
    outer_r = inner_r + wall_thickness;
 
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

            if( left_support_size > 0 )
            {
                _CordClipSupport( true, length, cutout_angle, left_support_size, outer_r );
            }

            if( right_support_size > 0 )
            {
                _CordClipSupport( false, length, cutout_angle, right_support_size, outer_r );
            }
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

module _CordClipSupport( is_left, length, cutout_angle, support_size, outer_r )
{
    support_offset_x = outer_r * cos( 90 - cutout_angle / 2 );
    support_offset_z = outer_r * sin( 90 - cutout_angle / 2 ) + outer_r;

    points = is_left
        ? [
            [ -support_offset_x - support_size, 0, 0 ],
            [ -support_offset_x, 0, support_offset_z ],
            [ -support_offset_x, 0, 0 ],
            [ -support_offset_x - support_size, length, 0 ],
            [ -support_offset_x, length, support_offset_z ],
            [ -support_offset_x, length, 0 ],
            ]
        : [
            [ support_offset_x, 0, support_offset_z ],
            [ support_offset_x + support_size, 0, 0 ],
            [ support_offset_x, 0, 0 ],
            [ support_offset_x, length, support_offset_z ],
            [ support_offset_x + support_size, length, 0 ],
            [ support_offset_x, length, 0 ]
        ];

    // for( point = points )
    // {
    //     #translate( point )
    //         sphere( r = 2 );
    // }

    polyhedron( points = points, faces = [
        [ 0, 1, 2 ],
        [ 3, 5, 4 ],
        [ 1, 4, 5, 2 ],
        [ 0, 2, 5, 3 ],
        [ 0, 3, 4, 1 ]
    ] );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
