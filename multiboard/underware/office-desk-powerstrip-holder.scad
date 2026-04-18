////////////////////////////////////////////////////////////////////////////////////////////////////

include <../../modules/utils.scad>
include <../../modules/multiboard.scad>
include <../../modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

office_desk_powerstrip_x = 102.3;
office_desk_powerstrip_y = 266.0;
office_desk_powerstrip_z = 26.3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

wall_width = 2.2;
wall_clearance = 0.5;

bottom_ledge_z = 3;
top_ledge_z = 1.5;

bottom_overhang_x = 25;
bottom_overhang_y = 50;

top_overhang_x = 15;
top_overhang_y = 40;

holder_connector_row_setups = [ [ 2, 1 ] ];

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 128 : 256;

holder_x = office_desk_powerstrip_x + wall_width * 2 + wall_clearance * 2;
holder_y = office_desk_powerstrip_y + wall_width * 2 + wall_clearance * 2;
holder_z = office_desk_powerstrip_z + wall_width + wall_clearance;

holder_z_offset = multiboard_connector_back_z;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color( workroom_multiboard_color)
            MultiboardMockUpTile( 6, 15 );

    OfficeDeskPowerStripHolder();

    translate([ wall_width + wall_clearance, wall_width, holder_z_offset ])
        OfficeDeskPowerStripPreview();
}
else if( render_mode == "print" )
{
    rotate([ 90, 0, 0 ])
        OfficeDeskPowerStripHolder();
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OfficeDeskPowerStripHolder()
{
    // back
    MultiboardConnectorBackAlt2( holder_x, holder_y, holder_connector_row_setups );

    // left wall
    translate([ 0, 0, holder_z_offset ])
        RoundedCubeAlt2( wall_width, holder_y, office_desk_powerstrip_z + wall_width + wall_clearance, round_bottom = false, round_top = true );

    // right wall
    translate([ holder_x - wall_width, 0, holder_z_offset ])
        RoundedCubeAlt2( wall_width, holder_y, office_desk_powerstrip_z + wall_width + wall_clearance, round_bottom = false, round_top = true );

    // bottom
    translate([ 0, 0, holder_z_offset ])
        RoundedCubeAlt2( holder_x, wall_width, bottom_ledge_z, round_bottom = false, round_top = true );

    // top
    translate([ 0, holder_y - wall_width, holder_z_offset ])
        RoundedCubeAlt2( holder_x, wall_width, top_ledge_z, round_bottom = false, round_top = true );

    // bottom-left overhang
    translate([ 0, 0, holder_z_offset + holder_z - wall_width ])
        RoundedCubeAlt2( bottom_overhang_x, bottom_overhang_y, wall_width, round_bottom = false, round_top = true );

    // bottom-right overhang
    translate([ holder_x - bottom_overhang_x, 0, holder_z_offset + holder_z - wall_width ])
        RoundedCubeAlt2( bottom_overhang_x, bottom_overhang_y, wall_width, round_bottom = false, round_top = true );

    // top-left overhang
    translate([ 0, holder_y - top_overhang_y, holder_z_offset + holder_z - wall_width ])
        RoundedCubeAlt2( top_overhang_x, top_overhang_y, wall_width, round_bottom = false, round_top = true );

    // top-right overhang
    translate([ holder_x - top_overhang_x, holder_y - top_overhang_y, holder_z_offset + holder_z - wall_width ])
        RoundedCubeAlt2( top_overhang_x, top_overhang_y, wall_width, round_bottom = false, round_top = true );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OfficeDeskPowerStripPreview()
{
    % cube([ office_desk_powerstrip_x, office_desk_powerstrip_y, office_desk_powerstrip_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
