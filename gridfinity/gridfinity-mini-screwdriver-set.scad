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

screwdriver_angle = -8.0;

cells_x = 3;
cells_y = 1;

// the height to be added on top of the base
top_z = 1;

wall_width = 1.6;
base_wall_z = 50.0;

cradle_bottom_offset_z = 6.0;
cradle_label_offset_z = 27.0;

cradle_clearance = 0.6;

screwdriver_extra_spacing_x = 1.2;

label_font_size = 4.0;
label_font = "Liberation Sans";
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );
base_offset_z = GRIDFINITY_BASE_Z + top_z;

cradle_support_y = max( getListAtIndex( mini_screwdriver_setups, MINI_SCREWDRIVER_SETUP_INDEX_BASE_R ) );

screwdriver_spacing_x = max( getListAtIndex( mini_screwdriver_setups, MINI_SCREWDRIVER_SETUP_INDEX_BASE_R ) ) * 2
    + screwdriver_extra_spacing_x;

setup_left = mini_screwdriver_setups[ 0 ];
setup_right = mini_screwdriver_setups[ len( mini_screwdriver_setups ) - 1 ];

cradle_x = screwdriver_spacing_x * 6 + wall_width * 2;
cradle_y = cradle_support_y + wall_width;
cradle_left_z = wall_width * 2
    + cradle_clearance
    + setup_left[ MINI_SCREWDRIVER_SETUP_INDEX_FULL_BARREL_Z ]
    + setup_left[ MINI_SCREWDRIVER_SETUP_INDEX_TIP_Z ] * 0.2;
cradle_right_z = wall_width * 2
    + cradle_clearance
    + setup_right[ MINI_SCREWDRIVER_SETUP_INDEX_FULL_BARREL_Z ]
    + setup_right[ MINI_SCREWDRIVER_SETUP_INDEX_TIP_Z ] * 0.7;

screwdrivers_offset_x = ( base_x - screwdriver_spacing_x * 5 ) / 2;

echo(cradle_x);
echo("base_x",base_x);

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

