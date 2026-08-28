include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

recycling_can_hinge_pin_section1_z = 29;
recycling_can_hinge_pin_gap12_z = 5;
recycling_can_hinge_pin_section2_z = 36;

recycling_can_hinge_pin_section1_r = 23.0 / 2;
recycling_can_hinge_pin_section2_r = 21.6 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "mo-model";

recycling_can_hinge_pin_base_extra_r = 6.0;
recycling_can_hinge_pin_base_z = 3.0;

recycling_can_hinge_pin_extra_z = 40.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    RecyclingCanHingePin();
}
else if( render_mode == "my-model" )
{
    RecyclingCanHingePin();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecyclingCanHingePin()
{
    // base
    cylinder(
        r = recycling_can_hinge_pin_section1_r + recycling_can_hinge_pin_base_extra_r,
        h = recycling_can_hinge_pin_base_z
        );

    // main pin section 1
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
        ])
        cylinder(
            r = recycling_can_hinge_pin_section1_r,
            h = recycling_can_hinge_pin_section1_z
            );

    // main pin section 1-2 gap
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
            + recycling_can_hinge_pin_section1_z
        ])
        cylinder(
            r1 = recycling_can_hinge_pin_section1_r,
            r2 = recycling_can_hinge_pin_section2_r,
            h = recycling_can_hinge_pin_gap12_z
            );

    // main pin section 2
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
            + recycling_can_hinge_pin_section1_z
            + recycling_can_hinge_pin_gap12_z
        ])
        cylinder(
            r = recycling_can_hinge_pin_section2_r,
            h = recycling_can_hinge_pin_section2_z
            );

    // extra section beyond 2
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
            + recycling_can_hinge_pin_section1_z
            + recycling_can_hinge_pin_gap12_z
            + recycling_can_hinge_pin_section2_z
        ])
        cylinder(
            r = recycling_can_hinge_pin_section2_r,
            h = recycling_can_hinge_pin_extra_z
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
