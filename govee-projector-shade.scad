////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

govee_projector_shade_x = 170;
govee_projector_shade_y = 180;
govee_projector_shade_z = 220;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

wall_width = 2.0;

difference_offset = 0.01;

base_width = 10.0;

cutout_scale = [ 1.5, 1.5, 2.2 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

translate([
    govee_projector_shade_x / 2 + wall_width + base_width,
    govee_projector_shade_y / 2 + wall_width + base_width,
    0
    ])
    GoveeProjectorShade();

if( render_mode == "preview" )
{
    % cube([
        govee_projector_shade_x + wall_width * 2 + base_width * 2,
        govee_projector_shade_y + wall_width * 2 + base_width * 2,
        0.1
        ]);

    % translate([
        govee_projector_shade_x / 2 + wall_width + base_width,
        govee_projector_shade_y + wall_width + base_width,
        govee_projector_shade_z
        ])
        scale( cutout_scale )
            sphere( r = govee_projector_shade_y / 2 );
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GoveeProjectorShade()
{
    scale_y = ( govee_projector_shade_y + wall_width ) / ( govee_projector_shade_x + wall_width );

    difference()
    {
        union()
        {
            scale([ 1, scale_y, 1])
                cylinder( r = govee_projector_shade_x / 2 + wall_width, h = govee_projector_shade_z );

            scale([ 1, scale_y, 1])
                cylinder( r = govee_projector_shade_x / 2 + wall_width + base_width, h = wall_width );
        }

        // remove the center of the cylinder
        translate([ 0, 0, -difference_offset])
            scale([ 1, scale_y, 1 ])
                cylinder( r = govee_projector_shade_x / 2, h = govee_projector_shade_z + difference_offset * 2);

        // remove the back
        translate([
            0,
            govee_projector_shade_y / 2,
            govee_projector_shade_z
            ])
            scale( cutout_scale )
                sphere( r = govee_projector_shade_y / 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
