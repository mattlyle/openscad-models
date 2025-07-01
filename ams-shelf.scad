////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

wall_stud_ab_separation = 406;
wall_stud_bc_separation = 419;

ams_2_pro_bottom_ledge_back_x = 235;
ams_2_pro_bottom_ledge_front_x = 235;
ams_2_pro_bottom_ledge_y = 250;
ams_2_pro_bottom_ledge_z = 11;

// the length in front of the AMS 2 Pro bottom edge to the fron of the AMS
ams_extra_front_y = 10;

// the length behind the AMS 2 Pro bottom edge to the back of the AMS
ams_extra_back_y = 25;

// the length behind the AMS 2 Pro to the wall
// shelf_extra_y = 130;
shelf_extra_y = 70;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-shelf-a";
// render_mode = "print-shelf-b";
// render_mode = "print-shelf-c";
// render_mode = "print-shelf-test";

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
spacer_tongue_groove_x = 6;

shelf_screw_r = 4.5 / 2;
shelf_screw_cone_r = 8.0 / 2;
shelf_screw_holder_z = 12;

preview_spacers_below_shelf_level_z = -20;

// TODO hexagon cutouts
// TODO cutouts for drying ports
// TODO cutouts for the AMS 2 Pro bottom ledge
// TODO cutouts for the power cable and the filament tube
// TODO x is too big, so need spacers... tongue and groove?
// TODO preview the AMS itself

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

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

    translate([ wall_stud_a_center_offset_x, 0, 0 ])
        Shelf(
            shelf_extra_x,
            ( wall_stud_ab_separation - spacer_x ) / 2,
            false,
            true
            );

    translate([ spacer_ab_offset_x, 0, shelf_base_offset_z + preview_spacers_below_shelf_level_z ])
        ShelfSpacer();

    translate([ wall_stud_b_center_offset_x, 0, 0 ])
        Shelf(
            ( wall_stud_ab_separation - spacer_x ) / 2,
            ( wall_stud_bc_separation - spacer_x ) / 2,
            true,
            true
            );

    translate([ spacer_bc_offset_x, 0, shelf_base_offset_z + preview_spacers_below_shelf_level_z ])
        ShelfSpacer();

    translate([ wall_stud_c_center_offset_x, 0, 0 ])
        Shelf(
            ( wall_stud_bc_separation - spacer_x ) / 2,
            shelf_extra_x,
            true,
            false
            );
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
    translate([ wall_stud_c_center_offset_x, 0, 0 ])
        Shelf( shelf_bottom_bracket_full_x * 0.7, shelf_bottom_bracket_full_x * 0.7, true, false );
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
        _ShelfBase( left_x + right_x );

    // AMS ledge

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

module _ShelfBase( x )
{
    translate([ x, 0, 0 ])
        rotate([ shelf_base_angle, 0, 180 ])
            cube([ x, shelf_base_y, shelf_base_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ShelfSpacer()
{
    // TODO tongue

    translate([ spacer_x, 0, 0 ])
        rotate([ shelf_base_angle, 0, 180 ])
            cube([ spacer_x, shelf_base_y, shelf_base_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AMS2ProPreview()
{
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
