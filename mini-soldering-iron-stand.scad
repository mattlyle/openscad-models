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
render_mode = "preview";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

$fn = $preview ? 32 : 128;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

MiniSolderingIronPreview();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MiniSolderingIronStand()
{
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
