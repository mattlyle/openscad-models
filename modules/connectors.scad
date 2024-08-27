// module that creates connectors

// the part that goes over
module SnapConnectorOver( width, height, clearance = 0.25 )
{
    // vertical part
    translate([ 0, height + clearance, 0 ])
        cube([ width, height, height + clearance ]);

    // horizontal over part
    translate([ 0, 0, height + clearance ])
        cube([ width, height * 2 + clearance, height ]);
}

// the part that the other goes over
module SnapConnectorOverMe( width, height )
{
    cube([ width, height, height ]);
}
