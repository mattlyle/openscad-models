include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

anker_puck_r = 60 / 2;
anker_puck_z = 10.7;
anker_puck_cord_strain_relief_r = 5.4 / 2;
anker_puck_cord_strain_relief_length = 12;
anker_puck_cord_r = 3.5 / 2;

phone_x = 75;
phone_y = 13;
phone_z = 110;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

anker_puck_cord_preview_length = 15;

// this is mainly because my google pixel 11 has the camera bump, so the phone case holder needs to be a bit higher
// than the puck
phone_case_holder_above = 4;

phone_case_holder_below = 30;
phone_case_holder_sides = 4;
phone_case_holder_thickness_front = 1.4;
phone_case_holder_thickness_back = 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    AnkerPuckPreview();
}
else if( render_mode == "print" )
{
    MyModel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PhoneCaseHolder()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PhoneCaseBase()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AnkerPuckPreview()
{
    color( [ 0.1, 0.1, 0.1 ] )
    {
        // puck
        cylinder(
            h = anker_puck_z,
            r = anker_puck_r
            );

        // cord strain relief
        translate([
            0,
            anker_puck_r + anker_puck_cord_strain_relief_length,
            anker_puck_z / 2
            ])
            rotate([
                90,
                0,
                0
                ])
                cylinder(
                    h = anker_puck_cord_strain_relief_length,
                    r = anker_puck_cord_strain_relief_r
                    );
        
        // cord
        translate([
            0,
            anker_puck_r + anker_puck_cord_strain_relief_length + anker_puck_cord_preview_length,
            anker_puck_z / 2
            ])
            rotate([
                90,
                0,
                0
                ])
                cylinder(
                    h = anker_puck_cord_preview_length,
                    r = anker_puck_cord_r
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
