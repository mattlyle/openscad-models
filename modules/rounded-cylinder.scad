////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RoundedCylinder(
    h,
    r,
    rounding_r = 1.0,
    round_top = true,
    round_bottom = true
    )
{

    hull()
    {
        if( round_top )
        {
            translate([ 0, 0, h - rounding_r ])
                rotate_extrude()
                    translate([ r - rounding_r, 0 ])
                        circle( r = rounding_r );
        }
        else
        {
            translate([ 0, 0, h - DIFFERENCE_CLEARANCE ])
                cylinder( r = r, h = DIFFERENCE_CLEARANCE );
        }

        if( round_bottom )
        {
            translate([ 0, 0, rounding_r ])
                rotate_extrude()
                    translate([ r - rounding_r, 0 ])
                        circle( r = rounding_r );
        }
        else
        {
            cylinder( r = r, h = DIFFERENCE_CLEARANCE );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
