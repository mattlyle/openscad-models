include <trapezoidal-prism.scad>
include <triangular-prism.scad>
include <rounded-cube.scad>
include <bin-helper.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

multiboard_cell_size = 25.0;
multiboard_wall_width = 2.0;
multiboard_screw_hole_r = 3.0;
multiboard_cell_corner_width = 14.0;
multiboard_cell_height = 6.5;
multiboard_corner_rounding_r = 1.0;

multiboard_connector_back_connector_clearance = 0.05;
multiboard_connector_back_z = 6.5;
multiboard_connector_back_connector_inner_r = 15.5 / 2 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_outer_r = 20.0 / 2 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_height = 3 + multiboard_connector_back_connector_clearance;
multiboard_connector_back_connector_vertical_height = 1.5;
multiboard_connector_back_pin_size = 1.0;
multiboard_connector_back_connector_top_offset = 1.5;

workroom_multiboard_color = [ 112.0 / 255.0, 128.0 / 255.0, 144.0 / 255.0 ];

multiboard_difference_overlap = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated

multiboard_cell_octagon_edge = multiboard_cell_size / ( 1 + sqrt( 2 ) );
multiboard_cell_octagon_r = multiboard_cell_octagon_edge * sqrt( 4 + 2 * sqrt( 2 ) ) / 2;

multiboard_screw_hole_holder_cross = sqrt( multiboard_cell_octagon_edge * multiboard_cell_octagon_edge * 2 );

