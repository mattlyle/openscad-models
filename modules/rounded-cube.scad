////////////////////////////////////////////////////////////////////////////////

// model for a rounded cube
module RoundedCube( size = [ 1, 1, 1 ], center = false, r = 0.5, fn = 10 )
{
    main_translate = ( center == true )
        ? [ 0, 0, 0 ]
        : [ (size[ 0 ] / 2), (size[ 1 ] / 2), (size[ 2 ] / 2) ];
    
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

////////////////////////////////////////////////////////////////////////////////
