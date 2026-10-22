include <../modules/gridfinity-base.scad>
include <../modules/gridfinity-helpers.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// the spools lie on their side, end to end along x
wire_spools_r = 58 / 2;
wire_spools_x = 200;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";
// render_mode = "print-3mf";

bin_color = "white";
label_color = "black";

label_text = "Wire Spools";
label_font = "Liberation Sans:style=Bold";
label_font_size = 6;
label_depth = 0.5;

cells_z = 1;

// a thin floor left on top of the base so the cutout doesn't expose the base's grid pattern
bin_floor_z = 1.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

cells_x = MinGridfinityCells( wire_spools_x );
cells_y = MinGridfinityCells( wire_spools_r * 2 );

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z - a fully gridfinity sized bin
holder_z = cells_z * gf_pitch;

wire_spools_y = wire_spools_r * 2;

wire_spools_offset_x = CenterInGridfinityCell( wire_spools_x, cells_x );
wire_spools_offset_y = CenterInGridfinityCell( wire_spools_y, cells_y );

// the spools rest on the floor, so their axis sits a radius above it
wire_spools_axis_z = GRIDFINITY_BASE_Z + bin_floor_z + wire_spools_r;

// keep the label clear of the bin's rounded edges
label_margin = GRIDFINITY_ROUNDING_R;

label_area_x = base_x - label_margin * 2;
label_area_y = wire_spools_offset_y - label_margin;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    WireSpoolBin();
    WireSpoolTextLabel();
}
else if( render_mode == "print-bin" )
{
    WireSpoolBin();
}
else if( render_mode == "print-text" )
{
    WireSpoolTextLabel();
}
else if( render_mode == "print-3mf" )
{
    color( bin_color )
        WireSpoolBin();
    color( label_color )
        WireSpoolTextLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WireSpoolBin()
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

        // the spools' cradle
        translate([ wire_spools_offset_x, base_y / 2, wire_spools_axis_z ])
            rotate([ 0, 90, 0 ])
                cylinder( r = wire_spools_r, h = wire_spools_x );

        // the opening above the spools so they drop in
        translate([ wire_spools_offset_x, wire_spools_offset_y, wire_spools_axis_z ])
            cube([
                wire_spools_x,
                wire_spools_y,
                holder_z - wire_spools_axis_z + DIFFERENCE_OFFSET
                ]);

        translate([ 0, 0, DIFFERENCE_CLEARANCE ])
            WireSpoolTextLabel();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WireSpoolTextLabel()
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
