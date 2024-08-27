include <modules/e-ink-display.scad>
include <modules/rounded-cube.scad>

// options

draw_tap_handle = true;
draw_back_plate = true;
draw_screen_above_plate = true;

// measured values

tap_handle_width = 56; // previous size was 50, but need more for stregth
tap_handle_height = 210; // previous height was 190
tap_handle_depth = 25;
tap_handle_radius = 5.0;
tap_handle_fn = 60;

display_offset_height = tap_handle_height - e_ink_display_circuit_board_height - 20;

threaded_fitting_radius = 8;
threaded_fitting_height = 20;

// the offset from the front of the tap handle to recess the screen
screen_depth_offset = 2.0;

back_plate_wall_width = 2.0;

model_spacing = 10.0;

// TODO also cover the parts of the screen that don't actually show the pixels
// TODO how to secure it in place with a 'snap' or something?

// handle
if( draw_tap_handle )
{
render()
{
    difference()
    {
        RoundedCube(
            size = [ tap_handle_width, tap_handle_height, tap_handle_depth ],
            radius = tap_handle_radius,
            center = false,
            fn = tap_handle_fn );

        // cutout for the screen to show through
        translate([( tap_handle_width - e_ink_display_screen_width ) / 2, display_offset_height, tap_handle_depth - e_ink_display_screen_depth - screen_depth_offset ])
            cube([ e_ink_display_screen_width, e_ink_display_screen_height, e_ink_display_screen_depth + screen_depth_offset ]);

        // cutout through the back
        translate([ ( tap_handle_width - e_ink_display_circuit_board_width ) / 2, display_offset_height - e_ink_display_screen_offset_height, 0 ])
            cube([ e_ink_display_circuit_board_width, e_ink_display_circuit_board_height, tap_handle_depth - e_ink_display_screen_depth - screen_depth_offset ]);

        // cutout for the threaded fitting
        translate([ tap_handle_width / 2, 0, tap_handle_depth / 2 ])
            rotate([ 270, 0, 0 ])
                cylinder( h = threaded_fitting_height, r = threaded_fitting_radius );
    }
}
}

// back plate
if( draw_back_plate )
{
translate([ tap_handle_width + model_spacing, display_offset_height - e_ink_display_screen_offset_height, 0 ])
{
    cube([ e_ink_display_circuit_board_width, e_ink_display_circuit_board_height, back_plate_wall_width ]);

    corner_peg_width = e_ink_display_circuit_board_screw_hole_corner_offset * 2;
    corner_peg_height = tap_handle_depth - e_ink_display_circuit_board_depth - e_ink_display_screen_depth - screen_depth_offset - back_plate_wall_width;

    // corner pegs
    translate([ 0, 0, back_plate_wall_width ])
        cube([ corner_peg_width, corner_peg_width, corner_peg_height ]);
    translate([ e_ink_display_circuit_board_width - corner_peg_width, 0, back_plate_wall_width ])
        cube([ corner_peg_width, corner_peg_width, corner_peg_height ]);
    translate([ 0, e_ink_display_circuit_board_height - corner_peg_width, back_plate_wall_width ])
        cube([ corner_peg_width, corner_peg_width, corner_peg_height ]);
    translate([ e_ink_display_circuit_board_width - corner_peg_width, e_ink_display_circuit_board_height - corner_peg_width, back_plate_wall_width ])
        cube([ corner_peg_width, corner_peg_width, corner_peg_height ]);

    // cylinders on pegs
    translate([ corner_peg_width / 2, corner_peg_width / 2, corner_peg_height + back_plate_wall_width ])
        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );
    translate([ e_ink_display_circuit_board_width - corner_peg_width / 2, corner_peg_width / 2, corner_peg_height + back_plate_wall_width ])
        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );
    translate([ corner_peg_width / 2, e_ink_display_circuit_board_height - corner_peg_width / 2, corner_peg_height + back_plate_wall_width ])
        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );
    translate([ e_ink_display_circuit_board_width - corner_peg_width / 2, e_ink_display_circuit_board_height - corner_peg_width / 2, corner_peg_height + back_plate_wall_width ])
        cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 50 );

    // horizontal support
    translate([ 0, e_ink_display_circuit_board_horizonal_support_offset, back_plate_wall_width ])
        cube([ e_ink_display_circuit_board_width, e_ink_display_circuit_board_horizonal_support_height,corner_peg_height ]);
    }
}

// this is just a debugging var to show the e-ink display above the plane if you want to see the back plate better
z_offset = 0.5;

// draw the e-ink display next to it for design help
if( draw_screen_above_plate )
{
translate([ 0, 0, z_offset ])
    translate([ tap_handle_width + model_spacing, display_offset_height - e_ink_display_screen_offset_height, tap_handle_depth - e_ink_display_circuit_board_depth - e_ink_display_screen_depth - screen_depth_offset ])
        EInkDisplay();
}