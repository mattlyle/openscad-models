use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
// include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

hairbrush_handle_x = 27.3;
hairbrush_handle_y = 109;
hairbrush_handle_z = 21.0;

hairbrush_head_base_x = 40.5;
hairbrush_head_y = 121;
hairbrush_head_z = 35;
hairbrush_head_radius_z = 10.1;
hairbrush_head_angle = 25;
hairbrush_head_offset_z = 4.0;
hairbrush_head_prongs_offset_x = 10.0;

hairbrush_clearance = 0.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// HairbrushHolder();

translate([ 0, 0, 0 ])
    Hairbrush();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HairbrushHolder()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Hairbrush()
{
    // handle
    rotate([ -90, 0, 0 ])
        scale([ hairbrush_handle_x/hairbrush_handle_z , 1.0, 1.0 ])
            cylinder( h = hairbrush_handle_y, r = max( hairbrush_handle_x, hairbrush_handle_z ) / 2 );

    // head - base
    translate([ 0, hairbrush_handle_y, - hairbrush_head_base_x / 2 + hairbrush_head_radius_z + hairbrush_head_offset_z ])
    {
        rotate([ -90, 0, 0 ])
        {
            union()
            {
                render()
                {
                    difference()
                    {
                        scale([ 1.0, hairbrush_head_radius_z / hairbrush_head_z, 1.0 ])
                            cylinder( h = hairbrush_head_y, r = hairbrush_head_base_x / 2 );

                    translate([ 0, hairbrush_head_offset_z, 0 ])
                        scale([ 1.0, hairbrush_head_radius_z / hairbrush_head_z, 1.0 ])
                            cylinder( h = hairbrush_head_y, r = hairbrush_head_base_x / 2 );
                    }
                }

                % translate([ hairbrush_head_prongs_offset_x, 0, 0 ])
                    rotate([ 0, 0, 180 + hairbrush_head_angle ])
                        PieSlicePrism( hairbrush_head_z, hairbrush_head_y, 180 - hairbrush_head_angle * 2 );
                % translate([ -hairbrush_head_prongs_offset_x, 0, 0 ])
                    rotate([ 0, 0, 180 + hairbrush_head_angle ])
                        PieSlicePrism( hairbrush_head_z, hairbrush_head_y, 180 - hairbrush_head_angle * 2 );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
