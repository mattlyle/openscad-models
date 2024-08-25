// model for the e-ink display

include <rounded-cube.scad>

module EInkDisplay()
{
    display_height = 71.3;
    display_width = 46.0;
    display_depth = 1.0;

    display_offset_x = 0;
    display_offset_y = 0;

    circuit_board_height = 85.0;
    circuit_board_width = 47.7;
    circuit_board_depth = 3.6;
    circuit_board_radius = 0.75;

    RoundedCube( size = [ 10, 10, 10 ], center = false, radius = 0.5, fn=10 );
}