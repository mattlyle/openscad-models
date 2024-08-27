include <modules/e-ink-display.scad>
include <modules/rounded-cube.scad>
include <modules/connectors.scad>

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

snap_connector_width = 10.0;
snap_connector_height = 2.0;

model_spacing = 10.0;

// TODO also cover the parts of the screen that don't actually show the pixels
// TODO how to secure it in place with a 'snap' or something?
// TODO the horizontal support doesn't touch because the measurement include the connectors and other BS

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

    // add the screen bezel
    screen_bezel_size = min( e_ink_display_screen_bezel_top, e_ink_display_screen_bezel_bottom, e_ink_display_screen_bezel_width );
    screen_bezel_depth = screen_depth_offset - e_ink_display_screen_depth;

    // slope the bezel sides
    translate([( tap_handle_width - e_ink_display_screen_width ) / 2, display_offset_height, tap_handle_depth - screen_depth_offset + screen_bezel_depth ])
    {
        bezel_points = [
            // top
            [ 0, e_ink_display_screen_height, screen_bezel_depth ], // A = 0
            [ e_ink_display_screen_width, e_ink_display_screen_height, screen_bezel_depth ], // B = 1
            [ e_ink_display_screen_width, 0, screen_bezel_depth ], // C = 2
            [ 0, 0, screen_bezel_depth ], // D = 3

            // inside
                [ screen_bezel_size, e_ink_display_screen_height - screen_bezel_size, 0 ], // E = 4
                [ e_ink_display_screen_width - screen_bezel_size, e_ink_display_screen_height - screen_bezel_size, 0 ], // F = 5
                [ e_ink_display_screen_width - screen_bezel_size, screen_bezel_size, 0 ], // G = 6
                [ screen_bezel_size, screen_bezel_size, 0 ], // H = 7

                // bottom
                [ 0, e_ink_display_screen_height, 0 ], // I = 8
                [ e_ink_display_screen_width, e_ink_display_screen_height, 0 ], // J = 9
                [ e_ink_display_screen_width, 0, 0 ], // K = 10
                [ 0, 0, 0 ] // L = 11
            ];

            bezel_faces = [
                // top
                [ 0, 1, 5, 4 ],
                [ 1, 2, 6, 5 ],
                [ 2, 3, 7, 6 ],
                [ 0, 4, 7, 3 ],

                // outside
                [ 0, 3, 11, 8 ],
                [ 0, 8, 9, 1 ],
                [ 2, 1, 9, 10 ],
                [ 3, 2, 10, 11 ],

                // bottom
                [ 11, 10, 6, 7 ],
                [ 6, 10, 9, 5 ],
                [ 4, 5, 9, 8 ],
                [ 11, 7, 4, 8 ],
            ];

            polyhedron( points = bezel_points, faces = bezel_faces );
        }

        // bottom connector
        translate([ ( tap_handle_width - snap_connector_width ) / 2, display_offset_height - e_ink_display_screen_offset_height, 0 ])
            SnapConnectorOverMe( snap_connector_width, snap_connector_height );

        // top connector
        translate([ ( tap_handle_width - snap_connector_width ) / 2, display_offset_height - e_ink_display_screen_offset_height + e_ink_display_circuit_board_height - snap_connector_height, 0 ])
            SnapConnectorOverMe( snap_connector_width, snap_connector_height );
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

        // bottom connector
        translate([ ( e_ink_display_circuit_board_width - snap_connector_width ) / 2, 0, back_plate_wall_width ])
            SnapConnectorOver( snap_connector_width, snap_connector_height );

        translate([ ( e_ink_display_circuit_board_width - snap_connector_width ) / 2 + snap_connector_width, e_ink_display_circuit_board_height, back_plate_wall_width ])
            rotate([ 0, 0, 180 ])
                SnapConnectorOver( snap_connector_width, snap_connector_height );
    }
}

// this is just a debugging var to show the e-ink display above the plane if you want to see the back plate better
z_offset = 0.5;

// draw the e-ink display next to it for design help
if( draw_screen_above_plate )
{
translate([ 0, 0, z_offset ])
        translate([ tap_handle_width + model_spacing, display_offset_height - e_ink_display_screen_offset_height, tap_handle_depth - e_ink_display_circuit_board_depth - e_ink_display_circuit_board_backside_clearance_depth - e_ink_display_screen_depth - screen_depth_offset ])
            EInkDisplay();
}
