// include <../3rd-party/multiboard_parametric_extended/multiboard_parametric_extended.scad>
include <modules/multiboard.scad>

////////////////////////////////////////////////////////////////////////////////
// settings

caliper_box_holder_thickness = 1.8;
caliper_box_holder_size_y = 70;

clearance = 2.5;

show_previews = false;

////////////////////////////////////////////////////////////////////////////////
// measurements

caliper_box_x = 91.4;
caliper_box_y = 248;
caliper_box_z = 26.3;

////////////////////////////////////////////////////////////////////////////////

caliper_box_holder_size_x = caliper_box_x + caliper_box_holder_thickness * 2 + clearance * 2;
caliper_box_holder_size_z = caliper_box_z + caliper_box_holder_thickness * 2 + clearance; // only 1 clearance

caliper_box_holder_offset_x = MultiboardConnectorBackAltXOffset( caliper_box_holder_size_x );

////////////////////////////////////////////////////////////////////////////////

// multiboard_core(5,4);

// draw a sample multiboard tile
if( show_previews )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
            MultiboardMockUpTile( 6, 4 );
}

// draw the holder
translate( show_previews ? [ multiboard_cell_size - caliper_box_holder_offset_x, 0, 0 ] : [ 0, 0, 0 ])
    CaliperBoxHolder();

// draw a preview of the box itseld inside
if( show_previews )
{
    translate([ multiboard_cell_size - caliper_box_holder_offset_x + caliper_box_holder_thickness + clearance, caliper_box_holder_thickness, caliper_box_holder_thickness ])
        CaliperBox();
}

// translate([ 0, 0, multiboard_cell_height ])
//     MultiboardConnectorBack( 2, 2 );

////////////////////////////////////////////////////////////////////////////////

module CaliperBoxHolder()
{
    union()
    {
        // back
        // cube([ caliper_box_holder_size_x, caliper_box_holder_size_y, caliper_box_holder_thickness ]);
        // MultiboardConnectorBack( 4, 3 );
        MultiboardConnectorBackAlt( caliper_box_holder_size_x, caliper_box_holder_size_y );

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
