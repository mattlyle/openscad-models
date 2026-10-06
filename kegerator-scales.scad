include <modules/utils.scad>
include <modules/rounded-cube.scad>
include <modules/cord-clip.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

co2_tank_r = 135 / 2;
n2_tank_r = 150 / 2;
keg_r = 220 / 2;

load_cell_xy = 34.1;
load_cell_z = 8.7;
load_cell_wire_cutout_x = 4;

weight_module_x = 34.2;
weight_module_y = 21.3;
weight_module_z = 3.2;

esp32_x = 28.3;
esp32_y = 51.5;
esp32_z = 12.6;

cord_r = 3.6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-keg-1-base";
// render_mode = "print-keg-1-top";
// render_mode = "print-keg-1-top-text";
// render_mode = "print-3mf-keg-1-top";
// render_mode = "print-keg-2-base";
// render_mode = "print-keg-2-top";
// render_mode = "print-keg-2-top-text";
// render_mode = "print-3mf-keg-2-top";
// render_mode = "print-keg-3-base";
// render_mode = "print-keg-3-top";
// render_mode = "print-keg-3-top-text";
// render_mode = "print-3mf-keg-3-top";
// render_mode = "print-co2-base";
// render_mode = "print-co2-top";
// render_mode = "print-co2-top-text";
// render_mode = "print-3mf-co2-top";
// render_mode = "print-n2-base";
// render_mode = "print-n2-top";
// render_mode = "print-n2-top-text";
// render_mode = "print-3mf-n2-top";
// render_mode = "print-test-ring";

top_bottom_fit_clearance = 0.5;

base_lid_z = 2;

top_lid_z = 4;
top_wall_z = 6;

wall_width = 2;

// base_struts_width = 2;
// base_struts_z = 4;
// num_base_struts = 2;

// top_struts_width = 2;
// top_struts_z = 4;
// num_top_struts = 2;

load_cell_clearance = 0.05;
load_cell_wall_width = 2.0;
load_cell_wall_z = 5.0;
load_cell_offset_y = 5;
load_cell_ring_z = 1.6;
load_cell_ring_thickness = 4.0;
load_cell_clip_xy = 2.0;
load_cell_clip_z = 1.4;
load_cell_rounding_r = 5.0;
load_cell_wire_hook_spacing = 6;
load_cell_wire_hook_x = 4.0;
load_cell_wire_hook_z = 1.0;

weight_module_clearance = 0.2;
weight_module_wall_width = 2.0;
weight_module_wall_z = 5.0;
weight_module_corner_length = 2;

esp32_clearance = 0.2;
esp32_wall_width = 2.0;
esp32_wall_z = 5.0;

// space between the cord cutout wall and the usb end of the board, for the plug
esp32_offset_y = 5;

alignment_guide_length = 5;
alignment_guide_width = 2.0;
alignment_guide_clearance = 0.3;
alignment_guide_angle_list = [ -90, 0, 90 ];
alignment_guide_top_z = 6;

test_top_r = 95;
test_top_width = 18;
test_top_z = 4;
test_top_alignment_guide_z = 10;
test_top_label_font_size = 8;
test_top_label_offset_y = 1;

top_color = "white";
label_color = "black";

keg_1_label = "Keg 1";
keg_2_label = "Keg 2";
keg_3_label = "Keg 3";
co2_label = "CO₂";
n2_label = "N₂";

label_font = "Liberation Sans:style=Bold";
label_font_size_top = 40;
label_font_size_bottom = 8;
label_depth = 0.5;
label_area_x = 40;
label_area_y = 12;
version_font_size = 6;

// space between the wall and the label on the base
base_label_offset_y = 5;

// THIS IS AUTO UPDATED BY THE BUILD SCRIPT - DO NOT EDIT
BUILD_SCRIPT_VERSION = "v3";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 512;

base_z = base_lid_z + load_cell_z;
top_z = top_lid_z + top_wall_z;

load_cell_holder_xy = load_cell_xy + ( load_cell_wall_width + load_cell_clearance ) * 2;

esp32_holder_x = esp32_x + esp32_wall_width * 2 + esp32_clearance * 2;
esp32_holder_y = esp32_y + esp32_wall_width * 2 + esp32_clearance * 2;

