include <modules/e-ink-display.scad>
include <modules/rounded-cube.scad>

tap_handle_width = 56; // previous size was 50, but need more for stregth
tap_handle_height = 210; // previous height was 190
tap_handle_depth = 25;

display_offset_height = tap_handle_height - e_ink_display_circuit_board_height - 20;

// the offset from the front of the tap handle to recess the screen
screen_depth_offset = 2.0;

// handle
render()
    difference()
    {
        RoundedCube(
            size=[ tap_handle_width, tap_handle_height, tap_handle_depth ],
            radius = 5.0,
            center = false,
            fn = 50 );

        // cutout for the screen to show through
        translate([( tap_handle_width - e_ink_display_screen_width ) / 2, display_offset_height, tap_handle_depth - e_ink_display_screen_depth - screen_depth_offset ])
            cube([ e_ink_display_screen_width, e_ink_display_screen_height, e_ink_display_screen_depth + screen_depth_offset ]);

        // cutout through the back
        translate([ ( tap_handle_width - e_ink_display_circuit_board_width ) / 2, display_offset_height - e_ink_display_screen_offset_height, 0 ])
            cube([ e_ink_display_circuit_board_width, e_ink_display_circuit_board_height, tap_handle_depth - e_ink_display_screen_depth - screen_depth_offset ]);
        

        // cutout for the threaded fitting
        // TODO finish!

    }


translate([ tap_handle_width + 10, display_offset_height - e_ink_display_screen_offset_height, tap_handle_depth - e_ink_display_circuit_board_depth - e_ink_display_screen_depth - screen_depth_offset ])
    EInkDisplay();

