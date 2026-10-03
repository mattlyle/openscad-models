////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// a cube with rounded edges/corners; each side can be left square with its round_* flag
// (corner resolution comes from $fn/$fa/$fs - pass $fn = ... at the call site to override)

module RoundedCube(
    x,
    y,
    z,
    r = 1.0,
    round_top = true,
    round_bottom = true,
    round_left = true,
    round_right = true,
    round_front = true,
    round_back = true
    )
{
    if( round_left && round_right )
        assert( x >= r * 2, "radius is too small for x" );
    else if( round_left || round_right )
        assert( x >= r, "radius is too small for x" );

    if( round_front && round_back )
        assert( y >= r * 2, "radius is too small for y" );
    else if( round_front || round_back )
        assert( y >= r, "radius is too small for y" );

    if( round_top && round_bottom )
        assert( z >= r * 2, "radius is too small for z" );
    else if( round_top || round_bottom )
        assert( z >= r, "radius is too small for z" );

    x0 = round_left ? r : 0;
    x1 = round_right ? x - r : x;

    y0 = round_front ? r : 0;
    y1 = round_back ? y - r : y;

    z0 = round_bottom ? r : 0;
    z1 = round_top ? z - r : z;

    points = [
        [ x0, y0, z0 ],
        [ x1, y0, z0 ],
        [ x1, y1, z0 ],
        [ x0, y1, z0 ],

        [ x0, y0, z1 ],
        [ x1, y0, z1 ],
        [ x1, y1, z1 ],
        [ x0, y1, z1 ]
    ];

    intersection()
    {
        cube([ x, y, z ]);

        hull()
        {
            for( i = [ 0 : 7 ] )
            {
                translate( points[ i ] )
                    sphere( r = r );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
