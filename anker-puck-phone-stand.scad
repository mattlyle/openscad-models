include <modules/utils.scad>
include <modules/rounded-cube.scad>
include <modules/rounded-cylinder.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

anker_puck_front_r = 58 / 2;
anker_puck_body_r = 60.1 / 2;
anker_puck_front_z = 0.5;
anker_puck_body_z = 10.2;
anker_puck_cord_strain_relief_r = 5.4 / 2;
anker_puck_cord_strain_relief_length = 12;
anker_puck_cord_r = 3.5 / 2;

phone_x = 75;
phone_y = 156.5;
phone_z = 13;
phone_camera_bump_x = 70.5;
phone_camera_bump_y = 29.5;
phone_camera_bump_z = 2.0;
phone_camera_bump_offset_y = 13;
phone_rounding_r = 10;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-base";
// render_mode = "print-holder";

// the version is engraved on the back of the holder, left of the cord slot and below the puck
// opening
phone_case_holder_version_offset_x = 16;
phone_case_holder_version_offset_y = 43;

// the version is engraved on the front of the base core, this far down from its top edge
base_core_version_offset_y = 15;

anker_puck_cord_preview_length = 30;

// this is mainly because my google pixel 11 has the camera bump, so the phone case holder needs to be a bit higher
// than the puck
phone_case_holder_above = 4;

phone_case_holder_below = 30;
phone_case_holder_sides = 4;
phone_case_holder_thickness_front = 1.4;
phone_case_holder_thickness_back = 2;
phone_case_holder_corner_r = 10;
phone_case_holder_back_rounding_r = 3.0;
phone_case_holder_flange_width = 0.8;
phone_case_holder_flange_clearance_z = 0.1;

// the radius of the curve that lifts the cord out of the holder, as a multiple of how deep the cord
// sits
phone_case_holder_cord_curve_r_scale = 2;

// how far above the puck's cord the holder's cord channel sits, so the channel prints cleanly
phone_case_holder_cord_offset_z = 1.0;

// height the holder off the floor
phone_case_holder_z = 100;

phone_case_holder_angle = 15;

base_core_extra_x = 10;
base_core_extra_y = 20;
base_core_cord_r = 12.1 / 2;
base_core_cord_cutout_angle = 60;
base_core_cord_cutout_offset_z = 10;
base_core_cord_clearance = 0.15;

holder_base_interface_clearance = 0.2;

base_plate_x = 130;
base_plate_y = 120;
base_plate_offset_y = 10;
base_plate_z = 2;
base_plate_rounding_r = 10;

version_label_font = "Liberation Sans:style=Bold";
version_label_font_size = 6;
version_label_depth = 0.4;

// space between the parts in the print previews
print_preview_gap = 20;

// THIS IS AUTO UPDATED BY THE BUILD SCRIPT - DO NOT EDIT
BUILD_SCRIPT_VERSION = "v4";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

base_plate_top_rounding_r = base_plate_z / 2;

phone_case_holder_thickness_z =
    phone_case_holder_thickness_front
    + anker_puck_front_z
    + anker_puck_body_z
    + phone_case_holder_thickness_back;
echo( str( "Holder (TPU) thickness:", phone_case_holder_thickness_z ) );

// the corners of the puck's bounding square on the holder's back face, found by tilting a point
// on the back face about the puck center the same way the holder is tilted
base_core_back_top_y =
    anker_puck_body_r * sin( phone_case_holder_angle )
    + phone_case_holder_thickness_z * cos( phone_case_holder_angle );
base_core_back_top_z =
    phone_case_holder_z
    + anker_puck_body_r * cos( phone_case_holder_angle )
    - phone_case_holder_thickness_z * sin( phone_case_holder_angle );

// follow the back face down to where it meets the floor; it leans back by the holder angle, so
// it moves tan( angle ) in y for every 1 in z
base_core_back_bottom_y =
    base_core_back_top_y
    - base_core_back_top_z * tan( phone_case_holder_angle );

