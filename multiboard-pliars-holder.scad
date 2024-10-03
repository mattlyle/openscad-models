include <modules/multiboard.scad>
include <modules/triangular-prism.scad>
include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "only-holder";
// render_mode = "";

num_pliars = 2;

handle_clearance = 2;

ring_wall_width = 2.0;
ring_wall_height = 20.0;

floor_height_min = 2.0;
floor_height_max = 6.0;

holder_y = 110;

rounded_cube_inset_overlap = 2.0;

// TODO: first print, use num = 2

////////////////////////////////////////////////////////////////////////////////
// measurements

pliars_handle_x = 17.2;

// pliars_handle_to_pivot_y = 101.2;
// pliars_top_y = 12.0;
pliars_full_y = 210;

pliars_handle_z = 51.8;

////////////////////////////////////////////////////////////////////////////////
// calculations

holder_x = ring_wall_width + ( pliars_handle_x + handle_clearance * 2 + ring_wall_width ) * num_pliars;
holder_z = multiboard_connector_back_z + pliars_handle_z + ring_wall_width + handle_clearance * 2;

holder_offset_x = MultiboardConnectorBackAltXOffset( holder_x );

////////////////////////////////////////////////////////////////////////////////

// draw a sample multiboard tile
if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
            MultiboardMockUpTile( 12, 4 );
}

// draw the holder
if( render_mode == "preview" || render_mode == "only-holder" )
{
    translate( render_mode == "preview" ? [ multiboard_cell_size - holder_offset_x, 0, 0 ] : [ 0, 0, 0 ])
        PliarsHolder();
}

// draw a preview of the pliars inside
if( render_mode == "preview" )
{
    // pliars preview
    for( i = [ 0 : num_pliars - 1 ] )
    {
    // i = 0;
        translate([ multiboard_cell_size - holder_offset_x, 0, 0 ])
        translate([ ring_wall_width + handle_clearance + i * ( ring_wall_width + handle_clearance * 2 + pliars_handle_x ), floor_height_min + handle_clearance, multiboard_connector_back_z + handle_clearance ])
            Pliars();
    }
}

////////////////////////////////////////////////////////////////////////////////

module PliarsHolder()
{
    union()
    {
        // back
        // MultiboardConnectorBackAlt( holder_x, holder_y );

        // bottom
        translate([ 0, 0, multiboard_connector_back_z - rounded_cube_inset_overlap ])
            RoundedCubeAlt( holder_x, floor_height_min, holder_z - multiboard_connector_back_z + rounded_cube_inset_overlap );

        // add back floor guide slope
        // translate([ ring_wall_width, floor_height_min, multiboard_connector_back_z ])
        //     TriangularPrism( holder_x - ring_wall_width * 2, floor_height_max - floor_height_min, ( holder_z - multiboard_connector_back_z ) / 2 );

        // TODO: these slopes are wrong

        // add near floor guide slope
        // translate([ holder_x - ring_wall_width, floor_height_min, multiboard_connector_back_z + holder_z - multiboard_connector_back_z ])
        //     rotate([ 0, 180, 0 ])
        //         TriangularPrism( holder_x - ring_wall_width * 2, floor_height_max - floor_height_min, ( holder_z - multiboard_connector_back_z ) / 2 );

        // top ring - left
        translate([ 0, holder_y - ring_wall_height, 0 ])
            RoundedCubeAlt( ring_wall_width, ring_wall_height, holder_z + multiboard_connector_back_z );
        // TODO: this will need supports?!

        // top ring - front
        // TODO: finish

        // top ring - right
        // translate([ holder_x - ring_wall_width, holder_y - ring_wall_height, 0 ])
        //     RoundedCubeAlt( ring_wall_width, ring_wall_height, holder_z + multiboard_connector_back_z );
        // TODO: this will need supports?!

        // dividers
        // for( i = [ 0 : num_pliars - 2 ] )
        // {
        //     translate([ multiboard_cell_size - holder_offset_x + ring_wall_width * 2 + handle_clearance * 2 + i * ( ring_wall_width + handle_clearance * 2 + pliars_handle_x ), holder_y - ring_wall_height, 0 ])
        //         RoundedCubeAlt( ring_wall_width, ring_wall_height, holder_z + multiboard_connector_back_z );
        // }

        // middle ring
        // TODO: finish

        // bottom ring
        // TODO finish
    }
}

////////////////////////////////////////////////////////////////////////////////

module Pliars()
{
    % translate([ 0, 0, 0 ])
        cube([ pliars_handle_x, pliars_full_y, pliars_handle_z ]);
}

////////////////////////////////////////////////////////////////////////////////
