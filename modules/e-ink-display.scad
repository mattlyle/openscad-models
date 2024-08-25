// model for the e-ink display

include <rounded-cube.scad>

module EInkDisplay()
{
    display_height = 10;
    display_width = 20;
    display_depth = 2;

    circuit_board_height = 20;
    circuit_board_width = 30;
    circuit_board_depth = 2;
    circuit_board_radius = 0.5;

    // RoundedCube(
    //     width = circuit_board_width,
    //     height = circuit_board_height,
    //     depth = circuit_board_depth,
    //     radius = circuit_board_radius,
    //     center = false,
    //     fn = 50);

    RoundedCube( size = [ 10, 10, 10 ], center = false, radius = 0.5, fn=10 );
}