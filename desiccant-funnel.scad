include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

funnel_tip_r = 24.6 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

funnel_r = 80 / 2;

funnel_wall_width = 1.6;

funnel_z = 80;
funnel_tip_z = 22;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;
funnel_cone_slope = ( funnel_r - funnel_tip_r ) / ( funnel_z - funnel_tip_z );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    DesiccantFunnel();
}
else if( render_mode == "print" )
{
    translate([ 0, 0, funnel_z ])
        rotate([ 180, 0, 0 ])
            DesiccantFunnel();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DesiccantFunnel()
{
    difference()
    {
        union()
        {
            cylinder(
                r = funnel_tip_r,
                h = funnel_tip_z
                );

            translate([ 0, 0, funnel_tip_z ])
                cylinder(
                    h = funnel_z - funnel_tip_z,
                    r1 = funnel_tip_r,
                    r2 = funnel_r
                    );
        }

        union()
        {
            translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                cylinder(
                    r = funnel_tip_r - funnel_wall_width,
                    h = funnel_tip_z + DIFFERENCE_CLEARANCE * 2
                    );

            translate([ 0, 0, funnel_tip_z - DIFFERENCE_CLEARANCE ])
                cylinder(
                    h = funnel_z - funnel_tip_z + DIFFERENCE_CLEARANCE * 2,
                    r1 = funnel_tip_r - funnel_wall_width - funnel_cone_slope * DIFFERENCE_CLEARANCE,
                    r2 = funnel_r - funnel_wall_width + funnel_cone_slope * DIFFERENCE_CLEARANCE
                    );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
