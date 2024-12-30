include <modules/rounded-cube.scad>
include <modules/trapezoidal-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

mini_soldering_iron_tip_z = 74.0;
mini_soldering_iron_grip_a_z = 11.0;
mini_soldering_iron_grip_b_z = 5.5;
mini_soldering_iron_grip_c_z = 34.5;
mini_soldering_iron_body_z = 88.0;
mini_soldering_iron_cord_z = 75.0;

mini_soldering_iron_tip_top_r = 4.0 / 2;
mini_soldering_iron_tip_bottom_r = 15.0 / 2;

mini_soldering_iron_grip_a_top_r = 15.0 / 2;
mini_soldering_iron_grip_a_bottom_r = 20.0 / 2;

mini_soldering_iron_grip_b_r = 22.3 / 2;
mini_soldering_iron_grip_c_r = 20.5 / 2;

mini_soldering_iron_body_top_r = 16.0 / 2;
mini_soldering_iron_body_bottom_r = 13.8 / 2;

mini_soldering_iron_cord_r = 5.3 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
render_mode = "print-base";

base_x = 240.0;
base_y = 90.0;
base_z = 2.0;

support_stand_x = 10;
support_stand_top_y = 10;
support_stand_base_y = 30;
support_stand_rear_z = 10.0;

mini_soldering_iron_angle = 10.0;

cradle_wall_width = 2.0;
cradle_clearance = 0.4;

cradle_tower_overlap = -2;

front_cutout_edge_size = 8.0;

front_tower_x = 96; // TODO: calculate
rear_tower_x = base_x - 20; // TODO: calculate

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

$fn = $preview ? 32 : 128;

mini_soldering_iron_total_z =
    mini_soldering_iron_tip_z
    + mini_soldering_iron_grip_a_z
    + mini_soldering_iron_grip_b_z
    + mini_soldering_iron_grip_c_z
    + mini_soldering_iron_body_z;
echo( "mini_soldering_iron_total_z", mini_soldering_iron_total_z );

support_stand_spacing = cos( mini_soldering_iron_angle ) * ( mini_soldering_iron_total_z - mini_soldering_iron_tip_z );
echo( "support_stand_spacing", support_stand_spacing );

support_stand_front_offset = sin( mini_soldering_iron_angle ) * ( mini_soldering_iron_total_z  - mini_soldering_iron_tip_z );
echo( "support_stand_front_offset", support_stand_front_offset );

