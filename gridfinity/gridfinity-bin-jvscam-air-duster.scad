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

label_text_lines = [ "JVSCAM", "AIR", "DUSTER" ];
label_font = "Georgia:style=Bold";
label_font_size = 12;
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
    union()
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

            // cut out the air duster base
            translate([
                air_duster_cutout_x,
                air_duster_cutout_y,
                base_offset_z
                ])
                JvscamPreview( true );

            // cut out the left side bin
            translate([
                air_duster_wall_width,
                air_duster_wall_width,
                base_offset_z
                ])
                RoundedCubeAlt2(
                    air_duster_cutout_x - air_duster_wall_width * 2 - air_duster_holder_padding,
                    base_y - air_duster_wall_width * 2,
                    bin_base_z + DIFFERENCE_CLEARANCE,
                    r = GRIDFINITY_ROUNDING_R,
                    round_top = false,
                    round_bottom = false
                    );
        
            // cut out the top bin
            translate([
                air_duster_wall_width,
                air_duster_wall_width + air_duster_top_y,
                base_offset_z
                ])
                RoundedCubeAlt2(
                    base_x - air_duster_wall_width * 2,
                    base_y - air_duster_top_y - air_duster_wall_width * 2,
                    bin_base_z + DIFFERENCE_CLEARANCE,
                    r = GRIDFINITY_ROUNDING_R,
                    round_top = false,
                    round_bottom = false
                    );

            // cut out the inside corner so we can round it
            translate([
                air_duster_cutout_x - air_duster_wall_width - air_duster_holder_padding - DIFFERENCE_CLEARANCE,
                air_duster_wall_width + air_duster_top_y - GRIDFINITY_ROUNDING_R,
                base_offset_z
                ])
                cube([
                    GRIDFINITY_ROUNDING_R + DIFFERENCE_CLEARANCE,
                    GRIDFINITY_ROUNDING_R + DIFFERENCE_CLEARANCE,
                    bin_base_z + DIFFERENCE_CLEARANCE
                    ]);

            // cut out the text
            translate([
                0,
                0,
                DIFFERENCE_CLEARANCE
                ])
                JvscamBinText();
        }

        // round the inside corner
        translate([
            air_duster_cutout_x - air_duster_wall_width - air_duster_holder_padding + GRIDFINITY_ROUNDING_R,
            air_duster_wall_width + air_duster_top_y - GRIDFINITY_ROUNDING_R,
            base_offset_z
            ])
            cylinder(
                r = GRIDFINITY_ROUNDING_R,
                h = bin_base_z
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module JvscamBinText()
{
    text_area_offset_x = air_duster_wall_width;
    text_area_offset_y = air_duster_wall_width + air_duster_top_y;

    text_area_size_x = base_x - air_duster_wall_width * 2;
    text_area_size_y = base_y - air_duster_top_y - air_duster_wall_width * 2;

    // #translate([
    //     text_area_offset_x,
    //     text_area_offset_y,
    //     base_offset_z
    //     ])
    //     cube([
    //         text_area_size_x,
    //         text_area_size_y,
    //         0.01
    //         ]);

    translate([
        text_area_offset_x,
        text_area_offset_y,
        base_offset_z - label_depth
        ])
        MultilineTextLabel(
            text_lines = label_text_lines,
            centered_in_area_x = text_area_size_x,
            centered_in_area_y = text_area_size_y,
            depth = label_depth,
            font_size = label_font_size,
            font = label_font,
            color = [ 0, 0, 0 ]
            );
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
