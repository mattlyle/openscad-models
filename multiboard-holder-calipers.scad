// include <../3rd-party/multiboard_parametric_extended/multiboard_parametric_extended.scad>
include <modules/multiboard-mock-up.scad>

////////////////////////////////////////////////////////////////////////////////
// settings

caliper_box_holder_thickness = 2.5;
caliper_box_holder_grid_size_x = 3; // number of grid holes to span
caliper_box_holder_size_y = 70;

clearance = 3;

////////////////////////////////////////////////////////////////////////////////
// measurements

caliper_box_x = 91.4;
caliper_box_y = 248;
caliper_box_z = 26.3;

////////////////////////////////////////////////////////////////////////////////

caliper_box_holder_size_x = caliper_box_x + caliper_box_holder_thickness * 2 + clearance * 2;
caliper_box_holder_size_z = caliper_box_z + caliper_box_holder_thickness * 2 + clearance; // only 1 clearance


////////////////////////////////////////////////////////////////////////////////

// multiboard_core(5,4);

// translate([ 0, 0, 16 ])
MultiboardMockUpTile( 5, 4 );

translate([ multiboard_cell_size / 2 + caliper_box_holder_thickness + clearance, caliper_box_holder_thickness, multiboard_cell_height + caliper_box_holder_thickness ])
    CaliperBox();

translate([ multiboard_cell_size / 2, 0, multiboard_cell_height ])
    CaliperBoxHolder();

////////////////////////////////////////////////////////////////////////////////

module CaliperBoxHolder()
{
    union()
    {
        // back
        cube([ caliper_box_holder_size_x, caliper_box_holder_size_y, caliper_box_holder_thickness ]);

        // bottom
        translate([ 0, 0, 0 ])
            cube([ caliper_box_holder_size_x, caliper_box_holder_thickness, caliper_box_holder_size_z ]);

        // front
        translate([ 0, 0, caliper_box_holder_size_z - caliper_box_holder_thickness ])
            cube([ caliper_box_holder_size_x, caliper_box_holder_size_y, caliper_box_holder_thickness ]);

        // left side
        cube([ caliper_box_holder_thickness, caliper_box_holder_size_y, caliper_box_holder_size_z ]);

        // right side
        translate([ caliper_box_holder_size_x - caliper_box_holder_thickness, 0, 0 ])
            cube([ caliper_box_holder_thickness, caliper_box_holder_size_y, caliper_box_holder_size_z ]);
    }

    color([ 0, 0, 0 ])
        translate([ 2, 4, caliper_box_holder_size_z ])
            linear_extrude( 0.5 )
                text( "Digital Calipers", size = 8 );
}

////////////////////////////////////////////////////////////////////////////////

module CaliperBox()
{
    % cube([ caliper_box_x, caliper_box_y, caliper_box_z ]);
}

////////////////////////////////////////////////////////////////////////////////
