////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
// render_mode = "print-part-A";
render_mode = "print-part-B";


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    LShapedOffsetConnectorPartA();

    translate([ 50, 0, 0 ])
        LShapedOffsetConnectorPartB();

    translate([ 200, 0, 0 ])
    {
        rotate([ 0, -90, 0 ])
            LShapedOffsetConnectorPartA();

        // center
        # translate([ -8, 0, 0 ])
            cylinder( r1 = 2.25, r2 = 7, h = 23, $fn = 8 );

        // top
        # translate([ -8, 25, 0 ])
            cylinder( r1 = 2.25, r2 = 7, h = 23, $fn = 8 );

        // bottom
        # translate([ -33, 0, 0 ])
            cylinder( r1 = 2.25, r2 = 7, h = 23, $fn = 8 );

        translate([ 2, 0, 23 ])
            rotate([ 0, 180, 0 ])
                LShapedOffsetConnectorPartB();
    }
}
else if( render_mode == "print-part-A" )
{
    LShapedOffsetConnectorPartA();
}
else if( render_mode == "print-part-B" )
{
    LShapedOffsetConnectorPartB();
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LShapedOffsetConnectorPartA()
{
    // import( file = "../assets/8 mm - Dual Offset Snap (DS Part A).stl" );

    hole_r = 2.25;
    hole_offset_z = 8;
    cell_r = 12.5;

    connector_offset_x = -15.5;
    connector_offset_y = -12;
    connector_offset_z = 0;
    connector_x = 14.4;
    connector_y = 49;
    connector_z = 16;

    // % translate([ 0, 0, hole_offset_z ])
    //     rotate([ 0, -90, 0 ])
    //         cylinder( h = 20, r = cell_r );

    // hole cylinders
    // % translate([ -20, 0, hole_offset_z ])
    //     rotate([ 0, 90, 0 ])
    //         cylinder( h = 75, r = hole_r );
    // % translate([ 0, cell_r * 2, 0 ])
    //     translate([ -20, 0, hole_offset_z ])
    //         rotate([ 0, 90, 0 ])
    //             cylinder( h = 75, r = hole_r );
    // % translate([ 0, 0, cell_r * 2 ])
    //     translate([ -20, 0, hole_offset_z ])
    //         rotate([ 0, 90, 0 ])
    //             cylinder( h = 75, r = hole_r );
    // % translate([ 0, cell_r * 2, cell_r * 2 ])
    //     translate([ -20, 0, hole_offset_z ])
    //         rotate([ 0, 90, 0 ])
    //             cylinder( h = 75, r = hole_r );

    // % translate([ connector_offset_x, connector_offset_y, connector_offset_z ])
    //     cube([ connector_x, connector_y, connector_z ]);

    // # translate([ 0, 8, 8 ])
    //     rotate([ 90, 0, 0 ])
    //         import( file = "../assets/8 mm - Dual Offset Snap (DS Part A).stl" );

    // center
    translate([ connector_x + 1, 5.65, 2.35 ])
        rotate([ 45, 0, 0 ])
            import(file="../assets/8mm - Mounting Offset Snap - DS Part A.stl");

    // bottom
    translate([ connector_x + 1, cell_r * 2, 0 ])
        import(file="../assets/8mm - Mounting Offset Snap - DS Part A.stl");

    // top
    translate([ connector_x + 1, 8, 33 ])
        rotate([ 90, 0, 0 ])
            import(file="../assets/8mm - Mounting Offset Snap - DS Part A.stl");

    // fill bottom-center
    difference()
    {
        translate([ -0.1, 3, 0 ])
            cube([ 4, 14, 16 ]);

        translate([ -20, 0, hole_offset_z ])
            rotate([ 0, 90, 0 ])
                cylinder( h = 75, r = 4.75 );
    }

    // fill top-center
    difference()
    {
        translate([ -0.1, -8, 11 ])
            cube([ 4, 16, 16 ]);

        translate([ -20, 0, hole_offset_z ])
            rotate([ 0, 90, 0 ])
                cylinder( h = 75, r = 4.75 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LShapedOffsetConnectorPartB()
{
    // center
    translate([ 0.4, 9.5, 0 ])
        rotate([ 0, 0, -45 ])
            import( file = "../assets/Double-Sided Snap (DS Part B) - Standard.stl" );

    // top
    translate([ -3.5, 24.9, 0 ])
        import( file = "../assets/Double-Sided Snap (DS Part B) - Standard.stl" );

    // bottom
    translate([ 34.9, 13.5, 0 ])
        rotate([ 0, 0, -90 ])
            import( file = "../assets/Double-Sided Snap (DS Part B) - Standard.stl" );

    // fill in the center
    translate( [ 22.5, 12.5, 1.3 ])
        rotate([ 0, 0, 45 ])
            cube( [ 13, 13, 2.6 ], center = true );

    // merge the top and center
    translate([ 5.0, 11.4, 0 ])
            cube([ 10, 2, 2.6 ]);

    // merge the bottom and center
    translate([ 21.4, -5.1, 0 ])
            cube([ 2, 10, 2.6 ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
