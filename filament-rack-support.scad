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
bracket_offset_y = 40;

// distance from the dowel center point to where the bracket meets the wall (screw hole is still above)
bracket_top_z = 16;

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
bottom_bracket_gripper_intercept_angle = 25; // TODO would be great to calculate this too

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

// TODO these need to be at the end!

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

    // top edge
    top_outer_intercept_angle = -120;
    top_outer_intercept_y = dowel_spacing_y - sin( top_outer_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );
    top_outer_intercept_z = -cos( top_outer_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );

    top_inner_intercept_angle = -100;
    top_inner_intercept_y = dowel_spacing_y - sin( top_inner_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );
    top_inner_intercept_z = -cos( top_inner_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );

    top_edge_points = [
        [ 0, top_outer_intercept_y, top_outer_intercept_z ],
        [ 0, top_inner_intercept_y, top_inner_intercept_z ],
        [ 0, dowel_spacing_y + bracket_offset_y, bracket_top_z - bracket_support_outer_edge_width ],
        [ 0, dowel_spacing_y + bracket_offset_y, bracket_top_z ],
        [ bracket_x, top_outer_intercept_y, top_outer_intercept_z ],
        [ bracket_x, top_inner_intercept_y, top_inner_intercept_z ],
        [ bracket_x, dowel_spacing_y + bracket_offset_y, bracket_top_z - bracket_support_outer_edge_width ],
        [ bracket_x, dowel_spacing_y + bracket_offset_y, bracket_top_z ]
        ];

    // for( point = top_edge_points )
    //     translate( point )
    //         sphere( r = 1 );

    polyhedron(
        points = top_edge_points,
        faces = [
            [ 0, 4, 5, 1 ],
            [ 1, 5, 6, 2 ],
            [ 7, 3, 2, 6 ],
            [ 4, 0, 3, 7 ],
            [ 0, 1, 2, 3 ],
            [ 4, 7, 6, 5 ],
            ]
        );

    // bottom edge
    bottom_inner_intercept_y = -sin( bottom_bracket_gripper_intercept_angle ) * ( dowel_r );
    bottom_inner_intercept_z = -cos( bottom_bracket_gripper_intercept_angle ) * ( dowel_r );
    bottom_outer_intercept_y = -sin( bottom_bracket_gripper_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );
    bottom_outer_intercept_z = -cos( bottom_bracket_gripper_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );

    bottom_edge_points = [
        [ 0, bottom_inner_intercept_y, bottom_inner_intercept_z ],
        [ 0, bottom_outer_intercept_y, bottom_outer_intercept_z ],
        [ 0, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z ],
        [ 0, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z + bracket_support_outer_edge_width ],

        [ bracket_x, bottom_inner_intercept_y, bottom_inner_intercept_z ],
        [ bracket_x, bottom_outer_intercept_y, bottom_outer_intercept_z ],
        [ bracket_x, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z ],
        [ bracket_x, dowel_spacing_y + bracket_offset_y, -bracket_bottom_z + bracket_support_outer_edge_width ],
    ];

    polyhedron(
        points = bottom_edge_points,
        faces = [
            [ 0, 4, 5, 1 ],
            [ 1, 5, 6, 2 ],
            [ 7, 3, 2, 6 ],
            [ 4, 0, 3, 7 ],
            [ 0, 1, 2, 3 ],
            [ 4, 7, 6, 5 ],
            ]
        );


    // bracket_top_z

    // wall plate

    // cut out the top screw

    // cut out the bottom screw

    // front face to mount a label
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
