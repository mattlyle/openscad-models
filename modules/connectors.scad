include <triangular-prism.scad>

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

// the part that the other goes over
module SnapConnectorOverMe( width, height_over )
{
    cube([ width, height_over, height_over ]);
}