multiboard_connector_back_connector_wedge_x = multiboard_connector_back_connector_outer_r - multiboard_connector_back_connector_inner_r;
multiboard_connector_back_connector_wedge_y = multiboard_connector_back_connector_wedge_x * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardMockUpTile( grid_cells_x, num_y )
{
    render()
    {
        for( x = [ 0 : grid_cells_x - 1 ] )
        {
            for( y = [ 0 : num_y - 1 ] )
            {
                translate([ multiboard_cell_size / 2 + multiboard_cell_size * x, multiboard_cell_size / 2 + multiboard_cell_size * y, 0 ])
                {
                    difference()
                    {
                        rotate([ 0, 0, 360 / 16 ])
                            cylinder( h = multiboard_cell_height, r = multiboard_cell_octagon_r, $fn = 8 );
                        rotate([ 0, 0, 360 / 16 ])
                            cylinder( h = multiboard_cell_height, r = multiboard_cell_octagon_r - multiboard_wall_width / 2, $fn = 8 );
                    }
                }

                if( x > 0 && y > 0 )
                {
                    difference()
                    {
                        translate([ multiboard_cell_size * x, multiboard_cell_size * y, multiboard_cell_height / 2 ])
                            rotate([ 0, 0, 45 ])
                                cube([ multiboard_cell_octagon_edge, multiboard_cell_octagon_edge, multiboard_cell_height ], center = true );

                        translate([ multiboard_cell_size * x, multiboard_cell_size * y, 0 ])
                            cylinder( h = multiboard_cell_height, r = multiboard_screw_hole_r, $fn = 16 );
                    }
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBack( grid_cells_x, grid_cells_y )
{
    extra_x = 5;

    back_x = extra_x * 2 + grid_cells_x * multiboard_cell_size;
    back_y = multiboard_cell_size * grid_cells_y;

    MultiboardConnectorBackAlt( back_x, back_y );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Calculate the x-offset that will be used for a multiboard back with size 'size_x'
function MultiboardConnectorBackAltXOffset( size_x ) = ( size_x - floor( size_x / multiboard_cell_size ) * multiboard_cell_size ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBackAlt( size_x, size_y, rounding_r = multiboard_corner_rounding_r )
{
    grid_cells_x = floor( size_x / multiboard_cell_size );
    grid_cells_y = floor( size_y / multiboard_cell_size );

    offset_x = MultiboardConnectorBackAltXOffset( size_x );

    echo( str( "multiboard back - grid cells X = ", grid_cells_x ) );
    echo( str( "multiboard back - grid cells Y = ", grid_cells_y ) );

    difference()
    {
        RoundedCube(
            size_x,
            size_y,
            multiboard_connector_back_z,
            r = rounding_r,
            round_top = false );

        // translate([ 0, 0, multiboard_connector_back_z ])
        //     cube([ size_x, size_y, multiboard_corner_rounding_r ]);

        for( i = [ 0 : grid_cells_x - 1 ] )
        {
            translate([ offset_x + multiboard_cell_size / 2 + i * multiboard_cell_size, 0, 0 ])
                _MultiboardConnectorBackConnectorCutoutToBottom( size_y );
        }
    }

    // add the pins back
    for( i = [ 0 : grid_cells_x - 1 ] )
    {
        translate([ offset_x + multiboard_cell_size / 2 + i * multiboard_cell_size, 0, multiboard_connector_back_connector_height - multiboard_connector_back_pin_size ])
            _MultiboardConnectorBackConnectorPin( size_y );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MultiboardConnectorBackAlt2( size_x, size_y, connector_y_setup, rounding_r = multiboard_corner_rounding_r )
{
    grid_cells_x = floor( size_x / multiboard_cell_size );
    grid_cells_y = floor( size_y / multiboard_cell_size );

    offset_x = MultiboardConnectorBackAltXOffset( size_x );

    echo( str( "multiboard back - grid cells X = ", grid_cells_x ) );
    echo( str( "multiboard back - grid cells Y = ", grid_cells_y ) );

    // verify the connector_y_setup
    echo();
    echo( "These lengths should all be the same:" );
    for( i = [ 0 : len( connector_y_setup ) - 1 ] )
    {
        setup = connector_y_setup[ i ];

            assert( len( setup ) == 1 || len( setup ) == 2, "Only connector_y_setups of length 1 or 2 supported" );

        if( len( setup ) == 2 )
        {
            echo( str( "row ", i, " / length: ", setup[ 0 ] - setup[ 1 ] ) );

            assert( setup[ 0 ] > setup[ 1 ], "First value must be >= second value" );
        }
        else
        {
            echo( str( "row ", i, " / length: ", setup[ 0 ], " (allowed to be less)" ) );
        }
    }
    echo();

    difference()
    {
        RoundedCube(
            size_x,
            size_y,
            multiboard_connector_back_z,
            r = rounding_r,
            round_top = false );

        // remove the cutouts
        for( setup = connector_y_setup )
        {
            if( len( setup ) == 2 )
            {
                for( i = [ 0 : grid_cells_x - 1 ] )
                {
                    // make sure the edge of the cutout isn't above the top
                    assert( setup[ 0 ] * multiboard_cell_size - multiboard_cell_size / 2 + multiboard_wall_width / 2 + multiboard_connector_back_connector_outer_r < size_y );

                    translate([ offset_x + multiboard_cell_size / 2 + i * multiboard_cell_size, 0, 0 ])
                        _MultiboardConnectorBackConnectorCutout(
                            setup[ 0 ] * multiboard_cell_size - multiboard_cell_size / 2 + multiboard_wall_width / 2,
                            setup[ 1 ] * multiboard_cell_size + multiboard_wall_width / 2,
                            true );
                }
            }
            else
            {
                for( i = [ 0 : grid_cells_x - 1 ] )
                {
                    translate([ offset_x + multiboard_cell_size / 2 + i * multiboard_cell_size, 0, 0 ])
                        _MultiboardConnectorBackConnectorCutoutToBottom(
                            setup[ 0 ] * multiboard_cell_size + multiboard_wall_width / 2
                            );
                }
            }
        }
    }

    // TODO: add the pins for all the cutouts
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the [ x, y, z ] outer size of the shell MultiboardConnectorHelper() makes for item_size_vector
//
// this is the size as modelled, lying on its back, so the printed height holder_z lands in y
function MultiboardConnectorHelperSize(
    item_size_vector,
    holder_z,
    clearance,
    wall_width = multiboard_wall_width
    ) =
    [
        item_size_vector[ 0 ] + wall_width * 2 + clearance * 2,
        holder_z + wall_width,
        item_size_vector[ 2 ] + wall_width * 2 + clearance * 2
        ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a multiboard-mounted holder shell sized around item_size_vector: connector back + rounded
// outer shell with a cutout for the item, running the full holder_z and open at the far end
// (for items that extend past it, like the doxie)
module MultiboardConnectorHelper(
    item_size_vector,
    holder_z,
    clearance,
    wall_width = multiboard_wall_width,
    corner_rounding_r = multiboard_corner_rounding_r
    )
{
    size_vector = MultiboardConnectorHelperSize(
        item_size_vector,
        holder_z,
        clearance,
        wall_width
        );

    item_cutout = BinHelperCube(
        item_size_vector[ 0 ] + clearance * 2,
        item_size_vector[ 2 ] + clearance * 2
        );

    MultiboardConnectorHelperBin(
        size_vector,
        [ item_cutout ],
        [ [ wall_width, 0 ] ],
        wall_width,
        corner_rounding_r
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the holder's modelled [ x, y, z ] for a bin of the given cutouts
//
// the bin stands up the way it prints, but the holder is modelled lying on its back, so the
// bin's height (holder_z) lands in y here and its depth away from the board lands in z
function MultiboardConnectorHelperBinSize(
    cutouts,
    holder_z,
    spacing,
    wall_width = multiboard_wall_width
    ) =
    let( bin_size = BinHelperEquallySpacedSize( cutouts, spacing, wall_width ) )
    [
        bin_size[ 0 ],
        holder_z + wall_width,
        bin_size[ 1 ]
        ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// a multiboard-mounted holder of the given outer size: connector back + rounded outer shell
// with the bin cutouts removed, for holders needing more than MultiboardConnectorHelper() covers
module MultiboardConnectorHelperBin(
    size_vector,
    cutouts,
    cutout_locations,
    wall_width = multiboard_wall_width,
    corner_rounding_r = multiboard_corner_rounding_r
    )
{
    // back
    MultiboardConnectorBackAlt( size_vector[ 0 ], size_vector[ 1 ] );

    difference()
    {
        translate([ 0, 0, multiboard_connector_back_z ])
            RoundedCube(
                x = size_vector[ 0 ],
                y = size_vector[ 1 ],
                z = size_vector[ 2 ],
                r = corner_rounding_r,
                round_bottom = false
                );

        // cut out the middle
        for( i = [ 0 : len( cutouts ) - 1 ] )
        {
            _MultiboardConnectorHelperBinCutout(
                cutouts[ i ],
                cutout_locations[ i ],
                size_vector,
                wall_width
                );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// one bin cutout, placed in the holder
//
// the bin stands the way it prints, but the holder is modelled lying on its back, so the three
// bin axes land on the holder like this:
//
//     bin x (across)                -> holder x
//     bin y (depth away from board) -> holder z, sat on top of the back plate
//     bin z (how far things go in)  -> holder y, counted back from the open end
module _MultiboardConnectorHelperBinCutout( cutout, location, size_vector, wall_width )
{
    footprint = BinHelperCutoutFootprint( cutout );
    cutout_depth = BinHelperCutoutDepth( cutout );

    // no depth of its own means it runs the whole way in, stopping at the lip things rest on
    depth_y = cutout_depth == 0 ? size_vector[ 1 ] - wall_width : cutout_depth;

    offset_x = location[ 0 ];
    offset_z = multiboard_connector_back_z + location[ 1 ];

    // it cuts back from the open end, standing a little proud so it shares no face with it
    offset_y = size_vector[ 1 ] - depth_y;
    cut_y = depth_y + DIFFERENCE_OFFSET;

    // cubes are located by their corner and cylinders by their center, so ask for the corner
    corner = BinHelperCutoutCorner( cutout, location );

    assert(
        corner[ 0 ] >= 0 && corner[ 0 ] + footprint[ 0 ] <= size_vector[ 0 ],
        str( "cutout at ", location, " does not fit the holder's x" )
        );
    assert(
        corner[ 1 ] >= 0 && corner[ 1 ] + footprint[ 1 ] <= size_vector[ 2 ],
        str( "cutout at ", location, " does not fit the holder's z" )
        );

    if( BinHelperCutoutIsCube( cutout ) )
    {
        translate([ offset_x, offset_y, offset_z ])
            cube([ footprint[ 0 ], cut_y, footprint[ 1 ] ]);
    }
    else
    {
        // the cylinder is drawn up its own z, so tip it over to run along the holder's y
        translate([ offset_x, offset_y, offset_z ])
            rotate([ -90, 0, 0 ])
                cylinder( r = footprint[ 0 ] / 2, h = cut_y );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardConnectorBackConnectorPin( length_y )
{
    // it's really a tiny pyramid, so we set $fn to 4
    translate([ 0, length_y - multiboard_connector_back_connector_outer_r - multiboard_connector_back_connector_top_offset, 0 ])
        cylinder( h = multiboard_connector_back_pin_size, r1 = 0, r2 = multiboard_connector_back_pin_size, $fn = 4 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardConnectorBackConnectorCutoutToBottom( length_y )
{
    cone_y = length_y - multiboard_connector_back_connector_outer_r - multiboard_connector_back_connector_top_offset;

    _MultiboardConnectorBackConnectorCutout( cone_y, 0, false );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _MultiboardConnectorBackConnectorCutout( cone_y, end_y, add_cutout )
{
    // make sure they are in the right order!
    assert( cone_y > end_y );
/*
    % union()
    {
        // cut out the cone
        translate([ 0, cone_y, 0 ])
            cylinder(
                h = multiboard_connector_back_connector_height,
                r1 = multiboard_connector_back_connector_inner_r,
                r2 = multiboard_connector_back_connector_outer_r );

        // cut out from there to the end...

        // slanted top
        translate([ 0, end_y + ( cone_y - end_y ) / 2, multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height ])
            TrapezoidalPrism(
                x_top = multiboard_connector_back_connector_outer_r * 2,
                x_bottom = multiboard_connector_back_connector_inner_r * 2,
                y = cone_y - end_y,
                z = multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height );

        // also cut out the vertical section under the trapazoid
        translate([ -multiboard_connector_back_connector_outer_r, end_y, multiboard_connector_back_connector_vertical_height ])
            cube([ multiboard_connector_back_connector_outer_r * 2, cone_y - end_y, multiboard_connector_back_connector_vertical_height ]);

        if( add_cutout )
        {
            translate([ -( multiboard_cell_size - multiboard_wall_width ) / 2, end_y - multiboard_cell_size, 0 ])
                cube([ multiboard_cell_size - multiboard_wall_width, multiboard_cell_size, multiboard_connector_back_connector_height ]);

            // near wedge
            translate([
                -multiboard_connector_back_connector_outer_r + multiboard_connector_back_connector_wedge_x,
                end_y,
                0
                ])
                rotate([ 0, -90, 0 ])
                    TriangularPrism(
                        x = multiboard_connector_back_connector_height, // z
                        y = multiboard_connector_back_connector_wedge_y * 3,
                        z = multiboard_connector_back_connector_wedge_x + 1 // x
                    );

            // far wedge
            translate([
                multiboard_connector_back_connector_outer_r - multiboard_connector_back_connector_wedge_x,
                end_y,
                multiboard_connector_back_connector_height
                ])
                rotate([ 0, 90, 0 ])
                    TriangularPrism(
                        x = multiboard_connector_back_connector_height, // z
                        y = multiboard_connector_back_connector_wedge_y * 3,
                        z = multiboard_connector_back_connector_wedge_x + 1 // x
                    );
        }
        else
        {
            // near wedge
            translate([
                -multiboard_connector_back_connector_outer_r + multiboard_connector_back_connector_wedge_x,
                end_y,
                0
                ])
                rotate([ 0, -90, 0 ])
                    TriangularPrism(
                        x = multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height, // z
                        y = multiboard_connector_back_connector_wedge_y,
                        z = multiboard_connector_back_connector_wedge_x // x
                    );

            // far wedge
            translate([
                multiboard_connector_back_connector_outer_r - multiboard_connector_back_connector_wedge_x,
                end_y,
                multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height
                ])
                rotate([ 0, 90, 0 ])
                    TriangularPrism(
                        x = multiboard_connector_back_connector_height - multiboard_connector_back_connector_vertical_height, // z
                        y = multiboard_connector_back_connector_wedge_y,
                        z = multiboard_connector_back_connector_wedge_x // x
                    );
        }
    }
*/
    //////////////////////////////////////////

    translate([ 0, cone_y, -multiboard_difference_overlap ])
        cylinder(
            h = multiboard_connector_back_connector_height + multiboard_difference_overlap,
            r1 = multiboard_connector_back_connector_inner_r,
            r2 = multiboard_connector_back_connector_outer_r );

    points = [
        // top
        [ -multiboard_connector_back_connector_outer_r, cone_y, multiboard_connector_back_connector_height ],
        [ -multiboard_connector_back_connector_outer_r, end_y, multiboard_connector_back_connector_height ],
        [ multiboard_connector_back_connector_outer_r, end_y, multiboard_connector_back_connector_height ],
        [ multiboard_connector_back_connector_outer_r, cone_y, multiboard_connector_back_connector_height ],

        // middle
        [ -multiboard_connector_back_connector_outer_r, cone_y, multiboard_connector_back_connector_vertical_height ],
        [ -multiboard_connector_back_connector_outer_r, end_y, multiboard_connector_back_connector_vertical_height ],
        [ multiboard_connector_back_connector_outer_r, end_y, multiboard_connector_back_connector_vertical_height ],
        [ multiboard_connector_back_connector_outer_r, cone_y, multiboard_connector_back_connector_vertical_height ],

        // bottom
        [ -multiboard_connector_back_connector_inner_r, cone_y, -multiboard_difference_overlap ],
        [ -multiboard_connector_back_connector_inner_r, end_y + multiboard_connector_back_connector_wedge_y, -multiboard_difference_overlap ],
        [ -multiboard_connector_back_connector_outer_r, end_y, -multiboard_difference_overlap ],
        [ multiboard_connector_back_connector_outer_r, end_y, -multiboard_difference_overlap ],
        [ multiboard_connector_back_connector_inner_r, end_y + multiboard_connector_back_connector_wedge_y, -multiboard_difference_overlap ],
        [ multiboard_connector_back_connector_inner_r, cone_y, -multiboard_difference_overlap ],
    ];

    // for( pt = points )
    // {
    //     # translate( pt )
    //         sphere( r = 0.2 );
    // }

    faces = [
        [ 0, 3, 2, 1 ],
        [ 0, 1, 5, 4 ],
        [ 1, 2, 6, 5 ],
        [ 3, 7, 6, 2 ],
        [ 3, 0, 4, 7 ],
        [ 4, 5, 9, 8 ],
        [ 5, 10, 9 ],
        [ 5, 6, 11, 10 ],
        [ 6, 12, 11 ],
        [ 6, 7, 13, 12 ],
        [ 7, 4, 8, 13 ],
        [ 8, 9, 10, 11, 12, 13 ],
    ];

    polyhedron( points = points, faces = faces );

    if( add_cutout )
    {
        translate([
            -( multiboard_cell_size - multiboard_wall_width ) / 2,
            end_y - multiboard_cell_size,
            -multiboard_difference_overlap ])
            cube([
                multiboard_cell_size - multiboard_wall_width,
                multiboard_cell_size + multiboard_difference_overlap,
                multiboard_connector_back_connector_height + multiboard_difference_overlap
                ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
