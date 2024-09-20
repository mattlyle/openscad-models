// include <../3rd-party/multiboard_parametric_extended/multiboard_parametric_extended.scad>
include <modules/multiboard.scad>
include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////
// settings

caliper_box_holder_thickness = 1.5;
caliper_box_holder_size_y = 70;

corner_rounding_radius = 1.0;

clearance = 2.5;

show_previews = false;

////////////////////////////////////////////////////////////////////////////////
// measurements

caliper_box_x = 91.4;
caliper_box_y = 248;
caliper_box_z = 26.3;

////////////////////////////////////////////////////////////////////////////////

caliper_box_holder_size_x = caliper_box_x + caliper_box_holder_thickness * 2 + clearance * 2;
caliper_box_holder_size_z = caliper_box_z + multiboard_connector_back_z + clearance * 2; // only 1 clearance

caliper_box_holder_offset_x = MultiboardConnectorBackAltXOffset( caliper_box_holder_size_x );

////////////////////////////////////////////////////////////////////////////////

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
    translate([ multiboard_cell_size - caliper_box_holder_offset_x + caliper_box_holder_thickness + clearance, caliper_box_holder_thickness, multiboard_connector_back_z ])
        CaliperBox();
}

////////////////////////////////////////////////////////////////////////////////

module CaliperBoxHolder()
{
    render()
    {
        union()
        {
            // back
            // back
            MultiboardConnectorBackAlt( caliper_box_holder_size_x, caliper_box_holder_size_y );

            // join section
            difference()
            {
                translate([ 0, 0, multiboard_connector_back_z - corner_rounding_radius * 2 ])
                    RoundedCube(
                        size = [ caliper_box_holder_size_x, caliper_box_holder_size_y, corner_rounding_radius * 3 ],
                        r = corner_rounding_radius,
                        fn = 36
                        );
                
                // cut off the bottom
                translate([ 0, 0, multiboard_connector_back_z - corner_rounding_radius * 2 ])
                    cube([ caliper_box_holder_size_x, caliper_box_holder_size_y, corner_rounding_radius ]);
                
                // cut off the top
                translate([ 0, 0, multiboard_connector_back_z ])
                    cube([ caliper_box_holder_size_x, caliper_box_holder_size_y, corner_rounding_radius ]);
            }

            difference()
            {
                // start with a rounded box
                RoundedCube(
                    size = [ caliper_box_holder_size_x, caliper_box_holder_size_y, caliper_box_holder_size_z ],
                    r = corner_rounding_radius,
                    fn = 36
                    );

                // remove the back
                cube([ caliper_box_holder_size_x, caliper_box_holder_size_y, multiboard_connector_back_z ]);

                // remove the area for the calipers box
                translate([ caliper_box_holder_thickness, caliper_box_holder_thickness, multiboard_connector_back_z ])
                    cube([ caliper_box_x + clearance * 2, caliper_box_y + clearance, caliper_box_z + clearance ]);
            }
        }
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
