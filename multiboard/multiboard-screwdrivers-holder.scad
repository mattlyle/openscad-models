include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/hexagons.scad>
include <../modules/triangular-prism.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";
// render_mode = "print-text";
// render_mode = "print-3mf";

holder_color = "white";
label_color = "black";

back_cells_x = 10;
back_cells_z = 3;

// connector slots up the back, by cell: one slot across the top two cells, one in the bottom cell
back_connector_row_setup_list = [ [ 3, 2 ], [ 1 ] ];

plate_y = 120;
plate_z = 3.6;

// solid border around the hexagon holes
plate_edge_xy = 4.0;

hex_r = 4.8;
hex_spacing = 1.6;

arm_x = 3.0;
arm_z = 50;

arm_rounding_r = 1.0;

label_text = "Screwdrivers";
label_font = "DejaVu Sans:style=Bold";
label_font_size = 21;
label_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

back_x = back_cells_x * multiboard_cell_size;
back_y = multiboard_connector_back_z;
back_z = back_cells_z * multiboard_cell_size;

plate_x = back_x - arm_x * 2;

echo( "back_x:", back_x );
echo( "back_z:", back_z );
echo( "plate_x:", plate_x );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    MultiboardScrewdriversHolder();

    MultiboardScrewdriversHolderLabel();
}
else if( render_mode == "print-holder" )
{
    MultiboardScrewdriversHolder();
}
else if( render_mode == "print-text" )
{
    MultiboardScrewdriversHolderLabel();
}
else if( render_mode == "print-3mf" )
{
    color( holder_color )
        MultiboardScrewdriversHolder();

    color( label_color )
        MultiboardScrewdriversHolderLabel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardScrewdriversHolder()
{
    difference()
    {
        union()
        {
            // hexagon plate
            translate([ arm_x, 0, 0 ])
                HexagonCube(
                    plate_x,
                    plate_y,
                    plate_z,
                    hex_r,
                    spacing = hex_spacing,
                    left_edge = plate_edge_xy,
                    right_edge = plate_edge_xy,
                    top_edge = plate_edge_xy,
                    bottom_edge = plate_edge_xy,
                    center_x = true,
                    center_y = true
                    );

            // multiboard back
            translate([ 0, plate_y + back_y, 0 ])
                rotate([ 90, 0, 0 ])
                    MultiboardConnectorBackAlt2( back_x, back_z, back_connector_row_setup_list );

            // left arm
            _MultiboardScrewdriversHolderArm( true );

            // right arm
            translate([ arm_x + plate_x, 0, 0 ])
                _MultiboardScrewdriversHolderArm( false );
        }

        // remove the inset text
        MultiboardScrewdriversHolderLabel( is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the label sitting in its recess on the front of the multiboard back, centered in the part of
// the face above the plate
//
// the cut version stands proud of the face so it has no coplanar surface to fight with, and
// is only ever subtracted so it has no use for a color; the printed one sits flush in the recess

module MultiboardScrewdriversHolderLabel( is_cutout = false )
{
    translate([ 0, plate_y + label_depth, plate_z ])
        rotate([ 90, 0, 0 ])
            CenteredTextLabel(
                label_text,
                centered_in_area_x = back_x,
                centered_in_area_y = back_z - plate_z,
                depth = is_cutout ? label_depth + DIFFERENCE_CLEARANCE : label_depth,
                font_size = label_font_size,
                font = label_font,
                color = is_cutout ? undef : label_color
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardScrewdriversHolderArm( is_left )
{
    // runs under the back so its rounded back corner lines up with the back's rounded edges,
    // the front and the side against the plate stay square to sit flush with the plate
    RoundedCube(
        arm_x,
        plate_y + back_y,
        plate_z,
        r = arm_rounding_r,
        round_top = false,
        round_left = is_left,
        round_right = !is_left,
        round_front = false
        );

    // triangular part
    translate([ 0, plate_y, plate_z ])
        rotate([ 90, 0, 0 ])
            TriangularPrism( arm_x, arm_z, plate_y );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
