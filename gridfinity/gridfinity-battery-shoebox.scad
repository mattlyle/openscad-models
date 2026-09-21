include <../modules/gridfinity-extended.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

shoebox_x = 202;
shoebox_y = 328;
shoebox_z = 120;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-baseplates";

shoebox_demo_thickness = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ShoeboxBaseplates();
    ShoeboxPreview();
}
else if( render_mode == "print-baseplates" )
{
    ShoeboxBaseplates();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ShoeboxBaseplates()
{
    GridfinityBaseplateSnugFitInto( shoebox_x, 0, 4, 4 );

    translate([ 0, 42 * 4, 0 ])
        GridfinityBaseplateSnugFitInto( shoebox_x, shoebox_y - 42 * 4, 4, 3 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the shoebox the baseplates need to fit inside
module ShoeboxPreview()
{
    // near
    % translate([ 0, -shoebox_demo_thickness, 0 ])
        cube([ shoebox_x, shoebox_demo_thickness, shoebox_z ]);

    // right
    % translate([ shoebox_x, 0, 0 ])
        cube([ shoebox_demo_thickness, shoebox_y, shoebox_z ]);

    // far
    % translate([ 0, shoebox_y + shoebox_demo_thickness, 0 ])
        cube([ shoebox_x, shoebox_demo_thickness, shoebox_z ]);

    // left
    % translate([ -shoebox_demo_thickness, 0, 0 ])
        cube([ shoebox_demo_thickness, shoebox_y, shoebox_z ]);

    // base
    % translate([ 0, 0, -shoebox_demo_thickness ])
        cube([ shoebox_x, shoebox_y, shoebox_demo_thickness ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
