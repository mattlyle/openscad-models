include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

pencil_r = 9.55 / 2;

sharpie_r = 11.6 / 2; // also pens

post_it_notes_x = 80;
post_it_notes_y = 11.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-text";
// render_mode = "print-3mf";

holder_color = "white";
label_color = "black";

// how far the top of the bin leans away from the board
present_angle = 20;

cells_x = 4;

// the height of the bin along its own (tilted) axis
bin_z = 41;

// the ribs fill the gap behind the leaning bin, and the open pockets between them can store small
// things, so fewer ribs makes wider pockets; the two end ribs are always there, so the minimum is 2
rib_count = 3;

// the first row is the one at the front
cutout_rows = [
    [ pencil_r, pencil_r, pencil_r, pencil_r ],
    [ sharpie_r, sharpie_r, sharpie_r, ],
];

wall_width = 2.0;
corner_rounding_r = 1.0;

pen_pencil_sharpie_clearance = 0.4;

pointed_tip_length = 6.0;

post_it_clearance = 1.0;

// one line, with the first text against the left edge and the second against the right
label_text_left = "Pointy Things";
label_text_right = "Sticky Things";
label_margin_x = 8;
label_font = "DejaVu Sans:style=Bold";
label_font_size = 7.5;
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

// the bin is modeled standing straight, then tilted as a whole, so bin_x / bin_y / bin_z are
// its own axes rather than the holder's
pen_x = cells_x * multiboard_cell_size;

// the post-it slot sits beside the pens, with a wall between and around
post_it_slot_x = post_it_notes_x + post_it_clearance * 2;

bin_x = pen_x + post_it_slot_x + wall_width * 2;

// each row is as deep as its fattest pen, with a wall around and between the rows
row_r_list = [ for( row = cutout_rows ) max( row ) ];

bin_y = SumList( AddValueToEachIndex( row_r_list, pen_pencil_sharpie_clearance ) * 2 )
    + wall_width * ( len( cutout_rows ) + 1 );

// the slot takes the full depth of the bin, the pad just has to fit in it
post_it_slot_y = bin_y - wall_width * 2;

assert(
    post_it_slot_y >= post_it_notes_y + post_it_clearance * 2,
    "the post-it notes are too thick for the bin"
    );

bin_size_vector = [ bin_x, bin_y, bin_z ];

// the bin tips about its front bottom edge, which leaves its back bottom corner touching the back
// plate and the top leaning forward, so the pivot is as far from the plate as the top leans
pivot_y = bin_z * sin( present_angle );

back_plate_y = pivot_y + bin_y * cos( present_angle );

// how far the back bottom corner of the bin is lifted off the bed
back_bottom_z = bin_y * sin( present_angle );

tilted_top_z = back_bottom_z + bin_z * cos( present_angle );

back_cells_z = ceil( tilted_top_z / multiboard_cell_size );
back_plate_z = back_cells_z * multiboard_cell_size;

holder_size_vector = [ bin_x, back_plate_y + multiboard_connector_back_z, back_plate_z ];

