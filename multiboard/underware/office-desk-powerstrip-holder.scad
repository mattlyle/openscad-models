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
wall_clearance = 0.2;

bottom_ledge_z = 3;
top_ledge_z = 1.5;

bottom_overhang_x = 25;
bottom_overhang_y = 60;

top_overhang_x = 15;
top_overhang_y = 50;

overhand_slant_y_percent = 0.5;

holder_connector_row_setups = [ [ 10, 9 ], [ 3, 2 ] ];

rounding_r = 0.7;

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
        RoundedCubeAlt2( wall_width, holder_y, office_desk_powerstrip_z + wall_width + wall_clearance, r = rounding_r, round_bottom = false, round_top = true );

    // right wall
    translate([ holder_x - wall_width, 0, holder_z_offset ])
        RoundedCubeAlt2( wall_width, holder_y, office_desk_powerstrip_z + wall_width + wall_clearance, r = rounding_r, round_bottom = false, round_top = true );

    // bottom
    translate([ 0, 0, holder_z_offset ])
        RoundedCubeAlt2( holder_x, wall_width, bottom_ledge_z, r = rounding_r, round_bottom = false, round_top = true );

    // top
    translate([ 0, holder_y - wall_width, holder_z_offset ])
        RoundedCubeAlt2( holder_x, wall_width, top_ledge_z, r = rounding_r, round_bottom = false, round_top = true );

    // bottom-left overhang
    translate([ 0, 0, holder_z_offset + holder_z - wall_width ])
        _OverhangHelper(
            bottom_overhang_x + wall_width + wall_clearance,
            bottom_overhang_y,
            overhand_slant_y_percent
            );

    // bottom-right overhang
    translate([ holder_x, 0, holder_z_offset + holder_z ])
        rotate([ 0, 180, 0 ])
            _OverhangHelper(
                bottom_overhang_x + wall_width + wall_clearance,
                bottom_overhang_y,
                overhand_slant_y_percent
                );

    // top-left overhang
    translate([ 0, holder_y, holder_z_offset + holder_z ])
        rotate([ 180, 0, 0 ])
            _OverhangHelper(
                top_overhang_x + wall_width + wall_clearance,
                top_overhang_y,
                overhand_slant_y_percent
                );

    // top-right overhang
    translate([ holder_x, holder_y, holder_z_offset + holder_z - wall_width ])
        rotate([ 180, 180, 0 ])
            _OverhangHelper(
                top_overhang_x,
                top_overhang_y,
                overhand_slant_y_percent
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _OverhangHelper( x, y, y_percent )
{
    // %RoundedCubeAlt2( x, y, wall_width, r = rounding_r, round_bottom = false, round_top = true );

    hull()
    {
        translate([ rounding_r, rounding_r, rounding_r ])
            sphere( r = rounding_r );
        translate([ x - rounding_r, rounding_r, rounding_r ])
            sphere( r = rounding_r );
        translate([ rounding_r, y - rounding_r, rounding_r ])
            sphere( r = rounding_r );
        translate([ x - rounding_r, y * y_percent, rounding_r ])
            sphere( r = rounding_r );

        translate([ rounding_r, rounding_r, wall_width - rounding_r ])
            sphere( r = rounding_r );
        translate([ x - rounding_r, rounding_r, wall_width - rounding_r ])
            sphere( r = rounding_r );
        translate([ rounding_r, y - rounding_r, wall_width - rounding_r ])
            sphere( r = rounding_r );
        translate([ x - rounding_r, y * y_percent, wall_width - rounding_r ])
            sphere( r = rounding_r );
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OfficeDeskPowerStripPreview()
{
    % cube([ office_desk_powerstrip_x, office_desk_powerstrip_y, office_desk_powerstrip_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
