////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/rounded-cube.scad>;
include <modules/triangular-prism.scad>;
include <modules/utils.scad>;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

wall_stud_ab_separation = 406;
wall_stud_bc_separation = 419;

ams_2_pro_bottom_ledge_x = 338; // note the front is actually 324
ams_2_pro_bottom_ledge_y = 250;
ams_2_pro_bottom_ledge_z = 11;

ams_2_pro_x = 372;
ams_2_pro_y = 278;
ams_2_pro_body_z = 110; // this is above the ledge below it
ams_2_pro_lid_z = 102;
ams_2_pro_lid_r = 210 / 2;

// the length in front of the AMS 2 Pro bottom edge to the front of the AMS
ams_extra_front_y = 10;

// the length behind the AMS 2 Pro bottom edge to the back of the AMS
ams_extra_back_y = 25;

// the length behind the AMS 2 Pro to the wall
// shelf_extra_y = 130;
shelf_extra_y = 50;

dowel_r = 9 / 2 + 0.1; // including clearance!

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-shelf-a";
// render_mode = "print-shelf-b";
// render_mode = "print-shelf-c";
// render_mode = "print-shelf-test";
// render_mode = "print-spacer-test";

wall_stud_width = 30; // approx

shelf_extra_x = 60;

// the width of the wall plate and top bracket
shelf_wall_plate_x = 20;

// the depth of the wall plate
shelf_wall_plate_y = 10;

// the height of the triangular bracket above the shelf
shelf_top_bracket_z = 40;

// the percent along the shelf top the bracket will extend
shelf_top_bracket_y_percent = 0.4;

// the height of the triangular bracket under the shelf
shelf_bottom_bracket_z = 100;

// the percent along the shelf top the bracket will extend
shelf_bottom_bracket_y_percent = 0.5;

// the bottom backet is wider than the top bracket, so this is the full width of the bottom bracket
shelf_bottom_bracket_full_x = 80;

shelf_base_angle = -20;
shelf_base_z = 8.0; // this is before the guide rails

spacer_x = 150;
spacer_tongue_groove_x = 4.0;
spacer_tongue_groove_z = 3.0;
spacer_tongue_groove_offset_near_y = 45;
spacer_tongue_groove_clearance = 0.2;

shelf_screw_r = 4.5 / 2;
shelf_screw_cone_r = 8.0 / 2;
shelf_screw_holder_z = 12;

// width (y) of the front ledge of the shelf
shelf_front_ledge_y = 6;

// width
shelf_front_ledge_z = 9;

dowel_front_offset_y = -30; // from the near bottom edge of the shelf
dowel_front_offset_z = -1;
dowel_front_support_ring_extra_z = 3.8; // this is the extra height of the ring below the dowel
dowel_back_offset_y = -250;
dowel_back_offset_z = -3;
dowel_back_support_ring_extra_z = 4.0;
dowel_support_ring_r = 3;

preview_spacers_below_shelf_level_z = -12;

// TODO hexagon cutouts
// TODO cutouts for drying ports
// TODO cutouts for the power cable and the filament tube
// TODO add grip on the top flat face so it won't slip

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

full_x = shelf_extra_x
    + wall_stud_ab_separation
    + wall_stud_bc_separation
    + shelf_extra_x;
echo( str( "Full X: ", full_x, " mm = ", full_x * 0.03937008, " inches" ) );

wall_stud_a_center_offset_x = shelf_extra_x;
wall_stud_b_center_offset_x = wall_stud_a_center_offset_x + wall_stud_ab_separation;
wall_stud_c_center_offset_x = wall_stud_b_center_offset_x + wall_stud_bc_separation;

wall_plate_z = shelf_screw_holder_z
    + shelf_top_bracket_z
    + shelf_base_z
    + shelf_bottom_bracket_z
    + shelf_screw_holder_z;

bottom_bracket_offset_z = shelf_screw_holder_z;
shelf_base_offset_z = bottom_bracket_offset_z + shelf_bottom_bracket_z;
top_bracket_offset_z = shelf_base_offset_z + shelf_base_z;
top_screw_holder_section_offset_z = top_bracket_offset_z + shelf_top_bracket_z;

shelf_base_y = ams_2_pro_bottom_ledge_y
    + ams_extra_front_y
    + ams_extra_back_y
    + shelf_extra_y;