rotate([ -90, 0, 0 ])
    _MiniScrewdriverHolderCradle();

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
}
else
{
    echo( str( "Unknown render mode: ", render_mode ) );
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
    GridfinityBase( cells_x, cells_y, top_z, round_top = false, center = false );

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

    // cradle
    translate([ 0, screwdrivers_cradle_offset_y, screwdrivers_cradle_offset_z ])
        rotate([ screwdriver_angle, 0, 0 ])
            _MiniScrewdriverHolderCradle();

    // cradle base
    _MiniScrewdriverHolderCradleBase();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module _MiniScrewdriverHolderCradle()
{
    for( i = [ 0 : len( mini_screwdriver_setups ) - 1 ] )
    {
        #translate([
            wall_width + screwdriver_spacing_x * ( i + 0.5 ),
            -cradle_support_y - wall_width,
            wall_width + cradle_clearance
            ])
            // rotate([ screwdriver_angle, 0, 360/12 ])
            rotate([ 0, 0, 360/12 ])
                MiniScrewdriverPreview( mini_screwdriver_setups[ i ] );
    }

    // back wall

    back_wall_left_x = 0;
    back_wall_right_x = cradle_x;

    back_wall_front_y = -wall_width;
    back_wall_back_y = 0;
    top_support_front_y = back_wall_front_y - cradle_support_y;
    
    back_wall_bottom_z = 0;
    back_wall_top_left_z = cradle_left_z;
    back_wall_top_right_z = cradle_right_z;
    top_support_left_z = cradle_left_z - wall_width;
    top_support_right_z = cradle_right_z - wall_width;

    back_wall_points = [
        [ back_wall_left_x, back_wall_back_y, back_wall_top_left_z ], // 0 - top left
        [ back_wall_right_x, back_wall_back_y, back_wall_top_right_z ], // 1 - top right
        [ back_wall_right_x, back_wall_back_y, back_wall_bottom_z ], // 2 - bottom right
        [ back_wall_left_x, back_wall_back_y, back_wall_bottom_z ], // 3 - bottom left

        [ back_wall_left_x, back_wall_front_y, back_wall_top_left_z ], // 4 - top left
        [ back_wall_right_x, back_wall_front_y, back_wall_top_right_z ], // 5 - top right
        [ back_wall_right_x, back_wall_front_y, back_wall_bottom_z ], // 6 - bottom right
        [ back_wall_left_x, back_wall_front_y, back_wall_bottom_z ], // 7 - bottom left
    ];

    // for( point = back_wall_points )
    // {
    //     translate( point )
    //         sphere( 0.5 );
    // }

    polyhedron(
        points = back_wall_points,
        faces = [
            [ 4, 5, 6, 7 ],
            [ 0, 4, 7, 3 ],
            [ 2, 3, 7, 6 ],
            [ 1, 2, 6, 5 ],
            [ 0, 1, 5, 4 ],
            [ 0, 3, 2, 1 ],
        ]
    );

    // labels
    for( i = [ 0 : len( mini_screwdriver_setups ) - 1 ] )
    {
        translate([
            wall_width + screwdriver_spacing_x * ( i + 0.5 ),
            -wall_width,
            wall_width + cradle_label_offset_z
            ])
            rotate([ 90, -90, 0 ])
                TextLabel(
                    mini_screwdriver_setups[ i ][ MINI_SCREWDRIVER_SETUP_INDEX_LABEL ],
                    depth = label_depth,
                    label_font_size,
                    label_font,
                    color = [ 0, 0, 0 ]
                    );
    }
    
    // bottom wall
    translate([ back_wall_left_x, top_support_front_y, back_wall_bottom_z ])
        cube([ cradle_x, cradle_support_y, wall_width ]);
    
    // bottom support bar
    difference()
    {
        translate([
            back_wall_left_x,
            top_support_front_y,
            back_wall_bottom_z + wall_width + cradle_bottom_offset_z
            ])
            cube([ cradle_x, cradle_support_y, wall_width ]);

        for( i = [ 0 : len( mini_screwdriver_setups ) - 1 ] )
        {
            setup = mini_screwdriver_setups[ i ];

            translate([
                wall_width + screwdriver_spacing_x * ( i + 0.5 ),
                - wall_width - cradle_support_y,
                back_wall_bottom_z + wall_width + cradle_bottom_offset_z - DIFFERENCE_CLEARANCE,
                ])
                cylinder(
                    h = wall_width + DIFFERENCE_CLEARANCE * 2,
                    r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_HANDLE_R ] + cradle_clearance
                    );
        }
    }
    
    // top support bar
    top_support_bar_points = [
        [ back_wall_left_x, back_wall_front_y, back_wall_top_left_z ], // 0 - top left
        [ back_wall_right_x, back_wall_front_y, back_wall_top_right_z ], // 1 - top right
        [ back_wall_right_x, back_wall_front_y, top_support_right_z ], // 2 - bottom right
        [ back_wall_left_x, back_wall_front_y, top_support_left_z ], // 3 - bottom left

        [ back_wall_left_x, top_support_front_y, back_wall_top_left_z ], // 0 - top left
        [ back_wall_right_x, top_support_front_y, back_wall_top_right_z ], // 1 - top right
        [ back_wall_right_x, top_support_front_y, top_support_right_z ], // 2 - bottom right
        [ back_wall_left_x, top_support_front_y, top_support_left_z ], // 3 - bottom left
    ];

    // for( point = top_support_bar_points )
    // {
    //     translate( point )
    //         sphere( 0.5 );
    // }

    difference()
    {
        polyhedron(
            points = top_support_bar_points,
            faces = [
                [ 4, 5, 6, 7 ],
                [ 0, 4, 7, 3 ],
                [ 2, 3, 7, 6 ],
                [ 1, 2, 6, 5 ],
                [ 0, 1, 5, 4 ],
                [ 0, 3, 2, 1 ],
            ]
        );

        for( i = [ 0 : len( mini_screwdriver_setups ) - 1 ] )
        {
            setup = mini_screwdriver_setups[ i ];

            translate([
                wall_width + screwdriver_spacing_x * ( i + 0.5 ),
                - wall_width - cradle_support_y,
                back_wall_bottom_z + wall_width,
                ])
                cylinder(
                    h = max( cradle_left_z, cradle_right_z ),
                    r = setup[ MINI_SCREWDRIVER_SETUP_INDEX_TIP_R ] + cradle_clearance
                    );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module _MiniScrewdriverHolderCradleBase()
{

}

////////////////////////////////////////////////////////////////////////////////////////////////////
