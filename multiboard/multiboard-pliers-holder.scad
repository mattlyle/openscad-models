use <../../3rd-party/MCAD/regular_shapes.scad>

include <../modules/multiboard.scad>
include <../modules/triangular-prism.scad>
include <../modules/rounded-cube.scad>
include <../modules/flattened-pyramid.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////
// measurements

pliers_handle_x_small_medium = 17.2;
pliers_handle_x_large = 20.1;

// pliers_handle_to_pivot_y = 101.2;
// pliers_top_y = 12.0;
pliers_full_y = 210;

pliers_handle_z_small_medium = 51.8;
pliers_handle_z_large = 69.8;

////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
render_mode = "only-holder";
// render_mode = "text-only";

handle_clearance = 2;

ring_wall_width = 2.0;
ring_wall_height = 15.0;
front_face_column_width = 4.0;

floor_height_min = 2.0;
floor_height_max = 14.0;

// small version
holder_y = 120;
front_text = "Small Pliers";
holder_connector_row_setups = [ [4,3], [2] ];
num_pliers = 4;
pliers_handle_x = pliers_handle_x_small_medium;
pliers_handle_z = pliers_handle_z_small_medium;

// medium version
// holder_y = 135;
// front_text = "Medium Pliers";
// holder_connector_row_setups = [ [5,4], [3,2], [1] ];
// num_pliers = 8;
// pliers_handle_x = pliers_handle_x_small_medium;
// pliers_handle_z = pliers_handle_z_small_medium;

// large version
// holder_y = 155;
// front_text = "Large Pliers";
// holder_connector_row_setups = [ [6,5], [4,3], [2,1] ];
// num_pliers = 4;
// pliers_handle_x = pliers_handle_x_large;
// pliers_handle_z = pliers_handle_z_large;

// this helps the two rounded cubes intersect each other without the rounded edges showing
rounded_cube_inset_overlap = 2.0;

////////////////////////////////////////////////////////////////////////////////
// calculations

holder_x = ring_wall_width + ( pliers_handle_x + handle_clearance * 2 + ring_wall_width ) * num_pliers;
holder_z = multiboard_connector_back_z + pliers_handle_z + ring_wall_width + handle_clearance * 2;

holder_offset_x = MultiboardConnectorBackAltXOffset( holder_x );

////////////////////////////////////////////////////////////////////////////////

// draw a sample multiboard tile
if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color( workroom_multiboard_color )
            MultiboardMockUpTile( 6, 6 );
}

// draw the holder
if( render_mode == "preview" || render_mode == "only-holder" )
{
    translate( render_mode == "preview" ? [ multiboard_cell_size - holder_offset_x, 0, 0 ] : [ 0, 0, 0 ])
        rotate( render_mode == "only-holder" ? [ 90, 0, 0 ]: [ 0, 0, 0 ] )
            PliersHolder();
}

// draw a preview of the pliers inside
if( render_mode == "preview" )
{
    // pliers preview
    for( i = [ 0 : num_pliers - 1 ] )
    {
        Pliers( i );
    }
}

// if( render_mode == "preview" || render_mode == "text-only" )
if( render_mode == "preview" || render_mode == "only-holder" )
{
    rotate( render_mode == "only-holder" ? [ 90, 0, 0 ]: [ 0, 0, 0 ] )
        translate([ render_mode == "preview" ?  multiboard_cell_size - holder_offset_x : 0, holder_y - ring_wall_height, holder_z ])
            color([ 0, 0, 0.4 ])
                CenteredTextLabel( front_text, font_size = 8, centered_in_area_x = holder_x, centered_in_area_y = ring_wall_height );
}

////////////////////////////////////////////////////////////////////////////////

module PliersHolder()
{
    union()
    {
        // back
        MultiboardConnectorBackAlt2( holder_x, holder_y, holder_connector_row_setups );

