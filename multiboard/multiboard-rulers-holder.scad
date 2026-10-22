include <../modules/bin-helper.scad>
include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements
//
// copied from the old gridfinity/gridfinity-ruler-bin.scad, which this replaces

// short 20cm ruler
ruler_a_x = 0.7;
ruler_a_y = 26.1;

// long 38cm ruler
ruler_b_x = 1.8;
ruler_b_y = 30.0;

// long 46cm cork-backed ruler (2x of these)
ruler_c_x = 1.4;
ruler_c_y = 32.4;

// tri-ruler
ruler_d_arm_x = 3.5;
ruler_d_arm_y = 16.6;

// angle calipers
angle_calipers_x = 2.7;
angle_calipers_y = 35.3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-bin-text";
// render_mode = "print-3mf-bin";
// render_mode = "print-guide";
// render_mode = "print-3mf-guide";

bin_color = "white";
guide_color = "white";
label_color = "black";

// the bin's own height, on top of the multiboard connector back - kept short so the rulers are
// easy to grab in and out
bin_z = 11.0;

// the guide's own height, on top of the multiboard connector back
top_guide_z = 18.0;

back_z = multiboard_connector_back_z;

// the bin's connector back needs a full cell of height to seat properly, even though the bin
// itself is shorter - so the two are different heights, like the tape measure holder
back_plate_z = multiboard_cell_size;

// the gap between adjacent ruler slots, and the margin around the outside of the row - split
// so the two can differ; the floor itself stays thin (bin_floor_z), these only space out the
// dividers and edges
ruler_spacing_x = 12.0;
ruler_spacing_y = multiboard_wall_width * 3;

bin_floor_z = multiboard_wall_width;

clearance_x = 0.3;
clearance_y = 0.4;

corner_rounding_r = multiboard_corner_rounding_r;

label_text = "Rulers";
label_font = "Liberation Sans:style=Bold";
label_font_size = 7;
label_depth = 0.4;

// keeps the label and logo clear of the bin's rounded left/right edges
label_margin_x = corner_rounding_r + 1;

label_gap_y = 1.0;
tick_mark_tall = 5;

// how far above the bin the guide mounts on the board - preview only, doesn't affect either part
guide_mount_gap_z = 304.8;

preview_ruler_length = 350;

