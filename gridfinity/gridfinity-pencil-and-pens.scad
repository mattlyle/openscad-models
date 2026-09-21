include <../modules/gridfinity-base.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

pencil_r = 9.55 / 2;

sharpie_r = 11.6 / 2; // also pens

small_screwdriver_r = 4.1 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";

label_text = "Pens and Pencils?!";
label_font = "Georgia:style=Bold";
label_font_size = 7;

cells_x = 3;
cells_y = 1;

// the height to be added on top of the base
top_z = 42.0;

corner_rounding_r = 3.7;
holder_clearance = 0.15;

pointed_tip_length = 6.0;

pen_pencil_sharpie_clearance = 0.4;

cutout_rows = [
    [ pencil_r, pencil_r, pencil_r, pencil_r, pencil_r, pencil_r, pencil_r, pencil_r ],
    [ sharpie_r, sharpie_r, sharpie_r, sharpie_r, sharpie_r, sharpie_r, sharpie_r ],
];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

// in theory this should be calculated based on the radiuses of the items in the row, but way more effort than it's worth?!
offset_y = [
    base_y * 0.21,
    base_y * 0.75
];

text_area_y = 9;
text_area_offset_y = 15;

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    PenPencilSharpieHolder();
    PenPencilSharpieTextLabel();
}
else if( render_mode == "print-bin" )
{
    PenPencilSharpieHolder();
}
else if( render_mode == "print-text" )
{
    PenPencilSharpieTextLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PenPencilSharpieHolder()
{
    difference()
    {
        GridfinityBase(
            cells_x,
            cells_y,
            top_z,
            round_top = true,
            center = false,
            magnets = GRIDFINITY_BASE_MAGNETS_ALL
            );

        for( i = [ 0 : len( cutout_rows ) - 1 ] )
        {
            row = cutout_rows[ i ];
            for( j = [ 0 : len( row ) - 1 ] )
            {
                offset_x = base_x / ( len( row ) + 1 ) * ( j + 1 );

                // the main shaft
                translate([ offset_x, offset_y[ i ], offset_z + pointed_tip_length ])
                    cylinder( h = holder_z - offset_z - pointed_tip_length, r = row[ j ] + pen_pencil_sharpie_clearance, $fn = 24 );

                // pointed base
                translate([ offset_x, offset_y[ i ], offset_z ])
                    cylinder( h = pointed_tip_length, r1 = pen_pencil_sharpie_clearance, r2 = row[ j ] + pen_pencil_sharpie_clearance, $fn = 24 );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PenPencilSharpieTextLabel()
{
    // #translate([ 0, text_area_offset_y, holder_z ])
    //     cube([ base_x, text_area_y, 0.1 ]);

    translate([ 0, text_area_offset_y, holder_z ])
        CenteredTextLabel(
            label_text,
            centered_in_area_x = base_x,
            centered_in_area_y = text_area_y,
            font_size = label_font_size,
            font = label_font
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
