include <triangular-prism.scad>

DEFAULT_NOSE_DEPTH = 1.2;
DEFAULT_NOSE_HEIGHT = 1.2;
DEFAULT_ANGLE_in = 40;
DEFAULT_ANGLE = 80;
DEFAULT_BASE_RADIUS = 2.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// module that creates connectors

// the part that goes over
module SnapConnectorOver( width, height_over, interior_angle = 45, clearance = 0.25 )
{
    overhang_height = height_over / tan( interior_angle );

    // vertical part
    translate([ 0, height_over + clearance, 0 ])
        cube([ width, height_over, height_over + overhang_height  - clearance ]);

    // horizontal over part
    translate([ 0, height_over + clearance, height_over + overhang_height - clearance ])
        rotate([ 180, 0, 0  ])
            TriangularPrism( width, height_over, overhang_height );
    // TODO: this '-clearance' actually puts it inside the connector part, but on purpose to keep it snug
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the part that the other goes over
module SnapConnectorOverMe( width, height_over )
{
    cube([ width, height_over, height_over ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateSnapConnectorHeightM(
    height,
    nose_depth = DEFAULT_NOSE_DEPTH,
    nose_height = DEFAULT_NOSE_HEIGHT,
    angle_in = DEFAULT_ANGLE_IN,
    angle_lock = DEFAULT_ANGLE_LOCK
    ) = nose_depth / tan( angle_lock ) + nose_height + nose_depth / tan( angle_in );

module SnapConnectorM(
    width,
    height,
    depth = 1.2,
    nose_depth = DEFAULT_NOSE_DEPTH,
    nose_height = DEFAULT_NOSE_HEIGHT,
    angle_in = DEFAULT_ANGLE_IN,
    angle_lock = DEFAULT_ANGLE_LOCK,
    base_radius = DEFAULT_BASE_RADIUS,
    )
{
    // bottom
    cube([ width, depth, height ]);

    nose_in_z = nose_depth / tan( angle_in );
    nose_lock_z = nose_depth / tan( angle_lock );

    points = [
        [ 0, depth, height ],
        [ 0, depth + nose_depth, height + nose_lock_z ],
        [ 0, depth + nose_depth, height + nose_lock_z + nose_height ],
        [ 0, depth, height + nose_lock_z + nose_height + nose_in_z ],
        [ 0, 0, height + nose_lock_z + nose_height + nose_in_z ],
        [ 0, 0, height ],

        [ width, depth, height ],
        [ width, depth + nose_depth, height + nose_lock_z ],
        [ width, depth + nose_depth, height + nose_lock_z + nose_height ],
        [ width, depth, height + nose_lock_z + nose_height + nose_in_z ],
        [ width, 0, height + nose_lock_z + nose_height + nose_in_z ],
        [ width, 0, height ],
    ];

    polyhedron(
        points = points,
        faces = [
            [ 0, 5, 4, 3, 2, 1 ],
            [ 6, 11, 10, 9, 8, 7 ],
            [ 0, 6, 11, 5 ],
            [ 0, 1, 7, 6 ],
            [ 1, 2, 8, 7 ],
            [ 2, 3, 9, 8 ],
            [ 3, 4, 10, 9 ],
            [ 4, 5, 11, 10 ]
            ]
    );

    // base back
    difference()
    {
        translate([ 0, -base_radius, 0 ])
            cube([ width, base_radius, base_radius ]);

        translate([ -DIFFERENCE_CLEARANCE, -base_radius, base_radius ])
            rotate([ 0, 90, 0 ])
                cylinder( r = base_radius, h = width + DIFFERENCE_CLEARANCE * 2 );
    }

    // base front
    // difference()
    // {
    //     translate([ 0, depth, 0 ])
    //         cube([ width, base_radius, base_radius ]);

    //     translate([ -DIFFERENCE_CLEARANCE, base_radius + depth, base_radius ])
    //         rotate([ 0, 90, 0 ])
    //             cylinder( r = base_radius, h = width + DIFFERENCE_CLEARANCE * 2 );
    // }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
