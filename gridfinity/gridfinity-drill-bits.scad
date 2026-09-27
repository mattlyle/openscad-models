include <../modules/bin-helper.scad>
include <../modules/gridfinity-base.scad>
include <../modules/gridfinity-helpers.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// drill bit index case footprint
drill_bits_x = 50.5;
drill_bits_y = 97.8;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";
// render_mode = "print-3mf";

bin_color = "white";
label_color = "black";

label_text = "Drill Bits";
label_font = "Liberation Sans:style=Bold";
label_font_size = 8;
label_depth = 0.5;

cells_z = 1;

// a thin floor left on top of the base so the cutout doesn't expose the base's grid pattern
bin_floor_z = 1.2;

clearance = 1.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

drill_bits_pocket_x = drill_bits_x + clearance * 2;
drill_bits_pocket_y = drill_bits_y + clearance * 2;

cells_x = MinGridfinityCells( drill_bits_pocket_x );
cells_y = MinGridfinityCells( drill_bits_pocket_y );

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z - a fully gridfinity sized bin
holder_z = cells_z * gf_pitch;

drill_bits_pocket_offset_x = CenterInGridfinityCell( drill_bits_pocket_x, cells_x );
drill_bits_pocket_offset_y = CenterInGridfinityCell( drill_bits_pocket_y, cells_y );

cutout_list = [
    BinHelperCutoutWithDepth(
        BinHelperCube( drill_bits_pocket_x, drill_bits_pocket_y ),
        holder_z - GRIDFINITY_BASE_Z - bin_floor_z
        )
    ];
cutout_location_list = [ [ drill_bits_pocket_offset_x, drill_bits_pocket_offset_y ] ];

// keep the label clear of the bin's rounded edges
label_margin = GRIDFINITY_ROUNDING_R;

label_area_x = base_x - label_margin * 2;
label_area_y = drill_bits_pocket_offset_y - clearance - label_margin;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    DrillBitsBin();
    DrillBitsTextLabel();
}
else if( render_mode == "print-bin" )
{
    DrillBitsBin();
}
else if( render_mode == "print-text" )
{
    DrillBitsTextLabel();
}
else if( render_mode == "print-3mf" )
{
    color( bin_color )
        DrillBitsBin();
    color( label_color )
        DrillBitsTextLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DrillBitsBin()
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

        translate([ 0, 0, DIFFERENCE_CLEARANCE ])
            DrillBitsTextLabel();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DrillBitsTextLabel()
{
    translate([ label_margin, label_margin, holder_z - label_depth ])
        CenteredTextLabel(
            label_text,
            label_area_x,
            label_area_y,
            depth = label_depth,
            font_size = label_font_size,
            font = label_font
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
