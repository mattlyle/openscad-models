include <../modules/gridfinity-base.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// blue/black mileseey - clip left
blue_black_mileseey_laser_x = 49.2;
blue_black_mileseey_laser_y = 85.2;
blue_black_mileseey_laser_z = 77.1;
blue_black_mileseey_laser_clip_x = 54.8 - blue_black_mileseey_laser_x;
blue_black_mileseey_laser_clip_y_offset = 30.2;
blue_black_mileseey_laser_clip_y = 31.6;
blue_black_mileseey_laser_clip_z = 43.9;
blue_black_mileseey_laser_clip_z_offset = 16.2;

// red craftsman 8m/26ft - clip right
red_craftsman_8m26ft_x = 44.3;
red_craftsman_8m26ft_y = 86.4;
red_craftsman_8m26ft_z = 78.6;
red_craftsman_8m26ft_clip_x = 48.3 - red_craftsman_8m26ft_x;
red_craftsman_8m26ft_clip_y_offset = 41.6;
red_craftsman_8m26ft_clip_y = 18.6;
red_craftsman_8m26ft_clip_z = 36.6;
red_craftsman_8m26ft_clip_z_offset = 18.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "print-bin";
// render_mode = "print-text";

blue_black_mileseey_laser_label_text = "Mileseey Laser";
red_craftsman_8m26ft_label_text = "Craftsman 26ft";
label_font_size = 6;

show_previews = false;

cells_x = 3;
cells_y = 3; // in grid cells

// the height to be added on top of the base
top_z = 1;

lip_height = 35.0;
lip_thickness = 1.5;

clearance = 1.0;

holder_offset_y = 20;
holder_offset_x = 3.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

base_x = CalculateGridfinitySize( cells_x );
base_y = CalculateGridfinitySize( cells_y );

// the combined z
holder_z = GRIDFINITY_BASE_Z + top_z;

blue_black_mileseey_laser_holder_x = blue_black_mileseey_laser_x + clearance * 2 + lip_thickness * 2;
blue_black_mileseey_laser_holder_y = blue_black_mileseey_laser_y + clearance * 2 + lip_thickness * 2;

red_craftsman_8m26ft_holder_x = red_craftsman_8m26ft_x + clearance * 2 + lip_thickness * 2;
red_craftsman_8m26ft_holder_y = red_craftsman_8m26ft_y + clearance * 2 + lip_thickness * 2;

blue_black_mileseey_laser_holder_offset_x = holder_offset_x;

red_craftsman_8m26ft_holder_offset_x = base_x - red_craftsman_8m26ft_holder_x - red_craftsman_8m26ft_clip_x - holder_offset_x;

