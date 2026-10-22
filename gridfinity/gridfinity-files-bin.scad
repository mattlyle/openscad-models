include <../modules/bin-helper.scad>
include <../modules/gridfinity-base.scad>
include <../modules/gridfinity-helpers.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

orange_bin_x = 77.3;
orange_bin_y = 26.8;

metal_file_x = 3.3;
metal_file_y = 14.0;

emory_board_x = 4.0;
emory_board_y = 20.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";
// render_mode = "print-3mf";

bin_color = "white";
label_color = "black";

label_text = "Files";
label_font = "Liberation Sans:style=Bold";
label_font_size = 12;
label_depth = 0.5;

cells_y = 1;
cells_z = 1;

// a thin floor left on top of the base so the cutouts don't expose the base's grid pattern
bin_floor_z = 1.2;

clearance = 0.8;

// the thinnest wall allowed between neighboring cutouts, and between the cutouts and the bin's
// edges; it sets the number of cells, then the cutouts are spread out to fill the bin
cutout_spacing = 3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

// the combined z - a fully gridfinity sized bin
holder_z = cells_z * gf_pitch;

cutout_z = holder_z - GRIDFINITY_BASE_Z - bin_floor_z;

cutout_list = [
    BinHelperCube( orange_bin_x + clearance * 2, orange_bin_y + clearance * 2, cutout_z ),
    BinHelperCube( metal_file_x + clearance * 2, metal_file_y + clearance * 2, cutout_z ),
    BinHelperCube( emory_board_x + clearance * 2, emory_board_y + clearance * 2, cutout_z )
    ];

cutouts_min_x = BinHelperEquallySpacedSize( cutout_list, cutout_spacing ).x;

cells_x = MinGridfinityCells( cutouts_min_x );

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the leftover x shared out equally between every gap, edges included
cutout_gap_x = cutout_spacing + ( base_x - cutouts_min_x ) / ( len( cutout_list ) + 1 );

cutout_location_list = AddValueToEachIndex(
    BinHelperEquallySpacedLocations( cutout_list, cutout_gap_x ),
    [ 0, ( base_y - BinHelperEquallySpacedSize( cutout_list, cutout_gap_x ).y ) / 2 ]
    );

// keep the label clear of the bin's rounded edges
label_margin = GRIDFINITY_ROUNDING_R;

label_area_x = base_x - label_margin * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    FilesBin();
    FilesTextLabel();
}
else if( render_mode == "print-bin" )
{
    FilesBin();
}
else if( render_mode == "print-text" )
{
    FilesTextLabel();
}
else if( render_mode == "print-3mf" )
{
    color( bin_color )
        FilesBin();
    color( label_color )
        FilesTextLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FilesBin()
{
    difference()
    {
        GridfinityBase(
            cells_x,
            cells_y,
            holder_z - GRIDFINITY_BASE_Z,
            round_top = true,
            center = false,
            magnets = GRIDFINITY_BASE_MAGNETS_ALL
            );

        BinHelper(
            bin_x = base_x,
            bin_y = base_y,
            bin_z = holder_z,
            cutout_list = cutout_list,
            cutout_location_list = cutout_location_list
            );

        FilesTextLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// "Files", inset into the bin's front face, centered between the top of the base and
// the top of the bin
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess
module FilesTextLabel( is_cutout = false )
{
    color_choice = is_cutout ? undef : label_color;
    depth_choice = is_cutout ? label_depth + DIFFERENCE_CLEARANCE : label_depth;

    translate([ label_margin, label_depth, GRIDFINITY_BASE_Z ])
        rotate([ 90, 0, 0 ])
            CenteredTextLabel(
                label_text,
                label_area_x,
                holder_z - GRIDFINITY_BASE_Z,
                depth = depth_choice,
                font_size = label_font_size,
                font = label_font,
                color = color_choice
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
