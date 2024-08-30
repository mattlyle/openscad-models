// model for a rounded cube

module RoundedCube( size = [ 1, 1, 1 ], center = false, radius = 0.5, fn = 10 )
{
    main_translate = ( center == true )
        ? [ 0, 0, 0 ]
        : [ size[ 0 ] / 2, size[ 1 ] / 2, size[ 2 ] / 2 ];
    
    translate( main_translate )
    {
        hull()
        {
            // faces
            cube([ size[ 0 ] - radius * 2, size[ 1 ] - radius * 2, size[ 2 ] ], center = true );
            cube([ size[ 0 ] - radius * 2, size[ 1 ], size[ 2 ] - radius * 2 ], center = true );
            cube([ size[ 0 ], size[ 1 ] - radius * 2, size[ 2 ] - radius * 2 ], center = true );
           
            // top corners
            translate ([ size[ 0 ] / 2 - radius, size[ 1 ] / 2 - radius, size[ 2 ] / 2 - radius ] )
                sphere( r = radius, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + radius, size[ 1 ] / 2 - radius, size[ 2 ] / 2 - radius ] )
                sphere( r = radius, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + radius, 0 - size[ 1 ] / 2 + radius, size[ 2 ] / 2 - radius ] )
                sphere( r = radius, $fn = fn );
            translate ([ size[ 0 ] / 2 - radius, 0 - size[ 1 ] / 2 + radius, size[ 2 ] / 2 - radius ] )
                sphere( r = radius, $fn = fn );
           
            // bottom corners
            translate ([ size[ 0 ] / 2 - radius, size[ 1 ] / 2 - radius, 0 - size[ 2 ] / 2 + radius ] )
                sphere( r = radius, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + radius, size[ 1 ] / 2 - radius, 0 - size[ 2 ] / 2 + radius ] )
                sphere( r = radius, $fn = fn );
            translate ([ 0 - size[ 0 ] / 2 + radius, 0 - size[ 1 ] / 2 + radius, 0 - size[ 2 ] / 2 + radius ] )
                sphere( r = radius, $fn = fn );
            translate ([ size[ 0 ] / 2 - radius, 0 - size[ 1 ] / 2 + radius, 0 - size[ 2 ] / 2 + radius ] )
                sphere( r = radius, $fn = fn );
        }
    }
}
