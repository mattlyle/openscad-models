include <../modules/gridfinity-base.scad>

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

cells_x = 3;
cells_y = 1;

// the height to be added on top of the base
top_z = 42.0;

corner_rounding_radius = 3.7;
holder_clearance = 0.15;

pointed_tip_length = 6.0;

pen_pencil_sharpie_clearance = 0.4;

cutout_rows = [
    [ pencil_radius, pencil_radius, pencil_radius, pencil_radius, small_screwdriver_radius, small_screwdriver_radius, small_screwdriver_radius ],
    [ sharpie_radius, sharpie_radius, sharpie_radius, sharpie_radius, sharpie_radius, sharpie_radius ],
];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

offset_y = [
    base_y * 0.3,
    base_y * 0.7
];

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" || render_mode == "bin-only" )
{
    PenPencilSharpieHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PenPencilSharpieHolder()
{
    render()
    {
        difference()
        {
            GridfinityBase( cells_x, cells_y, top_z, round_top = true, center = false );

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
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
