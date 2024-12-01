use <../../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <../modules/rounded-cube.scad>
// include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

screw_driver_shaft_diameter = 3.0;
screw_driver_handle_diameter = 12.5;
screw_driver_handle_flare_diameter = 18.2;

screw_driver_shaft_length = 47.0;
screw_driver_handle_length = 80;
screw_driver_handle_flare_length = 15.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
render_mode = "bin-only";
// render_mode = "text-only";

cup_x = 3; // in grid cells
cup_y = 4; // in grid cells
cup_z = 1;

num_screw_drivers = 7;

holder_clearance = 0.15;
corner_rounding_radius = 3.7;

screw_driver_padding_x = 7;
screw_driver_padding_y = 5;

screw_driver_edge_holder_length = 10;
screw_driver_shaft_clearance = 0.5;
screw_driver_handle_flare_clearance = 0.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cup_z * 42.0;

screw_driver_full_length = screw_driver_shaft_length + screw_driver_handle_length + screw_driver_handle_flare_length;

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

                translate([ 0, ( holder_y - screw_driver_full_length ) / 2, holder_z - screw_driver_handle_flare_diameter / 2 - screw_driver_padding_y ])
                {
                    rotate([ -90, 0, 0 ])
                    {
                        spacing_x = screw_driver_handle_flare_diameter / 2 + screw_driver_padding_x;
                        offset_x = ( holder_x - spacing_x * num_screw_drivers ) / 2 + screw_driver_handle_flare_diameter / 2;

                        for( i = [ 0: num_screw_drivers - 1 ] )
                        {
                            if( i % 2 == 0 )
                            {
                                translate([ offset_x + i * spacing_x, 0, 0 ])
                                    SmallScrewDriverCutout( holder_z - screw_driver_handle_flare_diameter / 2 - screw_driver_padding_y, true );

                                if( render_mode == "preview" )
                                {
                                    % translate([ offset_x + i * spacing_x, 0, 0 ])
                                        SmallScrewDriver();
                                }
                            }
                            else
                            {
                                translate([ offset_x + i * spacing_x, 0, screw_driver_full_length ])
                                    rotate([ 180, 0, 0 ])
                                        SmallScrewDriverCutout( holder_z - screw_driver_handle_flare_diameter / 2 - screw_driver_padding_y, false );

                                if( render_mode == "preview" )
                                {
                                    % translate([ offset_x + i * spacing_x, 0, screw_driver_full_length ])
                                        rotate([ 180, 0, 0 ])
                                            SmallScrewDriver();
                                }
                            }
                        }
                    }
                }
        }
    }
}

// if( render_mode == "preview" || render_mode == "text-only" )
// {
//     translate([ 0, holder_y - holder_y / 3, holder_z ])
//         CenteredTextLabel( "Small Screwdriver Set", 5, holder_x, holder_y / 3 );
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SmallScrewDriver()
{
    // shaft
    cylinder( h = screw_driver_shaft_length, r = screw_driver_shaft_diameter / 2, $fn = 36 );

    // handle
    translate([ 0, 0, screw_driver_shaft_length ])
        cylinder( h = screw_driver_handle_length, r = screw_driver_handle_diameter / 2, $fn = 36 );

    // flare
    translate([ 0, 0, screw_driver_shaft_length + screw_driver_handle_length ])
        cylinder( h = screw_driver_handle_flare_length, r1 = screw_driver_handle_diameter / 2, r2 = screw_driver_handle_flare_diameter / 2, $fn = 36 );
}

module SmallScrewDriverCutout( depth, flip_z )
{
    flipped_z_offset = flip_z ? -depth : 0;
    flipped_z_offset_full = flip_z ? -depth : - screw_driver_handle_flare_diameter / 2;

    // shaft holder
    translate([ 0, 0, -screw_driver_shaft_clearance ])
        cylinder( h = screw_driver_edge_holder_length, r = screw_driver_shaft_diameter / 2 + screw_driver_shaft_clearance, $fn = 36 );
    translate([ -screw_driver_shaft_diameter / 2 - screw_driver_shaft_clearance, flipped_z_offset, -screw_driver_shaft_clearance ])
        cube([ screw_driver_shaft_diameter + screw_driver_shaft_clearance * 2, depth, screw_driver_edge_holder_length ]);

    // flare holder
    translate([ 0, 0, screw_driver_full_length - screw_driver_edge_holder_length + screw_driver_shaft_clearance ])
        cylinder( h = screw_driver_edge_holder_length, r = screw_driver_handle_flare_diameter / 2 + screw_driver_handle_flare_clearance, $fn = 36 );
    translate([ -screw_driver_handle_flare_diameter / 2 - screw_driver_handle_flare_clearance, flipped_z_offset, screw_driver_full_length - screw_driver_edge_holder_length + screw_driver_shaft_clearance ])
        cube([ screw_driver_handle_flare_diameter + screw_driver_handle_flare_clearance * 2, depth, screw_driver_edge_holder_length ]);

    // center area
    translate([
        -screw_driver_handle_flare_diameter / 2 - screw_driver_handle_flare_clearance,
        flipped_z_offset_full,
        screw_driver_edge_holder_length - screw_driver_shaft_clearance ])
        cube([ screw_driver_handle_flare_diameter + screw_driver_handle_flare_clearance * 2, depth + screw_driver_handle_flare_diameter / 2, screw_driver_full_length - screw_driver_edge_holder_length * 2 + screw_driver_shaft_clearance * 2 ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
