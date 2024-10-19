
use <../3rd-party/MCAD/regular_shapes.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

roll_length = 305.0;

small_roll_radius = 46.0 / 2;

large_roll_radius = 76.5 / 2;

roll_clearance = 5;

cube_shelf_size = 281;

holder_ring_y = 20;
holder_ring_thickness = 2.0;

holder_back_ring_offset = roll_length * 2/3;

build_volume_size = 255;

preview_thickness = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

// if( render_mode == "preview" )
// {
//     CubeShelfPreview( cube_shelf_size );

//     PrinterBuildVolumePreview();
// }

PrinterBuildPlatePreview();

VinylRollHolderFace( small_roll_radius, cube_shelf_size, 1 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// function CalculateCombinedRadius( roll_radius ) = roll_radius + roll_clearance + holder_ring_thickness / 2;

function CalculateHexagonSideLength( roll_radius ) = (roll_radius + roll_clearance + holder_ring_thickness / 2 ) * 2 * sqrt( 3 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VinylRollHolderFace( roll_radius, max_width, num_rows )
{
    side_length = CalculateHexagonSideLength( roll_radius );

    max_rolls = floor( max_width / side_length );

    for( i = [ 0: num_rows - 1 ] )
    {
        translate([ 0, 0, i * side_length ])
            _VinylRollHolderRow(
                roll_radius = roll_radius,
                num_rolls = max_rolls - ( i % 2 == 0 ? 0 : -1 ),
                is_even_row = i % 2 == 0 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderRow( roll_radius, num_rolls, is_even_row )
{
    // combined_radius = CalculateCombinedRadius( roll_radius );

    // x_offset = is_even_row ? 0 : combined_radius; // TODO: finish!

    side_length = CalculateHexagonSideLength( roll_radius );

    for( i = [ 0 : num_rolls - 1 ] )
    {
        // translate([ x_offset + combined_radius + i * ( combined_radius * 3 ), 0, combined_radius ])
        // {
    //         _VinylRollHolder( roll_radius );

    //         VinylRollPreview( roll_radius );
        // }

        translate([ 0, 0, 0 ])
            _VinylRollHolderHexagon( roll_radius );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// module _VinylRollHolder( roll_radius )
// {
//     // near holder
//     rotate([ -90, 0, 0 ])
//         _VinylRollHolderHexagon();

//     // far holder
//     translate([ 0, holder_back_ring_offset, 0 ])
//         rotate([ -90, 0, 0 ])
//             _VinylRollHolderHexagon();
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _VinylRollHolderHexagon( roll_radius )
{
    render()
    {
        difference()
        {
            // outer
            hexagon_prism( radius = roll_radius + roll_clearance + holder_ring_thickness, height = holder_ring_y );

            // inner
            hexagon_prism( radius = roll_radius + roll_clearance, height = holder_ring_y );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CubeShelfPreview( cube_size )
{
    // bottom
    % translate([ 0, 0, -preview_thickness ])
        cube([ cube_size, cube_size, preview_thickness ]);

    // right
    % translate([ cube_size, 0, 0 ])
        cube([ preview_thickness, cube_size, cube_size ]);

    // top
    % translate([ 0, 0, cube_size ])
        cube([ cube_size, cube_size, preview_thickness ]);

    // left
    % translate([ -preview_thickness, 0, 0 ])
        cube([ preview_thickness, cube_size, cube_size ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PrinterBuildVolumePreview()
{
    // bottom
    # translate([ 0, 0, -preview_thickness ])
        cube([ build_volume_size, build_volume_size, preview_thickness ]);

    // right
    # translate([ build_volume_size, 0, 0 ])
        cube([ preview_thickness, build_volume_size, build_volume_size ]);

    // top
    # translate([ 0, 0, build_volume_size ])
        cube([ build_volume_size, build_volume_size, preview_thickness ]);

    // left
    # translate([ -preview_thickness, 0, 0 ])
        cube([ preview_thickness, build_volume_size, build_volume_size ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PrinterBuildPlatePreview()
{
    # translate([ 0, 0, -preview_thickness ])
        cube([ build_volume_size, build_volume_size, preview_thickness ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VinylRollPreview( r )
{
    % rotate([ -90, 0, 0 ])
        cylinder( h = roll_length, r = r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
