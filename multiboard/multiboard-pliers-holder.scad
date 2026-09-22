
include <../modules/multiboard.scad>
include <../modules/triangular-prism.scad>
include <../modules/rounded-cube.scad>
include <../modules/flattened-pyramid.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

pliers_handle_x_raw_small_medium = 17.2;
pliers_handle_x_raw_large = 20.1;

pliers_full_y = 210;

pliers_handle_z_raw_small_medium = 51.8;
pliers_handle_z_raw_large = 69.8;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-small-holder";
// render_mode = "print-small-text";
// render_mode = "print-medium-holder";
// render_mode = "print-medium-text";
// render_mode = "print-large-holder";
// render_mode = "print-large-text";
// render_mode = "print-small-3mf";
// render_mode = "print-medium-3mf";
// render_mode = "print-large-3mf";

holder_color = "white";
label_color = "black";

handle_clearance = 2;

ring_wall_width = 2.0;
ring_wall_height = 15.0;
front_face_column_width = 4.0;

floor_height_min = 2.0;
floor_height_max = 14.0;

preview_gap_x = 20;

// small version
holder_y_small = 120;
front_text_small = "Small Pliers";
holder_connector_row_setups_small = [ [ 4, 3 ], [ 2 ] ];
num_pliers_small = 6;
pliers_handle_x_small = pliers_handle_x_raw_small_medium;
pliers_handle_z_small = pliers_handle_z_raw_small_medium;

// medium version
holder_y_medium = 135;
front_text_medium = "Medium Pliers";
holder_connector_row_setups_medium = [ [ 5, 4 ], [ 3, 2 ], [ 1 ] ];
num_pliers_medium = 10;
pliers_handle_x_medium = pliers_handle_x_raw_small_medium + 2.5;
pliers_handle_z_medium = pliers_handle_z_raw_small_medium;

// large version
holder_y_large = 155;
front_text_large = "Large Pliers";
holder_connector_row_setups_large = [ [ 6, 5 ], [ 4, 3 ], [ 2, 1 ] ];
num_pliers_large = 6;
pliers_handle_x_large = pliers_handle_x_raw_large + 3;
pliers_handle_z_large = pliers_handle_z_raw_large + 20;

// this helps the two rounded cubes intersect each other without the rounded edges showing
rounded_cube_inset_overlap = 2.0;

label_font = "Liberation Sans:style=bold";
label_font_size = 8;
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

holder_x_small = ring_wall_width
    + ( pliers_handle_x_small + handle_clearance * 2 + ring_wall_width ) * num_pliers_small;
holder_z_small = multiboard_connector_back_z
    + pliers_handle_z_small
    + ring_wall_width
    + handle_clearance * 2;
holder_offset_x_small = MultiboardConnectorBackAltXOffset( holder_x_small );

holder_x_medium = ring_wall_width
    + ( pliers_handle_x_medium + handle_clearance * 2 + ring_wall_width ) * num_pliers_medium;
holder_z_medium = multiboard_connector_back_z
    + pliers_handle_z_medium
    + ring_wall_width
    + handle_clearance * 2;
holder_offset_x_medium = MultiboardConnectorBackAltXOffset( holder_x_medium );

holder_x_large = ring_wall_width
    + ( pliers_handle_x_large + handle_clearance * 2 + ring_wall_width ) * num_pliers_large;
holder_z_large = multiboard_connector_back_z
    + pliers_handle_z_large
    + ring_wall_width
    + handle_clearance * 2;
holder_offset_x_large = MultiboardConnectorBackAltXOffset( holder_x_large );