support_stand_front_z = support_stand_rear_z + support_stand_front_offset;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    preview_z = support_stand_rear_z + cradle_wall_width * 2 + mini_soldering_iron_grip_b_r;

    translate([ mini_soldering_iron_total_z / 2 + base_x / 2, base_y / 2, preview_z ])
        rotate([ 0, -90 + mini_soldering_iron_angle, 0 ])
            MiniSolderingIronPreview();

    MiniSolderingIronStand();
}
else if( render_mode == "print-base" )
{
    MiniSolderingIronStand();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MiniSolderingIronStand()
{
    render()
    {
        difference()
        {
            RoundedCubeAlt2( base_x, base_y, base_z, r = 1.0, round_top = false );

            translate([ front_cutout_edge_size, front_cutout_edge_size, 0 ])
                cube([ front_tower_x - front_cutout_edge_size * 2, base_y - front_cutout_edge_size * 2, base_z ]);
        }
    }

    // #translate([ front_tower_x, base_y/2, base_z ]) cube([ 1, 1, 1 ]);

    // front tower
    translate([ front_tower_x, 0, 0 ])
        _MiniSolderingIronStandTower( support_stand_front_z );
    translate([ front_tower_x, 0, 0 ])
        translate([ 0, base_y / 2, support_stand_front_z + base_z + cradle_tower_overlap ])
            _MiniSolderingIronStandFrontCradle();

    // rear tower
    translate([ rear_tower_x, 0, 0 ])
        _MiniSolderingIronStandTower( support_stand_rear_z );
    translate([ rear_tower_x, 0, 0 ])
        translate([ 0, base_y / 2, support_stand_rear_z + base_z + cradle_tower_overlap ])
            _MiniSolderingIronStandRearCradle();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MiniSolderingIronStandFrontCradle()
{
    outer_r = max(
        mini_soldering_iron_grip_a_bottom_r,
        mini_soldering_iron_grip_b_r,
        mini_soldering_iron_grip_c_r
        )
        + cradle_wall_width
        + cradle_clearance;

    translate([ 0, 0, outer_r ])
    {
        // grip a
        section_a_x = cradle_wall_width;
        _MiniSolderingIronCradleSection( mini_soldering_iron_grip_a_bottom_r, outer_r, section_a_x );

        // grip b
        offset_b_x = section_a_x;
        section_b_x = cradle_clearance * 2 + mini_soldering_iron_grip_b_z;
        translate([ offset_b_x, 0, 0 ])
            _MiniSolderingIronCradleSection( mini_soldering_iron_grip_b_r, outer_r, section_b_x );

        // grip c
        offset_c_x = section_a_x + section_b_x;
        section_c_x = cradle_wall_width;
        translate([ offset_c_x, 0, 0 ])
            _MiniSolderingIronCradleSection( mini_soldering_iron_grip_c_r, outer_r, section_c_x );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MiniSolderingIronStandRearCradle()
{
    outer_r = mini_soldering_iron_body_top_r + cradle_clearance + cradle_wall_width;

    translate([ 0, 0, outer_r ])
    {
        _MiniSolderingIronCradleSection(
            mini_soldering_iron_body_top_r + cradle_clearance,
            mini_soldering_iron_body_top_r + cradle_clearance + cradle_wall_width,
            support_stand_x );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MiniSolderingIronCradleSection( inner_r, outer_r, x )
{
    render()
    {
        difference()
        {
            // outer ring
            rotate([ 0, 90, 0 ])
                cylinder( h = x, r = outer_r );

            // cut out the inner ring
            rotate([ 0, 90, 0 ])
                cylinder( h = x, r = inner_r );

            // cut off the top
            translate([ 0, -outer_r, 0 ])
                cube([ x, outer_r * 2, outer_r ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MiniSolderingIronStandTower( z )
{
    translate([ support_stand_x / 2, base_y / 2, z + base_z ])
        rotate([ 0, 0, 90 ])
            TrapezoidalPrism( support_stand_top_y, support_stand_base_y, support_stand_x, z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MiniSolderingIronPreview()
{
    // cord
    color([ 0.1, 0.1, 0.1 ])
        translate([ 0, 0, -mini_soldering_iron_cord_z ])
            cylinder(
                h = mini_soldering_iron_cord_z,
                r = mini_soldering_iron_cord_r
                );

    // body
    color([ 0.3, 0.3, 0.3 ])
        translate([ 0, 0, 0 ])
            cylinder(
                h = mini_soldering_iron_body_z,
                r1 = mini_soldering_iron_body_bottom_r,
                r2 = mini_soldering_iron_body_top_r
                );

    // grip c
    color([ 0.3, 0.3, 0.3 ])
        translate([ 0, 0, mini_soldering_iron_body_z ])
            cylinder(
                h = mini_soldering_iron_grip_c_z,
                r = mini_soldering_iron_grip_c_r
                );

    // grip b
    color([ 0.3, 0.3, 0.3 ])
        translate([ 0, 0, mini_soldering_iron_body_z + mini_soldering_iron_grip_c_z ])
            cylinder(
                h = mini_soldering_iron_grip_b_z,
                r = mini_soldering_iron_grip_b_r
                );

    // grip a
    color([ 0.3, 0.3, 0.3 ])
        translate([ 0, 0, mini_soldering_iron_body_z + mini_soldering_iron_grip_c_z + mini_soldering_iron_grip_b_z ])
            cylinder(
                h = mini_soldering_iron_grip_a_z,
                r1 = mini_soldering_iron_grip_a_bottom_r,
                r2 = mini_soldering_iron_grip_a_top_r
                );

    // tip
    color([ 0.6, 0.1, 0.1 ])
        translate([ 0, 0, mini_soldering_iron_body_z + mini_soldering_iron_grip_c_z + mini_soldering_iron_grip_b_z + mini_soldering_iron_grip_a_z ])
            cylinder(
                h = mini_soldering_iron_tip_z,
                r1 = mini_soldering_iron_tip_bottom_r,
                r2 = mini_soldering_iron_tip_top_r
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
