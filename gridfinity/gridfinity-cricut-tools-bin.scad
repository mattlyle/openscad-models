include <../modules/gridfinity-base.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// (including clearance)
tool_r = ( 13.6 + 1.4 ) / 2;
burnishing_tool_x = 60.0 + 4;
burnishing_tool_y = 11.1 + 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";

cells_x = 2;
cells_y = 2;

// the height to be added on top of the base
top_z = 42;

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
                translate([ base_x / 5 * 1, base_y / 4 * 3, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );
                translate([ base_x / 5 * 2, base_y / 4 * 2, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );
                translate([ base_x / 5 * 3, base_y / 4 * 3, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );
                translate([ base_x / 5 * 4, base_y / 4 * 2, offset_z ])
                    cylinder( r = tool_r, h = top_z, $fn = 32 );

                // cut out burnishing tool
                translate([ calculateOffsetToCenter( base_x, burnishing_tool_x ), base_y / 4 * 1 - burnishing_tool_y, offset_z ])
                    cube([ burnishing_tool_x, burnishing_tool_y, top_z ]);
            }
        }
    }

    if( render_mode == "preview" || render_mode == "print-text" )
    {
        translate([ text_area_offset + 12, text_area_offset + 22, holder_z ])
            TextLabel( "Cricut Tools", font_size = 7, font = "Liberation Sans:style=Bold" );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
