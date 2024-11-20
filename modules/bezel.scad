////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Bezel( inner_x, inner_y, bezel_size, bezel_depth )
{
    x_outside_left = 0;
    x_outside_right = inner_x + bezel_size * 2;
    x_inside_left = bezel_size;
    x_inside_right = bezel_size + inner_x;

    y_outside_top = inner_y + bezel_size * 2;
    y_outside_bottom = 0;
    y_inside_top = bezel_size + inner_y;
    y_inside_bottom = bezel_size;

    echo("inside x",x_inside_right-x_inside_left);

    bezel_points = [
        // top
        [ x_outside_left, y_outside_top, bezel_depth ], // A = 0
        [ x_outside_right, y_outside_top, bezel_depth ], // B = 1
        [ x_outside_right, y_outside_bottom, bezel_depth ], // C = 2
        [ x_outside_left, y_outside_bottom, bezel_depth ], // D = 3

        // inside bottom
        [ x_inside_left, y_inside_top, 0 ], // E = 4
        [ x_inside_right, y_inside_top, 0 ], // F = 5
        [ x_inside_right, y_inside_bottom, 0 ], // G = 6
        [ x_inside_left, y_inside_bottom, 0 ], // H = 7

        // bottom
        [ x_outside_left, y_outside_top, 0 ], // I = 8
        [ x_outside_right, y_outside_top, 0 ], // J = 9
        [ x_outside_right, y_outside_bottom, 0 ], // K = 10
        [ x_outside_left, y_outside_bottom, 0 ] // L = 11
        ];

    // color([0.4,0,0])translate(bezel_points[0])sphere(r=0.5,$fn=24);

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
