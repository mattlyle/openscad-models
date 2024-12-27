include <../modules/gridfinity-base.scad>
include <../modules/utils.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

tool_r = 15.0 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
// render_mode = "print-bin";
render_mode = "print-text";

cells_x = 2;
cells_y = 1;

// the height to be added on top of the base
top_z = 42;
// top_z=0;

wall_width = 3;
clearance_y = 2.0;

magnets_in_corners_only = false;

// offset to get away from the rounded walls
text_area_offset = 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CricutToolsBin();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CricutToolsBin()
{
    if( render_mode == "preview" || render_mode == "print-bin" )
    {
        render()
        {
            difference()
            {
                GridfinityBase(
                    cells_x,
                    cells_y,
                    top_z,
                    round_top = true,
                    center = false,
                    magnets = magnets_in_corners_only ? GRIDFINITY_BASE_MAGNETS_CORNERS_ONLY : GRIDFINITY_BASE_MAGNETS_ALL );

                // cut out the tool locations
                translate([ base_x / 5 * 1, base_y / 3 * 2, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );

                translate([ base_x / 5 * 2, base_y / 3 * 1, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );

                translate([ base_x / 5 * 3, base_y / 3 * 2, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );

                translate([ base_x / 5 * 4, base_y / 3 * 1, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );
            }
        }
    }

    if( render_mode == "preview" || render_mode == "print-text" )
    {
        text_area_x = base_x / 5 * 2 - tool_r - text_area_offset;

        translate([ text_area_offset, 12.5, holder_z ])
            CenteredTextLabel( "Cricut", centered_in_area_x = text_area_x, centered_in_area_y = -1, font_size = 5.8 );
        translate([ text_area_offset, 5, holder_z ])
            CenteredTextLabel( "Tools", centered_in_area_x = text_area_x, centered_in_area_y = -1, font_size = 5.6 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
