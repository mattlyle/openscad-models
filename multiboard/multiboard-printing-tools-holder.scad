include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

isopropyl_alcohol_bottle_r = 32.5 / 2;

scissors_x = 4.4;
scissors_y = 13.4;

scraper_x = 39.6;
scraper_y = 8.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-text";
// render_mode = "print-3mf";

holder_color = "white";
label_color = "black";

// a two part entry is a rectangle, a one part entry is a circle
bin_list = [
    [ scraper_x, scraper_y ],
    [ scissors_x, scissors_y ],
    [ scissors_x, scissors_y ],
    [ isopropyl_alcohol_bottle_r ]
    ];

bin_spacing = 12;

bin_z = 45;

wall_width = 2.0;
clearance = 1.0;

// the towel hooks: a peg on each side of the holder, rising away from it at hook_angle above
// horizontal, so a towel loop slides back down toward the holder instead of off the end
hook_r = 6.0;
hook_length = 45.0;
hook_angle = 45;

// how deep the hooks are, front to back; they sit flush with the front of the holder
hook_y = 14.0;

label_text_line_1 = "Printing";
label_text_line_2 = "Tools";
label_font = "DejaVu Sans:style=Bold";
label_font_size = 14;
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

// none of them are given a depth, so they all run down to the floor
printing_tool_cutout_list = [ for( bin = bin_list ) PrintingToolCutout( bin ) ];

printing_tool_cutout_location_list = BinHelperEquallySpacedLocations(
    printing_tool_cutout_list,
    bin_spacing,
    wall_width
    );

holder_size_vector = MultiboardConnectorHelperBinSize(
    printing_tool_cutout_list,
    bin_z,
    bin_spacing,
    wall_width
    );

echo( str( "Holder Size: ", holder_size_vector ) );

// the hook's bottom edge meets the holder's side wall flush with the bottom of the holder
hook_root_z = hook_r / cos( hook_angle );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // the board stands behind the holder, so tip it up too
    translate([
        0,
        holder_size_vector.y + multiboard_connector_back_z + multiboard_cell_height,
        0
        ])
        rotate([ 90, 0, 0 ])
            color( workroom_multiboard_color )
                MultiboardMockUpTile( 12, 4 );

    translate([
        multiboard_cell_size - MultiboardConnectorBackAltXOffset( holder_size_vector.x ),
        0,
        0
        ])
    {
        PrintingToolsHolder();

        PrintingToolsHolderLabel();
    }
}
else if( render_mode == "print-holder" )
{
    PrintingToolsHolder();
}
else if( render_mode == "print-text" )
{
    PrintingToolsHolderLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        PrintingToolsHolder();

    color( label_color )
        PrintingToolsHolderLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// a two part entry is a rectangle, a one part entry is a circle

function PrintingToolCutout( bin ) =
    len( bin ) == 2
        ? BinHelperCube( bin.x + clearance * 2, bin.y + clearance * 2 )
        : BinHelperCylinder( bin.x + clearance );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PrintingToolsHolder()
{
    difference()
    {
        MultiboardConnectorHelperBin(
            holder_size_vector,
            printing_tool_cutout_list,
            printing_tool_cutout_location_list,
            wall_width
            );

        // remove the inset text
        PrintingToolsHolderLabel( is_cutout = true );
    }

    // the left hook points out along -x
    PrintingToolsHolderHook();

    // the right hook is the same one, mirrored across the middle of the holder
    translate([ holder_size_vector.x, 0, 0 ])
        mirror([ 1, 0, 0 ])
            PrintingToolsHolderHook();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the hook for the holder's left side, standing out along -x from the side wall
module PrintingToolsHolderHook()
{
    // rotating the profile up onto its edge points its extrusion toward -y, so start hook_y back
    translate([ 0, hook_y, 0 ])
        rotate([ 90, 0, 0 ])
            linear_extrude( height = hook_y )
                HookProfile(
                    hook_r,
                    hook_length,
                    hook_angle,
                    hook_root_z
                    );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a rounded peg rising out along -x from the origin's wall at the given angle, with the center
// of its root on the wall at root_z
//
// the root's circle is centered inside the wall and the peg clipped to the wall plane, so the
// peg's underside leaves the wall at a straight angle instead of curling out from under a circle
module HookProfile( r, length, angle, root_z )
{
    root_center = [ r, root_z - r * tan( angle ) ];
    tip_center = [ -length * cos( angle ), root_z + length * sin( angle ) ];

    intersection()
    {
        hull()
        {
            translate( root_center )
                circle( r = r );

            translate( tip_center )
                circle( r = r );
        }

        // everything out from the wall, overlapping it just enough to fuse to it
        translate([ -length - r * 2, 0 ])
            square([ length + r * 2 + DIFFERENCE_OFFSET, root_z + length + r * 2 ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label sitting in its recess on the front of the bins
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess

module PrintingToolsHolderLabel( is_cutout = false )
{
    translate([ 0, label_depth, 0 ])
        rotate([ 90, 0, 0 ])
            MultilineTextLabel(
                [ label_text_line_1, label_text_line_2 ],
                centered_in_area_x = holder_size_vector.x,
                centered_in_area_y = holder_size_vector.z,
                depth = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth,
                font_size = label_font_size,
                font = label_font,
                color = is_cutout ? undef : label_color
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
