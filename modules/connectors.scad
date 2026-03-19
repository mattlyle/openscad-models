include <triangular-prism.scad>
include <rounded-cube.scad>
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
    translate([ 0, -neck_y, 0 ])
    {
        union()
        {
            // neck
            cube([ neck_x, neck_y, neck_z ]);

            echo("cap=", cap_x * 2 + neck_x);

            // cap
            translate([ -cap_x, -cap_y, 0 ])
                RoundedCubeAlt2( cap_x * 2 + neck_x, cap_y, cap_z + neck_z, 0.5, round_bottom = false );
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
    clearance
    )
{
    translate([ 0, -neck_y, 0 ])
    {
        difference()
        {
            // cap cover
            translate([ -cap_x - collar_x - clearance, -cap_y, 0 ])
                RoundedCubeAlt2(
                    x = neck_x + cap_x * 2 + collar_x * 2 + clearance * 2,
                    y = cap_y + clearance + collar_y,
                    z = neck_z + cap_z + clearance + collar_z,
                    r = 0.5,
                    round_bottom = false,
                    round_front = false
                    );

            // cut out the cap
            translate([ -cap_x - clearance, -cap_y - DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE ])
                cube([
                    cap_x * 2 + clearance * 2 + neck_x,
                    cap_y + clearance + DIFFERENCE_CLEARANCE * 2,
                    neck_z + clearance + cap_z + DIFFERENCE_CLEARANCE
                    ]);

            // cut out the neck
            translate([ -clearance, -DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE ])
                cube([
                    neck_x + clearance * 2,
                    clearance + collar_y + DIFFERENCE_CLEARANCE * 2,
                    neck_z + clearance + DIFFERENCE_CLEARANCE
                    ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
