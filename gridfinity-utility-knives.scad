use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// folding knives
folding_knife_x = 22.6;
folding_knife_y = 109;
folding_knife_z = 35.8;

// retractable knives
retractable_knife_x = 21.5;
retractable_knife_y = 158;
retractable_knife_z = 37.5;

// x-acto knife
x_acto_knife_x = 14.7;
x_acto_knife_y = 153.2;
x_acto_knife_z = 14.7;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

cup_x = 3; // in grid cells
cup_y = 4; // in grid cells
cup_z = 1;

clearance = 1.5;

corner_rounding_radius = 3.7;

holder_clearance = 0.15;

x_acto_knife_spec = [ x_acto_knife_x, x_acto_knife_y, x_acto_knife_z ];
folding_knife_spec = [ folding_knife_x, folding_knife_y, folding_knife_z ];
retractable_knife_spec = [ retractable_knife_x, retractable_knife_y, retractable_knife_z ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cup_z * 42.0;

spacing_x = ( base_x - x_acto_knife_x - folding_knife_x - retractable_knife_x * 2 - clearance * 8 ) / 4;

x_offset_0 = spacing_x;
x_offset_1 = UpdateCutoutXOffset( x_offset_0, x_acto_knife_spec );
x_offset_2 = UpdateCutoutXOffset( x_offset_1, folding_knife_spec );
x_offset_3 = UpdateCutoutXOffset( x_offset_2, retractable_knife_spec );
x_offset_4 = UpdateCutoutXOffset( x_offset_3, retractable_knife_spec );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" || render_mode == "bin-only" )
{
    // base
    gridfinity_cup(
        width = cup_x,
        depth = cup_y,
        height = cup_z,
        position = "zero",
        filled_in = true,
        lip_style = "none"
        );

    render()
    {
        difference()
        {
            translate([ holder_clearance, holder_clearance, 0 ])
                RoundedCube(
                    size = [ holder_x, holder_y, holder_z ],
                    r = corner_rounding_radius,
                    fn = 36
                    );

            // cut off the area the gridfinity base covers
            cube([ base_x, base_y, base_z ]);

            // cut out the utility knife areas

            // x-acto
            UtilityKnifeCutout( x_offset_0, x_acto_knife_spec );

            // folding
            UtilityKnifeCutout( x_offset_1, folding_knife_spec );

            // retractable 1
            UtilityKnifeCutout( x_offset_2, retractable_knife_spec );

            // retractable 2
            UtilityKnifeCutout( x_offset_3, retractable_knife_spec );
        }
    }
}

if( render_mode == "preview" || render_mode == "text-only" )
{
    text_area_offset_x = x_offset_0 + x_acto_knife_x + clearance;
    text_area_x = x_offset_2 - text_area_offset_x - clearance;

    text_area_offset_y = min( ( base_y - x_acto_knife_y ) / 2 - clearance, ( base_y - retractable_knife_y ) / 2 - clearance );
    text_area_y = ( base_y - folding_knife_y ) / 2 - clearance - text_area_offset_y;

    // % translate([ text_area_offset_x, text_area_offset_y, holder_z ])
    //     cube([ text_area_x, text_area_y, 0.5 ]);

    translate([ text_area_offset_x, 17, holder_z ])
        CenteredTextLabel( "Utility", 6, "Georgia:style=Bold", text_area_x, -1 );
    translate([ text_area_offset_x, 8, holder_z ])
        CenteredTextLabel( "Knives", 6, "Georgia:style=Bold", text_area_x, -1 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function UpdateCutoutXOffset( current_x_offset, spec ) = current_x_offset + spec[ 0 ] + spacing_x;

module UtilityKnifeCutout( current_x_offset, spec )
{
    // echo( "z: ", spec[ 2 ] );
    // echo( "max: ", holder_z - base_z );

    depth = min( holder_z - base_z, spec[ 2 ] + clearance );

    // echo( "depth: ", depth );
    // echo( "==================================================" );

// TODO: must add clearance!

    translate([ current_x_offset - clearance, ( base_y - spec[ 1 ] ) / 2 - clearance, holder_z - depth ])
        cube([ spec[ 0 ] + clearance * 2, spec[ 1 ] + clearance * 2, depth ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
