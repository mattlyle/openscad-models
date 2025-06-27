include <../modules/multiboard.scad>
include <../modules/gridfinity-base.scad>
include <../modules/gridfinity-extended.scad>
include <../modules/triangular-prism.scad>
include <../modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-shelf";

grid_cells_x = 3;
grid_cells_y = 2;

back_z = 50;

bin_clearance = 1.2;

arm_x = 4.0;
arm_z = 35;

bottom_corder_xy = 3.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

shelf_x = CalculateGridfinitySize( grid_cells_x ) + 0.5;
shelf_y = CalculateGridfinitySize( grid_cells_y );

back_x = shelf_x + arm_x * 2 + bin_clearance * 2;
back_y = multiboard_connector_back_z;

echo( "back_x:", back_x );
echo( "back_y:", back_y );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ arm_x + bin_clearance, 0, 10 ])
        GridfinityBinPreview();

    translate([ 0, 0, 0 ])
        MultiboardGridfinityShelf();
}
else if( render_mode == "print-shelf" )
{
    translate([ arm_x + bin_clearance, 0, 0 ])
        MultiboardGridfinityShelf();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardGridfinityShelf()
{
    // baseplate
    translate([ arm_x + bin_clearance, 0, 0 ])
        GridfinityBaseplate( grid_cells_x, grid_cells_y );

    // multiboard back
    translate([ 0, shelf_y + back_y + bin_clearance, 0 ])
        rotate([ 90, 0, 0 ])
            MultiboardConnectorBackAlt( back_x, back_z );

    // gap between baseplate and back
    translate([ arm_x, shelf_y, 0 ])
        cube([ shelf_x + bin_clearance * 2, bin_clearance, GRIDFINITY_BASEPLATE_Z ]);

    // left arm
    _MultiboardGridfinityShelfArm( true );

    // right arm
    translate([ arm_x + bin_clearance * 2 + shelf_x, 0, 0 ])
        _MultiboardGridfinityShelfArm( false );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardGridfinityShelfArm( is_left )
{
    arm_y = shelf_y + bin_clearance - bottom_corder_xy;
    rounding_r = 1.0;

    hull()
    {
        if( is_left )
        {
            // front left corner
            translate([ rounding_r, bottom_corder_xy + rounding_r, rounding_r ])
                sphere( r = rounding_r );

            // back left corner
            translate([ rounding_r, bottom_corder_xy + arm_y, rounding_r ])
                sphere( r = rounding_r );

            // right side
            translate([ arm_x + bin_clearance - 0.01, bottom_corder_xy, 0 ])
                cube([ 0.01, arm_y, GRIDFINITY_BASEPLATE_Z ]);
            
            // top
            translate([ 0, bottom_corder_xy, GRIDFINITY_BASEPLATE_Z - 0.01 ])
                cube([ arm_x + bin_clearance, arm_y, 0.01 ]);
        }
        else
        {
            // front right corner
            translate([ arm_x - rounding_r, bottom_corder_xy + rounding_r, rounding_r ])
                sphere( r = rounding_r );

            // back right corner
            translate([ arm_x - rounding_r, bottom_corder_xy + arm_y, rounding_r ])
                sphere( r = rounding_r );

            // left side
            translate([ -bin_clearance - 0.01, bottom_corder_xy, 0 ])
                cube([ 0.01, arm_y, GRIDFINITY_BASEPLATE_Z ]);

            // top
            translate([ -bin_clearance, bottom_corder_xy, GRIDFINITY_BASEPLATE_Z - 0.01 ])
                cube([ arm_x + bin_clearance, arm_y, 0.01 ]);
        }
    }

    // // triangular part
    translate([ 0, arm_y + bottom_corder_xy, GRIDFINITY_BASEPLATE_Z ])
        rotate([ 90, 0, 0 ])
            TriangularPrism( arm_x, arm_z, arm_y );

    // bottom corner
    if( is_left )
    {
        translate([ arm_x + bin_clearance, shelf_y, GRIDFINITY_BASEPLATE_Z ])
            rotate([ 0, 90, -90 ])
                TriangularPrism( GRIDFINITY_BASEPLATE_Z, bottom_corder_xy, bottom_corder_xy );
    }
    else
    {
        translate([ -bin_clearance, shelf_y, GRIDFINITY_BASEPLATE_Z ])
            rotate([ 0, 90, 180 ])
                TriangularPrism( GRIDFINITY_BASEPLATE_Z, bottom_corder_xy, bottom_corder_xy );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityBinPreview()
{
    # GridfinityBase( grid_cells_x, grid_cells_y, 10, round_top = true, center = false );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
