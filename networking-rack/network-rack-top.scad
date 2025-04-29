////////////////////////////////////////////////////////////////////////////////////////////////////

include <../modules/rounded-cube.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

rack_inside_x = 416;
rack_inside_y = 416;

rack_side_bar_x = 56;
rack_offset_back_y = 32;
rack_front_bar_y = 31;
rack_bar_z = 30;

rack_front_offset_z = 2; // the front bar is 2mm higher than the side bars

rack_front_corder_x = 7;
rack_front_corder_y = 5;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print-section-back-left";
// render_mode = "print-section-back-right";
// render_mode = "print-section-front-left";
// render_mode = "print-section-front-right";

rack_top_z = 2.4;

side_bar_overlap_x = rack_side_bar_x * 0.5;
front_overlap_y = rack_front_bar_y * 0.5;

num_ribs = 3;

rib_width = 2.4;
rib_height_outside = 30.0;
rib_height_inside = 16.0;

edge_clearance = 0.2;

rack_preview_color = [ 0.2, 0.2, 0.2 ];

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

rack_top_section_x = rack_inside_x / 2 - edge_clearance;
rack_top_section_y = rack_inside_y / 2 - edge_clearance;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ -edge_clearance, -edge_clearance, -DIFFERENCE_CLEARANCE ])
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
    // color( rack_preview_color )
    //     translate( [ -rack_side_bar_x, rack_inside_y, -rack_bar_z ] )
    //         cube([
    //             rack_inside_x + rack_side_bar_x * 2,
    //             0.01,
    //             100
    //             ]);

    // left bar
    color( [ 0.2, 0.2, 0.2 ] )
        translate([ -rack_side_bar_x, 0, -rack_bar_z ])
            cube([ rack_side_bar_x, rack_inside_y, rack_bar_z - rack_front_offset_z ]);

    // right bar
    color( rack_preview_color )
        translate([ rack_inside_x, 0, -rack_bar_z ])
            cube([ rack_side_bar_x, rack_inside_y, rack_bar_z - rack_front_offset_z ]);

    // front
    color( rack_preview_color )
        translate([ -rack_side_bar_x, -rack_front_bar_y, -rack_bar_z ])
            cube([
                rack_inside_x + rack_side_bar_x * 2,
                rack_front_bar_y,
                rack_bar_z
                ]);

    // front left corner
    color( rack_preview_color )
        translate([ 0, 0, -rack_bar_z ] )
            cube([
                rack_front_corder_x,
                rack_front_corder_y,
                rack_bar_z
                ]);

    // front left corner
    color( rack_preview_color )
        translate([ rack_inside_x - rack_front_corder_x, 0, -rack_bar_z ])
            cube([
                rack_front_corder_x,
                rack_front_corder_y,
                rack_bar_z
                ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackTop( is_back, is_left )
{
    section_x = side_bar_overlap_x + rack_top_section_x;
    section_y = is_back
        ? 0 // TODO: finish with back setup
        : front_overlap_y + rack_top_section_y;

    echo( str( "section_x=", section_x ) );
    echo( str( "section_y=", section_y ) );
    assert( section_x <= BUILD_PLATE_X, "Too big for build plate (x)" );
    assert( section_y <= BUILD_PLATE_Y, "Too big for build plate (y)" );

    // flat top
    RoundedCubeAlt2(
        x = section_x,
        y = section_y,
        z = rack_top_z,
        r = rack_top_z,
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

    strut_left_z = is_left
        ? rib_height_outside
        : rib_height_inside;
    strut_right_z = !is_left
        ? rib_height_outside
        : rib_height_inside;

    // under the overhang
    translate([
        is_left ? 0 : 10,
        is_back ? 0 : front_overlap_y,
        -rack_front_offset_z + edge_clearance
        ])
        cube([
            side_bar_overlap_x,
            rack_top_section_y,
            rack_front_offset_z - edge_clearance
            ]);

    difference()
    {
        union()
        {
            // left outer strut
            translate([ strut_left_x, strut_near_y, -strut_left_z ])
                cube([ rib_width, rack_top_section_y, strut_left_z ]);

            // right outer strut
            translate([ strut_right_x, strut_near_y, -strut_right_z ])
                cube([ rib_width, rack_top_section_y, strut_right_z ]);

            // front outer strut
            translate([ strut_left_x, strut_near_y, -rib_height_outside ])
                RibStrut( is_left );

            // rear outer strut
            translate([ strut_left_x, strut_far_y, -rib_height_outside ])
                RibStrut( is_left );

            // left-right ribs
            for( i = [ 0 : num_ribs - 1 ] )
            {
                rib_y = ( i + 1 ) * ( rack_top_section_y / ( num_ribs + 1 ) );

                translate([ strut_left_x, strut_near_y + rib_y - rib_width / 2, -rib_height_outside ])
                    RibStrut( is_left );
            }

            // front-back ribs
            for( i = [ 0 : num_ribs - 1 ] )
            {
                rib_x = ( i + 1 ) * ( rack_top_section_x / ( num_ribs + 1 ) );

                translate([ strut_left_x + rib_x - rib_width / 2, strut_near_y, -rib_height_inside ])
                    cube([ rib_width, rack_top_section_y, rib_height_inside ]);
            }
        }

        // remove the corners if needed
        if( !is_back )
        {
            if( is_left )
            {
                translate([
                    strut_left_x - DIFFERENCE_CLEARANCE,
                    strut_near_y - DIFFERENCE_CLEARANCE,
                    -rib_height_outside - DIFFERENCE_CLEARANCE
                    ])
                    cube([
                        rack_front_corder_x + DIFFERENCE_CLEARANCE * 2,
                        rack_front_corder_y + DIFFERENCE_CLEARANCE * 2,
                        rib_height_outside + DIFFERENCE_CLEARANCE * 2
                        ]);
            }
            else
            {
                translate([
                    strut_right_x - rack_front_corder_x + rib_width - DIFFERENCE_CLEARANCE,
                    strut_near_y - DIFFERENCE_CLEARANCE,
                    -rib_height_outside - DIFFERENCE_CLEARANCE
                    ])
                    cube([
                        rack_front_corder_x + DIFFERENCE_CLEARANCE * 2,
                        rack_front_corder_y + DIFFERENCE_CLEARANCE * 2,
                        rib_height_outside + DIFFERENCE_CLEARANCE * 2
                        ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module RibStrut( is_left )
{
    // %cube([ rack_top_section_x, rib_width, rib_height_outside ]);

    points = [
        [ rib_width, 0, rib_height_outside ],
        [ rack_top_section_x - rib_width, 0, rib_height_outside ],
        [ rack_top_section_x - rib_width, 0, rib_height_outside - rib_height_inside ],
        [ rib_width, 0, 0 ],
        [ rib_width, rib_width, rib_height_outside ],
        [ rack_top_section_x - rib_width, rib_width, rib_height_outside ],
        [ rack_top_section_x - rib_width, rib_width, rib_height_outside - rib_height_inside ],
        [ rib_width, rib_width, 0 ],
    ];

    // for( point = points )
    // {
    //     #translate( point )
    //         sphere( r = 0.25 );
    // }

    polyhedron(
        points = points,
        faces = [
            [ 0, 1, 2, 3 ],
            [ 7, 6, 5, 4 ],
            [ 0, 3, 7, 4 ],
            [ 0, 4, 5, 1 ],
            [ 1, 5, 6, 2 ],
            [ 2, 6, 7, 3 ],
        ]
    );
}

////////////////////////////////////////////////////////////////////////////////////////////////////
