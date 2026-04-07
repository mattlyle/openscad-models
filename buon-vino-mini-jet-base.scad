////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/rounded-cube.scad>
include <modules/rounded-cylinder.scad>
include <modules/pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

leg_r = 12 / 2;

leg_bc_x = 260;
leg_b_y = 32;
leg_c_y = -54;

leg_z = 20;

pump_hose_r = 12.8 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-hose-support";

leg_clearance_r = 1.0;

pump_support_offset_x = 180;
pump_support_size_x = 60;
pump_support_offset_y = -66;
pump_support_size_y = 111;
pump_support_z = 22;

filter_support_offset_x = 20;
filter_support_size_x = 15;
filter_support_offset_y = -35;
filter_support_size_y = 77;
filter_support_z = 40;
filter_support_angle = 5;

base_extra = 20;
base_rounding_r = 0.5;

base_z = 3;

pump_hose_support_thickness = 2.4;
pump_hose_support_x = 20;
pump_hose_support_y = 15;
pump_hose_support_front_z = 40;
pump_hose_support_back_z = 15;
pump_hose_support_gripper_angle = 60;
pump_hose_support_rounding_r = 0.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 128 : 256;

leg_a_coord = [ 0, 0, 0 ];
leg_b_coord = [ leg_bc_x, leg_b_y, 0 ];
leg_c_coord = [ leg_bc_x, leg_c_y, 0 ];

base_offset_x = -leg_r - leg_clearance_r - base_extra;
base_size_x = leg_bc_x + leg_r * 2 + leg_clearance_r * 2 + base_extra * 2;

base_offset_y = leg_c_y - leg_r - leg_clearance_r - base_extra;
base_size_y = leg_b_y - leg_c_y + leg_r * 2 + leg_clearance_r * 2 + base_extra * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    PreviewBuonVino();

    BuonVinoMiniJetBase();

    translate([ -100, 0, 0 ])
    {
        % translate([ 0, 0, -pump_hose_support_front_z / 2])
            cylinder( r = pump_hose_r, h = pump_hose_support_front_z * 2 );

        PumpHoseSupport();
    }
}
else if( render_mode == "print-holder" )
{
    BuonVinoMiniJetBase();
}
else if( render_mode == "print-hose-support" )
{
    translate([ 0, 0, pump_hose_support_front_z ])
        rotate([ 180, 0, 0 ])
            PumpHoseSupport();
}
else
{
    assert( false, str( "Invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewBuonVino()
{
    # translate( leg_a_coord )
        cylinder( r = leg_r, h = leg_z );

    # translate( leg_b_coord )
        cylinder( r = leg_r, h = leg_z );

    # translate( leg_c_coord )
        cylinder( r = leg_r, h = leg_z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BuonVinoMiniJetBase()
{
    extra = 10;
    length_short = leg_r * 2 + ( leg_b_y - leg_c_y ) + extra;
    width = leg_r * 2 + extra;

    length_ab = sqrt( leg_bc_x * leg_bc_x + leg_b_y * leg_b_y ) + leg_r * 2 + extra;
    length_ac = sqrt( leg_bc_x * leg_bc_x + leg_c_y * leg_c_y ) + leg_r * 2 + extra;
    length_bc = leg_b_y - leg_c_y + leg_r * 2 + extra;

    points = [
        [
            filter_support_offset_x,
            filter_support_offset_y + filter_support_size_y / 2,
            filter_support_z / 2
            ],
        [
            pump_support_offset_x + pump_support_size_x,
            pump_support_offset_y + pump_support_size_y / 2,
            pump_support_z / 2
            ],
        [
            base_offset_x + base_size_x,
            base_offset_y + base_size_y,
            base_z
            ],
        [
            base_offset_x + base_size_x,
            base_offset_y,
            base_z
            ],
        [
            base_offset_x,
            base_offset_y,
            base_z
            ],
        [
            base_offset_x,
            base_offset_y + base_size_y,
            base_z
            ],
        ];

    // for( point = points )
    //     translate( point )
    //         #sphere( r=1 );

    difference()
    {
        union()
        {
            // base bottom
            translate([
                base_offset_x - base_rounding_r / 2,
                base_offset_y - base_rounding_r / 2,
                0
                ])
                RoundedCubeAlt2(
                    base_size_x + base_rounding_r,
                    base_size_y + base_rounding_r,
                    base_z,
                    round_top = false,
                    round_bottom = false,
                    r = base_rounding_r
                    );

            // sloped so liquid can drain off
            polyhedron(
                points = points,
                faces = [
                    [ 0, 5, 2, 1 ],
                    [ 1, 2, 3 ],
                    [ 0, 1, 3, 4 ],
                    [ 0, 4, 5 ],
                    [ 2, 5, 4, 3 ],
                    ]);
        }

        // remove the legs
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
        {
            translate( leg_a_coord )
                cylinder( r = leg_r + leg_clearance_r, h = pump_support_z );

            translate( leg_b_coord )
                cylinder( r = leg_r + leg_clearance_r, h = pump_support_z );

            translate( leg_c_coord )
                cylinder( r = leg_r + leg_clearance_r, h = pump_support_z );
        }
    }

    // pump base
    translate([ pump_support_offset_x, pump_support_offset_y, 0 ])
        cube([ pump_support_size_x, pump_support_size_y, pump_support_z ]);

    // filter base
    difference()
    {
        translate([ filter_support_offset_x, filter_support_offset_y, 0 ])
            cube([ filter_support_size_x, filter_support_size_y, filter_support_z ]);

        translate([ filter_support_offset_x, filter_support_offset_y - DIFFERENCE_CLEARANCE, filter_support_z ])
            rotate([ 0, filter_support_angle, 0 ])
                cube([ filter_support_size_x + 10, filter_support_size_y + DIFFERENCE_CLEARANCE * 2, 10 ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PumpHoseSupport()
{
    // gripper
    difference()
    {
        RoundedCylinder(
            r = pump_hose_r + pump_hose_support_thickness,
            h = pump_hose_support_front_z,
            rounding_r = pump_hose_support_rounding_r
            );

        // remove the core
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder( r = pump_hose_r + DIFFERENCE_CLEARANCE, h = pump_hose_support_front_z + DIFFERENCE_CLEARANCE * 2 );

        // remove the entrance
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            rotate([ 0, 0, 270 - pump_hose_support_gripper_angle / 2 ])
                PieSlicePrism(
                    pump_hose_r + pump_hose_support_thickness + 1,
                    pump_hose_support_front_z + DIFFERENCE_CLEARANCE * 2,
                    pump_hose_support_gripper_angle
                    );
    }

    // front
    translate([
        -pump_hose_support_x / 2,
        pump_hose_r,
        0
        ])
        RoundedCubeAlt2(
            pump_hose_support_x,
            pump_hose_support_thickness,
            pump_hose_support_front_z,
            pump_hose_support_rounding_r
            );

    // top
    translate([
        -pump_hose_support_x / 2,
        pump_hose_r,
        pump_hose_support_front_z - pump_hose_support_thickness
        ])
        RoundedCubeAlt2(
            pump_hose_support_x,
            pump_hose_support_y,
            pump_hose_support_thickness,
            pump_hose_support_rounding_r
            );


    // back
    translate([
        -pump_hose_support_x / 2,
        pump_hose_r + pump_hose_support_y - pump_hose_support_thickness,
        pump_hose_support_front_z - pump_hose_support_back_z
        ])
        RoundedCubeAlt2(
            pump_hose_support_x,
            pump_hose_support_thickness,
            pump_hose_support_back_z,
            pump_hose_support_rounding_r
            );

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