        // bottom
        translate([ 0, 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
            RoundedCubeAlt( holder_x, floor_height_min, holder_z - multiboard_connector_back_z + rounded_cube_inset_overlap );

        render()
        {
            difference()
            {
                translate([ ring_wall_width, ring_wall_width, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                    cube([ holder_x - ring_wall_width * 2, floor_height_max - floor_height_min, holder_z - multiboard_connector_back_z ]);

                for( i = [ 0 : num_pliers - 1 ] )
                {
                    PliersHolderBaseGuide( i );
                }
            }
        }

        // corner - left side
        translate([ 0, 0, holder_z - front_face_column_width ])
            RoundedCubeAlt( ring_wall_width, holder_y, front_face_column_width );

        // corner - left front
        // translate([ 0, 0, holder_z - ring_wall_width ])
        //     RoundedCubeAlt( front_face_column_width, holder_y, ring_wall_width );

        // corner - right side
        translate([ holder_x - ring_wall_width, 0, holder_z - front_face_column_width ])
            RoundedCubeAlt( ring_wall_width, holder_y, front_face_column_width );

        // corner - right front
        // translate([ holder_x - front_face_column_width, 0, holder_z - ring_wall_width ])
        //     RoundedCubeAlt( front_face_column_width, holder_y, ring_wall_width );

        // front column support
        for( i = [ 0 : num_pliers - 2 ] )
        {
            translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, holder_z - front_face_column_width ])
                RoundedCubeAlt( ring_wall_width, holder_y, front_face_column_width );
        }

        // top ring
        translate([ 0, holder_y - ring_wall_height, 0 ])
        {
            PliersHolderRing( false, true );

            for( i = [ 0 : num_pliers - 2 ] )
            {
                // Y bridge
                translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                    PliersHolderHorizontalBridgeY( false, true );

                // X support
                for( i = [ 0 : num_pliers - 1 ] )
                {
                    translate([ ring_wall_width / 2 + i * ( ring_wall_width + pliers_handle_x + handle_clearance * 2 ), 0, holder_z ])
                        rotate([ 0, 90, 0 ])
                            PliersHolderHorizontalBridgeLowerSupport( pliers_handle_x + handle_clearance * 2 + ring_wall_width );
                }
            }
        }

        // middle ring
        translate([ 0, ( holder_y - ring_wall_height ) / 2, 0 ])
        {
            PliersHolderRing( true, true );

            for( i = [ 0 : num_pliers - 2 ] )
            {
                // Y bridge
                translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                    PliersHolderHorizontalBridgeY( true, true );

                // X support
                for( i = [ 0 : num_pliers - 1 ] )
                {
                    translate([ ring_wall_width / 2 + i * ( ring_wall_width + pliers_handle_x + handle_clearance * 2 ), 0, holder_z ])
                    {
                        rotate([ 0, 90, 0 ])
                        {
                            // top support
                            PliersHolderHorizontalBridgeUpperSupport( pliers_handle_x + handle_clearance * 2 + ring_wall_width );

                            // bottom support
                            PliersHolderHorizontalBridgeLowerSupport( pliers_handle_x + handle_clearance * 2 + ring_wall_width );
                        }
                    }
                }
            }
        }

        // bottom ring
        translate([ 0, 0, 0 ])
        {
            PliersHolderRing( true, false );

            for( i = [ 0 : num_pliers - 2 ] )
            {
                // Y bridge
                translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                    PliersHolderHorizontalBridgeY( true, false );
            }

            // X support
            for( i = [ 0 : num_pliers - 1 ] )
            {
                translate([ ring_wall_width / 2 + i * ( ring_wall_width + pliers_handle_x + handle_clearance * 2 ), 0, holder_z ])
                    rotate([ 0, 90, 0 ])
                        PliersHolderHorizontalBridgeUpperSupport( pliers_handle_x + handle_clearance * 2 + ring_wall_width );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module PliersHolderBaseGuide( i )
{
    pyramid_x = pliers_handle_x + handle_clearance * 2;
    pyramid_y = pliers_handle_z + handle_clearance * 2;
    pyramid_z = floor_height_max - floor_height_min;

    translate([ ring_wall_width + i * ( ring_wall_width + handle_clearance * 2 + pliers_handle_x ), floor_height_max, multiboard_connector_back_z ])
        rotate([ 90, 0, 0 ])
            FlattenedPyramid( pyramid_x, pyramid_y, pyramid_x / 2, pyramid_y / 3, pyramid_z );
}

////////////////////////////////////////////////////////////////////////////////

module PliersHolderRing( add_top_supports, add_bottom_supports )
{
    // left
    translate([ 0, 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
        PliersHolderHorizontalBridgeY( add_top_supports, add_bottom_supports );

    // front
    translate([ 0, 0, holder_z - ring_wall_width ])
        RoundedCubeAlt( holder_x, ring_wall_height, ring_wall_width );

    // right
    translate([ holder_x - ring_wall_width, 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
        PliersHolderHorizontalBridgeY( add_top_supports, add_bottom_supports );
}

////////////////////////////////////////////////////////////////////////////////

module PliersHolderHorizontalBridgeY( add_top_supports, add_bottom_supports )
{
    // horizontal bar
    RoundedCubeAlt( ring_wall_width, ring_wall_height, holder_z - multiboard_connector_back_z + rounded_cube_inset_overlap );

    support_span_length = holder_z - multiboard_connector_back_z - ring_wall_width + rounded_cube_inset_overlap;

    if( add_top_supports )
    {
        PliersHolderHorizontalBridgeUpperSupport( support_span_length );
    }

    if( add_bottom_supports )
    {
        PliersHolderHorizontalBridgeLowerSupport( support_span_length );
    }
}

////////////////////////////////////////////////////////////////////////////////

module PliersHolderHorizontalBridgeUpperSupport( support_span_length )
{
    support_edge_length = support_span_length / 2 / sin( 45 );

    // near support
    translate([ 0, ring_wall_height - rounded_cube_inset_overlap, -support_span_length / 2 ])
    {
        render()
        {
            difference()
            {
                rotate([ 45, 0, 0 ])
                    RoundedCubeAlt( ring_wall_width, support_edge_length, support_edge_length );
                    
                // remove the bottom
                translate([ 0, -support_span_length / 2, 0 ])
                    cube([ ring_wall_width, support_span_length / 2, support_span_length ]);
                
                // remove the side
                translate([ 0, -support_span_length / 2, 0 ])
                    cube([ ring_wall_width, support_span_length, support_span_length / 2 ]);
            }
        }
    }

    // far support
    translate([ 0, ring_wall_height - rounded_cube_inset_overlap, support_span_length / 2 ])
    {
        render()
        {
            difference()
            {
                rotate([ 45, 0, 0 ])
                    RoundedCubeAlt( ring_wall_width, support_edge_length, support_edge_length );

                // remove the bottom
                translate([ 0, -support_span_length / 2, 0 ])
                    cube([ ring_wall_width, support_span_length / 2, support_span_length ]);

                // remove the side
                translate([ 0, -support_span_length / 2, support_span_length / 2 ])
                    cube([ ring_wall_width, support_span_length, support_span_length / 2 ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module PliersHolderHorizontalBridgeLowerSupport( support_span_length )
{
    support_edge_length = support_span_length / 2 / sin( 45 );

    // rear support
    translate([ 0, rounded_cube_inset_overlap, -support_span_length / 2 ])
    {
        render()
        {
            difference()
            {
                rotate([ 45, 0, 0 ])
                    RoundedCubeAlt( ring_wall_width, support_edge_length, support_edge_length );
                    
                // remove the top
                translate([ 0, 0, 0 ])
                    cube([ ring_wall_width, support_span_length / 2, support_span_length ]);
                
                // remove the side
                translate([ 0, -support_span_length / 2, 0 ])
                    cube([ ring_wall_width, support_span_length, support_span_length / 2 ]);
            }
        }
    }

    // front support
    translate([ 0, rounded_cube_inset_overlap, support_span_length / 2 ])
    {
        render()
        {
            difference()
            {
                rotate([ 45, 0, 0 ])
                    RoundedCubeAlt( ring_wall_width, support_edge_length, support_edge_length );

                // remove the top
                translate([ 0, 0, 0 ])
                    cube([ ring_wall_width, support_span_length / 2, support_span_length ]);

                // remove the side
                translate([ 0, -support_span_length / 2, support_span_length / 2 ])
                    cube([ ring_wall_width, support_span_length, support_span_length / 2 ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module Pliers( i )
{
    % translate([ multiboard_cell_size - holder_offset_x + ring_wall_width + handle_clearance + i * ( ring_wall_width + handle_clearance * 2 + pliers_handle_x ), floor_height_min + handle_clearance, multiboard_connector_back_z + handle_clearance ])
        cube([ pliers_handle_x, pliers_full_y, pliers_handle_z ]);
}

////////////////////////////////////////////////////////////////////////////////
