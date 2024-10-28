use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
// include <modules/triangular-prism.scad>
// include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

pencil_radius = 9.55 / 2;

sharpie_radius = 11.6 / 2; // also pens

small_screwdriver_radius = 4.1 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

cup_x = 3; // in grid cells
cup_y = 1; // in grid cells
cup_z = 1;

corner_rounding_radius = 3.7;
holder_clearance = 0.15;

pointed_tip_length = 6.0;

pen_pencil_sharpie_clearance = 0.4;

cutout_rows = [
    [ pencil_radius, pencil_radius, pencil_radius, pencil_radius, pencil_radius, small_screwdriver_radius ],
    [ sharpie_radius, sharpie_radius, sharpie_radius, sharpie_radius, sharpie_radius ],
];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cup_z * 42.0;

offset_y = [
    base_y * 0.3,
    base_y * 0.7
];
offset_z = base_z + 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" || render_mode == "bin-only" )
{
    PenPencilSharpieHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PenPencilSharpieHolder()
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
                    fn = 36 );

            // cut off the area the gridfinity base covers
            cube([ base_x, base_y, base_z ]);

            for( i = [ 0 : len( cutout_rows ) - 1 ] )
            {
                

                row = cutout_rows[ i ];
                for( j = [ 0 : len( row ) - 1 ] )
                {
                    offset_x = base_x / ( len( row ) + 1 ) * ( j + 1 );

                    translate([ offset_x, offset_y[ i ], offset_z + pointed_tip_length ])
                        cylinder( h = holder_z - offset_z - pointed_tip_length, r = row[ j ] + pen_pencil_sharpie_clearance, $fn = 24 );

                    translate([ offset_x, offset_y[ i ], offset_z ])
                        cylinder( h = pointed_tip_length, r1 = pen_pencil_sharpie_clearance, r2 = row[ j ] + pen_pencil_sharpie_clearance, $fn = 24 );
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _PenPencilSharpieHolderCutout( radius )
{

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
