////////////////////////////////////////////////////////////////////////////////////////////////////

include <../../modules/utils.scad>
include <../../modules/multiboard.scad>
include <../../modules/rounded-cube.scad>
include <../../modules/triangular-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

office_desk_powerstrip_x = 102.3;
office_desk_powerstrip_y = 266.0;
office_desk_powerstrip_z = 26.3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// TODO: maybe fix the overhangs in the corners?  but hard to print and likely not worth it since just under the desk
// TODO: better bottom so I don't put it in backwards

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

overhang_top_slant_y = 10;
overhang_side_slant_y = 10;

holder_connector_row_setups = [ [ 10, 9 ], [ 3, 2 ] ];

rounding_r = 0.7;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

holder_x = office_desk_powerstrip_x + wall_width * 2 + wall_clearance * 2;
holder_y = office_desk_powerstrip_y + wall_width * 2 + wall_clearance * 2;
holder_wall_z = office_desk_powerstrip_z / 2;

holder_z_offset = multiboard_connector_back_z;

holder_overhang_offset_z = office_desk_powerstrip_z + wall_clearance;

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
    MultiboardConnectorBackAlt2( holder_x, holder_y, holder_connector_row_setups, rounding_r );

    // left wall
    translate([ 0, 0, holder_z_offset ])
        RoundedCubeAlt2( wall_width, holder_y, holder_wall_z, r = rounding_r, round_bottom = false, round_top = true );

    // right wall
    translate([ holder_x - wall_width, 0, holder_z_offset ])
        RoundedCubeAlt2( wall_width, holder_y, holder_wall_z, r = rounding_r, round_bottom = false, round_top = true );

    // bottom
    // translate([ 0, 0, holder_z_offset ])
    //     RoundedCubeAlt2( holder_x, wall_width, bottom_ledge_z, r = rounding_r, round_bottom = false, round_top = true );

    // top
    // translate([ holder_x - rounding_r, holder_y, holder_z_offset ])
    //     rotate([ 180, 180, 0 ])
    //         TriangularPrism( holder_x - rounding_r * 2, wall_width, top_ledge_z );

    // overhangs
    translate([ 0, 0, holder_z_offset ])
    {
        _OverhangHelper( false, true ); // bottom-left
        _OverhangHelper( false, false ); // bottom-right
        _OverhangHelper( true, true ); // top-left
        _OverhangHelper( true, false ); // top-right
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _OverhangHelper( is_top, is_left )
{
    x = is_top ? top_overhang_x : bottom_overhang_x;
    y = is_top ? top_overhang_y : bottom_overhang_y;
    slant_y = is_top ? overhang_top_slant_y : overhang_side_slant_y;

    top_overhang_translate_v = is_top
        ? is_left
            ? [ rounding_r, holder_y, wall_width ] // top left
            : [ holder_x, holder_y, 0 ] // top right
        : is_left
            ? [ rounding_r, 0, 0 ] // bottom left
            : [ holder_x - rounding_r, 0, wall_width ]; // bottom right

    top_overhang_rotate_v = is_top
        ? is_left
            ? [ 0, 180, 180 ] // top left
            : [ 0, 0, 180 ] // top right
        : is_left
            ? [ 0, 0, 0 ] // bottom left
            : [ 0, 180, 0 ]; // bottom right

    // overhang top
    translate([ 0, 0, holder_overhang_offset_z ])
    {
        translate( top_overhang_translate_v )
        {
            rotate( top_overhang_rotate_v )
            {
                hull()
                {
                    // bottom face
                    translate([ rounding_r, rounding_r, rounding_r ])
                        sphere( r = rounding_r );
                    translate([ x - rounding_r, rounding_r, rounding_r ])
                        sphere( r = rounding_r );
                    translate([ rounding_r, y - rounding_r, rounding_r ])
                        sphere( r = rounding_r );
                    translate([ x - rounding_r, y - slant_y, rounding_r ])
                        sphere( r = rounding_r );

                    // top face
                    translate([ rounding_r, rounding_r, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                    translate([ x - rounding_r, rounding_r, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                    translate([ rounding_r, y - rounding_r, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                    translate([ x - rounding_r, y - slant_y, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                }
            }
        }
    }

    side_wall_offset_z = office_desk_powerstrip_z -holder_wall_z;
    side_translate_v = is_top
        ? is_left
            ? [ wall_width, holder_y, 0 ] // top left
            : [ holder_x, holder_y, 0 ] // top right
        : is_left
            ? [ 0, 0, 0 ] // bottom left
            : [ holder_x - wall_width, 0, 0 ]; // bottom right

    side_rotate_v = is_top
        ? is_left
            ? [ 0, 0, 180 ] // top left
            : [ 0, 0, 180 ] // top right
        : is_left
            ? [ 0, 0, 0 ] // bottom left
            : [ 0, 0, 0 ]; // bottom right

    // side
    translate([ 0, 0, holder_overhang_offset_z ])
    {
        translate( side_translate_v )
        {
            rotate( side_rotate_v )
            {
                hull()
                {
                    // left face
                    #translate([ rounding_r, rounding_r, -side_wall_offset_z - rounding_r - wall_clearance ])
                        sphere( r = rounding_r );
                    translate([ rounding_r, rounding_r, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                    translate([ rounding_r, y - rounding_r, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                    translate([ rounding_r, y + slant_y, -side_wall_offset_z - rounding_r - wall_clearance ])
                        sphere( r = rounding_r );

                    // right face
                    translate([ wall_width - rounding_r, rounding_r, -side_wall_offset_z - rounding_r - wall_clearance ])
                        sphere( r = rounding_r );
                    translate([ wall_width - rounding_r, rounding_r, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                    translate([ wall_width - rounding_r, y - rounding_r, wall_width - rounding_r ])
                        sphere( r = rounding_r );
                    translate([ wall_width - rounding_r, y + slant_y, -side_wall_offset_z - rounding_r - wall_clearance ])
                        sphere( r = rounding_r );
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OfficeDeskPowerStripPreview()
{
    % cube([ office_desk_powerstrip_x, office_desk_powerstrip_y, office_desk_powerstrip_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
