////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

leg_r = 12 / 2;

leg_bc_x = 259;
leg_b_y = 32;
leg_c_y = -54;

leg_z = 20;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print-holder";

base_x = 0;
base_y = 0;
base_z = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 128 : 256;

leg_a_coord = [ 0, 0, 0 ];
leg_b_coord = [ leg_bc_x, leg_b_y, 0 ];
leg_c_coord = [ leg_bc_x, leg_c_y, 0 ];

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
    z = 3;

    length_ab = sqrt( leg_bc_x * leg_bc_x + leg_b_y * leg_b_y ) + leg_r * 2 + extra;
    length_ac = sqrt( leg_bc_x * leg_bc_x + leg_c_y * leg_c_y ) + leg_r * 2 + extra;
    length_bc = leg_b_y - leg_c_y + leg_r * 2 + extra;

    difference()
    {
        union()
        {
            translate([ 0, 0, z ])
            {
                RotateFromPointAtoB( leg_a_coord, leg_b_coord )
                    translate([ 0, -width / 2, -leg_r - extra / 2 ])
                        cube([ z, width, length_ab ]);

                RotateFromPointAtoB( leg_a_coord, leg_c_coord )
                    translate([ 0, -width / 2, -leg_r - extra / 2 ])
                        cube([ z, width, length_ac ]);

                translate( leg_b_coord )
                    RotateFromPointAtoB( leg_b_coord, leg_c_coord )
                        translate([ 0, -width / 2, -leg_r - extra / 2 ])
                            cube([ z, width, length_bc ]);
            }
        }

        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
        {
            translate( leg_a_coord )
                cylinder( r = leg_r, h = leg_z + DIFFERENCE_CLEARANCE * 2);

            translate( leg_b_coord )
                cylinder( r = leg_r, h = leg_z + DIFFERENCE_CLEARANCE * 2);

            translate( leg_c_coord )
                cylinder( r = leg_r, h = leg_z + DIFFERENCE_CLEARANCE * 2);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
