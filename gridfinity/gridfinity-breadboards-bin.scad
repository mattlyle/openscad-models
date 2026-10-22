include <../modules/gridfinity-base.scad>
include <../modules/gridfinity-helpers.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>
include <../modules/trapezoidal-prism.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";
// render_mode = "print-3mf";

bin_color = "white";
label_color = "black";

label_text = "Breadboards";
label_font = "Liberation Sans:style=Bold";
label_font_size = 12;
label_depth = 0.5;

cells_x = 3;
cells_y = 5;
cells_z = 1;

bin_wall_xy = 2.0;

// a thin floor left on top of the base so the pocket doesn't expose the base's grid pattern
bin_floor_z = 1.2;

divider_count = 5;

// the dividers taper from the floor up, for strength
divider_bottom_x = 3.6;
divider_top_x = 1.6;

// fractions of the side wall height (above the floor) and the pocket length
divider_z_ratio = 0.90;
divider_y_ratio = 0.85;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z - a fully gridfinity sized bin
holder_z = cells_z * gf_pitch;

pocket_x = base_x - bin_wall_xy * 2;
pocket_y = base_y - bin_wall_xy * 2;
pocket_offset_z = GRIDFINITY_BASE_Z + bin_floor_z;

// the side wall height above the floor
pocket_z = holder_z - pocket_offset_z;

divider_y = pocket_y * divider_y_ratio;
divider_z = pocket_z * divider_z_ratio;

// the gap at the floor between neighbouring dividers (and between the outer dividers and the
// walls); it widens towards the top as the dividers taper
slot_x = ( pocket_x - divider_bottom_x * divider_count ) / ( divider_count + 1 );

assert( slot_x > 0, str( "too many dividers: ", divider_count, " leaves no room between them" ) );

// keep the label clear of the bin's rounded edges
label_margin = GRIDFINITY_ROUNDING_R;

label_area_x = base_x - label_margin * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    BreadboardsBin();
    BreadboardsTextLabel();
}
else if( render_mode == "print-bin" )
{
    BreadboardsBin();
}
else if( render_mode == "print-text" )
{
    BreadboardsTextLabel();
}
else if( render_mode == "print-3mf" )
{
    color( bin_color )
        BreadboardsBin();
    color( label_color )
        BreadboardsTextLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BreadboardsBin()
{
    difference()
    {
        GridfinityBase(
            cells_x,
            cells_y,
            holder_z - GRIDFINITY_BASE_Z,
            round_top = false,
            center = false,
            magnets = GRIDFINITY_BASE_MAGNETS_ALL
            );

        // the pocket's corners follow the outside rounding so the wall stays an even thickness
        translate([ bin_wall_xy, bin_wall_xy, pocket_offset_z ])
            RoundedCube(
                x = pocket_x,
                y = pocket_y,
                z = pocket_z + DIFFERENCE_CLEARANCE,
                r = GRIDFINITY_ROUNDING_R - bin_wall_xy,
                round_top = false,
                round_bottom = false
                );

        BreadboardsTextLabel( is_cutout = true );
    }

    for( i = [ 0 : divider_count - 1 ] )
    {
        translate([
            bin_wall_xy + slot_x * ( i + 1 ) + divider_bottom_x * i,
            bin_wall_xy + ( pocket_y - divider_y ) / 2,
            pocket_offset_z
            ])
            TrapezoidalPrism(
                x_top = divider_top_x,
                x_bottom = divider_bottom_x,
                y = divider_y,
                z = divider_z,
                center = false
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// "Breadboards", inset into the bin's front face
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess
module BreadboardsTextLabel( is_cutout = false )
{
    color_choice = is_cutout ? undef : label_color;
    depth_choice = is_cutout ? label_depth + DIFFERENCE_CLEARANCE : label_depth;

    translate([ label_margin, label_depth, GRIDFINITY_BASE_Z ])
        rotate([ 90, 0, 0 ])
            CenteredTextLabel(
                label_text,
                centered_in_area_x = label_area_x,
                centered_in_area_y = holder_z - GRIDFINITY_BASE_Z,
                depth = depth_choice,
                font_size = label_font_size,
                font = label_font,
                color = color_choice
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
