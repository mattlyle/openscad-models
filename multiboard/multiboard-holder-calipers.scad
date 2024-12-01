// include <../../3rd-party/multiboard_parametric_extended/multiboard_parametric_extended.scad>

include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>
// include <../modules/text-label.scad>
include <../modules/svg.scad>

////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "original-bin-only";
// render_mode = "larger-bin-only";

caliper_box_holder_thickness = 1.5;

corner_rounding_radius = 1.0;

clearance = 2.5;

// original caliper box

original_caliper_box_holder_cell_offset_x = 0;

original_caliper_box_holder_size_y = 70;

original_caliper_box_holder_text_label_1_offset_vector = [ 4, 50, 0 ];
original_caliper_box_holder_text_label_2_offset_vector = [ 34, 6, 0 ];
original_caliper_box_holder_text_label_font_size = 9;

original_caliper_box_holder_svg_scale_vector = [ 0.4, 0.4, 1.0 ];
original_caliper_box_holder_svg_rotation_z = -20;
original_caliper_box_holder_svg_offset_vector = [ 0, 10, 0 ];

// larger caliper box

larger_caliper_box_holder_cell_offset_x = 5;

larger_caliper_box_holder_size_y = 90;

larger_caliper_box_holder_text_label_1_offset_vector = [ 60, 30, 0 ];
larger_caliper_box_holder_text_label_2_offset_vector = [ 70, 15, 0 ];
larger_caliper_box_holder_text_label_font_size = 8;

larger_caliper_box_holder_svg_scale_vector = [ 0.4, 0.4, 1.0 ];
larger_caliper_box_holder_svg_rotation_z = 10;
larger_caliper_box_holder_svg_offset_vector = [ 5, -2, 0 ];

////////////////////////////////////////////////////////////////////////////////
// measurements

original_caliper_box_x = 91.4;
original_caliper_box_y = 248;
original_caliper_box_z = 26.3;

larger_caliper_box_x = 127.2;
larger_caliper_box_y = 425;
larger_caliper_box_z = 32.1;

////////////////////////////////////////////////////////////////////////////////
// calculations

// original box

original_caliper_box_holder_size_x = original_caliper_box_x + caliper_box_holder_thickness * 2 + clearance * 2;
original_caliper_box_holder_size_z = original_caliper_box_z + multiboard_connector_back_z + clearance * 2; // only 1 clearance

original_caliper_box_holder_offset_x = MultiboardConnectorBackAltXOffset( original_caliper_box_holder_size_x );

original_caliper_box_size_vector = [ original_caliper_box_x, original_caliper_box_y, original_caliper_box_z ];
original_caliper_box_holder_size_vector = [ original_caliper_box_holder_size_x, original_caliper_box_holder_size_y, original_caliper_box_holder_size_z ];

// larger box

larger_caliper_box_holder_size_x = larger_caliper_box_x + caliper_box_holder_thickness * 2 + clearance * 2;
larger_caliper_box_holder_size_z = larger_caliper_box_z + multiboard_connector_back_z + clearance * 2; // only 1 clearance

larger_caliper_box_holder_offset_x = MultiboardConnectorBackAltXOffset( larger_caliper_box_holder_size_x );

larger_caliper_box_size_vector = [ larger_caliper_box_x, larger_caliper_box_y, larger_caliper_box_z ];
larger_caliper_box_holder_size_vector = [ larger_caliper_box_holder_size_x, larger_caliper_box_holder_size_y, larger_caliper_box_holder_size_z ];

////////////////////////////////////////////////////////////////////////////////

// draw a sample multiboard tile
if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
            MultiboardMockUpTile( 12, 4 );
}

// draw the original holder
if( render_mode == "preview" || render_mode == "original-bin-only" )
{
    translate( render_mode == "preview" ? [ ( original_caliper_box_holder_cell_offset_x + 1 ) * multiboard_cell_size - original_caliper_box_holder_offset_x, 0, 0 ] : [ 0, 0, 0 ])
        CaliperBoxHolder(
            original_caliper_box_holder_size_vector,
            original_caliper_box_size_vector,
            original_caliper_box_holder_text_label_1_offset_vector,
            original_caliper_box_holder_text_label_2_offset_vector,
            original_caliper_box_holder_text_label_font_size,
            original_caliper_box_holder_svg_offset_vector,
            original_caliper_box_holder_svg_rotation_z,
            original_caliper_box_holder_svg_scale_vector );
}

