include <modules/e-ink-display.scad>
include <modules/rounded-cube.scad>
// include <modules/connectors.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

tap_handle_width = 56; // previous size was 50, but need more for stregth
tap_handle_height = 210; // previous height was 190
tap_handle_depth = 20;
tap_handle_radius = 5.0;
tap_handle_fn = 60;

back_plate_clearance = 0.75; // clearance on all sides for the backplate
back_plate_wall_snug_fit = 0.65; // eat this back into the clearance for the backplate
back_plate_wall_width = 1.4;

threaded_fitting_radius = 14.4 / 2;
threaded_fitting_height = 18;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "handle-only";
// render_mode = "backplate-only";
// render_mode = "threaded-insert-test-only";
// render_mode = "front-cutout-test-only";

// drawing options

// the offset from the front of the tap handle to recess the screen
screen_depth_offset = 2.0;

snap_connector_width = 8.0;
snap_connector_height = 1.8;
snap_connector_angle = 45;
snap_connector_clearance = 0.1;

model_spacing = 10.0; // spacing between the tap handle and back plate in the render

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

display_offset_height = tap_handle_height - e_ink_display_circuit_board_height - 20;

back_plate_width = e_ink_display_circuit_board_width;
back_plate_height = e_ink_display_circuit_board_height;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    TapHandle();

    translate([ tap_handle_width + model_spacing, display_offset_height - e_ink_display_screen_offset_height, 0 ])
        BackPlate( true );

    translate([ back_plate_wall_snug_fit, back_plate_wall_snug_fit, 0.5 ]) // just offset it up a little
        translate([ tap_handle_width + model_spacing, display_offset_height - e_ink_display_screen_offset_height, tap_handle_depth - e_ink_display_circuit_board_depth - e_ink_display_circuit_board_backside_clearance_depth - e_ink_display_screen_depth - screen_depth_offset ])
            EInkDisplay( true );

    // backplate demo
    color([ 0.4, 0, 0 ])
        translate([ ( tap_handle_width - back_plate_width ) / 2, display_offset_height - e_ink_display_screen_offset_height + back_plate_clearance * 2, -5 ])
            BackPlate( true );

    // threaded insert test rig
    translate([ 150, 0, 0 ])
    {
        render()
        {
            difference()
            {
                cube([ threaded_fitting_radius * 4, threaded_fitting_radius * 4, threaded_fitting_height * 1.5 ]);

                translate([ threaded_fitting_radius * 2, threaded_fitting_radius * 2, threaded_fitting_height / 2 ])
                    cylinder( h = threaded_fitting_height, r = threaded_fitting_radius, $fn = 48 );
            }
        }
    }
}

if( render_mode == "handle-only" )
{
    translate([ tap_handle_width, 0, tap_handle_depth ])
        rotate([ 0, 180, 0 ])
            TapHandle();
}

if( render_mode == "backplate-only" )
{
    BackPlate( false );
}

if( render_mode == "threaded-insert-test-only" )
{
    render()
    {
        difference()
        {
            cube([ threaded_fitting_radius * 4, threaded_fitting_radius * 4, threaded_fitting_height * 1.5 ]);

            translate([ threaded_fitting_radius * 2, threaded_fitting_radius * 2, threaded_fitting_height / 2 ])
                cylinder( h = threaded_fitting_height, r = threaded_fitting_radius, $fn = 48 );
        }
    }
}

