include <../modules/gridfinity-base.scad>
include <../modules/triangular-prism.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

scissors_x = 14;
scissors_y = 210;
scissors_z = 82;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
// render_mode = "preview";
render_mode = "print-bin";

cells_x = 1;
cells_y = 5;

// the height to be added on top of the base
top_z = 42.0;
// top_z = 0;
// top_z = 65; // based on calculated angle_height

wall_width = 3;
clearance_y = 2.0;

magnets_in_corners_only = false;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

// the z to start the cutouts
offset_z = GRIDFINITY_BASE_Z + GRIDFINITY_BASE_Z_SUGGESTED_CLEARANCE;

// scissors_angle = -acos( ( base_y - wall_width * 2 - clearance_y * 2 ) / scissors_y );
scissors_angle = -11.3;
echo( "scissors_angle", scissors_angle );

angle_height = scissors_y * sin( -scissors_angle );
echo( "angle_height", angle_height );

item_sizes_x = [ scissors_x, scissors_x ];
item_angle_offset_z = scissors_y * sin( -scissors_angle );
offsets_x = [
    calculateEquallySpacedOffset( item_sizes_x, base_x, 0, 0 ),
    calculateEquallySpacedOffset( item_sizes_x, base_x, 0, 1 ),
    ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ScissorsBin();

if( render_mode == "preview" )
{
    % translate([-10,0,0]) // show it off to the side a little
        translate([ offsets_x[ 0 ], wall_width, item_angle_offset_z + offset_z])
            rotate([ scissors_angle, 0, 0 ])
                TriangularPrism( scissors_x, scissors_y, scissors_z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScissorsBin()
{
    render()
    {
        difference()
        {
            GridfinityBase(
                cells_x,
                cells_y,
                top_z,
                round_top = true,
                center = false,
                magnets = magnets_in_corners_only ? GRIDFINITY_BASE_MAGNETS_CORNERS_ONLY : GRIDFINITY_BASE_MAGNETS_ALL );

            // cut out the tops
            translate([ offsets_x[ 0 ], wall_width, offset_z ])
                cube([ scissors_x, scissors_y - wall_width * 2 - clearance_y * 2, holder_z ]);
            translate([ offsets_x[ 1 ], wall_width, offset_z ])
                cube([ scissors_x, scissors_y - wall_width * 2 - clearance_y * 2, holder_z ]);
        }

        // add the angled bottoms back
        translate([ offsets_x[ 0 ], wall_width, offset_z ])
            TriangularPrism( scissors_x, base_y - wall_width * 2, angle_height );
        translate([ offsets_x[ 1 ], wall_width, offset_z ])
            TriangularPrism( scissors_x, base_y - wall_width * 2, angle_height );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
