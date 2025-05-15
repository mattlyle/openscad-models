////////////////////////////////////////////////////////////////////////////////////////////////////

include <../modules/rounded-cube.scad>
include <../modules/cord-clip.scad>
include <../modules/snap-connectors.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

rack_inside_x = 416;
rack_inside_y = 416;

rack_side_bar_x = 56;
rack_offset_back_y = 32;
rack_front_bar_y = 31;
rack_bar_z = 30;

rack_front_offset_z = 4; // the front bar is higher than the side bars

rack_front_corder_x = 7;
rack_front_corder_y = 5;

fan_x = 120.0;
fan_y = 120.0;
fan_top_bottom_z = 4.1;
fan_center_z = 25.3 - fan_top_bottom_z * 2;
fan_screw_hole_offset = 7.5;
fan_screw_hole_r = 5.0 / 2;

fan_wire_r = 3.35 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-section-back-left";
// render_mode = "print-section-back-right";
// render_mode = "print-section-front-left";
// render_mode = "print-section-front-right";
render_mode = "print-snap-connector-test";

rack_top_z = 2.4;

side_bar_overlap_x = rack_side_bar_x * 0.5;

front_overlap_y = rack_front_bar_y * 0.5;
back_overlap_y = 10;

num_ribs = 3;

rib_width = 1.2;
rib_height_outside = 30.0;
rib_height_inside = 16.0;

edge_clearance = 0.2;

snap_connector_width = 10.0;
snap_connector_height = 12.0;
snap_connector_depth = 1.6;
snap_connector_angle_in = 45;
snap_connector_angle_lock = 70;
snap_connector_nose_depth = 2.0;
snap_connector_nose_height = 1.0;
snap_connector_base_radius = 2.0;
snap_connector_offset_percent = 0.2;

snap_connector_test_y = 40;

rack_preview_color = [ 0.2, 0.2, 0.2 ];

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

rack_top_section_x = rack_inside_x / 2 - edge_clearance;
rack_top_section_y = rack_inside_y / 2 - edge_clearance;

fan_location_xy = [
    calculateOffsetToCenter( rack_top_section_x, fan_x ),
    calculateOffsetToCenter( rack_top_section_y, fan_y )
    ];

fan_outside_r = min( fan_x, fan_y ) / 2;
fan_inside_r = fan_outside_r - 1;
fan_core_r = fan_inside_r * 0.3;

fan_full_z = fan_top_bottom_z * 2 + fan_center_z;

fan_frame_width = rib_width;
fan_frame_x = fan_x + fan_frame_width * 2 + edge_clearance * 2;
fan_frame_y = fan_y + fan_frame_width * 2 + edge_clearance * 2;
fan_frame_z = fan_full_z;

cord_clip_inner_r = fan_wire_r + edge_clearance;
cord_clip_wall_thickness = rack_top_z;
cord_clip_length = rack_top_z;
cord_clip_base_width = CalculateCordClipBaseWidth(
    cord_clip_inner_r,
    cord_clip_wall_thickness
    );
cord_clip_base_height = CalculateCordClipBaseHeight(
    cord_clip_inner_r,
    cord_clip_wall_thickness
    );
