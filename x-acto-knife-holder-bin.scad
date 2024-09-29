use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

x_acto_knife_diameter = 13.55;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
// render_mode = "bin-only";
render_mode = "text-only";

cup_x = 1; // in grid cells
cup_y = 1; // in grid cells
cup_z = 1;

x_acto_knife_clearance = 0.15;

holder_clearance = 0.15;
corner_rounding_radius = 3.7;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cup_z * 42.0;

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

            // cut out the cylinder for the x-acto knife
            translate([ holder_x / 2, holder_y / 2, base_z ])
                cylinder( h = holder_z - base_z, r = x_acto_knife_diameter / 2 + x_acto_knife_clearance, $fn = 48 );
        }
    }
}

if( render_mode == "preview" || render_mode == "text-only" )
{
    text_area_y = ( holder_y - x_acto_knife_diameter - x_acto_knife_clearance) / 2;

    translate([ 0, holder_y - text_area_y, holder_z ])
        CenteredTextLabel( "X-ACTO", 4.5, holder_x, text_area_y );

    translate([ 0, 0, holder_z ])
        CenteredTextLabel( "KNIFE", 4.5, holder_x, text_area_y );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
