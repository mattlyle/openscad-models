include <../modules/gridfinity-extended.scad>
include <../modules/rounded-cube.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

wire_diameter = 3.2;
wire_spacing = 23.1 - wire_diameter;

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
first_wire_offset_x = -12;

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
wire_preview_extend_bottom = 40;
wire_preview_extend_top = 10;

magnet_offset_xy =
    gf_cupbase_upper_taper_height
    + gf_cupbase_lower_taper_height
    + gf_cupbase_magnet_position
    + 0.25;

grid_cell_wall_thickness =
    gf_cupbase_upper_taper_height
    + gf_cupbase_lower_taper_height;

magnet_cupbase_xy =
    gf_cupbase_magnet_position * 2
    + 1.11;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateWireX( wire_n ) = 
    wire_n * wire_spacing + first_wire_offset_x;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    WirePreviews();

    WireRackGridfinityBaseplate();

    # translate([ CalculateWireX( 1 ) - wire_diameter / 2, -10, 0 ])
        cube([ 23.0, 4.5, 2 ]);
    # translate([ CalculateWireX( 1 ) - wire_diameter / 2, -15, 0 ])
        cube([ 42.8, 4.5, 2 ]);
    # translate([ CalculateWireX( 1 ) - wire_diameter / 2, -20, 0 ])
        cube([ 62.7, 4.5, 2 ]);
    # translate([ CalculateWireX( 1 ) - wire_diameter / 2, -25, 0 ])
        cube([ 82.7, 4.5, 2 ]);
    # translate([ CalculateWireX( 1 ) - wire_diameter / 2, -30, 0 ])
        cube([ 102.6, 4.5, 2 ]);
    # translate([ CalculateWireX( 1 ) - wire_diameter / 2, -35, 0 ])
        cube([ 122.8, 4.5, 2 ]);
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
    cutout_height = base_height + DIFFERENCE_CLEARANCE * 2;

    render()
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

                // cut out the center of each grid cell
                for( i = [ 0 : cells_x - 1 ] )
                {
                    for( j = [ 0 : cells_y - 1 ] )
                    {
                        translate([ i * gf_pitch, j * gf_pitch, 0 ])
                        {
                            difference()
                            {
                                translate([
                                    grid_cell_wall_thickness,
                                    grid_cell_wall_thickness,
                                    0
                                    ])
                                    cube([
                                        gf_pitch - grid_cell_wall_thickness * 2,
                                        gf_pitch - grid_cell_wall_thickness * 2,
                                        cutout_height
                                        ]);

                                // bottom left
                                translate([
                                    -DIFFERENCE_CLEARANCE,
                                    -DIFFERENCE_CLEARANCE,
                                    -DIFFERENCE_CLEARANCE
                                    ])
                                    MagnetCupBase( cutout_height + DIFFERENCE_CLEARANCE * 2 );

                                // bottom right
                                translate([
                                    gf_pitch + DIFFERENCE_CLEARANCE,
                                    -DIFFERENCE_CLEARANCE,
                                    -DIFFERENCE_CLEARANCE
                                    ])
                                    rotate([ 0, 0, 90 ])
                                        MagnetCupBase( cutout_height + DIFFERENCE_CLEARANCE * 2 );

                                // top left
                                translate([
                                    -DIFFERENCE_CLEARANCE,
                                    gf_pitch + DIFFERENCE_CLEARANCE,
                                    -DIFFERENCE_CLEARANCE
                                    ])
                                    rotate([ 0, 0, -90 ])
                                        MagnetCupBase( cutout_height + DIFFERENCE_CLEARANCE * 2 );

                                // top right
                                translate([
                                    gf_pitch + DIFFERENCE_CLEARANCE,
                                    gf_pitch + DIFFERENCE_CLEARANCE,
                                    -DIFFERENCE_CLEARANCE
                                    ])
                                    rotate([ 0, 0, 180 ])
                                        MagnetCupBase( cutout_height + DIFFERENCE_CLEARANCE * 2 );
                            }
                        }
                    }
                }
            }
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
            -wire_preview_extend_bottom,
            0
            ])
            rotate([
                -90,
                0,
                0
                ])
                cylinder(
                    h = total_size_y + wire_preview_extend_top + wire_preview_extend_bottom,
                    r = wire_diameter / 2
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MagnetCupBase( h = gf_magnet_thickness )
{
    // magnet location
    // # translate([ magnet_offset_xy, magnet_offset_xy, 4 ])
    //     cylinder( r = gf_magnet_diameter / 2, h = h );

    render()
    {
        union()
        {
            // vertical part
            translate([ grid_cell_wall_thickness, grid_cell_wall_thickness, 0 ])
                cube([ magnet_offset_xy - grid_cell_wall_thickness, magnet_cupbase_xy, h ]);

            // horizontal part
            translate([ grid_cell_wall_thickness, grid_cell_wall_thickness, 0 ])
                cube([ magnet_cupbase_xy, magnet_offset_xy - grid_cell_wall_thickness, h ]);

            difference()
            {
                translate([ magnet_offset_xy, magnet_offset_xy, 0 ])
                    cylinder( r = magnet_cupbase_xy - magnet_offset_xy + grid_cell_wall_thickness, h = h );

                // remove the vertical part
                translate([
                    0,
                    0,
                    - DIFFERENCE_CLEARANCE
                    ])
                    cube([
                        magnet_offset_xy,
                        magnet_cupbase_xy + grid_cell_wall_thickness,
                        h + DIFFERENCE_CLEARANCE*2
                        ]);

                // remove the horizontal part
                translate([
                    0,
                    0,
                    - DIFFERENCE_CLEARANCE
                    ])
                    cube([
                        magnet_cupbase_xy + grid_cell_wall_thickness,
                        magnet_offset_xy,
                        h + DIFFERENCE_CLEARANCE*2
                        ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