echo( "small  - X: ", holder_x_small, " Z: ", holder_z_small );
echo( "medium - X: ", holder_x_medium, " Z: ", holder_z_medium );
echo( "large  - X: ", holder_x_large, " Z: ", holder_z_large );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    tile_cells_x_small = ceil( holder_x_small / multiboard_cell_size ) + 1;
    tile_cells_y_small = ceil( holder_y_small / multiboard_cell_size ) + 1;

    tile_cells_x_medium = ceil( holder_x_medium / multiboard_cell_size ) + 1;
    tile_cells_y_medium = ceil( holder_y_medium / multiboard_cell_size ) + 1;

    tile_cells_x_large = ceil( holder_x_large / multiboard_cell_size ) + 1;
    tile_cells_y_large = ceil( holder_y_large / multiboard_cell_size ) + 1;

    offset_x_small = 0;
    offset_x_medium = offset_x_small + tile_cells_x_small * multiboard_cell_size + preview_gap_x;
    offset_x_large = offset_x_medium + tile_cells_x_medium * multiboard_cell_size + preview_gap_x;

    translate([ offset_x_small, 0, 0 ])
        PliersPreviewInstance(
            holder_x_small, holder_y_small, holder_z_small,
            num_pliers_small, pliers_handle_x_small, pliers_handle_z_small,
            holder_connector_row_setups_small, front_text_small,
            holder_offset_x_small, tile_cells_x_small, tile_cells_y_small
            );

    translate([ offset_x_medium, 0, 0 ])
        PliersPreviewInstance(
            holder_x_medium, holder_y_medium, holder_z_medium,
            num_pliers_medium, pliers_handle_x_medium, pliers_handle_z_medium,
            holder_connector_row_setups_medium, front_text_medium,
            holder_offset_x_medium, tile_cells_x_medium, tile_cells_y_medium
            );

    translate([ offset_x_large, 0, 0 ])
        PliersPreviewInstance(
            holder_x_large, holder_y_large, holder_z_large,
            num_pliers_large, pliers_handle_x_large, pliers_handle_z_large,
            holder_connector_row_setups_large, front_text_large,
            holder_offset_x_large, tile_cells_x_large, tile_cells_y_large
            );
}
else if( render_mode == "print-small-holder" )
{
    PliersHolderForPrint(
        holder_x_small, holder_y_small, holder_z_small,
        num_pliers_small, pliers_handle_x_small, pliers_handle_z_small,
        holder_connector_row_setups_small, front_text_small
        );
}
else if( render_mode == "print-small-text" )
{
    PliersHolderTextLabel( holder_x_small, holder_y_small, holder_z_small, front_text_small );
}
else if( render_mode == "print-medium-holder" )
{
    PliersHolderForPrint(
        holder_x_medium, holder_y_medium, holder_z_medium,
        num_pliers_medium, pliers_handle_x_medium, pliers_handle_z_medium,
        holder_connector_row_setups_medium, front_text_medium
        );
}
else if( render_mode == "print-medium-text" )
{
    PliersHolderTextLabel( holder_x_medium, holder_y_medium, holder_z_medium, front_text_medium );
}
else if( render_mode == "print-large-holder" )
{
    PliersHolderForPrint(
        holder_x_large, holder_y_large, holder_z_large,
        num_pliers_large, pliers_handle_x_large, pliers_handle_z_large,
        holder_connector_row_setups_large, front_text_large
        );
}
else if( render_mode == "print-large-text" )
{
    PliersHolderTextLabel( holder_x_large, holder_y_large, holder_z_large, front_text_large );
}
else if( render_mode == "print-small-3mf" )
{
    color( holder_color )
        PliersHolderForPrint(
            holder_x_small, holder_y_small, holder_z_small,
            num_pliers_small, pliers_handle_x_small, pliers_handle_z_small,
            holder_connector_row_setups_small, front_text_small
            );
    color( label_color )
        PliersHolderTextLabel( holder_x_small, holder_y_small, holder_z_small, front_text_small );
}
else if( render_mode == "print-medium-3mf" )
{
    color( holder_color )
        PliersHolderForPrint(
            holder_x_medium, holder_y_medium, holder_z_medium,
            num_pliers_medium, pliers_handle_x_medium, pliers_handle_z_medium,
            holder_connector_row_setups_medium, front_text_medium
            );
    color( label_color )
        PliersHolderTextLabel( holder_x_medium, holder_y_medium, holder_z_medium, front_text_medium );
}
else if( render_mode == "print-large-3mf" )
{
    color( holder_color )
        PliersHolderForPrint(
            holder_x_large, holder_y_large, holder_z_large,
            num_pliers_large, pliers_handle_x_large, pliers_handle_z_large,
            holder_connector_row_setups_large, front_text_large
            );
    color( label_color )
        PliersHolderTextLabel( holder_x_large, holder_y_large, holder_z_large, front_text_large );
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// renders one size's mock-up tile, holder, ghost pliers, and label together, positioned at the local origin
module PliersPreviewInstance(
    holder_x, holder_y, holder_z,
    num_pliers, pliers_handle_x, pliers_handle_z,
    holder_connector_row_setups, front_text,
    holder_offset_x, tile_cells_x, tile_cells_y )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color( workroom_multiboard_color )
            MultiboardMockUpTile( tile_cells_x, tile_cells_y );

    translate([ multiboard_cell_size - holder_offset_x, 0, 0 ])
        PliersHolder(
            holder_x, holder_y, holder_z,
            num_pliers, pliers_handle_x, pliers_handle_z,
            holder_connector_row_setups, front_text
            );

    // pliers preview
    for( i = [ 0 : num_pliers - 1 ] )
    {
        Pliers( i, holder_offset_x, pliers_handle_x, pliers_handle_z );
    }

    translate([ multiboard_cell_size - holder_offset_x, holder_y - ring_wall_height, holder_z ])
        color( label_color )
            CenteredTextLabel(
                front_text,
                font = label_font,
                font_size = label_font_size,
                centered_in_area_x = holder_x,
                centered_in_area_y = ring_wall_height
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the holder, rotated into its print orientation
module PliersHolderForPrint(
    holder_x, holder_y, holder_z,
    num_pliers, pliers_handle_x, pliers_handle_z,
    holder_connector_row_setups, front_text )
{
    rotate([ 90, 0, 0 ])
        PliersHolder(
            holder_x, holder_y, holder_z,
            num_pliers, pliers_handle_x, pliers_handle_z,
            holder_connector_row_setups, front_text
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the front label, positioned to match the print-holder orientation
module PliersHolderTextLabel( holder_x, holder_y, holder_z, front_text )
{
    rotate([ 90, 0, 0 ])
        translate([ 0, holder_y - ring_wall_height, holder_z - label_depth + DIFFERENCE_CLEARANCE ])
            CenteredTextLabel(
                front_text,
                font = label_font,
                font_size = label_font_size,
                centered_in_area_x = holder_x,
                centered_in_area_y = ring_wall_height
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PliersHolder(
    holder_x, holder_y, holder_z,
    num_pliers, pliers_handle_x, pliers_handle_z,
    holder_connector_row_setups, front_text )
{
    difference()
    {
        union()
        {
            // back
            MultiboardConnectorBackAlt2( holder_x, holder_y, holder_connector_row_setups );

            // bottom
            translate([ 0, 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                RoundedCube( holder_x, floor_height_min, holder_z - multiboard_connector_back_z + rounded_cube_inset_overlap );

            render()
            {
                difference()
                {
                    translate([ ring_wall_width, ring_wall_width, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                        cube([ holder_x - ring_wall_width * 2, floor_height_max - floor_height_min, holder_z - multiboard_connector_back_z ]);

                    for( i = [ 0 : num_pliers - 1 ] )
                    {
                        PliersHolderBaseGuide( i, pliers_handle_x, pliers_handle_z );
                    }
                }
            }

            // corner - left side
            translate([ 0, 0, holder_z - front_face_column_width ])
                RoundedCube( ring_wall_width, holder_y, front_face_column_width );

            // corner - left front
            // translate([ 0, 0, holder_z - ring_wall_width ])
            //     RoundedCube( front_face_column_width, holder_y, ring_wall_width );

            // corner - right side
            translate([ holder_x - ring_wall_width, 0, holder_z - front_face_column_width ])
                RoundedCube( ring_wall_width, holder_y, front_face_column_width );

            // corner - right front
            // translate([ holder_x - front_face_column_width, 0, holder_z - ring_wall_width ])
            //     RoundedCube( front_face_column_width, holder_y, ring_wall_width );

            // front column support
            for( i = [ 0 : num_pliers - 2 ] )
            {
                translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, holder_z - front_face_column_width ])
                    RoundedCube( ring_wall_width, holder_y, front_face_column_width );
            }

            // top ring
            translate([ 0, holder_y - ring_wall_height, 0 ])
            {
                PliersHolderRing( false, true, holder_x, holder_z );

                for( i = [ 0 : num_pliers - 2 ] )
                {
                    // Y bridge
                    translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                        PliersHolderHorizontalBridgeY( false, true, holder_z );

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
                PliersHolderRing( true, true, holder_x, holder_z );

                for( i = [ 0 : num_pliers - 2 ] )
                {
                    // Y bridge
                    translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                        PliersHolderHorizontalBridgeY( true, true, holder_z );

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
                PliersHolderRing( true, false, holder_x, holder_z );

                for( i = [ 0 : num_pliers - 2 ] )
                {
                    // Y bridge
                    translate([ ( i + 1 ) * ( handle_clearance * 2 + pliers_handle_x + ring_wall_width ), 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
                        PliersHolderHorizontalBridgeY( true, false, holder_z );
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

        // remove the inset text
        translate([ 0, holder_y - ring_wall_height, holder_z - label_depth + DIFFERENCE_CLEARANCE ])
            CenteredTextLabel(
                front_text,
                font = label_font,
                font_size = label_font_size,
                centered_in_area_x = holder_x,
                centered_in_area_y = ring_wall_height,
                depth = label_depth,
                color = undef
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PliersHolderBaseGuide( i, pliers_handle_x, pliers_handle_z )
{
    pyramid_x = pliers_handle_x + handle_clearance * 2;
    pyramid_y = pliers_handle_z + handle_clearance * 2;
    pyramid_z = floor_height_max - floor_height_min;

    translate([ ring_wall_width + i * ( ring_wall_width + handle_clearance * 2 + pliers_handle_x ), floor_height_max, multiboard_connector_back_z ])
        rotate([ 90, 0, 0 ])
            FlattenedPyramid( pyramid_x, pyramid_y, pyramid_x / 2, pyramid_y / 3, pyramid_z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PliersHolderRing( add_top_supports, add_bottom_supports, holder_x, holder_z )
{
    // left
    translate([ 0, 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
        PliersHolderHorizontalBridgeY( add_top_supports, add_bottom_supports, holder_z );

    // front
    translate([ 0, 0, holder_z - ring_wall_width ])
        RoundedCube( holder_x, ring_wall_height, ring_wall_width );

    // right
    translate([ holder_x - ring_wall_width, 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
        PliersHolderHorizontalBridgeY( add_top_supports, add_bottom_supports, holder_z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PliersHolderHorizontalBridgeY( add_top_supports, add_bottom_supports, holder_z )
{
    // horizontal bar
    RoundedCube( ring_wall_width, ring_wall_height, holder_z - multiboard_connector_back_z + rounded_cube_inset_overlap );

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
                    RoundedCube( ring_wall_width, support_edge_length, support_edge_length );

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
                    RoundedCube( ring_wall_width, support_edge_length, support_edge_length );

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
                    RoundedCube( ring_wall_width, support_edge_length, support_edge_length );

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
                    RoundedCube( ring_wall_width, support_edge_length, support_edge_length );

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Pliers( i, holder_offset_x, pliers_handle_x, pliers_handle_z )
{
    % translate([ multiboard_cell_size - holder_offset_x + ring_wall_width + handle_clearance + i * ( ring_wall_width + handle_clearance * 2 + pliers_handle_x ), floor_height_min + handle_clearance, multiboard_connector_back_z + handle_clearance ])
        cube([ pliers_handle_x, pliers_full_y, pliers_handle_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
