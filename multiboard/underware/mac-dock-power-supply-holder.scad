include <../../modules/multiboard.scad>
include <../../modules/rounded-cube.scad>
include <../../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

power_strip_x = 66.0;
power_strip_y = 160.0;
power_strip_z = 33;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

wall_width = 2.2;
wall_clearance = 0.75;

top_bottom_edge_width = 8;
bottom_edge_z = 1.5;

holder_connector_row_setups = [ [ 6, 5 ], [ 4, 3 ], [ 2 ] ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

$fn = $preview ? 32 : 64;

holder_x = wall_width * 2 + wall_clearance * 2 + power_strip_x;
holder_y = wall_width * 2 + wall_clearance * 2 + power_strip_y;

holder_z_offset = multiboard_connector_back_z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // translate([ 0, 0, -multiboard_cell_height ])
    //     color( workroom_multiboard_color)
    //         MultiboardMockUpTile( 5, 10 );

    PowerStripHolder();

    translate([ wall_width + wall_clearance, wall_width, holder_z_offset ])
        PowerStripPreview();
}
else if( render_mode == "print" )
{
    rotate([ 90, 0, 0 ])
        PowerStripHolder();
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerStripHolder()
{
    // back
    MultiboardConnectorBackAlt2( holder_x, holder_y, holder_connector_row_setups );

    bottom_z = power_strip_z + wall_width + wall_clearance;

    // left - bottom
    translate([ 0, 0, multiboard_connector_back_z ])
        RoundedCubeAlt2(
            wall_width,
            holder_y,
            bottom_z,
            round_bottom = false,
            round_top = true
            );

    // right - bottom
    translate([ holder_x - wall_width, 0, multiboard_connector_back_z ])
        RoundedCubeAlt2(
            wall_width,
            holder_y,
            bottom_z,
            round_bottom = false,
            round_top = true
            );

    // bottom - left
    translate([
        0,
        holder_y - wall_width,
        multiboard_connector_back_z + bottom_z - bottom_edge_z - wall_width
        ])
        RoundedCubeAlt2(
            top_bottom_edge_width + wall_width,
            wall_width,
            wall_width + bottom_edge_z,
            round_bottom = true,
            round_top = true
            );

    // bottom - right
    translate([
        holder_x - top_bottom_edge_width - wall_width,
        holder_y - wall_width,
        multiboard_connector_back_z + bottom_z - bottom_edge_z - wall_width
        ])
        RoundedCubeAlt2(
            top_bottom_edge_width + wall_width,
            wall_width,
            wall_width + bottom_edge_z,
            round_bottom = true,
            round_top = true
            );

    // top - left
    translate([ 0, 0, multiboard_connector_back_z ])
        RoundedCubeAlt2(
            top_bottom_edge_width,
            wall_width,
            bottom_z,
            round_bottom = false,
            round_top = true
            );

    // top - right
    translate([ holder_x - top_bottom_edge_width, 0, multiboard_connector_back_z ])
        RoundedCubeAlt2(
            top_bottom_edge_width,
            wall_width,
            bottom_z,
            round_bottom = false,
            round_top = true
            );

    // front
    translate([ 0, 0, multiboard_connector_back_z + bottom_z - wall_width ])
        RoundedCubeAlt2(
            holder_x,
            holder_y,
            wall_width,
            round_bottom = false,
            round_top = true
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerStripPreview()
{
    % cube([ power_strip_x, power_strip_y, power_strip_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
