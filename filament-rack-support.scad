////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/pie-slice-prism.scad>
include <modules/hexagons.scad>
include <modules/rounded-cube.scad>
include <modules/connectors.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

dowel_r = 22.3 / 2;

filament_spool_r = 200 / 2;
filament_spool_x = 68;

ScrewHole_r = 5.0 / 2;
screw_head_r = 8.0 / 2 + 1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bracket-only";
// render_mode = "print-bracket-with-label-mount";
// render_mode = "print-label";
// render_mode = "print-standalone-label-with-gripper";

bracket_x = 20;
dowel_spacing_y = 135;

bracket_dowel_gripper_r = 4.0;

bracket_support_outer_edge_width = 6.0;

bracket_back_plate_width = 10;

bracket_back_plate_screw_inset_depth = 3.0;

dowel_gripper_angle_cutout = 135;

// distance from the back dowel center to the wall
bracket_offset_y = 40;

// distance from the dowel center point to where the bracket meets the wall (screw hole is still above)
bracket_top_z = 16;

// distance from the dowel center point to where the bracket meets the wall (screw hole is still below)
bracket_bottom_z = 80;

hex_cutouts_r = 4;
hex_cutouts_spacing = 1.5;

preview_x = 1000;

label_connector_cap_width = 2.0;
label_connector_collar_width = 2.0;
label_connector_cap_padding = 0.5;
label_neck_y = 8.0;
label_angle = -8.0;
label_neck_z = 8.0;
label_neck_offset_y = 2.5;
label_neck_offset_z = -4.0;

label_x = 80;
label_y = 3.5;
label_z = 25;
label_connector_offset_z = 5;
label_corner_radius = 0.75;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 128 : 256;

// TODO figure out how to actually calculate these?!?!
filament_spool_offset_z = 88.32;

dowel_gripper_angle = atan2( filament_spool_offset_z, dowel_spacing_y / 2 );

// this is the angle where the bottom of the bracket intersects with the dowel gripper
bottom_bracket_gripper_intercept_angle = 25; // TODO would be great to calculate this too

ScrewHole_extra_z = ScrewHole_r * 4;

label_neck_x = bracket_x - label_connector_cap_width * 2;