base_core_points = [
    // upper left, looking from the back
    [ anker_puck_body_r, base_core_back_top_y, base_core_back_top_z ],
    // upper right, looking from the back
    [ -anker_puck_body_r, base_core_back_top_y, base_core_back_top_z ],
    
    // lower left, looking from the back
    [ anker_puck_body_r, base_core_back_bottom_y, 0 ],
    // lower right, looking from the back
    [ -anker_puck_body_r, base_core_back_bottom_y, 0 ],
    
    // floor left, directly below the upper left
    [ anker_puck_body_r + base_core_extra_x, base_core_back_top_y + base_core_extra_y, 0 ],
    // floor right, directly below the upper right
    [ -anker_puck_body_r - base_core_extra_x, base_core_back_top_y + base_core_extra_y, 0 ],
    ];

// the angle the base core's rear face makes with the holder's back face, where they meet at the top
base_core_rear_angle =
    phone_case_holder_angle
    + atan( base_core_extra_y / base_core_back_top_z );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the unit normal of a face of a convex shape, pointing out of the shape
function _FaceNormal( point_list, face, center ) =
    let( normal = cross(
        point_list[ face[ 1 ] ] - point_list[ face[ 0 ] ],
        point_list[ face[ 2 ] ] - point_list[ face[ 0 ] ]
        ) )
    let( unit_normal = normal / norm( normal ) )
    unit_normal * ( point_list[ face[ 0 ] ] - center ) < 0 ? -unit_normal : unit_normal;

