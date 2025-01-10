include <../modules/gridfinity-base.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

deburring_tool_r = 8.5 / 2;

deburring_blades_x = 61.5;
deburring_blades_y = 4.8;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "print-bin";

cells_x = 2;
cells_y = 1;

// the height to be added on top of the base
top_z = 42.0;

clearance = 1.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

deburring_tool_offset_x = base_x / 2;
deburring_tool_offset_y = calculateEquallySpacedOffset( [ deburring_tool_r * 2, deburring_blades_y ], base_y, clearance, 0 ) + deburring_tool_r;

deburring_blades_offset_x = calculateOffsetToCenter( base_x, deburring_blades_x + clearance * 2 );
deburring_blades_offset_y = calculateEquallySpacedOffset( [ deburring_tool_r * 2, deburring_blades_y ], base_y, clearance, 1 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    DeburringToolBin();

    translate([ deburring_tool_offset_x, deburring_tool_offset_y, offset_z ])
        DeburringToolPreview();

    translate([ deburring_blades_offset_x, deburring_blades_offset_y, offset_z ])
        DeburringBladesPreview();
}
else if( render_mode == "print-bin" )
{
    DeburringToolBin();
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeburringToolBin()
{
    text_area_offset_y = 0;
    text_area_y = 0;

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
                magnets = GRIDFINITY_BASE_MAGNETS_ALL );

            // cut out the blades section
            translate([ deburring_blades_offset_x, deburring_blades_offset_y - clearance, offset_z ])
                cube([ deburring_blades_x + clearance * 2, deburring_blades_y + clearance * 2, holder_z ]);

            // cut out the tool
            translate([ deburring_tool_offset_x, deburring_tool_offset_y, offset_z ])
                cylinder( h = holder_z, r = deburring_tool_r + clearance );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeburringToolPreview()
{
    % cylinder( h = 100, r = deburring_tool_r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeburringBladesPreview()
{
    % cube([ deburring_blades_x, deburring_blades_y, 75.0 ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
