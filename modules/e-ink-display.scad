// model for the e-ink display

include <rounded-cube.scad>

// data sheet: https://www.waveshare.com/2.7inch-nfc-powered-e-paper-module.htm

// measured values

e_ink_display_screen_height = 71.3;
e_ink_display_screen_width = 46.0;
e_ink_display_screen_depth = 1.0;

e_ink_display_screen_offset_height = 7.0;
e_ink_display_screen_offset_width = 0.8;
e_ink_display_screen_bezel_top = 9.0;
e_ink_display_screen_bezel_bottom = 3.0;
e_ink_display_screen_bezel_width = 3.0;

e_ink_display_circuit_board_height = 85.0; // spec: 84.5
e_ink_display_circuit_board_width = 47.6; // spec: 47.5
e_ink_display_circuit_board_depth = 1.6;
e_ink_display_circuit_board_backside_clearance_depth = 2.0; // clearance for connectors on the backside
e_ink_display_circuit_board_rounding_radius = 0.75;

e_ink_display_circuit_board_screw_hole_corner_offset = 2.5; // the offset from the edge to the center of the corner screw hole
e_ink_display_circuit_board_screw_hole_radius = 1.35; // spec: 1.5

e_ink_display_circuit_board_horizonal_support_offset = 50.5; // the offset from the bottom to the bottom of the support
e_ink_display_circuit_board_horizonal_support_height = 3.5;

// calculated values

e_ink_display_screen_usable_height = e_ink_display_screen_height - e_ink_display_screen_bezel_top - e_ink_display_screen_bezel_bottom;
e_ink_display_screen_usable_width = e_ink_display_screen_width - e_ink_display_screen_bezel_width * 2;

e_ink_display_circuit_board_combined_depth = e_ink_display_circuit_board_depth + e_ink_display_circuit_board_backside_clearance_depth;

module EInkDisplay( show_clearance_areas = false )
{
    // circuit board
    translate([ 0, 0, e_ink_display_circuit_board_backside_clearance_depth ])
    {
        color([ 0.0, 0.4, 0.5 ])
        {
            render()
            {
                difference()
                {
                    RoundedCube(
                        size = [ e_ink_display_circuit_board_width, e_ink_display_circuit_board_height, e_ink_display_circuit_board_depth ],
                        center = false,
                        r = e_ink_display_circuit_board_rounding_radius,
                        fn = 50 );

                    // screw holes
                    translate([ e_ink_display_circuit_board_screw_hole_corner_offset, e_ink_display_circuit_board_screw_hole_corner_offset, 0 ])
                        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );
                    translate([ e_ink_display_circuit_board_width - e_ink_display_circuit_board_screw_hole_corner_offset, e_ink_display_circuit_board_screw_hole_corner_offset, 0 ])
                        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );
                    translate([ e_ink_display_circuit_board_screw_hole_corner_offset, e_ink_display_circuit_board_height - e_ink_display_circuit_board_screw_hole_corner_offset, 0 ])
                        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );
                    translate([ e_ink_display_circuit_board_width - e_ink_display_circuit_board_screw_hole_corner_offset, e_ink_display_circuit_board_height - e_ink_display_circuit_board_screw_hole_corner_offset, 0 ])
                        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );
                }
            }
        }
    }

    // circuit board clearance
    if( show_clearance_areas )
    {
        # translate([ e_ink_display_circuit_board_screw_hole_corner_offset, e_ink_display_circuit_board_screw_hole_corner_offset, 0 ])
            cube([ e_ink_display_circuit_board_width - e_ink_display_circuit_board_screw_hole_corner_offset * 2, e_ink_display_circuit_board_height - e_ink_display_circuit_board_screw_hole_corner_offset * 2, e_ink_display_circuit_board_backside_clearance_depth ]);
    }
    
    // screen
    translate([ e_ink_display_screen_offset_width, e_ink_display_screen_offset_height, e_ink_display_circuit_board_backside_clearance_depth + e_ink_display_circuit_board_depth ])
    {
        // hardware (including bezel)
        color([ 0.7, 0.7, 0.7 ])
            cube([ e_ink_display_screen_width, e_ink_display_screen_height, e_ink_display_screen_depth ]);
        
        // useful display (ignore bezel)
        color([ 0.4, 0.4, 0.4 ])
            translate([ e_ink_display_screen_bezel_width, e_ink_display_screen_bezel_bottom, e_ink_display_screen_depth ])
                cube([ e_ink_display_screen_usable_width, e_ink_display_screen_usable_height, 0.01 ]);
    }
}
