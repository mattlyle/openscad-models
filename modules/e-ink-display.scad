// model for the e-ink display

include <rounded-cube.scad>

module EInkDisplay()
{
    display_height = 71.3;
    display_width = 46.0;
    display_depth = 1.0;

    display_offset_height = 7.0;
    display_offset_width = 0.8;

    circuit_board_height = 85.0;
    circuit_board_width = 47.7;
    circuit_board_depth = 3.6;
    circuit_board_radius = 0.75;

    color([ 0.0, 0.4, 0.5 ])
        RoundedCube(
            size = [ circuit_board_width, circuit_board_height, circuit_board_depth ],
            center = false,
            radius = circuit_board_radius,
            fn = 30 );

    color([ 0.7, 0.7, 0.7 ])
        translate([ display_offset_width, display_offset_height, circuit_board_depth ])
            cube([ display_width, display_height, display_depth ]);

}