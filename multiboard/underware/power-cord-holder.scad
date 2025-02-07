include <../../modules/multiboard.scad>
include <../../modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

holder_x = 150;
holder_y = 150;

holder_connector_row_setups = [ [ 6, 3 ], [ 2 ] ];

cylinder_inner_r = 6.0;
cylinder_outer_r = 14.0;

cylinder_z = 25;
cylinder_lip_z = 3;

edge_wall_width = 2.2;
edge_wall_z = 5;

TOP_LEFT = 0;
TOP_RIGHT = 1;
BOTTOM_LEFT = 2;
BOTTOM_RIGHT = 3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

holder_z_offset = multiboard_connector_back_z;

peg_left_x = holder_x / 4;
peg_right_x = holder_x / 4 * 3;

peg_top_y = holder_y / 4 * 3;
peg_bottom_y = holder_y / 4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    PowerCordHolder();
}
else if( render_mode == "print" )
{
    rotate([ 90, 0, 0 ])
        PowerCordHolder();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerCordHolder()
{
    MultiboardConnectorBackAlt2( holder_x, holder_y, holder_connector_row_setups );

    translate([ peg_left_x, peg_top_y, holder_z_offset ])
        PowerCordHolderPeg( TOP_LEFT );
    translate([ peg_right_x, peg_top_y, holder_z_offset ])
        PowerCordHolderPeg( TOP_RIGHT );
    translate([ peg_left_x, peg_bottom_y, holder_z_offset ])
        PowerCordHolderPeg( BOTTOM_LEFT );
    translate([ peg_right_x, peg_bottom_y, holder_z_offset ])
        PowerCordHolderPeg( BOTTOM_RIGHT);

    translate([ 0, 0, holder_z_offset ])
        RoundedCubeAlt2( holder_x, edge_wall_width, edge_wall_z, round_bottom = false, round_top = true );
    translate([ 0, 0, holder_z_offset ])
        RoundedCubeAlt2( edge_wall_width, holder_y, edge_wall_z, round_bottom = false, round_top = true );
    translate([ 0, holder_y - edge_wall_width, holder_z_offset ])
        RoundedCubeAlt2( holder_x, edge_wall_width, edge_wall_z, round_bottom = false, round_top = true );
    translate([ holder_x - edge_wall_width, 0, holder_z_offset ])
        RoundedCubeAlt2( edge_wall_width, holder_y, edge_wall_z, round_bottom = false, round_top = true );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerCordHolderPeg( location )
{
    cylinder( h = cylinder_z, r = cylinder_inner_r );

    offset_x = location == TOP_LEFT || location == BOTTOM_LEFT
        ? ( -cylinder_outer_r + cylinder_inner_r ) * 0.5
        : ( cylinder_outer_r - cylinder_inner_r ) * 0.5;
    offset_y = location == BOTTOM_LEFT || location == BOTTOM_RIGHT
        ? ( -cylinder_outer_r + cylinder_inner_r ) * 0.5
        : ( cylinder_outer_r - cylinder_inner_r ) * 0.5;

    translate([ offset_x, offset_y, cylinder_z ])
        cylinder( h = cylinder_lip_z, r = cylinder_outer_r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