if( render_mode == "front-cutout-test-only" )
{
    extra_space = 10;

    translate([ 0, -display_offset_height + e_ink_display_screen_offset_height + extra_space, 0 ])
    {
        render()
        {
            difference()
            {
                translate([ tap_handle_width, 0, tap_handle_depth ])
                    rotate([ 0, 180, 0 ])
                        TapHandle();

                // cut off below the face
                cube([ tap_handle_width, display_offset_height - e_ink_display_screen_offset_height - extra_space, tap_handle_depth ]);

                // cut off above the face
                translate([ 0, display_offset_height + e_ink_display_circuit_board_height, 0 ])
                    cube([ tap_handle_width, 100, tap_handle_depth]);

                // cut off the whole back
                translate([ 0, 0, 8 ])
                    cube([ tap_handle_width, tap_handle_height, tap_handle_depth ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TapHandle()
{
    render()
    {
        difference()
        {
            RoundedCube(
                size = [ tap_handle_width, tap_handle_height, tap_handle_depth ],
                r = tap_handle_radius,
                center = false,
                fn = tap_handle_fn );

            // cutout for the screen to show through
            translate([( tap_handle_width - e_ink_display_screen_width ) / 2, display_offset_height, tap_handle_depth - e_ink_display_screen_depth - screen_depth_offset ])
                cube([ e_ink_display_screen_width, e_ink_display_screen_height, e_ink_display_screen_depth + screen_depth_offset ]);

            // cutout through the back
            translate([ ( tap_handle_width - e_ink_display_circuit_board_width ) / 2 - back_plate_clearance, display_offset_height - e_ink_display_screen_offset_height + back_plate_clearance, 0 ])
                cube([ e_ink_display_circuit_board_width + back_plate_clearance * 2, e_ink_display_circuit_board_height + back_plate_clearance * 2, tap_handle_depth - e_ink_display_screen_depth - screen_depth_offset ]);

            // cutout for the threaded fitting
            translate([ tap_handle_width / 2, 0, tap_handle_depth / 2 ])
                rotate([ 270, 0, 0 ])
                    cylinder( h = threaded_fitting_height, r = threaded_fitting_radius, $fn = 48 );
        }

        // add the screen bezel
        screen_bezel_size = min( e_ink_display_screen_bezel_top, e_ink_display_screen_bezel_bottom, e_ink_display_screen_bezel_width );
        screen_bezel_depth = screen_depth_offset - e_ink_display_screen_depth;

        // slope the bezel sides
        translate([( tap_handle_width - e_ink_display_screen_width ) / 2, display_offset_height, tap_handle_depth - screen_depth_offset + screen_bezel_depth ])
        {
            polyhedron(
                points = [
                    // top
                    [ 0, e_ink_display_screen_usable_height + screen_bezel_size * 2, screen_bezel_depth ], // A = 0
                    [ e_ink_display_screen_width, e_ink_display_screen_usable_height + screen_bezel_size * 2, screen_bezel_depth ], // B = 1
                    [ e_ink_display_screen_width, 0, screen_bezel_depth ], // C = 2
                    [ 0, 0, screen_bezel_depth ], // D = 3

                    // inside
                    [ screen_bezel_size, e_ink_display_screen_usable_height + screen_bezel_size, 0 ], // E = 4
                    [ e_ink_display_screen_width - screen_bezel_size, e_ink_display_screen_usable_height + screen_bezel_size, 0 ], // F = 5
                    [ e_ink_display_screen_width - screen_bezel_size, screen_bezel_size, 0 ], // G = 6
                    [ screen_bezel_size, screen_bezel_size, 0 ], // H = 7

                    // bottom
                    [ 0, e_ink_display_screen_usable_height + screen_bezel_size * 2, 0 ], // I = 8
                    [ e_ink_display_screen_width, e_ink_display_screen_usable_height + screen_bezel_size * 2, 0 ], // J = 9
                    [ e_ink_display_screen_width, 0, 0 ], // K = 10
                    [ 0, 0, 0 ] // L = 11
                    ],
                faces = [
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
                ] );
        }

        // add the extra gap for the screan offset
        translate([( tap_handle_width - e_ink_display_screen_width ) / 2, display_offset_height + screen_bezel_size * 2 + e_ink_display_screen_usable_height, tap_handle_depth - screen_bezel_depth ])
            cube([ e_ink_display_screen_usable_width + screen_bezel_size * 2, e_ink_display_screen_bezel_top - screen_bezel_size, screen_bezel_depth ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BackPlate( show_clearance_areas )
{
    translate([ back_plate_wall_snug_fit, back_plate_wall_snug_fit, 0 ])
    {
        // back plate
        cube([ back_plate_width, back_plate_height, back_plate_wall_width ]);

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
            cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 48 );
        translate([ e_ink_display_circuit_board_width - corner_peg_width / 2, corner_peg_width / 2, corner_peg_height + back_plate_wall_width ])
            cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 48 );
        translate([ corner_peg_width / 2, e_ink_display_circuit_board_height - corner_peg_width / 2, corner_peg_height + back_plate_wall_width ])
            cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 48 );
        translate([ e_ink_display_circuit_board_width - corner_peg_width / 2, e_ink_display_circuit_board_height - corner_peg_width / 2, corner_peg_height + back_plate_wall_width ])
            cylinder( h = e_ink_display_circuit_board_depth, r = e_ink_display_circuit_board_screw_hole_radius, $fn = 48 );

        // horizontal support
        translate([ 0, e_ink_display_circuit_board_horizonal_support_offset, back_plate_wall_width ])
            cube([ e_ink_display_circuit_board_width, e_ink_display_circuit_board_horizonal_support_height,corner_peg_height ]);

        // wall extra (undo the clearance for the back plate)
        translate([ -back_plate_wall_snug_fit, -back_plate_wall_snug_fit, 0 ])
            cube([ back_plate_width + back_plate_wall_snug_fit * 2, back_plate_wall_snug_fit, back_plate_wall_width ]);
        translate([ back_plate_width, -back_plate_wall_snug_fit, 0 ])
            cube([ back_plate_wall_snug_fit, back_plate_height + back_plate_wall_snug_fit * 2, back_plate_wall_width ]);
        translate([ -back_plate_wall_snug_fit, back_plate_height, 0 ])
            cube([ back_plate_width + back_plate_wall_snug_fit * 2, back_plate_wall_snug_fit, back_plate_wall_width ]);
        translate([ -back_plate_wall_snug_fit, -back_plate_wall_snug_fit, 0 ])
            cube([ back_plate_wall_snug_fit, back_plate_height + back_plate_wall_snug_fit * 2, back_plate_wall_width ]);

        // clearance
        if( show_clearance_areas )
        {
            # translate([ 0, -back_plate_clearance, 0 ])
                cube([ back_plate_width, back_plate_clearance, back_plate_wall_width ]);
            # translate([ back_plate_width, 0, 0 ])
                cube([ back_plate_clearance, back_plate_height, back_plate_wall_width ]);
            # translate([ 0, back_plate_height, 0 ])
                cube([ back_plate_width, back_plate_clearance, back_plate_wall_width ]);
            # translate([ -back_plate_clearance, 0, 0 ])
                cube([ back_plate_clearance, back_plate_height, back_plate_wall_width ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