echo( str( "Holder Size: ", holder_size_vector ) );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // the board stands behind the holder, so tip it up too
    translate([ 0, holder_size_vector.y + multiboard_cell_height, 0 ])
        rotate([ 90, 0, 0 ])
            color( workroom_multiboard_color )
                MultiboardMockUpTile( 12, 4 );

    translate([
        multiboard_cell_size - MultiboardConnectorBackAltXOffset( bin_x ),
        0,
        0
        ])
    {
        PenHolder();

        PenHolderLabel();
    }
}
else if( render_mode == "print-holder" )
{
    PenHolder();
}
else if( render_mode == "print-text" )
{
    PenHolderLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        PenHolder();

    color( label_color )
        PenHolderLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PenHolder()
{
    // the back plate is drawn flat, so tip it up to stand behind the bin
    translate([ 0, holder_size_vector.y, 0 ])
        rotate([ 90, 0, 0 ])
            MultiboardConnectorBackAlt( bin_x, back_plate_z );

    PenHolderTilt()
        PenHolderBin();

    PenHolderUnderside();

    for( i = [ 0 : rib_count - 1 ] )
    {
        translate([ ( bin_x - wall_width ) * i / ( rib_count - 1 ), 0, 0 ])
            PenHolderRib();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the text sitting in its recess on the front of the bin
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess

module PenHolderLabel()
{
    PenHolderTilt()
        _PenHolderLabelStraight();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the bin standing straight, open at the top, with every pen hole cut down its own z
//
// the label is cut in here too, so it tilts along with everything else

module PenHolderBin()
{
    cutout_floor_z = wall_width;

    difference()
    {
        RoundedCube(
            x = bin_x,
            y = bin_y,
            z = bin_z,
            r = corner_rounding_r,
            round_bottom = false,
            round_back = false
            );

        for( i = [ 0 : len( cutout_rows ) - 1 ] )
        {
            row = cutout_rows[ i ];

            for( j = [ 0 : len( row ) - 1 ] )
            {
                cutout_r = row[ j ] + pen_pencil_sharpie_clearance;

                translate([
                    CalculateEquallySpacedOffsetRadiuses(
                        row,
                        pen_x,
                        pen_pencil_sharpie_clearance,
                        j
                        ),
                    CalculateEquallySpacedOffsetRadiuses(
                        row_r_list,
                        bin_y,
                        pen_pencil_sharpie_clearance,
                        i
                        ),
                    cutout_floor_z
                    ])
                {
                    // the pointed base the tip of the pen settles into
                    cylinder(
                        h = pointed_tip_length,
                        r1 = pen_pencil_sharpie_clearance,
                        r2 = cutout_r
                        );

                    // the main shaft
                    translate([ 0, 0, pointed_tip_length ])
                        cylinder(
                            h = bin_z - cutout_floor_z - pointed_tip_length + DIFFERENCE_OFFSET,
                            r = cutout_r
                            );
                }
            }
        }

        // the post-it slot, beside the pens
        translate([
            pen_x + wall_width,
            wall_width,
            cutout_floor_z
            ])
            cube([ post_it_slot_x, post_it_slot_y, bin_z - cutout_floor_z + DIFFERENCE_OFFSET ]);

        // remove the inset text
        _PenHolderLabelStraight( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label in the bin's own frame, so it can be cut from the straight bin and tilted with it

module _PenHolderLabelStraight( is_cutout = false )
{
    translate([ 0, label_depth, 0 ])
        rotate([ 90, 0, 0 ])
            for( label = [
                [ label_text_left, label_margin_x, "left" ],
                [ label_text_right, bin_x - label_margin_x, "right" ]
                ] )
            {
                translate([ label[ 1 ], bin_z / 2, 0 ])
                    TextLabel(
                        label[ 0 ],
                        depth = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth,
                        font_size = label_font_size,
                        font = label_font,
                        color = is_cutout ? undef : label_color,
                        halign = label[ 2 ],
                        valign = "center"
                        );
            }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the solid wedge under the sloped floor, so the holder sits flat on the bed

module PenHolderUnderside()
{
    // sunk up into the floor so it is one piece with the bin
    floor_overlap_vector = [ -sin( present_angle ), cos( present_angle ) ] * wall_width / 2;

    front_point = [ pivot_y, 0 ];
    back_point = [ back_plate_y, back_bottom_z ];

    PenHolderExtrudeAlongX( bin_x )
        polygon([
            front_point,
            [ back_plate_y + multiboard_difference_overlap, 0 ],
            back_point + [ multiboard_difference_overlap, 0 ],
            back_point + floor_overlap_vector,
            front_point + floor_overlap_vector
            ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a rib filling the gap between the back plate and the leaning back wall of the bin

module PenHolderRib()
{
    // sunk into the back wall so it is one piece with the bin
    wall_overlap_vector = [ -cos( present_angle ), -sin( present_angle ) ] * wall_width / 2;

    bottom_point = [ back_plate_y, back_bottom_z ];
    top_point = bottom_point + [ -bin_z * sin( present_angle ), bin_z * cos( present_angle ) ];

    PenHolderExtrudeAlongX( wall_width )
        polygon([
            bottom_point,
            [ back_plate_y + multiboard_difference_overlap, bottom_point.y ],
            [ back_plate_y + multiboard_difference_overlap, top_point.y ],
            top_point,
            top_point + wall_overlap_vector,
            bottom_point + wall_overlap_vector
            ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// tips whatever it is given about the bin's front bottom edge

module PenHolderTilt()
{
    translate([ 0, pivot_y, 0 ])
        rotate([ present_angle, 0, 0 ])
            children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// extrudes a 2D profile drawn as [ y, z ] along x

module PenHolderExtrudeAlongX( length_x )
{
    rotate([ 90, 0, 90 ])
        linear_extrude( length_x )
            children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
