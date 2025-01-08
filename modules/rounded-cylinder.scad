////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RoundedCylinder( h = 10.0, r = 5.0, rounding_r = 1.0, round_top = true, round_bottom = true, fn = $preview ? 32 : 64 )
{
    // % cylinder( h = h, r = r, $fn = 64 );

    hull()
    {
        if( round_top )
        {
            translate([ 0, 0, h - rounding_r ])
                rotate_extrude()
                    translate([ r - rounding_r, 0 ])
                        circle( r = rounding_r, $fn = fn );
        }
        else
        {
            translate([ 0, 0, h - 0.01 ])
                cylinder( r = r, h = 0.01, $fn = fn );
        }

        if( round_bottom )
        {
            translate([ 0, 0, rounding_r ])
                rotate_extrude()
                    translate([ r - rounding_r, 0 ])
                        circle( r = rounding_r, $fn = fn );
        }
        else
        {
            cylinder( r = r, h = 0.01, $fn = fn );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