spacer_ab_offset_x = shelf_extra_x + ( wall_stud_ab_separation - spacer_x ) / 2;
spacer_bc_offset_x = shelf_extra_x
    + wall_stud_ab_separation
    + ( wall_stud_bc_separation - spacer_x ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    WallPreview();

    // shelf a
    translate([ wall_stud_a_center_offset_x, 0, 0 ])
        Shelf(
            shelf_extra_x,
            ( wall_stud_ab_separation - spacer_x ) / 2,
            false,
            true
            );

    // spacer a-b
    translate([ spacer_ab_offset_x, 0, shelf_base_offset_z + preview_spacers_below_shelf_level_z ])
        ShelfSpacer( spacer_x );

    // shelf b
    translate([ wall_stud_b_center_offset_x, 0, 0 ])
        Shelf(
            ( wall_stud_ab_separation - spacer_x ) / 2,
            ( wall_stud_bc_separation - spacer_x ) / 2,
            true,
            true
            );

    // spacer b-c
    translate([ spacer_bc_offset_x, 0, shelf_base_offset_z + preview_spacers_below_shelf_level_z ])
        ShelfSpacer( spacer_x );

    // shelf c
    translate([ wall_stud_c_center_offset_x, 0, 0 ])
        Shelf(
            ( wall_stud_bc_separation - spacer_x ) / 2,
            shelf_extra_x,
            true,
            false
            );

    // left ams
    translate([
        shelf_extra_x + ( wall_stud_ab_separation - ams_2_pro_x ) / 2,
        -shelf_base_y + ams_extra_front_y + shelf_front_ledge_y * 2,
        0
        ])
        rotate([ -shelf_base_angle, 0, 0 ])
            AMS2ProPreview();

    // right ams
    translate([
        shelf_extra_x + wall_stud_ab_separation + ( wall_stud_bc_separation - ams_2_pro_x ) / 2,
        -shelf_base_y + ams_extra_front_y + shelf_front_ledge_y * 2,
        0
        ])
        rotate([ -shelf_base_angle, 0, 0 ])
            AMS2ProPreview();
}
else if( render_mode == "print-shelf-a" )
{
    translate([ wall_stud_a_center_offset_x, 0, 0 ])
        Shelf( shelf_extra_x, wall_stud_ab_separation / 2, false, true );
}
else if( render_mode == "print-shelf-b" )
{
    translate([ wall_stud_b_center_offset_x, 0, 0 ])
        Shelf( wall_stud_ab_separation / 2, wall_stud_bc_separation / 2, true, true );
}
else if( render_mode == "print-shelf-c" )
{
    translate([ wall_stud_c_center_offset_x, 0, 0 ])
        Shelf( wall_stud_bc_separation / 2, shelf_extra_x, true, false );
}
else if( render_mode == "print-shelf-test" )
{
    Shelf( shelf_bottom_bracket_full_x * 0.55, shelf_bottom_bracket_full_x * 0.55, true, true );
}
else if( render_mode == "print-spacer-test" )
{
    rotate([ 0, -90, 0 ])
        ShelfSpacer( 30 );
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Shelf( left_x, right_x, left_connection, right_connection )
{
    total_x = left_x + right_x;
    total_y = shelf_base_y * cos( shelf_base_angle );
    total_z = wall_plate_z;

    echo();
    echo( str( "total x: ", total_x ) );
    echo( str( "total y: ", total_y ) );
    echo( str( "total z: ", total_z ) );

    // wall plate
    difference()
    {
        translate([ -shelf_wall_plate_x / 2, -shelf_wall_plate_y, 0 ])
            cube([ shelf_wall_plate_x, shelf_wall_plate_y, wall_plate_z  ]);

        // bottom screw hole shaft
        translate([
            0,
            DIFFERENCE_CLEARANCE,
            shelf_screw_holder_z / 2
            ])
            rotate([ 90, 0, 0 ])
                cylinder( r = shelf_screw_r, h = shelf_wall_plate_y + DIFFERENCE_CLEARANCE * 2 );
        
        // bottom screw hole cone
        translate([
            0,
            -shelf_wall_plate_y + shelf_screw_cone_r - DIFFERENCE_CLEARANCE,
            shelf_screw_holder_z / 2
            ])
            rotate([ 90, 0, 0 ])
                cylinder( r1 = 0, r2 = shelf_screw_cone_r, h = shelf_screw_cone_r );

        // top screw hole shaft
        translate([
            0,
            DIFFERENCE_CLEARANCE,
            top_screw_holder_section_offset_z + shelf_screw_holder_z / 2
            ])
            rotate([ 90, 0, 0 ])
                cylinder( r = shelf_screw_r, h = shelf_wall_plate_y + DIFFERENCE_CLEARANCE * 2 );

        // top screw hole cone
        translate([
            0,
            -shelf_wall_plate_y + shelf_screw_cone_r - DIFFERENCE_CLEARANCE,
            top_screw_holder_section_offset_z + shelf_screw_holder_z / 2
            ])
            rotate([ 90, 0, 0 ])
                cylinder( r1 = 0, r2 = shelf_screw_cone_r, h = shelf_screw_cone_r );
    }

    // bottom triangular bracket
    _ShelfBottomBracket();

    // horizontal shelf
    translate([ -left_x, 0, shelf_base_offset_z ])
        _ShelfBase( left_x + right_x, left_connection, right_connection );

    // top triangular bracket
    _ShelfTopBracket();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _ShelfTopBracket()
{
    rotateAbout = [ 0, shelf_base_offset_z ];

    rotatedTopFar_xy = RotatePointAboutPoint( // using y,z as x,y
        [ 0, shelf_base_offset_z + shelf_base_z ],
        rotateAbout,
        -shelf_base_angle
        );
    rotatedTopNear_xy = RotatePointAboutPoint( // using y,z as x,y
        [ -shelf_base_y, shelf_base_offset_z + shelf_base_z ],
        rotateAbout,
        -shelf_base_angle
        );

    // calculate the z where the shelf base meets the wall plate
    top_face_wall_slope_intercept = findSlopeIntercept( // using y,z as x,y
        rotatedTopFar_xy,
        rotatedTopNear_xy
        );
    top_face_wall_intercept_z =
        top_face_wall_slope_intercept[ 0 ] * -shelf_wall_plate_y
        + top_face_wall_slope_intercept[ 1 ];

    // calculate the point where the bracket meets the base
    top_face_brace_intercept_y =
        -shelf_top_bracket_y_percent * shelf_base_y * cos( shelf_base_angle )
        + rotatedTopFar_xy.x;
    top_face_brace_intercept_z =
        shelf_top_bracket_y_percent * shelf_base_y * sin( shelf_base_angle )
        + rotatedTopFar_xy.y;

    points = [
        // [ -shelf_wall_plate_x / 2, -shelf_wall_plate_y, shelf_base_offset_z + shelf_base_z ],

        // [ -shelf_wall_plate_x / 2, 0, shelf_base_offset_z ],
        // [ -shelf_wall_plate_x / 2, 0, shelf_base_offset_z + shelf_base_z ],
        // [ -shelf_wall_plate_x / 2, -shelf_base_y, shelf_base_offset_z + shelf_base_z ],

        // top far
        // [ -shelf_wall_plate_x / 2, rotatedTopFar_xy.x, rotatedTopFar_xy.y ],

        // top near
        // [ -shelf_wall_plate_x / 2, rotatedTopNear_xy.x, rotatedTopNear_xy.y ],

        // where the shelf top face meets the wall plate
        [ -shelf_wall_plate_x / 2, -shelf_wall_plate_y, top_face_wall_intercept_z ],

        // the top of the bracket at the wall plate
        [ -shelf_wall_plate_x / 2, -shelf_wall_plate_y, top_face_wall_intercept_z + shelf_top_bracket_z ],

        // where the top face meets the bracket
        [ -shelf_wall_plate_x / 2, top_face_brace_intercept_y, top_face_brace_intercept_z ],

        // backside
        [ shelf_wall_plate_x / 2, -shelf_wall_plate_y, top_face_wall_intercept_z ],
        [ shelf_wall_plate_x / 2, -shelf_wall_plate_y, top_face_wall_intercept_z + shelf_top_bracket_z ],
        [ shelf_wall_plate_x / 2, top_face_brace_intercept_y, top_face_brace_intercept_z ],
    ];

    // for( point = points )
    //     # translate( point )
    //         sphere( r = 1 );

    polyhedron(
        points = points,
        faces = [
            [ 0, 1, 2 ],
            [ 3, 5, 4 ],
            [ 1, 4, 5, 2 ],
            [ 0, 2, 5, 3 ],
            [ 0, 3, 4, 1 ],
        ]
    );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _ShelfBottomBracket()
{
    // TODO this needs to have the hexagon cutouts for weight/filament reduction

    farBottom = [ -shelf_wall_plate_x / 2, 0, shelf_base_offset_z ];

    rotatedBottomNear_xy = RotatePointAboutPoint( // using y,z as x,y
        [ -shelf_base_y, shelf_base_offset_z ],
        [ farBottom.y, farBottom.z ],
        -shelf_base_angle
        );

    // calculate the z where the shelf base meets the wall plate
    bottom_face_wall_slope_intercept = findSlopeIntercept( // using y,z as x,y
        [ farBottom.y, farBottom.z ],
        rotatedBottomNear_xy
        );
    bottom_face_wall_intercept_z =
        bottom_face_wall_slope_intercept[ 0 ] * -shelf_wall_plate_y
        + bottom_face_wall_slope_intercept[ 1 ];

    // calculate the z where the shelf base meets the bracket
    bottom_face_brace_intercept_y =
        -shelf_bottom_bracket_y_percent * shelf_base_y * cos( shelf_base_angle )
        + farBottom.y;
    bottom_face_brace_intercept_z =
        shelf_bottom_bracket_y_percent * shelf_base_y * sin( shelf_base_angle )
        + farBottom.z;
        
    points = [
        // where the top face meets the bracket
        [ -shelf_wall_plate_x / 2, -shelf_wall_plate_y, bottom_face_wall_intercept_z ],

        // where the bottom face meets the bracket
        [ -shelf_bottom_bracket_full_x / 2, bottom_face_brace_intercept_y, bottom_face_brace_intercept_z ],

        // where the bottom base meets the wall plate
        [ -shelf_wall_plate_x / 2, -shelf_wall_plate_y, bottom_bracket_offset_z ],

        // backside
        [ shelf_wall_plate_x / 2, -shelf_wall_plate_y, bottom_face_wall_intercept_z ],
        [ shelf_bottom_bracket_full_x / 2, bottom_face_brace_intercept_y, bottom_face_brace_intercept_z ],
        [ shelf_wall_plate_x / 2, -shelf_wall_plate_y, bottom_bracket_offset_z ],
        ];

    // for( point = points )
    //     # translate( point )
    //         sphere( r = 1 );

    difference()
    {
        polyhedron(
            points = points,
            faces = [
                [ 0, 1, 2 ],
                [ 3, 5, 4 ],
                [ 1, 4, 5, 2 ],
                [ 0, 2, 5, 3 ],
                [ 0, 3, 4, 1 ],
                ]    
            );

        // remove the back dowel
        translate([ -200, 0, shelf_base_offset_z ])
            rotate([ -shelf_base_angle, 0, 0 ])
                translate([ 0, -shelf_base_y - dowel_back_offset_y, dowel_back_offset_z ])
                    rotate([ 0, 90, 0 ])
                        cylinder( r = dowel_r, h = 400 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _ShelfBase( x, left_connection, right_connection )
{
    translate([ x, 0, 0 ])
    {
        rotate([ shelf_base_angle, 0, 180 ])
        {
            difference()
            {
                // main section
                _ShelfBaseMainFace( x );

                // remove the left groove
                if( left_connection )
                {
                    translate([
                        x
                            - spacer_tongue_groove_x
                            + spacer_tongue_groove_clearance
                            + DIFFERENCE_CLEARANCE,
                        -DIFFERENCE_CLEARANCE,
                        ( shelf_base_z - spacer_tongue_groove_z ) / 2 + spacer_tongue_groove_clearance
                        ])
                        cube([
                            spacer_tongue_groove_x - spacer_tongue_groove_clearance,
                            shelf_base_y
                                - spacer_tongue_groove_offset_near_y
                                - spacer_tongue_groove_clearance,
                            spacer_tongue_groove_z
                                - spacer_tongue_groove_clearance * 2
                            ]);
                }

                // remove the right grove
                if( right_connection )
                {
                    translate([
                        -DIFFERENCE_CLEARANCE,
                        -DIFFERENCE_CLEARANCE,
                        ( shelf_base_z - spacer_tongue_groove_z ) / 2 + spacer_tongue_groove_clearance
                        ])
                        cube([
                            spacer_tongue_groove_x - spacer_tongue_groove_clearance,
                            shelf_base_y
                                - spacer_tongue_groove_offset_near_y
                                - spacer_tongue_groove_clearance,
                            spacer_tongue_groove_z
                                - spacer_tongue_groove_clearance * 2
                            ]);
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ShelfSpacer( x )
{
    translate([ x, 0, 0 ])
    {
        rotate([ shelf_base_angle, 0, 180 ])
        {
            // main section
            _ShelfBaseMainFace( x );

            // tongue left
            difference()
            {
                translate([
                    x,
                    0,
                    ( shelf_base_z - spacer_tongue_groove_z ) / 2
                    ])
                    cube([
                        spacer_tongue_groove_x,
                        shelf_base_y - spacer_tongue_groove_offset_near_y,
                        spacer_tongue_groove_z
                        ]);

                translate([
                    x - DIFFERENCE_CLEARANCE,
                    shelf_base_y + dowel_back_offset_y - dowel_r,
                    0
                    ])
                    cube([
                        spacer_tongue_groove_x + DIFFERENCE_CLEARANCE * 2,
                        dowel_r * 2,
                        dowel_r * 2
                        ]);
            }

            // tongue right
            difference()
            {
                translate([
                    -spacer_tongue_groove_x,
                    0,
                    ( shelf_base_z - spacer_tongue_groove_z ) / 2
                    ])
                    cube([
                        spacer_tongue_groove_x,
                        shelf_base_y - spacer_tongue_groove_offset_near_y,
                        spacer_tongue_groove_z
                        ]);

                translate([
                    -spacer_tongue_groove_x - DIFFERENCE_CLEARANCE,
                    shelf_base_y + dowel_back_offset_y - dowel_r,
                    0
                    ])
                    cube([
                        spacer_tongue_groove_x + DIFFERENCE_CLEARANCE * 2,
                        dowel_r * 2,
                        dowel_r * 2
                        ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _ShelfBaseMainFace( x )
{
    // bottom dowel support
    dowel_front_support_under_ring_z = shelf_base_z
        + dowel_front_offset_z
        - dowel_r * 2
        - dowel_support_ring_r
        - dowel_front_support_ring_extra_z;
    front_dowel_support_points = [
        [ 0, shelf_base_y, 0 ],
        [ 0, shelf_base_y + dowel_front_offset_y, dowel_front_support_under_ring_z ],
        [ 0, shelf_base_y + dowel_front_offset_y * 2, 0 ],

        [ x, shelf_base_y, 0 ],
        [ x, shelf_base_y + dowel_front_offset_y, dowel_front_support_under_ring_z ],
        [ x, shelf_base_y + dowel_front_offset_y * 2, 0 ],
        ];
    // for( point = front_dowel_support_points )
    //     # translate( point )       
    //         sphere( r = 1 );

    dowel_back_support_under_ring_z = shelf_base_z
        + dowel_back_offset_z
        - dowel_r * 2
        - dowel_support_ring_r
        - dowel_back_support_ring_extra_z;
    back_dowel_support_y = 30;
    back_dowel_support_points = [
        [ 0, shelf_base_y + dowel_back_offset_y + back_dowel_support_y, 0 ],
        [ 0, shelf_base_y + dowel_back_offset_y, dowel_back_support_under_ring_z ],
        [ 0, shelf_base_y + dowel_back_offset_y - back_dowel_support_y, 0 ],

        [ x, shelf_base_y + dowel_back_offset_y + back_dowel_support_y, 0 ],
        [ x, shelf_base_y + dowel_back_offset_y, dowel_back_support_under_ring_z ],
        [ x, shelf_base_y + dowel_back_offset_y - back_dowel_support_y, 0 ],
        ];

    // for( point = back_dowel_support_points )
    //     # translate( point )       
    //         sphere( r = 1 );

    // main face
    difference()
    {
        union()
        {
            cube([ x, shelf_base_y, shelf_base_z ]);

            // front dowel support ring
            translate([ 0, shelf_base_y + dowel_front_offset_y, dowel_front_offset_z ])
                rotate([ 0, 90, 0 ])
                    cylinder( r = dowel_r + dowel_support_ring_r, h = x );

            // front dowel bottom support
            polyhedron(
                points = front_dowel_support_points,
                faces = [
                    [ 0, 2, 1 ],
                    [ 3, 4, 5 ],
                    [ 0, 3, 5, 2 ],
                    [ 0, 1, 4, 3 ],
                    [ 1, 2, 5, 4 ],
                ]
            );

            // back dowel support ring
            translate([ 0, shelf_base_y + dowel_back_offset_y, dowel_back_offset_z ])
                rotate([ 0, 90, 0 ])
                    cylinder( r = dowel_r + dowel_support_ring_r, h = x );

            // back dowel bottom support
            polyhedron(
                points = back_dowel_support_points,
                faces = [
                    [ 0, 2, 1 ],
                    [ 3, 4, 5 ],
                    [ 0, 3, 5, 2 ],
                    [ 0, 1, 4, 3 ],
                    [ 1, 2, 5, 4 ],
                ]
            );
        }

        // remove the front dowel
        translate([
            -DIFFERENCE_CLEARANCE,
            shelf_base_y + dowel_front_offset_y,
            dowel_front_offset_z
            ])
            rotate([ 0, 90, 0 ])
                cylinder( r = dowel_r, h = x + DIFFERENCE_CLEARANCE * 2 );

        // remove the back dowel
        translate([
            -DIFFERENCE_CLEARANCE,
            shelf_base_y + dowel_back_offset_y,
            dowel_back_offset_z
            ])
            rotate([ 0, 90, 0 ])
                cylinder( r = dowel_r, h = x + DIFFERENCE_CLEARANCE * 2 );
    }

    // front ledge
    translate([ 0, shelf_base_y - shelf_front_ledge_y, shelf_base_z ])
        cube([ x, shelf_front_ledge_y / 2, shelf_front_ledge_z ]);
    translate([ 0, shelf_base_y - shelf_front_ledge_y / 2, shelf_base_z ])
        TriangularPrism( x, shelf_front_ledge_y / 2, shelf_front_ledge_z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AMS2ProPreview()
{
    // ledge
    % translate([ ( ams_2_pro_x - ams_2_pro_bottom_ledge_x ) / 2, ams_extra_front_y, 0 ])
        RoundedCubeAlt2(
            x = ams_2_pro_bottom_ledge_x,
            y = ams_2_pro_bottom_ledge_y,
            z = ams_2_pro_bottom_ledge_z,
            r = 10,
            round_top = false,
            round_bottom = false
            );

    // body
    % translate([ 0, 0, ams_2_pro_bottom_ledge_z ])
        RoundedCubeAlt2(
            x = ams_2_pro_x,
            y = ams_2_pro_y,
            z = ams_2_pro_body_z,
            r = 20,
            round_top = false,
            round_bottom = false
            );

    animate_angle = $t < 0.5
        ? $t * 90 / 0.5
        : ( 1.0 - $t ) * 90 / 0.5;
    // echo( $t, " ===> ", animate_angle);

    // lid
    % translate([ 0, ams_2_pro_y - ams_extra_back_y, ams_2_pro_bottom_ledge_z + ams_2_pro_body_z ])
    {
        rotate([ -animate_angle, 0, 0 ])
        {
            translate([ 0, -ams_2_pro_lid_r, 0 ])
            {
                difference()
                {
                    rotate([ 0, 90, 0 ])
                        cylinder( r = ams_2_pro_lid_r, h = ams_2_pro_x );

                    translate([
                        -DIFFERENCE_CLEARANCE,
                        -ams_2_pro_lid_r - DIFFERENCE_CLEARANCE,
                        -ams_2_pro_lid_r - DIFFERENCE_CLEARANCE
                        ])
                        cube([
                            ams_2_pro_x + DIFFERENCE_CLEARANCE * 2,
                            ams_2_pro_lid_r * 2 + DIFFERENCE_CLEARANCE * 2,
                            ams_2_pro_lid_r + DIFFERENCE_CLEARANCE
                            ]);
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WallPreview()
{
    translate([ wall_stud_a_center_offset_x, 0, 0 ])
        WallStudPreview();
    translate([ wall_stud_b_center_offset_x, 0, 0 ])
        WallStudPreview();
    translate([ wall_stud_c_center_offset_x, 0, 0 ])
        WallStudPreview();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WallStudPreview()
{
    stud_y = 100;
    stud_z = 1000;

    % translate([ -wall_stud_width / 2, 0, -stud_z / 2 ])
        cube([ wall_stud_width, stud_y, stud_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
