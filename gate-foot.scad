include <modules/trapezoidal-prism.scad>
include <modules/rounded-cylinder.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Lucy decided the wooden foot of my gate looked like a stick, so she chewed it overnight... this is a replacement
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

gate_y = 20.3;
gate_z = 45.6;
gate_edge_post_x = 44.6;
gate_post_offset_x = 91.0; // TODO verify this measurement
gate_post_r = 13.7 / 2;

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

clip_x = 82.0; // NOTE: These are from the cleat side
clip_post_offset_x = 20.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "print-left";
// render_mode = "print-right";
// render_mode = "print-clip-left";
// render_mode = "print-clip-right";

clip_guide_x = 3.0;
clip_guide_z = 2.0;

clip_guide_1_offset_x = 58.0;
clip_guide_2_offset_x = 11.0;

clip_bottom_z = 4;
clip_overlap_y = 2.0;
clip_overlap_z = 16.0;
clip_pinch_angle = 6.0;

gate_overlap_x = foot_cleat_x + 2;

clearance_y = 1.0;
clearance_x = 1.2;

foot_offset_cutout_x = foot_x - foot_cleat_x;
foot_offset_cutout_y = 2.0;

foot_body_color = [ 135 / 255.0, 62 / 255.0, 35 / 255.0 ];
foot_cleat_color = [ 240 / 255.0, 175 / 255.0, 107 / 255.0 ];
foot_pad_color = [ 0.2, 0.2, 0.2 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 16 : 64;

clip_y = foot_y + gate_y + clip_overlap_y * 2 + clearance_y;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // right
    GateFoot( false, false );

    // left
    translate([ foot_x, 200, 0 ])
        rotate([ 0, 0, 180 ])
            GateFoot( true, false );

    // clip on top - right

    // clip on top - left
    translate([ 0, 200 + clip_overlap_y, gate_z + clip_bottom_z ])
        rotate([ 180, 0, 0 ])
            GateFootClip( false );

    // clip to the side - left
    translate([ 300, 0, 0 ])
        GateFootClip( true );

    // clip to the side - right
    translate([ 400, 0, 0 ])
        GateFootClip( false );

    // basic preview of the gate - right
    translate([ gate_overlap_x, 200 - foot_y, 0 ])
        rotate([ 0, 0, 180 ])
            GatePreview();
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
else if( render_mode == "print-clip-left" )
{
    GateFootClip( true );
}
else if( render_mode == "print-clip-right" )
{
    GateFootClip( false );
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GateFoot( is_left_foot, use_foot_pads = true )
{
    // % cube([ foot_x, foot_y, foot_z + ( use_foot_pads ? foot_pad_z : 0 ) ]);

    offset_z = use_foot_pads ? foot_pad_z : 0;

    // main body
    color( foot_body_color )
    {
        render()
        {
            difference()
            {
                hull()
                {
                    // rounded corner
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

                // cutout where the foot meets the cross beam
                if( is_left_foot )
                {
                    translate([ 0, foot_y - foot_offset_cutout_y, 0 ])
                        cube([ foot_offset_cutout_x, foot_offset_cutout_y, foot_z ]);
                }
                else
                {
                    translate([ 0, 0, 0 ])
                        cube([ foot_offset_cutout_x, foot_offset_cutout_y, foot_z ]);
                }
            }
        }
    }

    // cleat
    color( foot_cleat_color )
    {
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
    }

    // clip grooves
    translate([ foot_x - clip_guide_1_offset_x - clip_guide_x / 2, 0, foot_z - foot_edge_rounding_r ])
        cube([ clip_guide_x, foot_y, clip_guide_z + foot_edge_rounding_r ]);
    translate([ foot_x - clip_guide_2_offset_x - clip_guide_x / 2, 0, foot_z - foot_edge_rounding_r ])
        cube([ clip_guide_x, foot_y, clip_guide_z + foot_edge_rounding_r ]);

    // foot pads
    if( use_foot_pads )
    {
        // front foot
        color( foot_pad_color )
            translate([ foot_pad_offset_x, 0, 0 ])
                cube([ foot_pad_x, foot_y, foot_pad_z ]);

        // back foot
        color( foot_pad_color )
            translate([ foot_x - foot_pad_x - foot_pad_offset_x, 0, 0 ])
                cube([ foot_pad_x, foot_y, foot_pad_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GateFootClip( for_left_foot )
{
    cutout_x = gate_post_r * 2 + clearance_x * 2;
    cutout_y = clip_overlap_y + clearance_y * 1.5 + gate_y + gate_post_r * 2;

    render()
    {
        difference()
        {
            union()
            {
                // top
                cube([ clip_x, clip_y, clip_bottom_z ]);

                // cleat side
                cube([ clip_x, clip_overlap_y, clip_overlap_z ]);

                // back side
                translate([ 0, clip_y - clip_overlap_y, 0 ])
                    rotate([ clip_pinch_angle, 0, 0 ])
                        cube([ clip_x, clip_overlap_y, clip_overlap_z ]);
            }

            // remove the post area
            translate([ clip_post_offset_x, 0, 0 ])
                cube([ cutout_x, cutout_y, clip_overlap_z ]);

            // remove grooves
            translate([ clip_guide_1_offset_x-clip_guide_x / 2, clip_overlap_y, clip_bottom_z - clip_guide_z ])
                cube([ clip_guide_x, foot_y + clearance_y, clip_guide_z ]);
            translate([ clip_guide_2_offset_x - clip_guide_x / 2, clip_overlap_y, clip_bottom_z - clip_guide_z ])
                cube([ clip_guide_x, foot_y + clearance_y, clip_guide_z ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GatePreview()
{
    preview_vertical_parts_z = 200;

    // bottom
    % translate([ 0, 0, 0 ])
        cube([ foot_x, gate_y, gate_z ]);

    // vertical edge
    % translate([ 0, 0, gate_z ])
        cube([ gate_edge_post_x, gate_y, preview_vertical_parts_z ]);

    // post
    % translate([ gate_post_offset_x + gate_post_r, gate_y / 2, gate_z ])
        cylinder( h = preview_vertical_parts_z, r = gate_post_r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
