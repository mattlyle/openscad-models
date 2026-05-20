include <../modules/gridfinity-extended.scad>
include <../modules/rounded-cube.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

wire_diameter = 3.2;
wire_spacing = 23.0 - wire_diameter;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "print";

cells_x = 6;
cells_y = 1;

// how many cells to the left this tile is offset from the start of the shelf,
// so wire cutouts stay aligned when placing multiple tiles side by side
offset_cells_x = 0;

wire_cutout_extra = 0.1;        // extra clearance around wire in cutout slot
wire_floor_extra = 0.25;        // material thickness left below the wire

// the offset for the first wire
first_wire_offset_x = -10;

rounding_r = 4;

wire_cutout_multiplier = 1.75;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated

$fn = $preview ? 16 : 64;

total_size_x = gf_pitch * cells_x;
total_size_y = gf_pitch * cells_y;

echo( str( "total size x: ", total_size_x ) );
echo( str( "total size y: ", total_size_y ) );

// x distance from origin to where this tile's base starts
offset_size_x = gf_pitch * offset_cells_x;

// the cutout slot is a square rotated 45 degrees — cutout_side is the square's edge length,
// cutout_diagonal is the height of the resulting diamond cross-section
cutout_side = wire_diameter + wire_cutout_extra * 2;
cutout_diagonal = sqrt( ( cutout_side / 2 ) * ( cutout_side / 2 ) * 2 );

// total height of the wire-rack base layer
base_height = cutout_diagonal + wire_floor_extra;

// enough wires to cover both the offset area and this tile
num_wires = ceil( ( total_size_x + offset_size_x ) / wire_spacing ) + 1;

// how far the wire previews extend past the tile edges in Y
wire_preview_extend = 10;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateWireX( wire_n ) = 
    wire_n * wire_spacing + first_wire_offset_x;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    WirePreviews();

    WireRackGridfinityBaseplate();

    # translate([ first_wire_offset_x - wire_diameter / 2, -10, 0 ])
        cube([ 23.0, 5, 2 ]);
    # translate([ first_wire_offset_x - wire_diameter / 2, -15, 0 ])
        cube([ 42.8, 5, 2 ]);
}
else if( render_mode == "print" )
{
    WireRackGridfinityBaseplate();
}
else
{
    assert( false, str( "invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the gridfinity baseplate that sits on top of the wire-rack base layer
module WireRackGridfinityBaseplate()
{
    difference()
    {
        translate([ offset_size_x, 0, 0 ])
            RoundedCubeAlt2(
                total_size_x,
                total_size_y,
                base_height,
                rounding_r,
                round_top = false,
                round_bottom = false,
                );

        // cut a diamond-profile slot for each wire by rotating a square 45 degrees
        for( wire_n = [ -1 : 1 : num_wires ] )
        {
             translate([
                CalculateWireX( wire_n ),
                -DIFFERENCE_CLEARANCE,
                0
                ])
                rotate([
                    -90,
                    0,
                    0
                    ])
                    scale([
                        wire_cutout_multiplier,
                        1.0,
                        1.0
                        ])
                        cylinder(
                            h = total_size_y + DIFFERENCE_CLEARANCE * 2,
                            r = wire_diameter / 2
                            );
        }
    }

    translate([ offset_size_x, 0, base_height ])
        render()
            GridfinityBaseplate( cells_x, cells_y );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WirePreviews()
{
    for( wire_n = [ -1 : 1 : num_wires ] )
    {
        % translate([
            CalculateWireX( wire_n ),
            -wire_preview_extend,
            0
            ])
            rotate([
                -90,
                0,
                0
                ])
                cylinder(
                    h = total_size_y + wire_preview_extend * 2,
                    r = wire_diameter / 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
