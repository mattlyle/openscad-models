// use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity.scad>
use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

use <modules/triangular-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

screwdriver_handle_diameter = 37.0;
screwdriver_shaft_diameter = 10.0;
screwdriver_handle_length = 138.8;
screwdriver_shaft_length = 88.8;

screwdriver_bits_holder_x = 37.0;
screwdriver_bits_holder_y = 85.3;
screwdriver_bits_holder_z = 13.4;
screwdriver_bits_above_z = 27.4 - screwdriver_bits_holder_z;
screwdriver_bits_above_inset_xy = 3.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

cup_x = 2; // in grid cells
cup_y = 2; // in grid cells
cup_z = 1;

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

screwdriver_base_depth = 70;
screwdriver_base_extra_radius = 3;
screwdriver_base_lip_radius = 1;
screwdriver_base_cone_height = 15.0;
screwdriver_base_cone_radius_extra = 1.0;

screwdriver_bits_base_angle = 45;
screwdriver_bits_base_lip_height = 8;
screwdriver_bits_base_lip_thickness = 1.5;
screwdriver_bits_base_extra_x = 3.0;
screwdriver_bits_base_vertical_lip = 40.0;

show_previews = false;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

// screwdriver holder
screwdriver_holder_radius = screwdriver_shaft_diameter / 2 + screwdriver_base_extra_radius + screwdriver_base_cone_radius_extra + screwdriver_base_lip_radius;

// bits holder
screwdriver_bits_base_x = screwdriver_bits_holder_x + screwdriver_bits_base_lip_thickness * 2 + screwdriver_bits_base_extra_x;
screwdriver_bits_base_y = screwdriver_bits_holder_y * cos( screwdriver_bits_base_angle );
screwdriver_bits_base_z = screwdriver_bits_holder_y * sin( screwdriver_bits_base_angle );;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// husky_screwdriver();
// husky_screwdriver_bits();

// base
gridfinity_cup(
    width = cup_x,
    depth = cup_y,
    height = cup_z,
    position = "zero",
    filled_in = true,
    lip_style = "none"
);

combined_x = screwdriver_bits_base_x + screwdriver_holder_radius * 2;

// bits holder
translate([ ( base_x - combined_x ) / 3, ( base_y - screwdriver_bits_base_y ) / 2, base_z ])
    screwdriver_bits_base();

// screwdriver holder
translate([ base_x - screwdriver_holder_radius - ( base_x - combined_x ) / 3, ( base_y - screwdriver_holder_radius * 2 ) / 2 + screwdriver_holder_radius, base_z ])
    screwdriver_base();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screwdriver_base()
{
    render()
    {
        difference()
        {
            cylinder( h = screwdriver_base_depth, r = screwdriver_holder_radius, $fn = 48 );

            // main shaft
            cylinder( h = screwdriver_base_depth, r = screwdriver_shaft_diameter / 2 + screwdriver_base_extra_radius, $fn = 48 );

            // cone
            translate([ 0, 0, screwdriver_base_depth - screwdriver_base_cone_height ])
                cylinder(
                    h = screwdriver_base_cone_height,
                    r1 = screwdriver_shaft_diameter / 2 + screwdriver_base_extra_radius,
                    r2 = screwdriver_shaft_diameter / 2 + screwdriver_base_extra_radius + screwdriver_base_cone_radius_extra,
                    $fn = 48 );
        }
    }

    if( show_previews )
    {
        translate([ 0, 0, 0 ])
            husky_screwdriver();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screwdriver_bits_base()
{
    translate([ screwdriver_bits_base_x, screwdriver_bits_base_y, 0 ])
        rotate([ 0, 0, 180 ])
            TriangularPrism( x = screwdriver_bits_base_x, y = screwdriver_bits_base_y, z = screwdriver_bits_base_z );

    // bottom lip
    rotate([ screwdriver_bits_base_angle, 0, 0 ])
        cube([ screwdriver_bits_base_x, screwdriver_bits_base_lip_thickness, screwdriver_bits_base_lip_height ]);

    // left lip
    translate([ 0, 0, 0 ])
        rotate([ screwdriver_bits_base_angle, 0, 0 ])
            cube([ screwdriver_bits_base_lip_thickness, screwdriver_bits_base_vertical_lip, screwdriver_bits_base_lip_height ]);

    // right lip
    translate([ screwdriver_bits_base_x - screwdriver_bits_base_lip_thickness, 0, 0 ])
        rotate([ screwdriver_bits_base_angle, 0, 0 ])
            cube([ screwdriver_bits_base_lip_thickness, screwdriver_bits_base_vertical_lip, screwdriver_bits_base_lip_height ]);

    if( show_previews )
    {
        translate([ screwdriver_bits_base_lip_thickness + screwdriver_bits_base_extra_x / 2, screwdriver_bits_base_lip_thickness, 0 ])
            rotate([ screwdriver_bits_base_angle, 0, 0 ])
                husky_screwdriver_bits();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module husky_screwdriver()
{
    union()
    {
        % cylinder( h = screwdriver_shaft_length, r = screwdriver_shaft_diameter / 2, $fn = 24 );

        % translate([ 0, 0, screwdriver_shaft_length ])
            cylinder( h = screwdriver_handle_length, r = screwdriver_handle_diameter / 2, $fn = 24 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module husky_screwdriver_bits()
{
    % cube([ screwdriver_bits_holder_x, screwdriver_bits_holder_y, screwdriver_bits_holder_z ]);

    % translate([ screwdriver_bits_above_inset_xy, screwdriver_bits_above_inset_xy, screwdriver_bits_holder_z ])
        cube([ screwdriver_bits_holder_x - screwdriver_bits_above_inset_xy * 2, screwdriver_bits_holder_y - screwdriver_bits_above_inset_xy * 2, screwdriver_bits_above_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
