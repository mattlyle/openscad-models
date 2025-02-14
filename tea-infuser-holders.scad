////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements


short_infuser_top_r = 58.6 / 2;
short_infuser_bottom_r = 51.1 / 2;
short_infuser_z = 57.1;
short_infuser_top_lip_z = 3.2;
short_infuser_top_lip_r = 67.3 / 2;

short_infuser_handle_full_x = 131.0;
short_infuser_handle_offset_x = 80.1 - short_infuser_top_lip_r * 2;
short_infuser_handle_y = 25.0;
short_infuser_handle_wire_d = 2.6;
short_infuser_handle_hook_z = 10.7;


tall_infuser_r = 59.3 / 2;
tall_infuser_z = 167;
tall_infuser_top_section_r = 74.8 / 2;
tall_infuser_top_section_z = 9.4;
tall_infuser_sloped_section_z = 17.0 - tall_infuser_top_section_z;
tall_infuser_lip_r = 86.0 / 2;
tall_infuser_lip_z = 0.8;
tall_infuser_handle_x = 6.1;
tall_infuser_handle_y = 21.9;
tall_infuser_handle_z = 60.2;
tall_infuser_handle_angle = 5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ShortInfuserPreview( );

    translate( [ 100, 0, 0 ] )
        TallInfuserPreview( );
}
else
{
    assert( false, "Unknown render mode" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ShortInfuserPreview( )
{
    % rotate([ 0, 0, -90 ])
        union()
        {
            cylinder( r1 = short_infuser_bottom_r, r2 = short_infuser_top_r, h = short_infuser_z - short_infuser_top_lip_z);

            translate( [ 0, 0, short_infuser_z - short_infuser_top_lip_z ] )
                cylinder( r = short_infuser_top_lip_r, h = short_infuser_top_lip_z );

            handle_offset_x = -short_infuser_handle_offset_x - short_infuser_top_lip_r;

            translate([ handle_offset_x, -short_infuser_handle_y / 2, short_infuser_z - short_infuser_handle_wire_d ])
                cube([ short_infuser_handle_full_x, short_infuser_handle_y, short_infuser_handle_wire_d ]);

            translate([ handle_offset_x, -short_infuser_handle_y / 2, short_infuser_z - short_infuser_handle_hook_z ])
                cube([ short_infuser_handle_wire_d, short_infuser_handle_y, short_infuser_handle_hook_z ]);
        }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TallInfuserPreview( )
{
    slope_section_offset_z = tall_infuser_z
        - tall_infuser_lip_z
        - tall_infuser_top_section_z
        - tall_infuser_sloped_section_z;

    top_section_offset_z = tall_infuser_z
        - tall_infuser_lip_z
        - tall_infuser_top_section_z;

    lip_offset_z = tall_infuser_z
        - tall_infuser_lip_z;

    % union()
    {
        // main body
        cylinder( r = tall_infuser_r, h = slope_section_offset_z );

        // sloped section
        translate([ 0, 0, slope_section_offset_z ])
            cylinder( r1 = tall_infuser_r, r2 = tall_infuser_top_section_r, h = tall_infuser_sloped_section_z );

        // top section
        translate([ 0, 0, top_section_offset_z])
            cylinder( r = tall_infuser_top_section_r, h = tall_infuser_top_section_z );

        // lip
        translate([ 0, 0, lip_offset_z ])
            cylinder( r = tall_infuser_lip_r, h = tall_infuser_lip_z );

        // handle
        translate([ -tall_infuser_lip_r - tall_infuser_handle_x / 2, -tall_infuser_handle_y / 2, tall_infuser_z - tall_infuser_lip_z ])
            rotate([ 0, -tall_infuser_handle_angle, 0 ])
                cube([ tall_infuser_handle_x, tall_infuser_handle_y, tall_infuser_handle_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

