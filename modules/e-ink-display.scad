// model for the e-ink display

include <rounded-cube.scad>

// measured values

e_ink_display_screen_height = 71.3;
e_ink_display_screen_width = 46.0;
e_ink_display_screen_depth = 1.0;

e_ink_display_screen_offset_height = 7.0;
e_ink_display_screen_offset_width = 0.8;
e_ink_display_screen_bezel_top = 8.4;
e_ink_display_screen_bezel_bottom = 3.0;
e_ink_display_screen_bezel_width = 3.0;

e_ink_display_circuit_board_height = 85.0;
e_ink_display_circuit_board_width = 47.7;
e_ink_display_circuit_board_depth = 3.6;
e_ink_display_circuit_board_rounding_radius = 0.75;

e_ink_display_circuit_board_screw_hole_corner_offset = 3.25; // the offset from the edge to the center of the corner screw hole
e_ink_display_circuit_board_screw_hole_radius = 2.0;

e_ink_display_circuit_board_horizonal_support_offset = 50.5; // the offset from the bottom to the bottom of the support
e_ink_display_circuit_board_horizonal_support_height = 3.5;

// calculated values

e_ink_display_screen_usable_height = e_ink_display_screen_height - e_ink_display_screen_bezel_top - e_ink_display_screen_bezel_bottom;
e_ink_display_screen_usable_width = e_ink_display_screen_width - e_ink_display_screen_bezel_width * 2;

module EInkDisplay()
{
    // circuit board
    color([ 0.0, 0.4, 0.5 ])
    {
        render()
        {
            difference()
            {
                RoundedCube(
                    size = [ e_ink_display_circuit_board_width, e_ink_display_circuit_board_height, e_ink_display_circuit_board_depth ],
                    center = false,
                    radius = e_ink_display_circuit_board_rounding_radius,
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

    // screen
    translate([ e_ink_display_screen_offset_width, e_ink_display_screen_offset_height, e_ink_display_circuit_board_depth ])
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
