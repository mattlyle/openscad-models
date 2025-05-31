include <../modules/gridfinity-base.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

MINI_SCREWDRIVER_SETUP_INDEX_TIP_Z = 0;
MINI_SCREWDRIVER_SETUP_INDEX_TIP_R = 1;
MINI_SCREWDRIVER_SETUP_INDEX_CONE_Z = 2;
MINI_SCREWDRIVER_SETUP_INDEX_FULL_BARREL_Z = 3;
MINI_SCREWDRIVER_SETUP_INDEX_HANDLE_R = 4;
MINI_SCREWDRIVER_SETUP_INDEX_BASE_Z = 5;
MINI_SCREWDRIVER_SETUP_INDEX_BASE_R = 6;
MINI_SCREWDRIVER_SETUP_INDEX_LABEL = 7;

mini_screwdriver_setups = [
    // [ tip_z, tip_r, cone_z, full_barrel_z, handle_r, baze_z, base_r, label ]
    [ 24, 2.0 / 2, 6.3, 71.6, 8.0 / 2, 3.8, 11.1 / 2, "2.0mm / RED -", ],
    [ 24, 2.0 / 2, 6.3, 71.6, 8.0 / 2, 3.8, 11.1 / 2, "PH00 / TEAL +", ],
    [ 26, 2.4 / 2, 7.4, 82.3, 9.0 / 2, 3.8, 13.6 / 2, "2.4mm / GOLD -", ],
    [ 26, 2.4 / 2, 7.4, 82.3, 9.0 / 2, 3.8, 13.6 / 2, "PH0 / PURPLE +", ],
    [ 30, 3.0 / 2, 8.0, 87.4, 10.0 / 2, 3.8, 13.6 / 2, "3.0mm / BRONZE -", ],
    [ 30, 2.0 / 2, 8.0, 87.4, 10.0 / 2, 3.8, 13.6 / 2, "PH1 / SILVER +", ],
];

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

screwdriver_spacing_x = 18.0;
screwdriver_angle = -8.0;

cells_x = 3;
cells_y = 1;

// the height to be added on top of the base
top_z = 1;

screwdrivers_offset_y = 10;
screwdrivers_offset_z = 7;

wall_width = 1.6;
base_wall_z = 50.0;

holder_z = 2.4;
top_holder_offset_z = 75;
bottom_holder_offset_z = 10;

handle_clearance_r = 1.0;
label_font_size = 4.0;
label_font = "Liberation Sans";
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );
base_offset_z = GRIDFINITY_BASE_Z + top_z;

holder_x = screwdriver_spacing_x * 6 + wall_width * 2;
holder_y = max( getListAtIndex( mini_screwdriver_setups, MINI_SCREWDRIVER_SETUP_INDEX_BASE_R ) );