weight_module_holder_x =
    weight_module_x
    + weight_module_wall_width * 2
    + weight_module_clearance * 2;
weight_module_holder_y =
    weight_module_y
    + weight_module_wall_width * 2
    + weight_module_clearance * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // keg row
    PreviewRow( keg_r, keg_1_label, true );

    // co2 tank row
    translate([ 0, 250, 0 ])
        PreviewRow( co2_tank_r, co2_label, false );

    // n2 tank row
    translate([ 0, 500, 0 ])
        PreviewRow( n2_tank_r, n2_label, false );

    // test top row
    translate([ 0, -250, 0 ])
        PreviewTestRow( keg_r, keg_1_label, false );
}
else if( render_mode == "print-keg-1-base" )
{
    ScaleBase( keg_r, keg_1_label, true );
}
else if( render_mode == "print-keg-1-top" )
{
    ScaleTop( keg_r, keg_1_label );
}
else if( render_mode == "print-keg-1-top-text" )
{
    ScaleTopLabel( keg_1_label );
}
else if( render_mode == "print-3mf-keg-1-top" )
{
    color( top_color )
        ScaleTop( keg_r, keg_1_label );

    color( label_color )
        ScaleTopLabel( keg_1_label );
}
else if( render_mode == "print-keg-2-base" )
{
    ScaleBase( keg_r, keg_2_label, true );
}
else if( render_mode == "print-keg-2-top" )
{
    ScaleTop( keg_r, keg_2_label );
}
else if( render_mode == "print-keg-2-top-text" )
{
    ScaleTopLabel( keg_2_label );
}
else if( render_mode == "print-3mf-keg-2-top" )
{
    color( top_color )
        ScaleTop( keg_r, keg_2_label );

    color( label_color )
        ScaleTopLabel( keg_2_label );
}
else if( render_mode == "print-keg-3-base" )
{
    ScaleBase( keg_r, keg_3_label, true );
}
else if( render_mode == "print-keg-3-top" )
{
    ScaleTop( keg_r, keg_3_label );
}
else if( render_mode == "print-keg-3-top-text" )
{
    ScaleTopLabel( keg_3_label );
}
else if( render_mode == "print-3mf-keg-3-top" )
{
    color( top_color )
        ScaleTop( keg_r, keg_3_label );

    color( label_color )
        ScaleTopLabel( keg_3_label );
}
else if( render_mode == "print-co2-base" )
{
    ScaleBase( co2_tank_r, co2_label, false );
}
else if( render_mode == "print-co2-top" )
{
    ScaleTop( co2_tank_r, co2_label );
}
else if( render_mode == "print-co2-top-text" )
{
    ScaleTopLabel( co2_label );
}
else if( render_mode == "print-3mf-co2-top" )
{
    color( top_color )
        ScaleTop( co2_tank_r, co2_label );

    color( label_color )
        ScaleTopLabel( co2_label );
}
else if( render_mode == "print-n2-base" )
{
    ScaleBase( n2_tank_r, n2_label, false );
}
else if( render_mode == "print-n2-top" )
{
    ScaleTop( n2_tank_r, n2_label );
}
else if( render_mode == "print-n2-top-text" )
{
    ScaleTopLabel( n2_label );
}
else if( render_mode == "print-3mf-n2-top" )
{
    color( top_color )
        ScaleTop( n2_tank_r, n2_label );

    color( label_color )
        ScaleTopLabel( n2_label );
}
else if( render_mode == "print-test-ring" )
{
    TestRing( keg_r, keg_1_label );
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the assembled scale, then the base and the top as they print
module PreviewRow( scale_r, label, use_cord_clips )
{
    ScaleBase( scale_r, label, use_cord_clips );

    // translate([ 0, 0, 18 ])
    translate([ 0, 0, 30 ])
        rotate([ 0, 180, 0 ])
        {
            ScaleTop( scale_r, label );

            color( label_color )
                ScaleTopLabel( label );
        }

    translate([ 250, 0, 0 ])
        ScaleBase( scale_r, label, use_cord_clips );

    translate([ 500, 0, 0 ])
    {
        ScaleTop( scale_r, label );

        color( label_color )
            ScaleTopLabel( label );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewTestRow( scale_r, label, use_cord_clips )
{
    ScaleBase( scale_r, label, use_cord_clips );

    // translate([ 0, 0, 18 ])
    translate([ 0, 0, 30 ])
        rotate([ 0, 180, 0 ])
            TestRing( scale_r, label );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleBase( scale_r, label, use_cord_clips )
{
    difference()
    {
        // full base
        cylinder(
            r = scale_r + wall_width,
            h = base_z
            );
        
        // cut out the inside
        translate([ 0, 0, base_lid_z ])
            cylinder(
                r = scale_r,
                h = base_z
                );

        // cut out the cord
        translate([
            -cord_r / 2,
            -scale_r - wall_width,
            base_lid_z
            ])
            cube([
                cord_r,
                wall_width * 2,
                base_z - base_lid_z + DIFFERENCE_CLEARANCE
                ]);
    }

    // add back the load cell holders
    for( i = [ 45, 135, 225, 315 ])
    {
        rotate([ 0, 0, i ])
            translate([
                -load_cell_holder_xy / 2,
                scale_r - load_cell_holder_xy - load_cell_offset_y,
                base_lid_z - DIFFERENCE_CLEARANCE
                ])
                _LoadCellHolder( use_cord_clips );
    }

    // add back the ESP32 holder, just inside the cord cutout
    translate([
        -esp32_holder_x / 2,
        -scale_r + esp32_offset_y,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        _ESP32Holder();

    // add back the weight module holder, dead center
    translate([
        -weight_module_holder_x / 2,
        -weight_module_holder_y / 2,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        _WeightModuleHolder();

    // alignment guides
    for( i = alignment_guide_angle_list )
    {
        // center
        // #rotate([ 0, 0, i ])
        //     translate([
        //         -alignment_guide_width / 2,
        //         scale_r - alignment_guide_length,
        //         base_lid_z
        //         ])
        //         cube([
        //             alignment_guide_width,
        //             alignment_guide_length,
        //             base_z - base_lid_z
        //             ]);

        // left
        rotate([ 0, 0, i ])
            translate([
                -alignment_guide_width / 2 - alignment_guide_width - alignment_guide_clearance,
                scale_r - alignment_guide_length,
                base_lid_z
                ])
                cube([
                    alignment_guide_width,
                    alignment_guide_length,
                    base_z - base_lid_z
                    ]);
        
        // right
        rotate([ 0, 0, i ])
            translate([
                alignment_guide_width / 2 + alignment_guide_clearance,
                scale_r - alignment_guide_length,
                base_lid_z
                ])
                cube([
                    alignment_guide_width,
                    alignment_guide_length,
                    base_z - base_lid_z
                    ]);
    }

    // raised label on the floor, opposite the ESP32 holder
    translate([
        -label_area_x / 2,
        scale_r - base_label_offset_y - label_area_y,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        CenteredTextLabel(
            label,
            centered_in_area_x = label_area_x,
            centered_in_area_y = label_area_y,
            depth = label_depth + DIFFERENCE_CLEARANCE,
            font_size = label_font_size_bottom,
            font = label_font,
            color = undef
            );

    // raised version on the floor, at 3 o'clock where the label is at 12, facing the same way
    translate([
        scale_r - base_label_offset_y - label_area_y / 2,
        0,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        VersionLabel( label_depth + DIFFERENCE_CLEARANCE );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleTop( scale_r, label )
{
    difference()
    {
        // full base
        cylinder(
            r = scale_r + wall_width * 2 + top_bottom_fit_clearance,
            h = top_z
            );
        
        // cut out the inside
        translate([ 0, 0, top_lid_z ])
            cylinder(
                r = scale_r + wall_width + top_bottom_fit_clearance,
                h = top_z
                );

        // cut out the cord, starting outside the skirt so nothing is left of it
        translate([
            -cord_r / 2,
            -scale_r - wall_width * 2 - top_bottom_fit_clearance - DIFFERENCE_CLEARANCE,
            top_lid_z
            ])
            cube([
                cord_r,
                wall_width * 2 + DIFFERENCE_CLEARANCE,
                top_z - top_lid_z + DIFFERENCE_CLEARANCE
                ]);

        // inset the label into the face that prints on the bed
        ScaleTopLabel( label, is_cutout = true );
    }

    // raised version, dead center on the underside
    translate([ 0, 0, top_lid_z - DIFFERENCE_CLEARANCE ])
        VersionLabel( label_depth + DIFFERENCE_CLEARANCE );

    // alignment guides, between the pairs of guides on the base and clear of its rim
    for( i = alignment_guide_angle_list )
        rotate([ 0, 0, i ])
            translate([
                -alignment_guide_width / 2,
                scale_r - alignment_guide_length,
                top_lid_z - DIFFERENCE_CLEARANCE
                ])
                cube([
                    alignment_guide_width,
                    alignment_guide_length - alignment_guide_clearance,
                    alignment_guide_top_z + DIFFERENCE_CLEARANCE
                    ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TestRing( scale_r, label )
{
    difference()
    {
        cylinder(
            r = test_top_r,
            h = test_top_z
            );

        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                r = test_top_r - test_top_width,
                h = test_top_z + DIFFERENCE_CLEARANCE * 2
                );

        // inset the label into the face that prints on the bed, centered across the ring at the top
        translate([
            0,
            test_top_r - test_top_width / 2 - test_top_label_offset_y,
            0
            ])
            ScaleTopLabel(
                label,
                is_cutout = true,
                font_size = test_top_label_font_size
                );

        // inset the version in the same face, at the bottom of the ring. mirrored like the label
        translate([
            0,
            -( test_top_r - test_top_width / 2 - test_top_label_offset_y ),
            -DIFFERENCE_OFFSET
            ])
            mirror([ 1, 0, 0 ])
                VersionLabel( label_depth + DIFFERENCE_OFFSET );
    }

    for( i = alignment_guide_angle_list )
    {
        rotate([ 0, 0, i ])
            translate([
                -alignment_guide_width / 2,
                test_top_r - alignment_guide_clearance,
                0
                ])
                cube([
                    alignment_guide_width,
                    scale_r - test_top_r - alignment_guide_clearance,
                    test_top_alignment_guide_z
                    ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// centered in the top. mirrored because the top is modeled upside down, so it reads correctly once
// the top is flipped over the base. the cut version stands proud of the face so it has no coplanar
// surface to fight with; the printed one sits flush in the recess
module ScaleTopLabel( label, is_cutout = false, font_size = label_font_size_top )
{
    offset_z = is_cutout ? -DIFFERENCE_OFFSET : 0;
    depth_choice = is_cutout ? label_depth + DIFFERENCE_OFFSET : label_depth;

    mirror([ 1, 0, 0 ])
        translate([ -label_area_x / 2, -label_area_y / 2, offset_z ])
            CenteredTextLabel(
                label,
                centered_in_area_x = label_area_x,
                centered_in_area_y = label_area_y,
                depth = depth_choice,
                font_size = font_size,
                font = label_font,
                color = undef
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the version the build script stamped into the model, centered on the origin
module VersionLabel( depth )
{
    translate([ -label_area_x / 2, -label_area_y / 2, 0 ])
        CenteredTextLabel(
            BUILD_SCRIPT_VERSION,
            centered_in_area_x = label_area_x,
            centered_in_area_y = label_area_y,
            depth = depth,
            font_size = version_font_size,
            font = label_font,
            color = undef
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _LoadCellHolder( use_cord_clips )
{
    difference()
    {
        cube([
            load_cell_holder_xy,
            load_cell_holder_xy,
            load_cell_wall_z
            ]);

        // remove above the load cell ring
        translate([
            load_cell_wall_width,
            load_cell_wall_width,
            load_cell_ring_z
            ])
            RoundedCube(
                load_cell_xy + load_cell_clearance * 2,
                load_cell_xy + load_cell_clearance * 2,
                load_cell_wall_z,
                load_cell_rounding_r,
                round_top = false,
                round_bottom = false
                );

        // remove the extra material below the center of the load cell
        translate([
            load_cell_wall_width + load_cell_ring_thickness,
            load_cell_wall_width + load_cell_ring_thickness,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                load_cell_xy + load_cell_clearance * 2 - load_cell_ring_thickness * 2,
                load_cell_xy + load_cell_clearance * 2 - load_cell_ring_thickness * 2,
                load_cell_wall_z
                ]);

        // cut out the wire channel
        translate([
            ( load_cell_holder_xy - load_cell_wire_cutout_x ) / 2,
            -DIFFERENCE_CLEARANCE,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                load_cell_wire_cutout_x,
                load_cell_wall_width + DIFFERENCE_CLEARANCE * 2,
                load_cell_wall_z + DIFFERENCE_CLEARANCE * 2
                ]);
    }

    // top-left clip
    translate([
        0,
        load_cell_holder_xy - load_cell_wall_z - load_cell_clip_xy,
        load_cell_wall_z
        ])
        cube([
            load_cell_wall_z + load_cell_clip_xy,
            load_cell_wall_z + load_cell_clip_xy,
            load_cell_clip_z
            ]);

    // top-right clip
    translate([
        load_cell_holder_xy - load_cell_wall_z - load_cell_clip_xy,
        load_cell_holder_xy - load_cell_wall_z - load_cell_clip_xy,
        load_cell_wall_z
        ])
        cube([
            load_cell_wall_z + load_cell_clip_xy,
            load_cell_wall_z + load_cell_clip_xy,
            load_cell_clip_z
            ]);

    // hooks to pin the wire down, centered below the wire channel
    if( use_cord_clips )
    {
        translate([
            load_cell_holder_xy / 2,
            -load_cell_wall_width * 2 - load_cell_wire_hook_spacing * 2,
            0
            ])
            CordHookPair(
                load_cell_wire_hook_x,
                load_cell_wire_hook_z,
                load_cell_wall_width,
                load_cell_wall_width,
                load_cell_wire_hook_spacing,
                true
                );
    }

    if( render_mode == "preview" )
    {
        %translate([
            load_cell_wall_width + load_cell_clearance,
            load_cell_wall_width + load_cell_clearance,
            load_cell_ring_z
            ])
            RoundedCube(
                load_cell_xy,
                load_cell_xy,
                load_cell_z,
                load_cell_rounding_r,
                round_top = false,
                round_bottom = false
            );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _WeightModuleHolder()
{
    cavity_x = weight_module_x + weight_module_clearance * 2;
    cavity_y = weight_module_y + weight_module_clearance * 2;

    difference()
    {
        cube([
            weight_module_holder_x,
            weight_module_holder_y,
            weight_module_wall_z
            ]);

        translate([
            weight_module_wall_width,
            weight_module_wall_width,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                cavity_x,
                cavity_y,
                weight_module_wall_z + DIFFERENCE_CLEARANCE * 2
                ]);

        // cut out the left and right walls, leaving only the corners
        for( x = [
            -DIFFERENCE_CLEARANCE,
            weight_module_holder_x - weight_module_wall_width - DIFFERENCE_CLEARANCE
            ] )
            translate([
                x,
                weight_module_wall_width + weight_module_corner_length,
                -DIFFERENCE_CLEARANCE
                ])
                cube([
                    weight_module_wall_width + DIFFERENCE_CLEARANCE * 2,
                    cavity_y - weight_module_corner_length * 2,
                    weight_module_wall_z + DIFFERENCE_CLEARANCE * 2
                    ]);
    }

    if( render_mode == "preview" )
    {
        %translate([
            weight_module_wall_width + weight_module_clearance,
            weight_module_wall_width + weight_module_clearance,
            0
            ])
            cube([ weight_module_x, weight_module_y, weight_module_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the usb end of the board faces -y, toward the cord, and is left open
module _ESP32Holder()
{
    cavity_x = esp32_x + esp32_clearance * 2;
    cavity_y = esp32_y + esp32_clearance * 2;

    difference()
    {
        cube([
            esp32_holder_x,
            esp32_holder_y,
            esp32_wall_z
            ]);

        translate([
            esp32_wall_width,
            esp32_wall_width,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                cavity_x,
                cavity_y,
                esp32_wall_z + DIFFERENCE_CLEARANCE * 2
                ]);

        // open the usb end
        translate([
            esp32_wall_width,
            -DIFFERENCE_CLEARANCE,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                cavity_x,
                esp32_wall_width + DIFFERENCE_CLEARANCE * 2,
                esp32_wall_z + DIFFERENCE_CLEARANCE * 2
                ]);
    }

    if( render_mode == "preview" )
    {
        %translate([
            esp32_wall_width + esp32_clearance,
            esp32_wall_width + esp32_clearance,
            0
            ])
            cube([ esp32_x, esp32_y, esp32_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
