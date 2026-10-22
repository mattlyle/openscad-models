include <../modules/bin-helper.scad>
include <../modules/gridfinity-base.scad>
include <../modules/gridfinity-helpers.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// label maker footprint
label_maker_x = 75.9;
label_maker_y = 29.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";
// render_mode = "print-3mf";

bin_color = "white";
label_color = "black";

label_text = "Label Maker";
label_font = "Liberation Sans:style=Bold";
label_font_size = 8;
label_depth = 0.5;

cells_z = 1;

// a thin floor left on top of the base so the cutout doesn't expose the base's grid pattern
bin_floor_z = 1.2;

clearance = 0.8;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

label_maker_pocket_x = label_maker_x + clearance * 2;
label_maker_pocket_y = label_maker_y + clearance * 2;

// keep the label clear of the bin's rounded edges
label_margin = GRIDFINITY_ROUNDING_R;

// the label sits in front of the pocket, so it needs its own strip of the bin
label_strip_y = label_font_size + label_margin * 2;

cells_x = MinGridfinityCells( label_maker_pocket_x );
cells_y = MinGridfinityCells( label_maker_pocket_y + label_strip_y );

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z - a fully gridfinity sized bin
holder_z = cells_z * gf_pitch;

label_maker_pocket_offset_x = CenterInGridfinityCell( label_maker_pocket_x, cells_x );
label_maker_pocket_offset_y = CenterInGridfinityCell( label_maker_pocket_y, cells_y );

cutout_list = [
    BinHelperCutoutWithDepth(
        BinHelperCube( label_maker_pocket_x, label_maker_pocket_y ),
        holder_z - GRIDFINITY_BASE_Z - bin_floor_z
        )
    ];
cutout_location_list = [ [ label_maker_pocket_offset_x, label_maker_pocket_offset_y ] ];

label_area_x = base_x - label_margin * 2;
label_area_y = label_maker_pocket_offset_y - clearance - label_margin;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    LabelMakerBin();
    LabelMakerTextLabel();
}
else if( render_mode == "print-bin" )
{
    LabelMakerBin();
}
else if( render_mode == "print-text" )
{
    LabelMakerTextLabel();
}
else if( render_mode == "print-3mf" )
{
    color( bin_color )
        LabelMakerBin();
    color( label_color )
        LabelMakerTextLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LabelMakerBin()
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
            LabelMakerTextLabel();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LabelMakerTextLabel()
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
