////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

leg_r = 12 / 2;

leg_bc_x = 260;
leg_b_y = 32;
leg_c_y = -54;

leg_z = 20;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print-holder";

leg_clearance_r = 1.0;

pump_support_offset_x = 180;
pump_support_size_x = 60;
pump_support_offset_y = -66;
pump_support_size_y = 111;
pump_support_z = 20;

filter_support_offset_x = 20;
filter_support_size_x = 15;
filter_support_offset_y = -35;
filter_support_size_y = 77;
filter_support_z = 38;
filter_support_angle = 5;

base_extra = 8;
base_rounding_r = 0.5;

base_z = 3;

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
}
else if( render_mode == "print-holder" )
{
    BuonVinoMiniJetBase();
}
else
{
    echo( str( "Invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewBuonVino()
{
    translate( leg_a_coord )
        cylinder( r = leg_r, h = leg_z );

    translate( leg_b_coord )
        cylinder( r = leg_r, h = leg_z );

    translate( leg_c_coord )
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