// every ruler in the row, in order: [ x, y, is_tri ]. The tri-ruler's arm dimensions go in x/y
// just like any other ruler - it's just tagged so it can be found and cut Y-shaped (see
// TriRulerCutout) instead of as a plain rectangle, no matter where it sits in the list
ruler_specs = [
    [ ruler_a_x, ruler_a_y, false ],
    [ ruler_b_x, ruler_b_y, false ],
    [ ruler_b_x, ruler_b_y, false ],
    [ ruler_c_x, ruler_c_y, false ],
    [ ruler_c_x, ruler_c_y, false ],
    [ ruler_c_x, ruler_c_y, false ],
    [ ruler_d_arm_x, ruler_d_arm_y, true ],
    [ angle_calipers_x, angle_calipers_y, false ],
    ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

holder_z = bin_z + back_z;
holder_guide_z = top_guide_z + back_z;

tri_ruler_index = [ for( i = [ 0 : len( ruler_specs ) - 1 ] ) if( ruler_specs[ i ][ 2 ] ) i ][ 0 ];

// the tri-ruler's cutout is Y-shaped, but reserves a square footprint here so it still takes
// part in the equally-spaced layout
tri_bounding_box = ( ruler_specs[ tri_ruler_index ][ 1 ] + clearance_y ) * 2;

ruler_cutout_list = [
    for( spec = ruler_specs )
        spec[ 2 ]
            ? BinHelperCube( tri_bounding_box, tri_bounding_box )
            : BinHelperCube( spec[ 0 ] + clearance_x * 2, spec[ 1 ] + clearance_y * 2 )
    ];

ruler_location_list = BinHelperEquallySpacedLocations( ruler_cutout_list, ruler_spacing_x, ruler_spacing_y );

bin_size_vector = MultiboardConnectorHelperBinSize( ruler_cutout_list, holder_z, ruler_spacing_x, ruler_spacing_y );
guide_size_vector = [ bin_size_vector.x, bin_size_vector.y, holder_guide_z ];

// the plain rectangular slots - everything except the tri-ruler
standard_cutout_list = [ for( i = [ 0 : len( ruler_cutout_list ) - 1 ] ) if( i != tri_ruler_index ) ruler_cutout_list[ i ] ];
standard_location_list = [ for( i = [ 0 : len( ruler_cutout_list ) - 1 ] ) if( i != tri_ruler_index ) ruler_location_list[ i ] ];

tri_ruler_location = ruler_location_list[ tri_ruler_index ];
tri_ruler_center = [ tri_ruler_location.x + tri_bounding_box / 2, tri_ruler_location.y + tri_bounding_box / 2 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    RulersPreview();
}
else if( render_mode == "print-bin" )
{
    RulersBin();
}
else if( render_mode == "print-bin-text" )
{
    RulersBinTextLabel();
}
else if( render_mode == "print-3mf-bin" )
{
    color( bin_color )
        RulersBin();
    color( label_color )
        RulersBinTextLabel();
}
else if( render_mode == "print-guide" )
{
    RulersGuide();
}
else if( render_mode == "print-3mf-guide" )
{
    color( guide_color )
        RulersGuide();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the bin and the guide, mounted on a shared board, one foot apart, with ghost rulers standing
// between them
module RulersPreview()
{
    tile_cells_x = ceil( bin_size_vector.x / multiboard_cell_size ) + 1;
    tile_cells_y = ceil( ( guide_mount_gap_z + holder_guide_z ) / multiboard_cell_size ) + 1;

    offset_x = MultiboardConnectorBackAltXOffset( bin_size_vector.x );

    translate([ 0, bin_size_vector.y + multiboard_connector_back_z + multiboard_cell_height, 0 ])
        rotate([ 90, 0, 0 ])
            color( workroom_multiboard_color )
                MultiboardMockUpTile( tile_cells_x, tile_cells_y );

    translate([ multiboard_cell_size - offset_x, 0, 0 ])
    {
        RulersBin();
        RulersBinTextLabel();
        RulersPreviewRulers();

        translate([ 0, 0, guide_mount_gap_z ])
            RulersGuide();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RulersBin()
{
    // the back plate, standing behind the bin - taller than the bin itself, sharing its bottom edge
    translate([ 0, bin_size_vector.y + multiboard_connector_back_z, 0 ])
        rotate([ 90, 0, 0 ])
            MultiboardConnectorBackAlt( bin_size_vector.x, back_plate_z );

    difference()
    {
        BinHelperBin(
            size_vector = bin_size_vector,
            cutout_list = standard_cutout_list,
            cutout_location_list = standard_location_list,
            corner_rounding_r = corner_rounding_r,
            floor_z = bin_floor_z,
            round_back = false
            );

        // the tri-ruler's Y-shaped slot, cut to the same floor depth as the rest
        translate([ tri_ruler_center.x, tri_ruler_center.y, bin_floor_z ])
            TriRulerCutout(
                ruler_d_arm_x, ruler_d_arm_y,
                clearance_x, clearance_y,
                holder_z - bin_floor_z + DIFFERENCE_OFFSET
                );

        RulersBinTextLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the "Rulers" label plus a pseudo ruler-marking logo, inset into the bin's front face
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess
module RulersBinTextLabel( is_cutout = false )
{
    label_area_x = bin_size_vector.x - label_margin_x * 2;
    label_area_y = label_font_size + 2;

    color_choice = is_cutout ? undef : label_color;
    depth_choice = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth;

    translate([ 0, label_depth, 0 ])
        rotate([ 90, 0, 0 ])
        {
            // the logo runs along the bottom, full width inside the rounded corners
            translate([ label_margin_x, label_margin_x, 0 ])
                RulerTickMarks( label_area_x, tick_mark_tall, depth_choice, color_choice );

            // the text sits above the logo
            translate([ label_margin_x, label_margin_x + tick_mark_tall + label_gap_y - 1, 0 ])
                CenteredTextLabel(
                    label_text,
                    centered_in_area_x = label_area_x,
                    centered_in_area_y = label_area_y,
                    depth = depth_choice,
                    font_size = label_font_size,
                    font = label_font,
                    color = color_choice
                    );
        }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a pseudo ruler-marking logo: a tick every mm, taller every 5th and 10th
module RulerTickMarks( length, tall, depth, color_override )
{
    color( color_override )
    {
        for( mm = [ 0 : length ] )
        {
            is_10 = mm % 10 == 0;
            is_5 = mm % 5 == 0;

            tick_y = is_10 ? tall : is_5 ? tall * 0.65 : tall * 0.35;
            tick_x = is_10 ? 0.6 : 0.3;

            translate([ mm, 0, 0 ])
                cube([ tick_x, tick_y, depth ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// not a bin - just a comb of dividers standing on the board, open at the top, bottom, and front,
// so the rulers slide in from the front and stay vertical instead of falling sideways
module RulersGuide()
{
    // the back plate, standing behind the guide
    translate([ 0, guide_size_vector.y + multiboard_connector_back_z, 0 ])
        rotate([ 90, 0, 0 ])
            MultiboardConnectorBackAlt( guide_size_vector.x, guide_size_vector.z );

    // one more divider than there are rulers, sitting in the gaps BinHelperEquallySpacedLocations
    // already left between/around the slots below, so they line up with the bin's own dividers
    for( i = [ 0 : len( ruler_cutout_list ) ] )
    {
        is_outer_fin = ( i == 0 || i == len( ruler_cutout_list ) );

        fin_x = ( i == 0 )
            ? 0
            : ruler_location_list[ i - 1 ].x + BinHelperCutoutFootprint( ruler_cutout_list[ i - 1 ] ).x;

        // the outer two fins sit in the row's edge margin, the rest sit in the between-slot gaps
        fin_width = is_outer_fin ? ruler_spacing_y : ruler_spacing_x;

        // round everything except the back, which sits flush against the connector back plate
        translate([ fin_x, 0, 0 ])
            RoundedCube(
                fin_width,
                guide_size_vector.y,
                guide_size_vector.z,
                r = corner_rounding_r,
                round_back = false
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a Y-shaped cutout for the tri-ruler's 3 arms, centered on the origin
module TriRulerCutout( arm_x, arm_y, clearance_x, clearance_y, cut_h )
{
    hub_r = arm_x + clearance_x * 2;
    arm_length = arm_y + clearance_y * 2;

    cylinder( h = cut_h, r = hub_r );

    for( i = [ 0 : 2 ] )
        rotate([ 0, 0, i * 120 + 90 ])
            translate([ -hub_r / 2, 0, 0 ])
                cube([ hub_r, arm_length, cut_h ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ghost previews of the rulers, standing in the bin and reaching up through the guide
module RulersPreviewRulers()
{
    for( i = [ 0 : len( ruler_cutout_list ) - 1 ] )
    {
        if( i != tri_ruler_index )
        {
            location = ruler_location_list[ i ];
            footprint = BinHelperCutoutFootprint( ruler_cutout_list[ i ] );

            translate([ location.x + clearance_x, location.y + clearance_y, bin_floor_z ])
                % cube([ footprint.x - clearance_x * 2, footprint.y - clearance_y * 2, preview_ruler_length ]);
        }
    }

    translate([ tri_ruler_center.x, tri_ruler_center.y, bin_floor_z ])
        % TriRulerCutout( ruler_d_arm_x, ruler_d_arm_y, 0, 0, preview_ruler_length );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
