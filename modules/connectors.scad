include <triangular-prism.scad>
include <utils.scad>

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

module SlideConnectorM(
    neck_x,
    neck_y,
    neck_z,
    cap_x,
    cap_y,
    cap_z
    )
{
    echo( str( "neck_x = ", neck_x ) );
    echo( str( "neck_y = ", neck_y ) );
    echo( str( "neck_z = ", neck_z ) );


    translate([ 0, -neck_y, 0 ])
    {
        union()
        {
            // neck
            cube([ neck_x, neck_y, neck_z ]);

            // cap
            translate([ -cap_x, -cap_y, 0 ])
                cube([ cap_x * 2 + neck_x, cap_y, cap_z + neck_z ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SlideConnectorF(
    neck_x,
    neck_y,
    neck_z,
    cap_x,
    cap_y,
    cap_z,
    collar_x,
    collar_y,
    collar_z,
    padding
    )
{
    // % SlideConnectorM(neck_x,neck_extra_y,neck_y,neck_z,cap_x,cap_y,cap_z);

    translate([ 0, -neck_y, 0 ])
    {
        // cap cover
        difference()
        {
            translate([ -cap_x - collar_x - padding, -cap_y, 0 ])
                cube([
                    neck_x + cap_x * 2 + collar_x * 2 + padding * 2,
                    cap_y + padding + collar_y,
                    neck_z + cap_z + padding + collar_z
                    ]);

            // cut out the cap
            translate([ -cap_x - padding, -cap_y - DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE ])
                cube([
                    cap_x * 2 + padding * 2 + neck_x,
                    cap_y + padding + DIFFERENCE_CLEARANCE * 2,
                    neck_z + padding + cap_z + DIFFERENCE_CLEARANCE
                    ]);

            // cut out the neck
            translate([ -padding, -DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE ])
                cube([
                    neck_x + padding * 2,
                    padding + collar_y + DIFFERENCE_CLEARANCE * 2,
                    neck_z + padding + DIFFERENCE_CLEARANCE
                    ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
