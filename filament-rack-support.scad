////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

dowel_r = 22.3 / 2;

filament_spool_r = 200 / 2;
filament_spool_x = 68;

// screw_r = 5.0 / 2;

// TODO able to mount a label

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";

bracket_x = 20;
dowel_spacing_y = 135;

bracket_dowel_gripper_r = 4.0;

bracket_support_outer_edge_width = 6.0;
bracket_back_plate_width = 10;

dowel_gripper_angle_cutout = 135;

// distance from the back dowel center to the wall
bracket_offset_y = 50;

// distance from the dowel center point to where the bracket meets the wall (screw hole is still below)
bracket_bottom_z = 80;

preview_x = 1000;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 256;

// TODO figure out how to actually calculate these?!?!
filament_spool_offset_z = 88.32;

dowel_gripper_angle = atan2( filament_spool_offset_z, dowel_spacing_y / 2 );

// this is the angle where the bottom of the bracket intersects with the dowel gripper
bottom_bracker_gripper_intercept_angle = 25; // TODO would be great to calculate this

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    DowelPreview();

    translate([ 0, dowel_spacing_y, 0 ])
        DowelPreview();

    translate([ 0, dowel_spacing_y / 2, filament_spool_offset_z ])
        FilamentSpoolPreview();

    // back wall preview
    % translate([ 0, dowel_spacing_y + bracket_offset_y, -filament_spool_r ])
        cube([ preview_x, 0.01, filament_spool_r * 4 ]);

    translate([ -bracket_x, 0, 0 ])
        FilamentSpoolBracket();
}
else if( render_mode == "print-holder" )
{
    // TODO implement print-holder mode
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DowelPreview()
{
    % rotate([ 0, 90, 0 ])
        cylinder( r = dowel_r, h = preview_x );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FilamentSpoolPreview()
{
    % rotate([ 0, 90, 0 ])
        cylinder( r = filament_spool_r, h = filament_spool_x );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FilamentSpoolBracket()
{
    gripper_outer_r = dowel_r + bracket_dowel_gripper_r;

    span_angle = 2 * ( 90 - dowel_gripper_angle );

    difference()
    {
        union()
        {
            // near gripper
            rotate([ 0, 90, 0 ])
            {
                difference()
                {
                    // outer cylinder
                    cylinder( r = gripper_outer_r, h = bracket_x );

                    // cut out the area to let the filamet slide past
                    rotate([
                        -DIFFERENCE_CLEARANCE,
                        0,
                        90 + dowel_gripper_angle - dowel_gripper_angle_cutout / 2
                        ])
                        PieSlicePrism(
                            width = gripper_outer_r * 2, // doubled just to make sure the cut out doesn't clip
                            height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                            angle = dowel_gripper_angle_cutout
                            );
                }
            }

            // back gripper
            translate([ 0, dowel_spacing_y, 0 ])
            {
                rotate([ 0, 90, 0 ])
                {
                    difference()
                    {
                        // outer cylinder
                        cylinder( r = gripper_outer_r, h = bracket_x );

                        // cut out the area to let the filamet slide past
                        rotate([
                            -DIFFERENCE_CLEARANCE,
                            0,
                            -90 - dowel_gripper_angle - dowel_gripper_angle_cutout / 2
                            ])
                            PieSlicePrism(
                                width = gripper_outer_r * 2, // doubled just to make sure the cut out doesn't clip
                                height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                                angle = dowel_gripper_angle_cutout
                                );
                    }
                }
            }

            // span top
            difference()
            {
                translate([ 0, dowel_spacing_y / 2, filament_spool_offset_z ])
                    rotate([ -90 + dowel_gripper_angle, 0, 0 ])
                        rotate([ 0, 90, 0 ])
                            PieSlicePrism(
                                width = filament_spool_r + dowel_r + bracket_support_outer_edge_width,
                                height = bracket_x,
                                angle = span_angle
                                );

                translate([ -DIFFERENCE_CLEARANCE, dowel_spacing_y / 2, filament_spool_offset_z + DIFFERENCE_CLEARANCE ])
                    rotate([ -90 + dowel_gripper_angle - DIFFERENCE_CLEARANCE, 0, 0 ])
                        rotate([ 0, 90, 0 ])
                            PieSlicePrism(
                                width = filament_spool_r + dowel_r,
                                height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                                angle = span_angle + DIFFERENCE_CLEARANCE * 2
                                );
            }
        }

        // cut out the dowel
        rotate([ 0, 90, 0 ])
            difference()
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder( r = dowel_r, h = bracket_x + DIFFERENCE_CLEARANCE * 2 );

        // cut out the dowel
        translate([ 0, dowel_spacing_y, 0 ])
            rotate([ 0, 90, 0 ])
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder( r = dowel_r, h = bracket_x + DIFFERENCE_CLEARANCE * 2 );
    }


    inner_intercept_y = -sin( bottom_bracker_gripper_intercept_angle ) * ( dowel_r );
    inner_intercept_z = -cos( bottom_bracker_gripper_intercept_angle ) * ( dowel_r );

    outer_intercept_y = -sin( bottom_bracker_gripper_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );
    outer_intercept_z = -cos( bottom_bracker_gripper_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );

    // bottom edge
    points = [
        [ 0, inner_intercept_y, inner_intercept_z ],
        // [ 0, 0, -dowel_r - bracket_support_outer_edge_width ], // TODO this point should really be rotated around
        [ 0, outer_intercept_y, outer_intercept_z ],
        [ 0, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z ],
        [ 0, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z + bracket_support_outer_edge_width ],

        [ bracket_x, inner_intercept_y, inner_intercept_z ],
        // [ bracket_x, 0, -dowel_r - bracket_support_outer_edge_width ], // TODO this point should really be rotated around
        [ bracket_x, outer_intercept_y, outer_intercept_z ],
        [ bracket_x, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z ],
        [ bracket_x, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z + bracket_support_outer_edge_width ],
    ];

    // for( point = points )
    //     translate( point )
    //         sphere( r = 1 );

    polyhedron(
        points = points,
        faces = [
            [ 0, 4, 5, 1 ],
            [ 1, 5, 6, 2 ],
            [ 7, 3, 2, 6 ],
            [ 4, 0, 3, 7 ],
            [ 0, 1, 2, 3 ],
            [ 4, 7, 6, 5 ],
            ]
        );

    // wall plate
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
