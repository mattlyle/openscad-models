// include <../3rd-party/multiboard_parametric_extended/multiboard_parametric_extended.scad>

include <modules/multiboard.scad>
include <modules/rounded-cube.scad>
// include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "original-bin-only";
// render_mode = "larger-bin-only";

caliper_box_holder_thickness = 1.5;

original_caliper_box_holder_size_y = 70;

corner_rounding_radius = 1.0;

clearance = 2.5;

////////////////////////////////////////////////////////////////////////////////
// measurements

original_caliper_box_x = 91.4;
original_caliper_box_y = 248;
original_caliper_box_z = 26.3;

////////////////////////////////////////////////////////////////////////////////
// calculations

original_caliper_box_holder_size_x = original_caliper_box_x + caliper_box_holder_thickness * 2 + clearance * 2;
original_caliper_box_holder_size_z = original_caliper_box_z + multiboard_connector_back_z + clearance * 2; // only 1 clearance

original_caliper_box_holder_offset_x = MultiboardConnectorBackAltXOffset( original_caliper_box_holder_size_x );

original_caliper_box_spec = [ original_caliper_box_x, original_caliper_box_y, original_caliper_box_z ];
original_caliper_box_holder_spec = [ original_caliper_box_holder_size_x, original_caliper_box_holder_size_y, original_caliper_box_holder_size_z ];

////////////////////////////////////////////////////////////////////////////////

// draw a sample multiboard tile
if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
            MultiboardMockUpTile( 6, 4 );
}

// draw the original holder
if( render_mode == "preview" || render_mode == "original-bin-only" )
{
    translate( render_mode == "preview" ? [ multiboard_cell_size - original_caliper_box_holder_offset_x, 0, 0 ] : [ 0, 0, 0 ])
        CaliperBoxHolder( original_caliper_box_holder_spec, original_caliper_box_spec );
}

// draw a preview of the box itself inside
if( render_mode == "preview" )
{
    translate([ multiboard_cell_size - original_caliper_box_holder_offset_x + caliper_box_holder_thickness + clearance, caliper_box_holder_thickness, multiboard_connector_back_z ])
        CaliperBox( original_caliper_box_spec );
}

////////////////////////////////////////////////////////////////////////////////

module CaliperBoxHolder( holder_spec, box_spec )
{
    render()
    {
        union()
        {
            // back
            MultiboardConnectorBackAlt( holder_spec[ 0 ], holder_spec[ 1 ] );

            // join section
            difference()
            {
                translate([ 0, 0, multiboard_connector_back_z - corner_rounding_radius * 2 ])
                    RoundedCube(
                        size = [ holder_spec[ 0 ], holder_spec[ 1 ], corner_rounding_radius * 3 ],
                        r = corner_rounding_radius,
                        fn = 36
                        );
                
                // cut off the bottom
                translate([ 0, 0, multiboard_connector_back_z - corner_rounding_radius * 2 ])
                    cube([ holder_spec[ 0 ], holder_spec[ 1 ], corner_rounding_radius ]);
                
                // cut off the top
                translate([ 0, 0, multiboard_connector_back_z ])
                    cube([ holder_spec[ 0 ], holder_spec[ 1 ], corner_rounding_radius ]);
            }

            difference()
            {
                // start with a rounded box
                RoundedCube(
                    size = [ holder_spec[ 0 ], holder_spec[ 1 ], holder_spec[ 2 ] ],
                    r = corner_rounding_radius,
                    fn = 36
                    );

                // remove the back
                cube([ holder_spec[ 0 ], holder_spec[ 1 ], multiboard_connector_back_z ]);

                // remove the area for the calipers box
                translate([ caliper_box_holder_thickness, caliper_box_holder_thickness, multiboard_connector_back_z ])
                    cube([ box_spec[ 0 ] + clearance * 2, box_spec[ 1 ] + clearance, box_spec[ 2 ] + clearance ]);
            }
        }
    }

    color([ 0, 0, 0 ])
        translate([ 2, 4, holder_spec[ 2 ] ]) // TODO remove constants
            linear_extrude( 0.5 )
                text( "Digital Calipers", size = 8 ); // TODO: swap with module
}

////////////////////////////////////////////////////////////////////////////////

module CaliperBox( box_spec )
{
    % cube( box_spec );
}

////////////////////////////////////////////////////////////////////////////////
