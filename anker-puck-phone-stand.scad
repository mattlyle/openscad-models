include <modules/utils.scad>
include <modules/rounded-cube.scad>

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
// render_mode = "print";

anker_puck_cord_preview_length = 30;

// this is mainly because my google pixel 11 has the camera bump, so the phone case holder needs to be a bit higher
// than the puck
phone_case_holder_above = 4;

phone_case_holder_below = 30;
phone_case_holder_sides = 4;
phone_case_holder_thickness_front = 1.4;
phone_case_holder_thickness_back = 2;
phone_case_holder_corner_r = 10;

// height the holder off the floor
phone_case_holder_z = 100;

phone_case_holder_angle = 15;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

phone_case_holder_thickness_z =
    phone_case_holder_thickness_front
    + anker_puck_front_z
    + anker_puck_body_z
    + phone_case_holder_thickness_back;
echo( str( "Holder (TPU) thickness:", phone_case_holder_thickness_z ) );

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

    %PhoneCaseBase();
}
else if( render_mode == "print" )
{
    MyModel();
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

    cord_z = ( anker_puck_front_z + anker_puck_body_z ) / 2;

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
            AnkerPuckPreview();

            // open the back above the puck body
            translate([ 0, 0, anker_puck_front_z + anker_puck_body_z - DIFFERENCE_CLEARANCE ])
                cylinder(
                    h = phone_case_holder_thickness_z,
                    r = anker_puck_body_r
                    );

            // open the back above the cord, at the full strain relief thickness the whole way out
            translate([ 0, 0, cord_z ])
                rotate([ -90, 0, 0 ])
                    cylinder(
                        h = holder_bottom_y + DIFFERENCE_CLEARANCE,
                        r = anker_puck_cord_strain_relief_r
                        );

            translate([ -anker_puck_cord_strain_relief_r, 0, cord_z ])
                cube([
                    anker_puck_cord_strain_relief_r * 2,
                    holder_bottom_y + DIFFERENCE_CLEARANCE,
                    phone_case_holder_thickness_z
                    ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PhoneCaseBase()
{
    base_core_extra_x = 10;
    base_core_extra_y = 20;

    base_plate_x = 130;
    base_plate_y = 120;
    base_plate_offset_y = 10;
    base_plate_z = 2;
    base_plate_rounding_r = 10;

    // base core

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

    // for( point = base_core_points )
    //     # translate( point )
    //         sphere( r = 1 );

    base_core_faces = [
        [ 0, 4, 2 ],
        [ 1, 3, 5 ],
        [ 0, 1, 5, 4 ],
        [ 2, 4, 5, 3 ],
        [ 0, 2, 3, 1 ],
        ];

    polyhedron( points = base_core_points, faces = base_core_faces );

    // base plate
    translate([
        -base_plate_x / 2,
        -base_plate_y / 2 + base_plate_offset_y,
        0
        ])
        RoundedCube(
            base_plate_x,
            base_plate_y,
            base_plate_z,
            r = base_plate_rounding_r,
            round_top = false,
            round_bottom = false,
            );
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