text_offset_y = 8.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    TapeMeasuresHolder();
    TapeMeasuresTextLabels();
}
else if( render_mode == "print-bin" )
{
    TapeMeasuresHolder();
}
else if( render_mode == "print-text" )
{
    TapeMeasuresTextLabels();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TapeMeasuresHolder()
{
    GridfinityBase( cells_x, cells_y, top_z, round_top = false, center = false );

    // blue/black mileseey
    translate([ blue_black_mileseey_laser_holder_offset_x, holder_offset_y, holder_z ])
    {
        union()
        {
            // near wall
            translate([ blue_black_mileseey_laser_clip_x, 0, 0 ])
                cube([ blue_black_mileseey_laser_holder_x, lip_thickness, lip_height ]);

            // right wall
            translate([ blue_black_mileseey_laser_clip_x + blue_black_mileseey_laser_holder_x - lip_thickness, 0, 0 ])
                cube([ lip_thickness, blue_black_mileseey_laser_holder_y, lip_height ]);

            // far wall
            translate([ blue_black_mileseey_laser_clip_x, blue_black_mileseey_laser_holder_y - lip_thickness, 0 ])
                cube([ blue_black_mileseey_laser_holder_x, lip_thickness, lip_height ]);

            // left wall
            render()
            {
                difference()
                {
                    translate([ blue_black_mileseey_laser_clip_x, 0, 0 ])
                        cube([ lip_thickness, blue_black_mileseey_laser_holder_y, lip_height ]);
                    translate([ blue_black_mileseey_laser_clip_x, blue_black_mileseey_laser_clip_y_offset + lip_thickness, blue_black_mileseey_laser_clip_z_offset - clearance ])
                        cube([ lip_thickness, blue_black_mileseey_laser_clip_y + clearance * 2, blue_black_mileseey_laser_clip_z ]);
                }
            }
        }

        if( render_mode == "preview" && show_previews )
        {
            translate([ lip_thickness + clearance, lip_thickness + clearance, 0 ])
                blue_black_mileseey_laser_tape_measure();
        }
    }

    // red craftsman
    translate([ red_craftsman_8m26ft_holder_offset_x, holder_offset_y, holder_z ])
    {
        union()
        {
            // near wall
            cube([ red_craftsman_8m26ft_holder_x, lip_thickness, lip_height ]);

            // right wall
            render()
            {
                difference()
                {
                    translate([ red_craftsman_8m26ft_holder_x - lip_thickness, 0, 0 ])
                        cube([ lip_thickness, red_craftsman_8m26ft_holder_y, lip_height ]);
                    translate([ red_craftsman_8m26ft_holder_x - lip_thickness, red_craftsman_8m26ft_clip_y_offset + lip_thickness, red_craftsman_8m26ft_clip_z_offset - clearance ])
                        cube([ lip_thickness, red_craftsman_8m26ft_clip_y + clearance * 2, red_craftsman_8m26ft_clip_z ]);
                }
            }

            // far wall
            translate([ 0, red_craftsman_8m26ft_holder_y - lip_thickness, 0 ])
                cube([ red_craftsman_8m26ft_holder_x, lip_thickness, lip_height ]);

            // left wall
            translate([ 0, 0, 0 ])
                cube([ lip_thickness, red_craftsman_8m26ft_holder_y, lip_height ]);
        }

        if( render_mode == "preview" && show_previews )
        {
            translate([ lip_thickness + clearance, lip_thickness + clearance, 0 ])
                red_craftsman_8m_26ft_tape_measure();
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TapeMeasuresTextLabels()
{
    blue_black_mileseey_laser_holder_offset_x_fake_center = 3.0;
    translate([ blue_black_mileseey_laser_holder_offset_x + blue_black_mileseey_laser_holder_offset_x_fake_center, text_offset_y, holder_z ])
        linear_extrude( 0.5 )
            text( blue_black_mileseey_laser_label_text, size = label_font_size );

    translate([ red_craftsman_8m26ft_holder_offset_x, text_offset_y, holder_z ])
        linear_extrude( 0.5 )
            text( red_craftsman_8m26ft_label_text, size = label_font_size );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module red_craftsman_8m_26ft_tape_measure()
{
    % cube([ red_craftsman_8m26ft_x, red_craftsman_8m26ft_y, red_craftsman_8m26ft_z ]);

    % translate([ red_craftsman_8m26ft_x, red_craftsman_8m26ft_clip_y_offset, red_craftsman_8m26ft_clip_z_offset ])
        cube([ red_craftsman_8m26ft_clip_x, red_craftsman_8m26ft_clip_y, red_craftsman_8m26ft_clip_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blue_black_mileseey_laser_tape_measure()
{
    % translate([ blue_black_mileseey_laser_clip_x, 0, 0 ])
        cube([ blue_black_mileseey_laser_x, blue_black_mileseey_laser_y, blue_black_mileseey_laser_z ]);

    % translate([ 0, blue_black_mileseey_laser_clip_y_offset, blue_black_mileseey_laser_clip_z_offset ])
        cube([ blue_black_mileseey_laser_clip_x, blue_black_mileseey_laser_clip_y, blue_black_mileseey_laser_clip_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
