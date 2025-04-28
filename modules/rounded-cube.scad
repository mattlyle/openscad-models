////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RoundedCubeAlt( x, y, z, center = false, r = 1.0, fn = 24 )
{
    RoundedCube( size = [ x, y, z ], center, r, fn );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// model for a rounded cube

module RoundedCube( size = [ 1, 1, 1 ], center = false, r = 1.0, fn = 24 )
{
    main_translate = ( center == true )
        ? [ 0, 0, 0 ]
        : [ size[ 0 ] / 2, size[ 1 ] / 2, size[ 2 ] / 2 ];

    translate( main_translate )
    {
        hull()
        {
            // faces
            cube([ size[ 0 ] - r * 2, size[ 1 ] - r * 2, size[ 2 ] ], center = true );
            cube([ size[ 0 ] - r * 2, size[ 1 ], size[ 2 ] - r * 2 ], center = true );
            cube([ size[ 0 ], size[ 1 ] - r * 2, size[ 2 ] - r * 2 ], center = true );

            // top corners
            translate ([ size[ 0 ] / 2 - r, size[ 1 ] / 2 - r, size[ 2 ] / 2 - r ] )
                sphere( r = r, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + r, size[ 1 ] / 2 - r, size[ 2 ] / 2 - r ] )
                sphere( r = r, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + r, 0 - size[ 1 ] / 2 + r, size[ 2 ] / 2 - r ] )
                sphere( r = r, $fn = fn );
            translate ([ size[ 0 ] / 2 - r, 0 - size[ 1 ] / 2 + r, size[ 2 ] / 2 - r ] )
                sphere( r = r, $fn = fn );

            // bottom corners
            translate ([ size[ 0 ] / 2 - r, size[ 1 ] / 2 - r, 0 - size[ 2 ] / 2 + r ] )
                sphere( r = r, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + r, size[ 1 ] / 2 - r, 0 - size[ 2 ] / 2 + r ] )
                sphere( r = r, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + r, 0 - size[ 1 ] / 2 + r, 0 - size[ 2 ] / 2 + r ] )
                sphere( r = r, $fn = fn );
            translate ([ size[ 0 ] / 2 - r, 0 - size[ 1 ] / 2 + r, 0 - size[ 2 ] / 2 + r ] )
                sphere( r = r, $fn = fn );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RoundedCubeAlt2(
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
    else
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

module RoundedCubeAlt3( x, y, z, r_top = 1.0, r_bottom = 1.0, r_x = 5.0 )
{
    hull()
    {
        translate([ r_x, r_x, 0 ])
            cylinder( h = z, r = r_x );
        translate([ x - r_x, r_x, 0 ])
            cylinder( h = z, r = r_x );
        translate([ r_x, y - r_x, 0 ])
            cylinder( h = z, r = r_x );
        translate([ x - r_x, y - r_x, 0 ])
            cylinder( h = z, r = r_x );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
