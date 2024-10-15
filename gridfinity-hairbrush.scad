use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
include <modules/pie-slice-prism.scad>
include <modules/trapezoidal-prism.scad>
include <modules/text-label.scad>

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

hairbrush_head_prongs_x = 59.2;
hairbrush_head_prongs_offset_x = 10.0;
hairbrush_head_prongs_z = 42;

hairbrush_clearance = 1.25;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "bin-only";
// render_mode = "text-only";

corner_rounding_radius = 3.7;
holder_clearance = 0.15;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculated values

hairbrush_x = hairbrush_head_prongs_x + hairbrush_clearance * 2;
hairbrush_y = hairbrush_handle_y + hairbrush_head_y + hairbrush_clearance * 2;
hairbrush_z = hairbrush_handle_z;

cells_x = ceil( hairbrush_x / gf_pitch );
cells_y = ceil( hairbrush_y / gf_pitch );
cells_z = 1;

base_x = cells_x * gf_pitch;
base_y = cells_y * gf_pitch;
base_z = 7.0;

holder_x = base_x - holder_clearance * 2;
holder_y = base_y - holder_clearance * 2;
holder_z = cells_z * 42.0;

echo( "cells_x", cells_x );
echo( "cells_y", cells_y );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" || render_mode == "bin-only" )
{
    HairbrushHolder();
}

if( render_mode == "preview" )
{
    translate([ base_x / 2, ( base_y - hairbrush_y ) / 2, base_z + hairbrush_z / 2 + hairbrush_clearance * 2 ])
        Hairbrush();
}

if( render_mode == "preview" || render_mode == "text-only" )
{
    text_area_width = hairbrush_handle_y + ( holder_y - hairbrush_y ) / 2 - hairbrush_clearance;
    text_area_height = ( holder_x - hairbrush_handle_x * 1.5 + hairbrush_clearance * 2 ) / 2;

    translate([ text_area_height + holder_clearance, holder_clearance, holder_z ])
        rotate([ 0, 0, 90 ])
            CenteredTextLabel( "Hairbrush", 10, "Georgia:style=Bold", text_area_width, text_area_height );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HairbrushHolder()
{
    // base
    gridfinity_cup(
        width = cells_x,
        depth = cells_y,
        height = 1,
        position = "zero",
        filled_in = true,
        lip_style = "none"
        );
        
    render()
    {
        difference()
        {
            translate([ holder_clearance, holder_clearance, 0 ])
                RoundedCube(
                    size = [ holder_x, holder_y, holder_z ],
                    r = corner_rounding_radius,
                    fn = 36
                    );

            // cut off the area the gridfinity base covers
            cube([ base_x, base_y, base_z ]);

            translate([ base_x / 2, ( base_y - hairbrush_y ) / 2, base_z ])
            {
                // handle
                translate([ 0, -hairbrush_clearance, hairbrush_z / 2 + hairbrush_clearance * 2 ])
                    rotate([ -90, 0, 0 ])
                        scale([ 1.0, hairbrush_handle_z / hairbrush_handle_x, 1.0 ])
                            cylinder( h = hairbrush_handle_y, r = hairbrush_handle_x / 2 + hairbrush_clearance, $fn = 48 );
                
                // handle upward
                translate([ -hairbrush_handle_x/2 - hairbrush_clearance, -hairbrush_clearance, hairbrush_z / 2 + hairbrush_clearance * 2 ])
                    TrapezoidalPrism(
                        x_top = hairbrush_handle_x * 1.5,
                        x_bottom = hairbrush_handle_x + hairbrush_clearance * 2,
                        y = hairbrush_handle_y + hairbrush_clearance * 2,
                        z = holder_z - ( hairbrush_z / 2 + hairbrush_clearance * 2 ),
                        center = false );

                // head
                translate([ -hairbrush_head_base_x / 2 - hairbrush_clearance, hairbrush_handle_y - hairbrush_clearance, hairbrush_head_offset_z - hairbrush_clearance ])
                    cube([ hairbrush_head_base_x + hairbrush_clearance * 2, hairbrush_head_y + hairbrush_clearance * 2, hairbrush_head_z ]);

                // prongs
                translate([ hairbrush_head_prongs_offset_x, hairbrush_handle_y - hairbrush_clearance, hairbrush_head_offset_z ])
                    rotate([ -90, 0, 0 ])
                        rotate([ 0, 0, 180 + hairbrush_head_angle ])
                            PieSlicePrism( hairbrush_head_z * 2, hairbrush_head_y + hairbrush_clearance * 2, 180 - hairbrush_head_angle * 2 );
                translate([ -hairbrush_head_prongs_offset_x, hairbrush_handle_y - hairbrush_clearance, hairbrush_head_offset_z ])
                    rotate([ -90, 0, 0 ])
                        rotate([ 0, 0, 180 + hairbrush_head_angle ])
                            PieSlicePrism( hairbrush_head_z * 2, hairbrush_head_y + hairbrush_clearance * 2, 180 - hairbrush_head_angle * 2 );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Hairbrush()
{
    color([ 0.3, 0.3, 0.6 ])
    {
        union()
        {
            // handle
            rotate([ -90, 0, 0 ])
                scale([ 1.0, hairbrush_handle_z / hairbrush_handle_x, 1.0 ])
                    cylinder( h = hairbrush_handle_y, r = hairbrush_handle_x / 2 );

            // head
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

                        translate([ hairbrush_head_prongs_offset_x, 0, 0 ])
                            rotate([ 0, 0, 180 + hairbrush_head_angle ])
                                PieSlicePrism( hairbrush_head_z, hairbrush_head_y, 180 - hairbrush_head_angle * 2 );
                        translate([ -hairbrush_head_prongs_offset_x, 0, 0 ])
                            rotate([ 0, 0, 180 + hairbrush_head_angle ])
                                PieSlicePrism( hairbrush_head_z, hairbrush_head_y, 180 - hairbrush_head_angle * 2 );
                    }
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