// draw the larger holder
if( render_mode == "preview" || render_mode == "larger-bin-only" )
{
    translate( render_mode == "preview" ? [ ( larger_caliper_box_holder_cell_offset_x + 1 ) * multiboard_cell_size - larger_caliper_box_holder_offset_x, 0, 0 ] : [ 0, 0, 0 ])
        CaliperBoxHolder(
            larger_caliper_box_holder_size_vector,
            larger_caliper_box_size_vector,
            larger_caliper_box_holder_text_label_1_offset_vector,
            larger_caliper_box_holder_text_label_2_offset_vector,
            larger_caliper_box_holder_text_label_font_size,
            larger_caliper_box_holder_svg_offset_vector,
            larger_caliper_box_holder_svg_rotation_z,
            larger_caliper_box_holder_svg_scale_vector );
}

// draw a preview of the boxes inside
if( render_mode == "preview" )
{
    // original
    translate([ ( original_caliper_box_holder_cell_offset_x + 1 ) * multiboard_cell_size - original_caliper_box_holder_offset_x + caliper_box_holder_thickness + clearance, caliper_box_holder_thickness, multiboard_connector_back_z ])
        CaliperBox( original_caliper_box_size_vector );

    // larger
    translate([ ( larger_caliper_box_holder_cell_offset_x + 1 ) * multiboard_cell_size - larger_caliper_box_holder_offset_x + caliper_box_holder_thickness + clearance, caliper_box_holder_thickness, multiboard_connector_back_z ])
        CaliperBox( larger_caliper_box_size_vector );
}

////////////////////////////////////////////////////////////////////////////////

module CaliperBoxHolder(
    holder_size_vector,
    box_size_vector,
    text_label_1_offset_vector,
    text_label_2_offset_vector,
    text_label_font_size,
    svg_offset_vector,
    svg_offset_rotation_z,
    svg_scale_size_vector )
{
    render()
    {
        union()
        {
            // back
            MultiboardConnectorBackAlt( holder_size_vector[ 0 ], holder_size_vector[ 1 ] );

            // join section
            difference()
            {
                translate([ 0, 0, multiboard_connector_back_z - corner_rounding_radius * 2 ])
                    RoundedCube(
                        size = [ holder_size_vector[ 0 ], holder_size_vector[ 1 ], corner_rounding_radius * 3 ],
                        r = corner_rounding_radius,
                        fn = 36
                        );
                
                // cut off the bottom
                translate([ 0, 0, multiboard_connector_back_z - corner_rounding_radius * 2 ])
                    cube([ holder_size_vector[ 0 ], holder_size_vector[ 1 ], corner_rounding_radius ]);
                
                // cut off the top
                translate([ 0, 0, multiboard_connector_back_z ])
                    cube([ holder_size_vector[ 0 ], holder_size_vector[ 1 ], corner_rounding_radius ]);
            }

            difference()
            {
                // start with a rounded box
                RoundedCube(
                    size = [ holder_size_vector[ 0 ], holder_size_vector[ 1 ], holder_size_vector[ 2 ] ],
                    r = corner_rounding_radius,
                    fn = 36
                    );

                // remove the back
                cube([ holder_size_vector[ 0 ], holder_size_vector[ 1 ], multiboard_connector_back_z ]);

                // remove the area for the calipers box
                translate([ caliper_box_holder_thickness, caliper_box_holder_thickness, multiboard_connector_back_z ])
                    cube([ box_size_vector[ 0 ] + clearance * 2, box_size_vector[ 1 ] + clearance, box_size_vector[ 2 ] + clearance ]);
            }
        }
    }

    color([ 0, 0, 0 ])
        translate([ text_label_1_offset_vector[ 0 ], text_label_1_offset_vector[ 1 ], holder_size_vector[ 2 ] ])
            linear_extrude( 0.5 )
                text( "Digital", size = text_label_font_size, font = "Verdana:style=Bold" ); // TODO: swap with module
    color([ 0, 0, 0 ])
        translate([ text_label_2_offset_vector[ 0 ], text_label_2_offset_vector[ 1 ], holder_size_vector[ 2 ] ])
            linear_extrude( 0.5 )
                text( "Calipers", size = text_label_font_size, font = "Verdana:style=Bold" ); // TODO: swap with module

    color([ 0, 0, 0 ])
        translate([ svg_offset_vector[ 0 ], svg_offset_vector[ 1 ], holder_size_vector[ 2 ] ])
            scale( svg_scale_size_vector )
                rotate([ 0, 0, svg_offset_rotation_z ])
                    SVG( "../../assets/calipers-svgrepo-com.svg" );
}

////////////////////////////////////////////////////////////////////////////////

module CaliperBox( box_size_vector )
{
    % cube( box_size_vector );
}

////////////////////////////////////////////////////////////////////////////////