screwdrivers_offset_x = ( base_x - screwdriver_spacing_x * 5 ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if ( render_mode == "print" )
{
    MiniScrewdriverSetHolder();
}
else if ( render_mode == "preview" )
{
    // for( i = [ 0 : len( mini_screwdriver_setups ) - 1 ] )
    // {
    //     #translate([
    //         screwdrivers_offset_x + screwdriver_spacing_x * i,
    //         screwdrivers_offset_y,
    //         screwdrivers_offset_z
    //         ])
    //         rotate([ screwdriver_angle, 0, 0 ])
    //             MiniScrewdriverPreview( mini_screwdriver_setups[ i ] );
    // }

    // translate([ screwdrivers_offset_x + screwdriver_spacing_x * 0, screwdrivers_offset_y, screwdrivers_offset_z ])
    //     rotate([ screwdriver_angle, 0, 0 ])
    //         MiniScrewdriverPreview( mini_screwdriver_handle_a_z );
    // translate([ screwdrivers_offset_x + screwdriver_spacing_x * 1, screwdrivers_offset_y, screwdrivers_offset_z ])
    //     rotate([ screwdriver_angle, 0, 0 ])
    //         MiniScrewdriverPreview( mini_screwdriver_handle_a_z );
    // translate([ screwdrivers_offset_x + screwdriver_spacing_x * 2, screwdrivers_offset_y, screwdrivers_offset_z ])
    //     rotate([ screwdriver_angle, 0, 0 ])
    //         MiniScrewdriverPreview( mini_screwdriver_handle_b_z );
    // translate([ screwdrivers_offset_x + screwdriver_spacing_x * 3, screwdrivers_offset_y, screwdrivers_offset_z ])
    //     rotate([ screwdriver_angle, 0, 0 ])
    //         MiniScrewdriverPreview( mini_screwdriver_handle_b_z );
    // translate([ screwdrivers_offset_x + screwdriver_spacing_x * 4, screwdrivers_offset_y, screwdrivers_offset_z ])
    //     rotate([ screwdriver_angle, 0, 0 ])
    //         MiniScrewdriverPreview( mini_screwdriver_handle_c_z );
    // translate([ screwdrivers_offset_x + screwdriver_spacing_x * 5, screwdrivers_offset_y, screwdrivers_offset_z ])
    //     rotate([ screwdriver_angle, 0, 0 ])
    //         MiniScrewdriverPreview( mini_screwdriver_handle_c_z );

    // MiniScrewdriverSetHolder();
    
    rotate([ -90, 0, 0 ])
        MiniScrewdriverSetHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module MiniScrewdriverPreview( setup )
{
    tip_z = setup[ 0 ];
    tip_r = setup[ 1 ];
    cone_z = setup[ 2 ];
    full_barrel_z = setup[ 3 ];
    handle_r = setup[ 4 ];
    base_z = setup[ 5 ];
    base_r = setup[ 6 ];
    label  = setup[ 7 ];

    handle_z = full_barrel_z - base_z - cone_z;

    // base
    cylinder( r = base_r, h = base_z, $fn = 6 );

    // handle
    translate([ 0, 0, base_z ])
        cylinder( r = handle_r, h = handle_z );

    // handle cone
    translate([ 0, 0, base_z + handle_z ])
        cylinder( r1 = handle_r, r2 = tip_r, h = cone_z );

    // tip
    translate([ 0, 0, base_z + handle_z + cone_z ])
        cylinder( r = tip_r, h = tip_z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module MiniScrewdriverSetHolder()
{
    // base
    // GridfinityBase( cells_x, cells_y, top_z, round_top = false, center = false );

    // walls
    // difference()
    // {
    //     translate([ 0, 0, base_offset_z ])
    //         RoundedCubeAlt2(
    //             x = base_x,
    //             y = base_y,
    //             z = base_wall_z,
    //             r = GRIDFINITY_ROUNDING_R,
    //             round_top = true,
    //             round_bottom = false,
    //             round_left = true,
    //             round_right = true,
    //             center = false,
    //             );

    //     translate([ wall_width, -GRIDFINITY_ROUNDING_R, base_offset_z - DIFFERENCE_CLEARANCE ])
    //         RoundedCubeAlt2(
    //             x = base_x - wall_width * 2,
    //             y = base_y - wall_width + GRIDFINITY_ROUNDING_R,
    //             z = base_wall_z + DIFFERENCE_CLEARANCE * 2,
    //             r = GRIDFINITY_ROUNDING_R,
    //             round_top = false,
    //             round_bottom = false,
    //             round_left = true,
    //             round_right = true,
    //             center = false,
    //             );
    // }

    // holder
    translate([ 0, 0, 0 ])
        // rotate([ screwdriver_angle, 0, 0 ])
            _MiniScrewdriverHolderCombinedSupports();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module _MiniScrewdriverHolderCombinedSupports()
{
    holder_top_y = holder_y / 2 + wall_width;
    holder_bottom_y = holder_y + wall_width;

    holder_top_offset_y = holder_y - holder_top_y + wall_width;

    // back wall
    translate([ ( base_x - holder_x ) / 2, holder_bottom_y - wall_width, bottom_holder_offset_z ])
        RoundedCubeAlt2(
            x = holder_x,
            y = wall_width,
            z = top_holder_offset_z - bottom_holder_offset_z + holder_z,
            r = 1.0,
            round_top = true,
            round_bottom = true,
            round_left = true,
            round_right = true
            );

    // top holder
    translate([ 0, 0, top_holder_offset_z ])
    {
        difference()
        {
            translate([ ( base_x - holder_x ) / 2, holder_top_offset_y, 0 ])
                RoundedCubeAlt2(
                    x = holder_x,
                    y = holder_top_y,
                    z = holder_z,
                    r = 1.0,
                    round_top = true,
                    round_bottom = true,
                    round_left = true,
                    round_right = true,
                    center = false
                    );

            for( i = [ 0 : len( mini_screwdriver_setups ) - 1 ] )
            {
                setup = mini_screwdriver_setups[ i ];

                // tip_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_TIP_Z ];
                tip_r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_TIP_R ];
                // cone_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_CONE_Z ];
                // full_barrel_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_FULL_BARREL_Z ];
                // handle_r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_HANDLE_R ];
                // base_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_BASE_Z ];
                // base_r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_BASE_R ];
                // label  = setup[ MINI_SCREWDRIVER_SETUP_INDEX_LABEL ];

                // handle_z = full_barrel_z - base_z - cone_z;

                translate([
                    screwdrivers_offset_x + screwdriver_spacing_x * i,
                    holder_top_offset_y,
                    -DIFFERENCE_CLEARANCE
                    ])
                    cylinder(
                        r = tip_r + handle_clearance_r,
                        h = holder_z + DIFFERENCE_CLEARANCE * 2
                        );
            }
        }
    }

    // bottom holder
    translate([ 0, 0, bottom_holder_offset_z ])
    {
        difference()
        {
            translate([ ( base_x - holder_x ) / 2, 0, 0 ])
                RoundedCubeAlt2(
                    x = holder_x,
                    y = holder_bottom_y,
                    z = holder_z,
                    r = 1.0,
                    round_top = true,
                    round_bottom = true,
                    round_left = true,
                    round_right = true,
                    center = false
                    );

            for( i = [ 0 : len( mini_screwdriver_setups ) - 1 ] )
            {
                setup = mini_screwdriver_setups[ i ];

                // tip_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_TIP_Z ];
                // tip_r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_TIP_R ];
                // cone_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_CONE_Z ];
                // full_barrel_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_FULL_BARREL_Z ];
                handle_r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_HANDLE_R ];
                // base_z = setup[ MINI_SCREWDRIVER_SETUP_INDEX_BASE_Z ];
                // base_r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_BASE_R ];
                // label  = setup[ MINI_SCREWDRIVER_SETUP_INDEX_LABEL ];

                // handle_z = full_barrel_z - base_z - cone_z;

                translate([
                    screwdrivers_offset_x + screwdriver_spacing_x * i,
                    0,
                    -DIFFERENCE_CLEARANCE
                    ])
                    cylinder(
                        r = handle_r + handle_clearance_r,
                        h = holder_z + DIFFERENCE_CLEARANCE * 2
                        );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
