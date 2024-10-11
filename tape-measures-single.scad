use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// silver malco tru-lok 12ft - clip right
silver_malco_12ft_x = 28.5;
silver_malco_12ft_y = 71.0;
silver_malco_12ft_z = 56.7;
silver_malco_12ft_clip_x = 32.6 - silver_malco_12ft_x;
silver_malco_12ft_clip_y_offset = 33.2;
silver_malco_12ft_clip_y = 19.3;
silver_malco_12ft_clip_z = 35.3;
silver_malco_12ft_clip_z_offset = 9.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

show_previews = false;

cup_x = 1; // in grid cells
cup_y = 2; // in grid cells
cup_z = 1;

lip_height = 35.0;
lip_thickness = 1.5;

clearance = 1.0;

holder_offset_y = 6;

text_offset_x = 1.5;
text_offset_y = 0.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

base_x = cup_x * 42.0;
base_y = cup_y * 42.0;
base_z = 7.0;

silver_malco_12ft_holder_x = silver_malco_12ft_x + clearance * 2 + lip_thickness * 2;
silver_malco_12ft_holder_y = silver_malco_12ft_y + clearance * 2 + lip_thickness * 2;

silver_malco_12ft_holder_offset_x = ( base_x - silver_malco_12ft_holder_x ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// base
gridfinity_cup(
    width = cup_x,
    depth = cup_y,
    height = cup_z,
    position = "zero",
    filled_in = true,
    lip_style = "none"
    );

// text
translate([ text_offset_x, text_offset_y, base_z ])
    linear_extrude( 0.5 )
        text( "Silver Malco", size = 5.1 );

// silver malco 12ft
translate([ silver_malco_12ft_holder_offset_x, holder_offset_y, base_z ])
{
    union()
    {
        // near wall
        cube([ silver_malco_12ft_holder_x, lip_thickness, lip_height ]);

        // right wall
        render()
        {
            difference()
            {
                translate([ silver_malco_12ft_holder_x - lip_thickness, 0, 0 ])
                    cube([ lip_thickness, silver_malco_12ft_holder_y, lip_height ]);
                translate([ silver_malco_12ft_holder_x - lip_thickness, silver_malco_12ft_clip_y_offset + lip_thickness, silver_malco_12ft_clip_z_offset - clearance ])
                    cube([ lip_thickness, silver_malco_12ft_clip_y + clearance * 2, silver_malco_12ft_clip_z ]);
            }
        }

        // far wall
        translate([ 0, silver_malco_12ft_holder_y - lip_thickness, 0 ])
            cube([ silver_malco_12ft_holder_x, lip_thickness, lip_height ]);

        // left wall
        translate([ 0, 0, 0 ])
            cube([ lip_thickness, silver_malco_12ft_holder_y, lip_height ]);
    }

    if( show_previews )
    {
        translate([ lip_thickness + clearance, lip_thickness + clearance, 0 ])
            red_craftsman_8m_26ft_tape_measure();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module silver_malco_12ft_tape_measure()
{
    % cube([ silver_malco_12ft_x, silver_malco_12ft_y, silver_malco_12ft_z ]);

    % translate([ silver_malco_12ft_x, silver_malco_12ft_clip_y_offset, silver_malco_12ft_clip_z_offset ])
        cube([ silver_malco_12ft_clip_x, silver_malco_12ft_clip_y, silver_malco_12ft_clip_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