// where a corner of a convex shape ends up when all of its faces move inward by the clearance; the
// corner must be shared by exactly three faces, and it is where those three moved faces meet
function _InsetCorner( corner_index, point_list, face_list, clearance ) =
    let( center = [
        SumList( GetListAtIndex( point_list, 0 ) ),
        SumList( GetListAtIndex( point_list, 1 ) ),
        SumList( GetListAtIndex( point_list, 2 ) )
        ] / len( point_list ) )
    let( corner_face_list = [
        for( face = face_list )
            if( search( corner_index, face ) != [] )
                face
        ] )
    assert( len( corner_face_list ) == 3, "every corner must be shared by exactly three faces" )
    let( n1 = _FaceNormal( point_list, corner_face_list[ 0 ], center ) )
    let( n2 = _FaceNormal( point_list, corner_face_list[ 1 ], center ) )
    let( n3 = _FaceNormal( point_list, corner_face_list[ 2 ], center ) )
    let( d1 = n1 * point_list[ corner_index ] - clearance )
    let( d2 = n2 * point_list[ corner_index ] - clearance )
    let( d3 = n3 * point_list[ corner_index ] - clearance )
    ( d1 * cross( n2, n3 ) + d2 * cross( n3, n1 ) + d3 * cross( n1, n2 ) )
        / ( n1 * cross( n2, n3 ) );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // color( [ 0.1, 0.1, 0.1 ] )
    //     AnkerPuckPreview();

    translate([
        0,
        0,
        phone_case_holder_z
        ])
        rotate([
            -90 - phone_case_holder_angle,
            0,
            0
            ])
        {
            PhoneCaseHolder();

            // the phone's back lies on the holder's front face, with the camera bump ending at the
            // holder's top edge
            translate([
                -phone_x / 2,
                -anker_puck_body_r
                    - phone_case_holder_above
                    - phone_camera_bump_y
                    - phone_camera_bump_offset_y,
                -phone_z
                ])
                PhonePreview();
        }

    % PhoneCaseBase();

    translate([ 200, 0, 0 ])
        PhoneCaseBase();

    translate([ 350, 0, 0 ])
        PhoneCaseHolder();
}
else if( render_mode == "print-base" )
{
    PhoneCaseBase();
}
else if( render_mode == "print-holder" )
{
    PhoneCaseHolder();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PhoneCaseHolder()
{
    offset_left_x = anker_puck_body_r - phone_case_holder_corner_r + phone_case_holder_sides;
    offset_right_x = -anker_puck_body_r + phone_case_holder_corner_r - phone_case_holder_sides;

    offset_top_y = -anker_puck_body_r + phone_case_holder_corner_r - phone_case_holder_above;
    offset_bottom_y = anker_puck_body_r - phone_case_holder_corner_r + phone_case_holder_below;

    holder_bottom_y = anker_puck_body_r + phone_case_holder_below;

    holder_x = anker_puck_body_r * 2
        + phone_case_holder_sides * 2;
    holder_y = anker_puck_body_r * 2
        + phone_case_holder_above
        + phone_case_holder_below;

    flange_start_z =
        anker_puck_front_z
        + anker_puck_body_z
        + phone_case_holder_flange_clearance_z;

    cord_z = ( anker_puck_front_z + anker_puck_body_z ) / 2 + phone_case_holder_cord_offset_z;

    // the cord runs straight for the length of the strain relief, then curves up out of the back;
    // the curve is a quarter circle whose center is above the cord, and the cutout is done once the
    // outside edge of the cord's channel comes up through the back
    cord_depth_z = phone_case_holder_thickness_z - cord_z;
    cord_curve_r = cord_depth_z * phone_case_holder_cord_curve_r_scale;
    cord_curve_outer_r = cord_curve_r + anker_puck_cord_strain_relief_r;
    cord_curve_start_y = anker_puck_body_r + anker_puck_cord_strain_relief_length;
    cord_curve_end_y =
        cord_curve_start_y
        + cord_curve_outer_r * sin( acos( ( cord_curve_r - cord_depth_z ) / cord_curve_outer_r ) );
    echo( str( "Holder (TPU) wall below the cord cutout:", holder_bottom_y - cord_curve_end_y ) );

    difference()
    {
        hull()
        {
            // top left
            translate([
                offset_left_x,
                offset_top_y,
                0
                ])
                cylinder(
                    r = phone_case_holder_corner_r,
                    h = phone_case_holder_thickness_z
                    );

            // top right
            translate([
                offset_right_x,
                offset_top_y,
                0
                ])
                cylinder(
                    r = phone_case_holder_corner_r,
                    h = phone_case_holder_thickness_z
                    );

            // bottom left
            translate([
                offset_left_x,
                offset_bottom_y,
                0
                ])
                cylinder(
                    r = phone_case_holder_corner_r,
                    h = phone_case_holder_thickness_z
                    );

            // bottom right
            translate([
                offset_right_x,
                offset_bottom_y,
                0
                ])
                cylinder(
                    r = phone_case_holder_corner_r,
                    h = phone_case_holder_thickness_z
                    );
        }

        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
        {
            // the puck, without the part of the cord that carries on past where the curve starts
            intersection()
            {
                AnkerPuckPreview();

                translate([
                    -holder_x / 2,
                    -holder_y,
                    -phone_case_holder_thickness_z
                    ])
                    cube([
                        holder_x,
                        holder_y + cord_curve_start_y - DIFFERENCE_CLEARANCE,
                        phone_case_holder_thickness_z * 3
                        ]);
            }

            // open the back above the puck body, up to the flange
            translate([ 0, 0, anker_puck_front_z + anker_puck_body_z - DIFFERENCE_CLEARANCE ])
                cylinder(
                    h = phone_case_holder_flange_clearance_z + DIFFERENCE_CLEARANCE,
                    r = anker_puck_body_r
                    );

            // the flange is what is left around this smaller opening, all the way to the back of
            // the holder, and the puck has to be pushed through it
            translate([ 0, 0, flange_start_z - DIFFERENCE_CLEARANCE ])
                cylinder(
                    h = phone_case_holder_thickness_z,
                    r = anker_puck_body_r - phone_case_holder_flange_width
                    );

            // open the back above the cord, at the full strain relief thickness the whole way out
            translate([ 0, 0, cord_z ])
                rotate([ -90, 0, 0 ])
                    cylinder(
                        h = cord_curve_start_y + DIFFERENCE_CLEARANCE,
                        r = anker_puck_cord_strain_relief_r
                        );

            translate([ -anker_puck_cord_strain_relief_r, 0, cord_z ])
                cube([
                    anker_puck_cord_strain_relief_r * 2,
                    cord_curve_start_y + DIFFERENCE_CLEARANCE,
                    phone_case_holder_thickness_z
                    ]);

            // the cord curving up out of the back: the cord's channel and everything above it,
            // swept around the center of the curve, which is above the cord
            translate([ 0, cord_curve_start_y, cord_z + cord_curve_r ])
                rotate([ 0, 90, 0 ])
                    rotate_extrude( angle = 90 )
                    {
                        translate([ cord_curve_r, 0 ])
                            circle( r = anker_puck_cord_strain_relief_r );

                        translate([ 0, -anker_puck_cord_strain_relief_r ])
                            square([ cord_curve_r, anker_puck_cord_strain_relief_r * 2 ]);
                    }
        }

        // the version, engraved into the back of the holder; it reads from above like the holder is
        // when it is looked at from behind, with the cord slot at the bottom
        translate([
            phone_case_holder_version_offset_x,
            phone_case_holder_version_offset_y,
            phone_case_holder_thickness_z - version_label_depth
            ])
            rotate([ 0, 0, 180 ])
                TextLabel(
                    BUILD_SCRIPT_VERSION,
                    depth = version_label_depth + DIFFERENCE_CLEARANCE,
                    font_size = version_label_font_size,
                    font = version_label_font,
                    color = undef,
                    halign = "center",
                    valign = "center"
                    );
    }

    // where the base core's rear face is above the bottom corners; it starts at the base core's top
    // edge, which is the puck's radius back from the puck center, and rises at the rear angle
    base_core_interface_rear_z =
        phone_case_holder_thickness_z
        + ( offset_bottom_y + anker_puck_body_r ) * tan( base_core_rear_angle );

    // the base core's side edges slant outward as they go down its rear face, so use the points'
    // height in the preview to see how far down the rear face they are, and how far out its edge is
    base_core_interface_rear_preview_z =
        phone_case_holder_z
        - offset_bottom_y * cos( phone_case_holder_angle )
        - base_core_interface_rear_z * sin( phone_case_holder_angle );
    base_core_interface_rear_x =
        anker_puck_body_r
        + base_core_extra_x
            * ( base_core_back_top_z - base_core_interface_rear_preview_z )
            / base_core_back_top_z;

    base_core_interface_points = [
        [ offset_right_x, offset_top_y, phone_case_holder_thickness_z ],
        [ offset_left_x, offset_top_y, phone_case_holder_thickness_z ],
        [ offset_right_x, offset_bottom_y, phone_case_holder_thickness_z ],
        [ offset_left_x, offset_bottom_y, phone_case_holder_thickness_z ],
        [ -base_core_interface_rear_x, offset_bottom_y, base_core_interface_rear_z ],
        [ base_core_interface_rear_x, offset_bottom_y, base_core_interface_rear_z ],
        ];

    difference()
    {
        hull()
        {
            // 4 points along the back of the holder
            translate( base_core_interface_points[ 0 ] )
                sphere( r = phone_case_holder_corner_r );
            translate( base_core_interface_points[ 1 ] )
                sphere( r = phone_case_holder_corner_r );
            translate( base_core_interface_points[ 2 ] )
                sphere( r = phone_case_holder_corner_r );
            translate( base_core_interface_points[ 3 ] )
                sphere( r = phone_case_holder_corner_r );

            translate( base_core_interface_points[ 4 ] )
                sphere( r = phone_case_holder_back_rounding_r );
            translate( base_core_interface_points[ 5 ] )
                sphere( r = phone_case_holder_back_rounding_r );
        }

        // remove the bottom where it overlaps the main holder
        translate([
            offset_right_x - phone_case_holder_corner_r - DIFFERENCE_CLEARANCE,
            offset_top_y - phone_case_holder_corner_r - DIFFERENCE_CLEARANCE,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                holder_x + DIFFERENCE_CLEARANCE * 2,
                holder_y + DIFFERENCE_CLEARANCE * 2,
                phone_case_holder_thickness_z
                ]);

        // remove the holder core, moved down so its front face is not in the same plane as the
        // holder's back face
        translate([ 0, 0, -DIFFERENCE_CLEARANCE * 2 ])
            rotate([
                90 + phone_case_holder_angle,
                0,
                0
                ])
                translate([
                    0,
                    0,
                    -phone_case_holder_z
                    ])
                    _PhoneCaseBaseCore( for_difference = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PhoneCaseBase()
{
    // base core
    _PhoneCaseBaseCore();

    // base plate, with the corners at base_plate_rounding_r and the top edge at its own radius
    base_plate_corner_x = base_plate_x / 2 - base_plate_rounding_r;
    base_plate_corner_front_y = -base_plate_y / 2 + base_plate_offset_y + base_plate_rounding_r;
    base_plate_corner_back_y = base_plate_y / 2 + base_plate_offset_y - base_plate_rounding_r;

    hull()
    {
        for(
            x = [ -base_plate_corner_x, base_plate_corner_x ],
            y = [ base_plate_corner_front_y, base_plate_corner_back_y ]
            )
        {
            translate([ x, y, 0 ])
                RoundedCylinder(
                    h = base_plate_z,
                    r = base_plate_rounding_r,
                    rounding_r = base_plate_top_rounding_r,
                    round_top = true,
                    round_bottom = false
                    );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the core as it prints: every face moved inward by the holder interface clearance, and a channel
// for the cord; for_difference gives the full-size solid core for cutting out of the holder instead
module _PhoneCaseBaseCore( for_difference = false )
{
    clearance = for_difference
        ? 0
        : holder_base_interface_clearance;

    base_core_faces = [
        [ 0, 4, 2 ],
        [ 1, 3, 5 ],
        [ 0, 1, 5, 4 ],
        [ 2, 4, 5, 3 ],
        [ 0, 2, 3, 1 ],
        ];

    inset_point_list = [
        for( i = [ 0 : len( base_core_points ) - 1 ] )
            _InsetCorner( i, base_core_points, base_core_faces, clearance )
        ];

    difference()
    {
        polyhedron( points = inset_point_list, faces = base_core_faces );

        if( !for_difference )
        {
            translate([
                0,
                base_plate_y / 2 + base_plate_offset_y,
                base_core_cord_cutout_offset_z
                ])
                rotate([
                    base_core_cord_cutout_angle,
                    0,
                    0
                    ])
                    cylinder(
                        r = base_core_cord_r + base_core_cord_clearance,
                        h = base_plate_y
                        );

            // the version, engraved into the front face of the core, near its top edge; the face
            // leans back by the holder angle, so tip the text onto it
            translate( ( inset_point_list[ 0 ] + inset_point_list[ 1 ] ) / 2 )
                rotate([ 90 - phone_case_holder_angle, 0, 0 ])
                    translate([ 0, -base_core_version_offset_y, -version_label_depth ])
                        TextLabel(
                            BUILD_SCRIPT_VERSION,
                            depth = version_label_depth + DIFFERENCE_CLEARANCE,
                            font_size = version_label_font_size,
                            font = version_label_font,
                            color = undef,
                            halign = "center",
                            valign = "center"
                            );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AnkerPuckPreview()
{
    // puck front
    cylinder(
        h = anker_puck_front_z,
        r = anker_puck_front_r
        );

    // puck body
    translate([
        0,
        0,
        anker_puck_front_z - DIFFERENCE_CLEARANCE
        ])
        cylinder(
            h = anker_puck_body_z + DIFFERENCE_CLEARANCE,
            r = anker_puck_body_r
            );

    // cord strain relief
    translate([
        0,
        anker_puck_body_r + anker_puck_cord_strain_relief_length,
        ( anker_puck_front_z + anker_puck_body_z ) / 2
        ])
        rotate([
            90,
            0,
            0
            ])
            cylinder(
                h = anker_puck_cord_strain_relief_length + anker_puck_cord_strain_relief_r,
                r = anker_puck_cord_strain_relief_r
                );
    
    // cord
    translate([
        0,
        anker_puck_body_r
            + anker_puck_cord_strain_relief_length
            + anker_puck_cord_preview_length,
        ( anker_puck_front_z + anker_puck_body_z ) / 2
        ])
        rotate([
            90,
            0,
            0
            ])
            cylinder(
                h = anker_puck_cord_preview_length,
                r = anker_puck_cord_r
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PhonePreview()
{
    RoundedCube(
        phone_x,
        phone_y,
        phone_z,
        r = phone_rounding_r,
        round_top = false,
        round_bottom = false,
        );

    translate([
        ( phone_x - phone_camera_bump_x ) / 2,
        phone_camera_bump_offset_y,
        phone_z - DIFFERENCE_CLEARANCE
        ])
        RoundedCube(
            phone_camera_bump_x,
            phone_camera_bump_y,
            phone_camera_bump_z,
            r = phone_camera_bump_y / 2,
            round_top = false,
            round_bottom = false,
            )
            translate([ 0, phone_camera_bump_offset_y, 0 ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