gripper_outer_r = dowel_r + bracket_dowel_gripper_r;
span_angle = 2 * ( 90 - dowel_gripper_angle );

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
        FilamentSpoolBracket( true );

    translate([ -label_x / 2 + bracket_x + label_connector_cap_width + label_connector_cap_padding, -20, -label_connector_offset_z * 2 ])
        rotate([ label_angle, 0, 0 ])
            LabelHolder();

    translate([ 150, 0, 0 ])
    // translate([ -150, 0, 0 ])
        StandaloneDowelLabelHolder();
}
else if( render_mode == "print-bracket-only" )
{
    translate([
        bracket_bottom_z + ScrewHole_extra_z,
        dowel_r + bracket_dowel_gripper_r,
        bracket_x
        ])
        rotate([ 0, 90, 0 ])
            FilamentSpoolBracket( false );
}
else if( render_mode == "print-bracket-with-label-mount" )
{
    translate([
        bracket_bottom_z + ScrewHole_extra_z,
        dowel_r + bracket_dowel_gripper_r,
        bracket_x
        ])
        rotate([ 0, 90, 0 ])
            FilamentSpoolBracket( true );
}
else if( render_mode == "print-label" )
{
    translate([
        ( label_x - label_neck_x ) / 2,
        label_z,
        label_neck_y + label_connector_cap_width + label_y
        ])
        rotate([ 90, 0, 0 ])
            LabelHolder();
}
else if( render_mode == "print-standalone-label-with-gripper" )
{
    translate([
        ( label_x - label_neck_x ) / 2,
        label_z,
        label_neck_y + label_connector_cap_width + label_y * 2
        ])
        rotate([ 90 - label_angle, 0, 0 ])
            StandaloneDowelLabelHolder();
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

module FilamentSpoolBracket( include_label_bracket )
{
   difference()
    {
        union()
        {
            // near gripper
            rotate([
                90 + dowel_gripper_angle - dowel_gripper_angle_cutout / 2,
                0,
                0
                ])
                DowelGripper();

            // back gripper
            translate([ 0, dowel_spacing_y, 0 ])
                rotate([
                    -90 - dowel_gripper_angle - dowel_gripper_angle_cutout / 2,
                    0,
                    0
                    ])
                    DowelGripper();

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
        }

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
    bottom_inner_intercept_y = -sin( bottom_bracket_gripper_intercept_angle ) * dowel_r;
    bottom_inner_intercept_z = -cos( bottom_bracket_gripper_intercept_angle ) * dowel_r;
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

    // wall plate
    difference()
    {
        translate([
            0,
            dowel_spacing_y + bracket_offset_y - bracket_back_plate_width,
            -bracket_bottom_z - ScrewHole_extra_z
            ])
            cube([
                bracket_x,
                bracket_back_plate_width,
                bracket_top_z + bracket_bottom_z + ScrewHole_extra_z * 2
                ]);

        // cut out the top screw
        translate([
            bracket_x / 2,
            dowel_spacing_y + bracket_offset_y,
            bracket_top_z + ScrewHole_extra_z / 4
            ])
            rotate([ 90, 0, 0 ])
                ScrewHole();

        // cut out the bottom screw
        translate([
            bracket_x / 2,
            dowel_spacing_y + bracket_offset_y,
            -bracket_bottom_z - ScrewHole_extra_z / 4
            ])
            rotate([ 90, 0, 0 ])
                ScrewHole();
    }

    // hexagons

    // we do this by creating a polyhedron of the basic dimmentions, cut out the round sections, then cut out the hexagons

    rear_dowel_inner_intercept_angle = 40;
    rear_dowel_inner_intercept_y = dowel_spacing_y - sin( rear_dowel_inner_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );
    rear_dowel_inner_intercept_z = -cos( rear_dowel_inner_intercept_angle ) * ( dowel_r + bracket_dowel_gripper_r );

    near_dowel_inner_intercept_angle = -40;
    near_dowel_inner_intercept_y = -sin( near_dowel_inner_intercept_angle ) * dowel_r;
    near_dowel_inner_intercept_z = -cos( near_dowel_inner_intercept_angle ) * dowel_r;

    hexagon_body_points = [
        [ 0, dowel_spacing_y + bracket_offset_y - bracket_back_plate_width, bracket_top_z - bracket_support_outer_edge_width ],
        [ 0, top_inner_intercept_y, top_inner_intercept_z ],
        [ 0, rear_dowel_inner_intercept_y, rear_dowel_inner_intercept_z ],
        [ 0, near_dowel_inner_intercept_y, near_dowel_inner_intercept_z ],
        [ 0, bottom_inner_intercept_y, bottom_inner_intercept_z ],
        [ 0, dowel_spacing_y + bracket_offset_y - bracket_back_plate_width, -bracket_bottom_z + bracket_support_outer_edge_width ],

        [ bracket_x, dowel_spacing_y + bracket_offset_y - bracket_back_plate_width, bracket_top_z - bracket_support_outer_edge_width ],
        [ bracket_x, top_inner_intercept_y, top_inner_intercept_z ],
        [ bracket_x, rear_dowel_inner_intercept_y, rear_dowel_inner_intercept_z ],
        [ bracket_x, near_dowel_inner_intercept_y, near_dowel_inner_intercept_z ],
        [ bracket_x, bottom_inner_intercept_y, bottom_inner_intercept_z ],
        [ bracket_x, dowel_spacing_y + bracket_offset_y - bracket_back_plate_width, -bracket_bottom_z + bracket_support_outer_edge_width ],
        ];
    // for( point = hexagon_body_points )
    //     translate( point )
    //        # sphere( r = 1 );

    difference()
    {
        polyhedron(
            points = hexagon_body_points,
            faces = [
                [ 0, 6, 7, 1 ],
                [ 1, 7, 8, 2 ],
                [ 2, 8, 9, 3 ],
                [ 3, 9, 10, 4 ],
                [ 4, 10, 11, 5 ],
                [ 6, 0, 5, 11 ],
                [ 0, 1, 2, 3, 4, 5 ],
                [ 11, 10, 9, 8, 7, 6 ]
                ] );

        // cut out the near dowel
        rotate([ 0, 90, 0 ])
            difference()
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder( r = dowel_r, h = bracket_x + DIFFERENCE_CLEARANCE * 2 );

        // cut out the rear dowel
        translate([ 0, dowel_spacing_y, 0 ])
            rotate([ 0, 90, 0 ])
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder( r = dowel_r, h = bracket_x + DIFFERENCE_CLEARANCE * 2 );

        // cut out the span
        translate([ -DIFFERENCE_CLEARANCE, dowel_spacing_y / 2, filament_spool_offset_z ])
            rotate([ -90 + dowel_gripper_angle, 0, 0 ])
                rotate([ 0, 90, 0 ])
                    PieSlicePrism(
                        width = filament_spool_r + dowel_r + bracket_support_outer_edge_width,
                        height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                        angle = span_angle
                        );

        // hexagon cutouts
        translate([ bracket_x + DIFFERENCE_CLEARANCE, 0, bracket_top_z ])
        {
            rotate([ -90, 0, 90 ])
            {
                for( row = [ 0 : 16 ] )
                {
                    for( col = [ 0 : 16 ] )
                    {
                        translate([
                            CalculateHexagonOffsetX(
                                row,
                                col,
                                hex_cutouts_r,
                                hex_cutouts_spacing
                                ),
                            CalculateHexagonOffsetY(
                                row,
                                hex_cutouts_r,
                                hex_cutouts_spacing
                                ),
                            0
                            ])
                            Hexagon( hex_cutouts_r, bracket_x + DIFFERENCE_CLEARANCE * 2 );
                    }
                }
            }
        }
    }

    if( include_label_bracket )
    {
        translate([
            0,
            -dowel_r - bracket_dowel_gripper_r + label_neck_offset_y,
            - label_neck_z / 2 + label_neck_offset_z
            ])
        {
            translate([ label_connector_cap_width, 0, 0 ])
                rotate([ label_angle, 0, 0 ])
                    SlideConnectorM(
                        label_neck_x,
                        label_neck_y,
                        label_neck_z,
                        label_connector_cap_width,
                        label_connector_cap_width,
                        label_connector_cap_width
                        );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module StandaloneDowelLabelHolder()
{
    // gripper
    rotate([
        90 + dowel_gripper_angle - dowel_gripper_angle_cutout / 2,
        0,
        0
        ])
        DowelGripper();

    // label
    translate([
        -( label_x - label_neck_x ) / 2,
        -dowel_r - bracket_dowel_gripper_r - label_y,
        -label_z / 2
        ])
        rotate([ label_angle, 0, 0 ])
            RoundedCubeAlt2( label_x, label_y, label_z, label_corner_radius );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DowelGripper()
{
    rotate([ 0, 90, 0 ])
    {
        difference()
        {
            // outer cylinder
            cylinder( r = gripper_outer_r, h = bracket_x );

            // cut out the area to let the filamet slide past
            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                PieSlicePrism(
                    width = gripper_outer_r * 2, // doubled just to make sure the cut out doesn't clip
                    height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                    angle = dowel_gripper_angle_cutout
                    );

            difference()
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder( r = dowel_r, h = bracket_x + DIFFERENCE_CLEARANCE * 2 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewHole()
{
    translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
        cylinder( r = ScrewHole_r, h = bracket_back_plate_width );

    translate([ 0, 0, bracket_back_plate_width -bracket_back_plate_screw_inset_depth ])
        cylinder( r = screw_head_r, h = bracket_back_plate_screw_inset_depth + DIFFERENCE_CLEARANCE );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LabelHolder()
{
    union()
    {
        translate([
            -( label_x - label_neck_x ) / 2,
            -label_neck_y - label_connector_cap_width - label_y,
            0
            ])
            RoundedCubeAlt2( label_x, label_y, label_z, label_corner_radius );

        translate([ 0, 0, label_connector_offset_z ])
            SlideConnectorF(
                label_neck_x,
                label_neck_y,
                label_neck_z,
                label_connector_cap_width,
                label_connector_cap_width,
                label_connector_cap_width,
                label_connector_collar_width,
                label_connector_collar_width,
                label_connector_collar_width,
                label_connector_cap_padding
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