cord_clip_spacing = fan_x / 4.5;
// cord_clip_support_size = cord_clip_inner_r * 1.2;
cord_clip_support_height = cord_clip_base_width * 1.5;

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
    translate([ -side_bar_overlap_x, rack_top_section_y, 0 ])
        NetworkRackTop( true, true );

    // back right
    translate([ rack_top_section_x, rack_top_section_y, 0 ])
        NetworkRackTop( true, false, fan_location_xy );

    // translate([ 0, -200, 0 ])
    //     FanPreview();

    // snap connector test
    translate([ -100, 0, 0 ])
        SnapConnectorTest( true );
    translate([ -100, 0, 0 ])
        SnapConnectorTest( false );
}
else if( render_mode == "print-section-back-left" )
{
    difference() // TODO: remove!  this cuts out part so it prints faster and uses less filament
    {
        translate([ rack_top_section_x + side_bar_overlap_x, 0, rack_top_z ])
            rotate([ 0, 180, 0 ])
                NetworkRackTop( false, true );

        translate([ -10, 130, 0 ])
            cube([ 160, 120, 40 ]);
    }
}
else if( render_mode == "print-section-back-right" )
{
    translate([ rack_top_section_x + side_bar_overlap_x, 0, 0 ])
        rotate([ 0, 180, 0 ])
            NetworkRackTop( true, false, fan_location_xy );
}
else if( render_mode == "print-section-front-left" )
{
}
else if( render_mode == "print-section-front-right" )
{
}
else if( render_mode == "print-snap-connector-test" )
{
    translate([ -10, snap_connector_test_y, rib_width ])
        rotate([ 0, -90, 0 ])
            SnapConnectorTest( true );

    translate([ 20, snap_connector_test_y, 0 ])
        rotate([ 0, -90, 0 ])
            SnapConnectorTest( false );

    // translate([ 0, -10, 0 ])
    //     SnapConnectorA(
    //         width = snap_connector_width,
    //         height = snap_connector_height,
    //         depth = snap_connector_depth,
    //         angle_in = snap_connector_angle_in,
    //         angle_lock = snap_connector_angle_lock,
    //         nose_depth = snap_connector_nose_depth,
    //         nose_height = snap_connector_nose_height,
    //         base_radius = snap_connector_base_radius
    //         );
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
    color( rack_preview_color )
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

module NetworkRackTop(
    is_back,
    is_left,
    fan_cutout_location_xy = undef,
    usb_hub_cutout_location_xy = undef
    )
{
    section_x = side_bar_overlap_x + rack_top_section_x;
    section_y = !is_back
        ? rack_top_section_y + front_overlap_y
        : rack_top_section_y + back_overlap_y;

    // echo( str( "section_x=", section_x ) );
    // echo( str( "section_y=", section_y ) );
    assert( section_x <= BUILD_PLATE_X, "Too big for build plate (x)" );
    assert( section_y <= BUILD_PLATE_Y, "Too big for build plate (y)" );

    // flat top
    difference()
    {
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

        if( fan_cutout_location_xy )
        {
            // remove the fan cutout from the top
            translate([
                fan_cutout_location_xy.x + fan_x / 2,
                fan_cutout_location_xy.y + fan_y / 2,
                -DIFFERENCE_CLEARANCE
                ])
                cylinder( r = fan_outside_r, h = rack_top_z + DIFFERENCE_CLEARANCE * 2 );

            // cut out for the bottom left screw hole
            translate([
                fan_cutout_location_xy.x + fan_screw_hole_offset,
                fan_cutout_location_xy.y + fan_screw_hole_offset,
                -DIFFERENCE_CLEARANCE
                ])
                cylinder( r = fan_screw_hole_r, h = rack_top_z + DIFFERENCE_CLEARANCE * 2 );

            // cut out for the bottom right screw hole
            translate([
                fan_cutout_location_xy.x + fan_x - fan_screw_hole_offset,
                fan_cutout_location_xy.y + fan_screw_hole_offset,
                -DIFFERENCE_CLEARANCE
                ])
                cylinder( r = fan_screw_hole_r, h = rack_top_z + DIFFERENCE_CLEARANCE * 2 );

            // cut out for the top left screw hole
            translate([
                fan_cutout_location_xy.x + fan_screw_hole_offset,
                fan_cutout_location_xy.y + fan_y - fan_screw_hole_offset,
                -DIFFERENCE_CLEARANCE
                ])
                cylinder( r = fan_screw_hole_r, h = rack_top_z + DIFFERENCE_CLEARANCE * 2 );

            // cut out for the top right screw hole
            translate([
                fan_cutout_location_xy.x + fan_x - fan_screw_hole_offset,
                fan_cutout_location_xy.y + fan_y - fan_screw_hole_offset,
                -DIFFERENCE_CLEARANCE
                ])
                cylinder( r = fan_screw_hole_r, h = rack_top_z + DIFFERENCE_CLEARANCE * 2 );
        }
    }

    strut_left_x = is_left
        ? side_bar_overlap_x
        : 0;
    strut_right_x = is_left
        ? section_x - rib_width
        : section_x - side_bar_overlap_x - rib_width;

    strut_near_y = is_back
        ? 0
        : front_overlap_y;
    strut_far_y = is_back
        ? section_y - rib_width - back_overlap_y
        : section_y - rib_width;

    strut_left_z = is_left
        ? rib_height_outside
        : rib_height_inside;
    strut_right_z = !is_left
        ? rib_height_outside
        : rib_height_inside;

    // under the overhang
    translate([
        is_left ? 0 : section_x - side_bar_overlap_x,
        is_back ? 0 : front_overlap_y,
        -rack_front_offset_z + edge_clearance
        ])
        cube([
            side_bar_overlap_x,
            rack_top_section_y,
            rack_front_offset_z
            ]);

    // fan cutout
    if( fan_cutout_location_xy )
    {
        // translate([ fan_cutout_location_xy.x, fan_cutout_location_xy.y, -50 ])
        //     FanPreview();
        // # translate([
        //     fan_cutout_location_xy.x,
        //     fan_cutout_location_xy.y,
        //     -fan_full_z
        //     ])
        //     cube([ fan_x, fan_y, fan_full_z ]);

        // frame bottom
        translate([
            fan_cutout_location_xy.x - fan_frame_width - edge_clearance,
            fan_cutout_location_xy.y - fan_frame_width - edge_clearance,
            -fan_frame_z
            ])
            cube([ fan_frame_x, fan_frame_width, fan_frame_z ]);

        // frame top
        translate([
            fan_cutout_location_xy.x - fan_frame_width - edge_clearance,
            fan_cutout_location_xy.y + fan_y + edge_clearance,
            -fan_frame_z
            ])
            cube([ fan_frame_x, fan_frame_width, fan_frame_z ]);

        // frame left
        translate([
            fan_cutout_location_xy.x - fan_frame_width - edge_clearance,
            fan_cutout_location_xy.y - fan_frame_width - edge_clearance,
            -fan_frame_z
            ])
            cube([ fan_frame_width, fan_frame_y, fan_frame_z ]);

        // frame right
        translate([
            fan_cutout_location_xy.x + fan_x + edge_clearance,
            fan_cutout_location_xy.y - fan_frame_width - edge_clearance,
            -fan_frame_z
            ])
            cube([ fan_frame_width, fan_frame_y, fan_frame_z ]);

        for( i = [ 0 : 3 ] )
        {
            translate([
                fan_cutout_location_xy.x + fan_x / 2,
                fan_cutout_location_xy.y + fan_y / 2,
                -fan_frame_z
                ])
                rotate([ 0, 0, i * 90 ])
                {
                    // #translate([
                    //     -fan_x / 2 - edge_clearance,
                    //     fan_y / 2 + edge_clearance,
                    //     -0.25
                    //     ])
                    //     cube([ fan_x + edge_clearance * 2, fan_frame_width, 0.25 ]);

                    translate([
                        -cord_clip_spacing,
                        fan_y / 2 + edge_clearance + fan_frame_width + cord_clip_base_width / 2,
                        cord_clip_base_height
                        ])
                        rotate([ 180, 0, 90 ])
                            CordClipAndBase();

                    translate([
                        cord_clip_spacing,
                        fan_y / 2 + edge_clearance + fan_frame_width + cord_clip_base_width / 2,
                        cord_clip_base_height
                        ])
                        rotate([ 180, 0, 90 ])
                            CordClipAndBase();
                }
        }
    }

    snap_offset_bottom_y = rack_top_section_y * snap_connector_offset_percent;
    snap_offset_top_y = rack_top_section_y * ( 1.0 - snap_connector_offset_percent );

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

            if( is_left )
            {
                // bottom connector
                translate([ strut_right_x + rib_width, snap_offset_bottom_y, 0 ])
                    TopConnectorM();

                // top connector
                translate([ strut_right_x + rib_width, snap_offset_top_y, 0 ])
                    TopConnectorM();
            }

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

        if( fan_cutout_location_xy )
        {
            fan_cutout_z = rib_height_outside + DIFFERENCE_CLEARANCE;

            // remove the fan cutout from the ribs
            translate([
                fan_cutout_location_xy.x - edge_clearance - DIFFERENCE_CLEARANCE,
                fan_cutout_location_xy.y - edge_clearance - DIFFERENCE_CLEARANCE,
                -fan_cutout_z + DIFFERENCE_CLEARANCE
                ])
                cube([
                    fan_x + edge_clearance * 2 + DIFFERENCE_CLEARANCE * 2,
                    fan_y + edge_clearance * 2 + DIFFERENCE_CLEARANCE * 2,
                    fan_cutout_z
                    ]);
        }

        // remove the snap connector cutouts
        if( !is_left  )
        {
            TopConnectorCutoutF();
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module RibStrut( is_left )
{
    // %cube([ rack_top_section_x, rib_width, rib_height_outside ]);

    left_z = is_left
        ? rib_height_outside - rib_height_inside
        : 0;
    right_z = is_left
        ? 0
        : rib_height_outside - rib_height_inside;

    points = [
        [ rib_width, 0, rib_height_outside ],
        [ rack_top_section_x - rib_width, 0, rib_height_outside ],
        [ rack_top_section_x - rib_width, 0, left_z ],
        [ rib_width, 0, right_z ],
        [ rib_width, rib_width, rib_height_outside ],
        [ rack_top_section_x - rib_width, rib_width, rib_height_outside ],
        [ rack_top_section_x - rib_width, rib_width, rib_height_outside - rib_height_inside ],
        [ rib_width, rib_width, right_z ],
    ];

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

module TopConnectorM( is_reversed )
{
    rotation = is_reversed
        ? [ 0, 90, 0 ]
        : [ 0, -90, 180 ];
    translation = is_reversed
        ? [ 0, -snap_connector_depth, snap_connector_width ]
        : [ 0, snap_connector_depth, 0 ];

    translate( translation )
        rotate( rotation )
            SnapConnectorA(
                width = snap_connector_width,
                height = snap_connector_height + edge_clearance,
                depth = snap_connector_depth,
                angle_in = snap_connector_angle_in,
                angle_lock = snap_connector_angle_lock,
                nose_depth = snap_connector_nose_depth,
                nose_height = snap_connector_nose_height,
                base_radius = snap_connector_base_radius
                );
}

module TopConnectorCutoutF( is_reversed )
{
    // snap_connector_full_height = snap_connector_height
    //     + CalculateSnapConnectorHeightM(
    //         height = snap_connector_height,
    //         nose_depth = snap_connector_nose_depth,
    //         nose_height = snap_connector_nose_height,
    //         angle_in = snap_connector_angle_in,
    //         angle_lock = snap_connector_angle_lock
    //         );

    y_offset = is_reversed
        ? -snap_connector_depth - snap_connector_nose_depth
        : 0;

    // translate([ -DIFFERENCE_CLEARANCE, y_offset, -edge_clearance ])
    //     cube([
    //         snap_connector_full_height + edge_clearance + DIFFERENCE_CLEARANCE * 2,
    //         snap_connector_depth + snap_connector_nose_depth + edge_clearance * 2,
    //         snap_connector_width + edge_clearance * 2
    //         ]);

    translate([ 0, y_offset, 0 ])
        SnapConnectorCutout(
            width = snap_connector_width,
            height = snap_connector_height,
            clearance = edge_clearance,
            depth = snap_connector_depth,
            angle_in = snap_connector_angle_in,
            angle_lock = snap_connector_angle_lock,
            nose_depth = snap_connector_nose_depth,
            nose_height = snap_connector_nose_height,
            base_radius = snap_connector_base_radius
            );
}

module TopConnectorBraceF( is_reversed )
{
    translation = is_reversed
        ? [ 0, 0, snap_connector_width ]
        : [ 0, 0, 0 ];
    rotation = is_reversed
        ? [ 180, 0, 0 ]
        : [ 0, 0, 0 ];

    left_x = 0;
    right_x = snap_connector_height - rib_width - edge_clearance;

    near_y = -edge_clearance - snap_connector_nose_depth - snap_connector_depth;
    mid_y = -edge_clearance - snap_connector_nose_depth;
    far_y = -edge_clearance;

    bottom_z = -edge_clearance;
    top_z = snap_connector_width + edge_clearance;

    points = [
        [ right_x, far_y, top_z ], // 0
        [ right_x, mid_y, top_z ], // 1
        [ left_x, near_y, top_z ], // 2
        [ left_x, far_y, top_z ], // 3
        [ right_x, far_y, bottom_z ], // 4
        [ right_x, mid_y, bottom_z ], // 5
        [ left_x, near_y, bottom_z ], // 6
        [ left_x, far_y, bottom_z ], // 7
        ];

    // translate( translation )
    //     rotate( rotation )
    //         for( point = points )
    //             # translate( point )
    //                 sphere( 0.2 );

    translate( translation )
        rotate( rotation )
            polyhedron(
                points = points,
                faces = [
                    [ 0, 1, 2, 3 ],
                    [ 4, 7, 6, 5 ],
                    [ 0, 4, 5, 1 ],
                    [ 1, 5, 6, 2 ],
                    [ 2, 6, 7, 3 ],
                    [ 0, 3, 7, 4 ],
                    ]
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module CordClipAndBase()
{
    CordClip(
        cord_clip_inner_r,
        cord_clip_wall_thickness,
        cord_clip_length,
        show_preview = $preview,
        );

    points = [
        [ -cord_clip_base_width / 2, 0, 0 ],
        [ cord_clip_base_width / 2, 0, 0 ],
        [ -cord_clip_base_width / 2, -cord_clip_length, -cord_clip_support_height ],
        [ -cord_clip_base_width / 2, cord_clip_length, 0 ],
        [ cord_clip_base_width / 2, cord_clip_length, 0 ],
        [ -cord_clip_base_width / 2, 2 * cord_clip_length, -cord_clip_support_height ],
        ];

    polyhedron(
        points = points,
        faces = [
            [ 0, 1, 2 ],
            [ 3, 5, 4 ],
            [ 1, 4, 5, 2 ],
            [ 0, 2, 5, 3 ],
            [ 0, 3, 4, 1 ]
            ]
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module FanPreview()
{
    num_fan_blades = 7;

    // bottom
    difference()
    {
        cube([ fan_x, fan_y, fan_top_bottom_z ]);

        translate([ fan_x / 2, fan_y / 2, -DIFFERENCE_CLEARANCE ])
            cylinder( r = fan_inside_r, h = fan_top_bottom_z + DIFFERENCE_CLEARANCE * 2 );
    }

    // center
    difference()
    {
        translate([ fan_x / 2, fan_y / 2, fan_top_bottom_z ])
            cylinder( r = fan_outside_r, h = fan_center_z );

        translate([ fan_x / 2, fan_y / 2, fan_top_bottom_z - DIFFERENCE_CLEARANCE])
            cylinder( r = fan_inside_r, h = fan_center_z + DIFFERENCE_CLEARANCE * 2 );
    }

    // top
    difference()
    {
        section_z = fan_top_bottom_z + fan_center_z;

        translate([ 0, 0, section_z ])
            cube([ fan_x, fan_y, fan_top_bottom_z ]);

        translate([ fan_x / 2, fan_y / 2, section_z - DIFFERENCE_CLEARANCE ])
            cylinder( r = fan_inside_r, h = fan_top_bottom_z + DIFFERENCE_CLEARANCE * 2 );

        // bottom left screw hole
        translate([
            fan_screw_hole_offset,
            fan_screw_hole_offset,
            section_z - DIFFERENCE_CLEARANCE
            ])
            cylinder( r = fan_screw_hole_r, h = fan_top_bottom_z + DIFFERENCE_CLEARANCE * 2 );

        // bottom right screw hole
        translate([
            fan_x - fan_screw_hole_offset,
            fan_screw_hole_offset,
            section_z - DIFFERENCE_CLEARANCE
            ])
            cylinder( r = fan_screw_hole_r, h = fan_top_bottom_z + DIFFERENCE_CLEARANCE * 2 );

        // top left screw hole
        translate([
            fan_screw_hole_offset,
            fan_y - fan_screw_hole_offset,
            section_z - DIFFERENCE_CLEARANCE
            ])
            cylinder( r = fan_screw_hole_r, h = fan_top_bottom_z + DIFFERENCE_CLEARANCE * 2 );

        // top right screw hole
        translate([
            fan_x - fan_screw_hole_offset,
            fan_y - fan_screw_hole_offset,
            section_z - DIFFERENCE_CLEARANCE
            ])
            cylinder( r = fan_screw_hole_r, h = fan_top_bottom_z + DIFFERENCE_CLEARANCE * 2 );
    }

    translate([ fan_x / 2, fan_y / 2, -DIFFERENCE_CLEARANCE ])
        cylinder( r = fan_core_r, h = fan_full_z );

    for( i = [ 0 : num_fan_blades - 1 ] )
    {
        angle = i * 360 / num_fan_blades;

        translate([ fan_x / 2 - DIFFERENCE_CLEARANCE, fan_y / 2, -DIFFERENCE_CLEARANCE + fan_full_z * 0.05 ])
            rotate([ -30, 0, angle ])
                cube([ fan_x * 0.47, 1, fan_full_z * 0.9 ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module SnapConnectorTest( is_m )
{ 
    test_top_y = snap_connector_test_y * 0.85;
    test_bottom_y = snap_connector_test_y * 0.15;
    test_z_extra = 6;
    test_z = snap_connector_width + test_z_extra * 2 + edge_clearance * 2;

    if( is_m )
    {
        // plate
        translate([ -rib_width, -snap_connector_test_y, 0 ])
            cube([ rib_width, snap_connector_test_y, test_z ]);
        
        // bottom
        translate([ 0, -snap_connector_test_y + test_bottom_y, test_z_extra + edge_clearance ])
            TopConnectorM( false );
        
        // top
        translate([ 0, -snap_connector_test_y + test_top_y, test_z_extra + edge_clearance ])
            TopConnectorM( true );
    }
    else
    {
        difference()
        {
            // plate
            translate([ 0, -snap_connector_test_y, 0 ])
                cube([ rib_width, snap_connector_test_y, test_z ]);

            // bottom
            translate([ 0, -snap_connector_test_y + test_bottom_y, test_z_extra + edge_clearance ])
                TopConnectorCutoutF( false );

            // top
            translate([ 0, -snap_connector_test_y + test_top_y, test_z_extra + edge_clearance ])
                TopConnectorCutoutF( true );
        }

        translate([ rib_width, -snap_connector_test_y + test_bottom_y, test_z_extra + edge_clearance ])
            TopConnectorBraceF( false );

        translate([ rib_width, -snap_connector_test_y + test_top_y, test_z_extra + edge_clearance ])
            TopConnectorBraceF( true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
