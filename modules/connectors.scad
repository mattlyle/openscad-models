// module that creates connectors

// the part that goes over
module SnapConnectorOver( width, height, clearance = 0.25 )
{
    // vertical part
    translate([ 0, height + clearance, 0 ])
        cube([ width, height, height + clearance ]);

    // horizontal over part
    render()
    {
        difference()
        {
            connector_cutout_size = sqrt( height * height * 2 );

            translate([ 0, clearance, height ])
                cube([ width, height * 2, height ]);

            translate([ 0, clearance, 0 ])
                rotate([ 45, 0, 0 ])
                    cube([ width, connector_cutout_size, connector_cutout_size ]);
        }
    }
}

// the part that the other goes over
module SnapConnectorOverMe( width, height )
{
    cube([ width, height, height ]);
}
