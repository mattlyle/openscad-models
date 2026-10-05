include <modules/utils.scad>
include <modules/rounded-cube.scad>
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

scale_extra_r = 5;

base_lid_z = 3;

top_lid_z = 3;
top_wall_z = 6;

wall_width = 2;

// base_struts_width = 2;
// base_struts_z = 4;
// num_base_struts = 2;

// top_struts_width = 2;
// top_struts_z = 4;
// num_top_struts = 2;

load_cell_clearance = 0.2;
load_cell_wall_width = 2.0;
load_cell_wall_z = 5.0;
load_cell_offset_y = 5;
load_cell_ring_z = 1.6;
load_cell_ring_thickness = 4.0;
load_cell_clip_xy = 2.0;
load_cell_clip_z = 1.4;
load_cell_rounding_r = 5.0;

weight_module_clearance = 0.2;
weight_module_wall_width = 2.0;
weight_module_wall_z = 5.0;
weight_module_corner_length = 2;

esp32_clearance = 0.2;
esp32_wall_width = 2.0;
esp32_wall_z = 5.0;
// space between the cord cutout wall and the usb end of the board, for the plug
esp32_offset_y = 5;

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

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
    PreviewRow( keg_r, keg_1_label );

    translate([ 0, 250, 0 ])
        PreviewRow( co2_tank_r, co2_label );

    translate([ 0, 500, 0 ])
        PreviewRow( n2_tank_r, n2_label );
}
else if( render_mode == "print-keg-1-base" )
{
    ScaleBase( keg_r, keg_1_label );
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
    ScaleBase( keg_r, keg_2_label );
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
    ScaleBase( keg_r, keg_3_label );
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
    ScaleBase( co2_tank_r, co2_label );
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
    ScaleBase( n2_tank_r, n2_label );
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
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the assembled scale, then the base and the top as they print
module PreviewRow( scale_r, label )
{
    ScaleBase( scale_r, label );

    // translate([ 0, 0, 18 ])
    translate([ 0, 0, 30 ])
        rotate([ 0, 180, 0 ])
        {
            ScaleTop( scale_r, label );

            color( label_color )
                ScaleTopLabel( label );
        }

    translate([ 250, 0, 0 ])
        ScaleBase( scale_r, label );

    translate([ 500, 0, 0 ])
    {
        ScaleTop( scale_r, label );

        color( label_color )
            ScaleTopLabel( label );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleBase( scale_r, label )
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
                _LoadCellHolder();
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

    // raised label on the floor, just above the weight module holder
    translate([
        -label_area_x / 2,
        weight_module_holder_y / 2,
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
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleTop( scale_r, label )
{
    difference()
    {
        // full base
        cylinder(
            r = scale_r + scale_extra_r + wall_width,
            h = top_z
            );
        
        // cut out the inside
        translate([ 0, 0, top_lid_z ])
            cylinder(
                r = scale_r + scale_extra_r,
                h = top_z
                );

        // cut out the cord
        translate([
            -cord_r / 2,
            -scale_r - scale_extra_r - wall_width,
            top_lid_z
            ])
            cube([
                cord_r,
                wall_width * 2,
                top_z - top_lid_z + DIFFERENCE_CLEARANCE
                ]);

        // inset the label into the face that prints on the bed
        ScaleTopLabel( label, is_cutout = true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// centered in the top. mirrored because the top is modeled upside down, so it reads correctly once
// the top is flipped over the base. the cut version stands proud of the face so it has no coplanar
// surface to fight with; the printed one sits flush in the recess
module ScaleTopLabel( label, is_cutout = false )
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
                font_size = label_font_size_top,
                font = label_font,
                color = undef
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _LoadCellHolder()
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

    // TODO: add wire hooks too

    // if( render_mode == "preview" )
    // {
    //     %translate([
    //         load_cell_wall_width + load_cell_clearance,
    //         load_cell_wall_width + load_cell_clearance,
    //         load_cell_ring_z
    //         ])
    //         RoundedCube(
    //             load_cell_xy,
    //             load_cell_xy,
    //             load_cell_z,
    //             load_cell_rounding_r,
    //             round_top = false,
    //             round_bottom = false
    //         );
    // }
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
