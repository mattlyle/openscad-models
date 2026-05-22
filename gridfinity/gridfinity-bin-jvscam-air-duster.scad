include <../modules/gridfinity-base.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

air_duster_base_x = 23.6;
air_duster_base_y = 44.2;
air_duster_base_z = 93.0;

air_duster_top_xz = 36.7;
air_duster_top_y = 60.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";

cells_x = 2;
cells_y = 3;

top_z = 10.0;

label_font = "Georgia:style=Bold";
label_font_size = 14;
label_depth = 0.4;

bin_base_z = 30.0;
air_duster_wall_width = 2.0;
air_duster_holder_padding = 1.0;
bin_floor_z = 1.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

$fn = $preview ? 64 : 128;

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

base_offset_z = GRIDFINITY_BASE_Z + bin_floor_z;

air_duster_cutout_x = 
    base_x
    - air_duster_wall_width
    - air_duster_top_xz
    + calculateOffsetToCenter( air_duster_top_xz, air_duster_base_x + air_duster_holder_padding * 2 );

air_duster_cutout_y =
    air_duster_wall_width
        + calculateOffsetToCenter( air_duster_top_y, air_duster_base_y + air_duster_holder_padding * 2 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if ( render_mode == "preview" )
{
    JvscamBin();
    JvscamBinText();

    %translate([
        air_duster_cutout_x,
        air_duster_cutout_y,
        base_offset_z
        ])
        JvscamPreview( false );
}
else if ( render_mode == "print-bin" )
{
    JvscamBin();
}
else if ( render_mode == "print-text" )
{
    JvscamBinText();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module JvscamBin()
{
    difference()
    {
        GridfinityBase(
            cells_x,
            cells_y,
            bin_floor_z + bin_base_z,
            round_top = false,
            center = false
            );

        // base_x - air_duster_wall_width - calculateOffsetToCenter( air_duster_top_x, air_duster_base_x )

        // cut out the air duster base
        translate([
            air_duster_cutout_x,
            air_duster_cutout_y,
            base_offset_z
            ])
            JvscamPreview( true );
    }

    // cut out the side bin
    // #translate([
    //     air_duster_wall_width,
    //     air_duster_wall_width,
    //     base_offset_z + bin_base_z ])
    //     RoundedCubeAlt2(
    //         10,
    //         10,
    //         bin_base_z + DIFFERENCE_CLEARANCE,
    //         r = GRIDFINITY_ROUNDING_R,
    //         round_top = false,
    //         round_bottom = false
    //         );

    // cut out the top bin

    // cut out the air duster handle
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module JvscamBinText()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module JvscamPreview( pad_base = false )
{
    // bottom
    translate([
        pad_base ? -air_duster_holder_padding : 0 ,
        pad_base ? -air_duster_holder_padding : 0 ,
        0
        ])
        RoundedCubeAlt2(
            air_duster_base_x + ( pad_base ? ( air_duster_holder_padding * 2 ) : 0 ),
            air_duster_base_y + ( pad_base ? ( air_duster_holder_padding * 2 ) : 0 ),
            air_duster_base_z,
            r = 6.0,
            round_top = false,
            round_bottom = false
            );

    // top
    translate([
        -( air_duster_top_xz - air_duster_base_x ) / 2,
        -( air_duster_top_y - air_duster_base_y ) / 2,
        air_duster_base_z
        ])
        RoundedCubeAlt2(
            air_duster_top_xz,
            air_duster_top_y,
            air_duster_top_xz,
            r = 8.0,
            round_top = true,
            round_bottom = true,
            round_left = true,
            round_right = true,
            round_front = false,
            round_back = false
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
