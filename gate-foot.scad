include <modules/trapezoidal-prism.scad>
include <modules/rounded-cylinder.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Lucy decided the wooden foot of my gate looked like a stick, so she chewed it overnight... this is a replacement
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

foot_x = 260;
foot_y = 19.7;
foot_z = 44.8;

foot_pad_x = 47.1;
foot_pad_z = 47.6 - foot_z;
foot_pad_offset_x = 1.5;

foot_cleat_x = 126.0;
foot_cleat_y = 29.1 - foot_y;
foot_cleat_outer_z = 14.5;
foot_cleat_inner_z = 11.9;
foot_cleat_offset_z = 15.5;

foot_rounding_r = 21.0;

foot_edge_rounding_r = 1.0;

foot_body_color = [ 135 / 255.0, 62 / 255.0, 35 / 255.0 ];
foot_cleat_color = [ 240 / 255.0, 175 / 255.0, 107 / 255.0 ];
foot_pad_color = [ 0.2, 0.2, 0.2 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "print-left";
// render_mode = "print-right";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 16 : 64;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // right
    GateFoot( false, false );

    // left
    translate([ foot_x * 2 + 10, foot_y, 0 ])
        rotate([ 0, 0, 180 ])
            GateFoot( true, false );
}
else if( render_mode == "print-left" )
{
    translate([ foot_x, 0, 0 ])
        rotate([ 90, 0, 180 ])
            GateFoot( true, false );
}
else if( render_mode == "print-right" )
{
    translate([ 0, 0, foot_y ])
        rotate([ -90, 0, 0 ])
            GateFoot( false, false );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GateFoot( is_left_foot, use_foot_pads = true )
{
    // % cube([ foot_x, foot_y, foot_z + ( use_foot_pads ? foot_pad_z : 0 ) ]);

    offset_z = use_foot_pads ? foot_pad_z : 0;

    // main body
    // color( foot_body_color )
    // {
        hull()
        {
            // rounded corner
            render()
            {
                difference()
                {
                    translate([ foot_rounding_r, 0, offset_z + ( foot_z - foot_rounding_r ) ])
                        rotate([ -90, 0, 0 ])
                            RoundedCylinder( h = foot_y, r = foot_rounding_r, rounding_r = foot_edge_rounding_r );

                    translate([ 0, 0, 0 ])
                        cube([ foot_rounding_r, foot_y, foot_z - foot_rounding_r ]);

                    translate([ foot_rounding_r, 0, 0 ])
                        cube([ foot_rounding_r, foot_y, foot_z ]);
                }
            }

            // bottom points
            translate([ foot_edge_rounding_r, foot_edge_rounding_r, foot_edge_rounding_r ])
                sphere( r = foot_edge_rounding_r );
            translate([ foot_x - foot_edge_rounding_r, foot_edge_rounding_r, foot_edge_rounding_r ])
                sphere( r = foot_edge_rounding_r );
            translate([ foot_x - foot_edge_rounding_r, foot_y - foot_edge_rounding_r, foot_edge_rounding_r ])
                sphere( r = foot_edge_rounding_r );
            translate([ foot_edge_rounding_r, foot_y - foot_edge_rounding_r, foot_edge_rounding_r ])
                sphere( r = foot_edge_rounding_r );

            // top corner
            translate([ foot_x - foot_edge_rounding_r, foot_edge_rounding_r, foot_z - foot_edge_rounding_r ])
                sphere( r = foot_edge_rounding_r );
            translate([ foot_x - foot_edge_rounding_r, foot_y - foot_edge_rounding_r, foot_z - foot_edge_rounding_r ])
                sphere( r = foot_edge_rounding_r );
        }
    // }

    // cleat
    // color( foot_cleat_color )
    // {
        if( is_left_foot )
        {
            translate([ foot_x - foot_cleat_x, foot_y - 0.01, offset_z + foot_cleat_offset_z ])
                rotate([ 0, -90, -90 ])
                    TrapezoidalPrism( foot_cleat_outer_z, foot_cleat_inner_z, foot_cleat_x, foot_cleat_y, center = false );

            // also add a merge spot to fill in the rounded edge
            translate([ foot_x - foot_edge_rounding_r, foot_y - foot_edge_rounding_r, foot_cleat_offset_z ])
                cube([ foot_edge_rounding_r, foot_edge_rounding_r, foot_cleat_inner_z ]);
        }
        else
        {
            translate([ foot_x - foot_cleat_x, 0, offset_z + foot_cleat_inner_z + foot_cleat_offset_z ])
                rotate([ 0, 90, -90 ])
                    TrapezoidalPrism( foot_cleat_outer_z, foot_cleat_inner_z, foot_cleat_x, foot_cleat_y, center = false );

            // also add a merge spot to fill in the rounded edge
            translate([ foot_x - foot_edge_rounding_r, 0, foot_cleat_offset_z ])
                cube([ foot_edge_rounding_r, foot_edge_rounding_r, foot_cleat_inner_z ]);
        }
    // }

    if( use_foot_pads )
    {
        // front foot
        // color( foot_pad_color )
            translate([ foot_pad_offset_x, 0, 0 ])
                cube([ foot_pad_x, foot_y, foot_pad_z ]);

        // back foot
        // color( foot_pad_color )
            translate([ foot_x - foot_pad_x - foot_pad_offset_x, 0, 0 ])
                cube([ foot_pad_x, foot_y, foot_pad_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
