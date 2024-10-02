include <modules/multiboard.scad>

////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "only-holder";
// render_mode = "";

num_pliars = 8;

handle_clearance = 2;

////////////////////////////////////////////////////////////////////////////////
// measurements

pliars_handle_x = 17.2;
pliars_handle_y = 51.8;
pliars_handle_to_pivot_z = 101.2;
pliars_top_x = 12.0;
pliars_full_z = 210;

////////////////////////////////////////////////////////////////////////////////
// calculations

holder_x = ( pliars_handle_x + handle_clearance * 2 ) * num_pliars;
holder_y = 100;

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
    // back
    // translate( render_mode == "preview" ? [ ( original_caliper_box_holder_cell_offset_x + 1 ) * multiboard_cell_size - original_caliper_box_holder_offset_x, 0, 0 ] : [ 0, 0, 0 ])
    //     PliarsHolder();

}

// draw a preview of the pliars inside
if( render_mode == "preview" )
{
    // Pliars();
}

////////////////////////////////////////////////////////////////////////////////

module PliarsHolder()
{
    MultiboardConnectorBackAlt( holder_x, holder_y );
}

////////////////////////////////////////////////////////////////////////////////

module Pliars()
{
    % translate([ 0, pliars_full_z, 0 ])
        rotate([ 90, 0, 0 ])
            cube([ pliars_handle_x, pliars_handle_y, pliars_full_z ]);
}

////////////////////////////////////////////////////////////////////////////////
