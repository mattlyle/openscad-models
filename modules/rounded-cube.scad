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

module RoundedCubeAlt2( x, y, z, r = 1.0, round_top = true, round_bottom = true, center = false, fn = 36 )
{
    assert( x > r * 2, "radius is too small for x" );
    assert( y > r * 2, "radius is too small for y" );
    assert( z > r * 2, "radius is too small for y" );

    x0 = r;
    x1 = x - r;

    y0 = r;
    y1 = y - r;

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

    render()
    {
        difference()
        {
            // outer hull
            hull()
            {
                for( i = [ 0 : 7 ] )
                {
                    translate( points[ i ] )
                        sphere( r = r, $fn = fn );
                }
            }

            // chop off the top if not rounded
            if( !round_top )
            {
                translate([ 0, 0, z ])
                    cube([ x, y, r ]);
            }

            // chop off the bottom if not rounded
            if( !round_bottom )
            {
                translate([ 0, 0, -r ])
                    cube([ x, y, r ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
