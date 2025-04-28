////////////////////////////////////////////////////////////////////////////////////////////////////

include <../modules/rounded-cube.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

rack_inside_x = 416;
rack_inside_y = 416;

rack_side_bar_x = 10; // TODO: get the actual measurement
rack_offset_back_y = 10; // TODO: get the actual measurement
rack_front_bar_y = 10; // TODO: get the actual measurement
rack_bar_z = 10; // TODO: get the actual measurement

rack_front_left_corder_x = 7;
rack_front_left_corder_y = 5;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-section-back-left";
// render_mode = "print-section-back-right";
// render_mode = "print-section-front-left";
// render_mode = "print-section-front-right";

rack_top_z = 4.0;

side_bar_overlap_x = rack_side_bar_x * 0.75;
front_overlap_y = rack_front_bar_y * 0.75;

num_ribs_left_right = 3;

rib_width = 2.4;
rib_height = 12.0;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

rack_top_section_x = rack_inside_x / 2;
rack_top_section_y = rack_inside_y / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
        NetworkRackPreview();

    // front left
    translate([ -side_bar_overlap_x, -front_overlap_y, 0 ])
        NetworkRackTop( false, true );

    // front right
    // translate([ rack_top_section_x, -front_overlap_y, 0 ])
    //     NetworkRackTop( false, false );

    // back left
    // NetworkRackTop( true, true );

    // back right
    // NetworkRackTop( true, false );
}
else if( render_mode == "print-section-back-left" )
{
    translate([ rack_top_section_x + side_bar_overlap_x, 0, rack_top_z ])
        rotate([ 0, 180, 0 ])
            NetworkRackTop( false, true );
}
else if( render_mode == "print-section-back-right" )
{
}
else if( render_mode == "print-section-front-left" )
{
}
else if( render_mode == "print-section-front-right" )
{
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackPreview()
{
    // back wall
    // color( "black" )
    //     translate( [ -rack_side_bar_x, rack_inside_y, -rack_bar_z ] )
    //         cube([
    //             rack_inside_x + rack_side_bar_x * 2,
    //             0.01,
    //             100
    //             ]);

    // left bar
    color( "black" )
        translate( [ -rack_side_bar_x, 0, -rack_bar_z ] )
            cube([ rack_side_bar_x, rack_inside_y, rack_bar_z ]);

    // right bar
    color( "black" )
        translate( [ rack_inside_x, 0, -rack_bar_z ] )
            cube([ rack_side_bar_x, rack_inside_y, rack_bar_z ]);

    // front
    color( "black" )
        translate( [ -rack_side_bar_x, -rack_front_bar_y, -rack_bar_z ] )
            cube([
                rack_inside_x + rack_side_bar_x * 2,
                rack_front_bar_y,
                rack_bar_z
                ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackTop( is_back, is_left )
{
    // TODO: cut out the corners!!!

    section_x = side_bar_overlap_x + rack_top_section_x;
    section_y = is_back
        ? 0 // TODO: finish with back setup
        : front_overlap_y + rack_top_section_y;

    // echo( str( "section_x=", section_x ) );
    // echo( str( "section_y=", section_y ) );
    assert( section_x <= BUILD_PLATE_X, "Too big for build plate (x)" );
    assert( section_y <= BUILD_PLATE_Y, "Too big for build plate (y)" );

    // flat top
    RoundedCubeAlt2(
        x = section_x,
        y = section_y,
        z = rack_top_z,
        r = 4.0,
        round_top = true,
        round_bottom = false,
        round_left = is_left,
        round_right = !is_left,
        round_front = !is_back,
        round_back = is_back
        );

    // % cube([
    //     section_x,
    //     section_y,
    //     rack_top_z
    //     ]);

    strut_left_x = is_left
        ? side_bar_overlap_x
        : 0;
    strut_right_x = is_left
        ? section_x - rib_width
        : section_x - side_bar_overlap_x - rib_width;

    strut_near_y = is_back
        ? -1 // TODO: finish
        : front_overlap_y;
    strut_far_y = is_back
        ? -1 // TODO: finish
        : section_y - rib_width;

    // left outer strut
    translate([ strut_left_x, strut_near_y, -rib_height ])
        cube([ rib_width, rack_top_section_y, rib_height ]);

    // right outer strut
    translate([ strut_right_x, strut_near_y, -rib_height ])
        cube([ rib_width, rack_top_section_y, rib_height ]);

    // front outer strut
    translate([ strut_left_x, strut_near_y, -rib_height ])
        cube([ rack_top_section_x, rib_width, rib_height ]);

    // rear outer strut
    translate([ strut_left_x, strut_far_y, -rib_height ])
        cube([ rack_top_section_x, rib_width, rib_height ]);


    // left-right ribs

    //
}

////////////////////////////////////////////////////////////////////////////////////////////////////
