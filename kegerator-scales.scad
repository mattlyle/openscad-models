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
load_cell_wire_cutout_x = 5.5;

weight_module_x = 34.2;
weight_module_y = 21.3;
weight_module_z = 3.2;
weight_module_pcb_z = 1.7;

// width of the strip along the left and right sides of the board that has the solder pads
weight_module_pads_x = 6.7;

// large ESP32
// esp32_x = 28.3;
// esp32_y = 51.5;
// esp32_z = 12.6;
esp32_x = 17.9;
esp32_y = 21.2;
esp32_z = 3.5;
esp32_board_only_z = 2.0;
esp32_pcb_z = 1.3;

// width of the strip along the left and right sides of the board that has the solder pads
esp32_pads_x = 3.0;
esp32_pin_pitch = 2.54;

// measured from the usb end of the board to the center of the first pad
esp32_first_pin_y = 3.0;

cord_x = 9.1;

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
// render_mode = "print-soldering-jig";

top_bottom_fit_clearance = 0.5;

// extra room around each tank, added to the radius of the whole scale
co2_extra_r = 8;
n2_extra_r = 5;
keg_extra_r = 0;

base_lid_z = 2;

top_lid_z = 4;
top_wall_z = 6;

wall_width = 2;

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

weight_module_clearance = 0.1;
weight_module_wall_width = 2.0;
weight_module_wall_z = 5.0;
weight_module_corner_length = 2;

// space between the weight module holder and each of its cord clips
weight_module_cord_clip_gap = 2;

// extra room around the cord in a cord clip
cord_clip_clearance = 0.2;

// how much farther the arm of a cord hook reaches past the cord
cord_hook_arm_extra = 1;

// distance from the center to the outer face of the cord hooks just inside the alignment guides
alignment_cord_hook_r = 65;
weight_module_offset_z = 1.0;

esp32_clearance = 0.2;
esp32_wall_width = 2.0;
esp32_wall_z = 5.0;
esp32_offset_z = 2.0;
esp32_extra_y = 1.1;

// how far the usb end of the board sticks out past the inside of the base wall, into the cutout
esp32_poke_y = 1.0;

// the pads that get wired, counted from the usb end starting at 0, the same on both sides: D1 and
// D2 on one side, GND and 3V3 on the other
esp32_wired_pin_list = [ 1, 2 ];
esp32_pin_cutout_margin = 2.0;

esp32_clip_xy = 3.0;
esp32_clip_z = 1.8;

alignment_guide_length = 5;
alignment_guide_width = 2.0;
alignment_guide_clearance = 0.3;
alignment_guide_angle_list = [ -90, 0, 90 ];
alignment_guide_top_z = 6;

test_ring_keg_r = 95;
test_ring_co2_tank_r = 50;
test_ring_n2_tank_r = 65;

test_ring_width = 18;
test_ring_z = 6;
test_ring_alignment_guide_z = 10;
test_ring_label_font_size = 8;
test_ring_label_offset_y = 1;

soldering_jig_base_x = 100;
soldering_jig_base_y = 100;
soldering_jig_base_z = 3;
soldering_jig_base_rounding_r = 5;
soldering_jig_stand_r = 6;
soldering_jig_stand_z = 45;
soldering_jig_arm_clearance = 0.2;
soldering_jig_arm_width = 2;
soldering_jig_esp32_arm_x = 2.25;
soldering_jig_esp32_arm_y = 10;
soldering_jig_weightmodule_arm_x = 2.10;
soldering_jig_weightmodule_arm_y = 8;

// how far each holder is moved out from the center of the stand, so the boards don't touch
soldering_jig_extension_x = 10;

// degrees each side of the crossbar is tilted up at its free end, so the boards slide back
soldering_jig_tilt = 10;

soldering_jig_gusset_width = 12;

// height of the ridge behind each board that stops it sliding off the end, toward the stand
soldering_jig_stop_z = 1;

// space between the front edge of the base and the version label
soldering_jig_label_offset_y = 5;

soldering_jib_alligator_clip_r = 3.0 / 2;
soldering_jib_alligator_clip_z = 15;
soldering_jib_alligator_clip_spacing_x = 40;

top_color = "white";
label_color = "black";

keg_1_label = "Keg 1";
keg_2_label = "Keg 2";
keg_3_label = "Keg 3";
co2_tank_label = "CO₂";
n2_tank_label = "N₂";

scale_base_version_label_offset_x = -2;
scale_base_version_label_offset_y = 15;
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
BUILD_SCRIPT_VERSION = "v12";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 512;

base_z = base_lid_z + load_cell_z;
top_z = top_lid_z + top_wall_z;

load_cell_holder_xy = load_cell_xy + ( load_cell_wall_width + load_cell_clearance ) * 2;

// the cord hooks are as tall as the weight module holder walls, and are as wide as the load cell
// wire hooks. the gap under the arm is whatever height is left over
weight_module_cord_hook_z = weight_module_wall_z - load_cell_wall_width - cord_clip_clearance;

// from the middle of the cord to the post of a cord hook, which is where the hooks are placed from
cord_hook_inner_x = load_cell_wire_hook_x / 2 + cord_clip_clearance;

co2_scale_r = co2_tank_r + co2_extra_r;
n2_scale_r = n2_tank_r + n2_extra_r;
keg_scale_r = keg_r + keg_extra_r;

esp32_holder_x = esp32_x
    + esp32_wall_width * 2
    + esp32_clearance * 2;
esp32_holder_y = esp32_y
    + esp32_wall_width * 2
    + esp32_clearance * 2;

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
    PreviewRow( keg_scale_r, keg_1_label, true );

    // co2 tank row
    translate([ 0, 250, 0 ])
        PreviewRow( co2_scale_r, co2_tank_label, false );

    // n2 tank row
    translate([ 0, 500, 0 ])
        PreviewRow( n2_scale_r, n2_tank_label, false );

    // test top row
    translate([ 0, -250, 0 ])
        PreviewTestRingRow( co2_scale_r, test_ring_co2_tank_r, co2_tank_label, false );

    // soldering jig, below the test top row
    translate([ 0, -500, 0 ])
        SolderingJig();
}
else if( render_mode == "print-keg-1-base" )
{
    ScaleBase( keg_scale_r, keg_1_label, true );
}
else if( render_mode == "print-keg-1-top" )
{
    ScaleTop( keg_scale_r, keg_1_label );
}
else if( render_mode == "print-keg-1-top-text" )
{
    _ScaleTopLabel( keg_1_label );
}
else if( render_mode == "print-3mf-keg-1-top" )
{
    color( top_color )
        ScaleTop( keg_scale_r, keg_1_label );

    color( label_color )
        _ScaleTopLabel( keg_1_label );
}
else if( render_mode == "print-keg-2-base" )
{
    ScaleBase( keg_scale_r, keg_2_label, true );
}
else if( render_mode == "print-keg-2-top" )
{
    ScaleTop( keg_scale_r, keg_2_label );
}
else if( render_mode == "print-keg-2-top-text" )
{
    _ScaleTopLabel( keg_2_label );
}
else if( render_mode == "print-3mf-keg-2-top" )
{
    color( top_color )
        ScaleTop( keg_scale_r, keg_2_label );

    color( label_color )
        _ScaleTopLabel( keg_2_label );
}
else if( render_mode == "print-keg-3-base" )
{
    ScaleBase( keg_scale_r, keg_3_label, true );
}
else if( render_mode == "print-keg-3-top" )
{
    ScaleTop( keg_scale_r, keg_3_label );
}
else if( render_mode == "print-keg-3-top-text" )
{
    _ScaleTopLabel( keg_3_label );
}
else if( render_mode == "print-3mf-keg-3-top" )
{
    color( top_color )
        ScaleTop( keg_scale_r, keg_3_label );

    color( label_color )
        _ScaleTopLabel( keg_3_label );
}
else if( render_mode == "print-co2-base" )
{
    ScaleBase( co2_scale_r, co2_tank_label, false );
}
else if( render_mode == "print-co2-top" )
{
    ScaleTop( co2_scale_r, co2_tank_label );
}
else if( render_mode == "print-co2-top-text" )
{
    _ScaleTopLabel( co2_tank_label );
}
else if( render_mode == "print-3mf-co2-top" )
{
    color( top_color )
        ScaleTop( co2_scale_r, co2_tank_label );

    color( label_color )
        _ScaleTopLabel( co2_tank_label );
}
else if( render_mode == "print-n2-base" )
{
    ScaleBase( n2_scale_r, n2_tank_label, false );
}
else if( render_mode == "print-n2-top" )
{
    ScaleTop( n2_scale_r, n2_tank_label );
}
else if( render_mode == "print-n2-top-text" )
{
    _ScaleTopLabel( n2_tank_label );
}
else if( render_mode == "print-3mf-n2-top" )
{
    color( top_color )
        ScaleTop( n2_scale_r, n2_tank_label );

    color( label_color )
        _ScaleTopLabel( n2_tank_label );
}
else if( render_mode == "print-test-ring" )
{
    // TestRing( keg_scale_r, test_ring_keg_r, keg_1_label );
    TestRing( co2_scale_r, test_ring_co2_tank_r, co2_tank_label );
    // TestRing( n2_scale_r, test_ring_n2_tank_r, n2_tank_label );
}
else if( render_mode == "print-soldering-jig" )
{
    SolderingJig();
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
                _ScaleTopLabel( label );
        }

    translate([ 250, 0, 0 ])
        ScaleBase( scale_r, label, use_cord_clips );

    translate([ 500, 0, 0 ])
    {
        ScaleTop( scale_r, label );

        color( label_color )
            _ScaleTopLabel( label );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewTestRingRow( scale_r, test_ring_r, label, use_cord_clips )
{
    ScaleBase( scale_r, label, use_cord_clips );

    // translate([ 0, 0, 18 ])
    translate([ 0, 0, 30 ])
        rotate([ 0, 180, 0 ])
            TestRing( scale_r, test_ring_r, label );
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
            -cord_x / 2,
            -scale_r - wall_width,
            base_lid_z
            ])
            cube([
                cord_x,
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

    // add back the ESP32 holder, with the usb end of the board poking into the cord cutout. the
    // board is wider than the cutout, so the holder is clipped at the inside of the wall
    intersection()
    {
        translate([
            -esp32_holder_x / 2,
            -scale_r - esp32_poke_y - esp32_wall_width - esp32_clearance,
            base_lid_z - DIFFERENCE_CLEARANCE
            ])
            _ESP32Holder();

        translate([ -esp32_holder_x, -scale_r, 0 ])
            cube([ esp32_holder_x * 2, scale_r, base_z ]);
    }

    // add back the weight module holder, dead center
    translate([
        -weight_module_holder_x / 2,
        -weight_module_holder_y / 2,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        _WeightModuleHolder();

    // cord hooks just above and below the weight module holder, centered on it, to keep the wires
    // from pushing up into the top. the cord runs side to side, and each hook's post is on the
    // holder side, so its opening faces away from the holder
    for( side = [ -1, 1 ] )
        translate([
            -side * load_cell_wall_width / 2,
            side * (
                weight_module_holder_y / 2
                + weight_module_cord_clip_gap
                + cord_hook_inner_x
                + load_cell_wall_width
                ),
            base_lid_z - DIFFERENCE_CLEARANCE
            ])
            rotate([ 0, 0, -side * 90 ])
                _CordHook();

    // cord hook to the left of the weight module holder, standing up and down with its opening at
    // the bottom. the cord runs through it side to side, level with the middle of the holder
    translate([
        -( weight_module_holder_x / 2 + weight_module_cord_clip_gap ),
        0,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        rotate([ 0, 0, 90 ])
            _CordHook();

    // cord hooks just inside the alignment guides, with their openings toward the center
    for( i = alignment_guide_angle_list )
        rotate([ 0, 0, i ])
            translate([
                load_cell_wall_width / 2,
                alignment_cord_hook_r - cord_hook_inner_x - load_cell_wall_width,
                base_lid_z - DIFFERENCE_CLEARANCE
                ])
                rotate([ 0, 0, 90 ])
                    _CordHook();

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
        scale_r
            - base_label_offset_y
            - label_area_y / 2
            + scale_base_version_label_offset_x,
        scale_base_version_label_offset_y,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        _VersionLabel( label_depth + DIFFERENCE_CLEARANCE );
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
            -cord_x / 2,
            -scale_r - wall_width * 2 - top_bottom_fit_clearance - DIFFERENCE_CLEARANCE,
            top_lid_z
            ])
            cube([
                cord_x,
                wall_width * 2 + DIFFERENCE_CLEARANCE,
                top_z - top_lid_z + DIFFERENCE_CLEARANCE
                ]);

        // inset the label into the face that prints on the bed
        _ScaleTopLabel( label, is_cutout = true );
    }

    // raised version, dead center on the underside
    translate([ 0, 0, top_lid_z - DIFFERENCE_CLEARANCE ])
        _VersionLabel( label_depth + DIFFERENCE_CLEARANCE );

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

module TestRing( scale_r, test_ring_r, label )
{
    difference()
    {
        cylinder(
            r = test_ring_r,
            h = test_ring_z
            );

        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder(
                r = test_ring_r - test_ring_width,
                h = test_ring_z + DIFFERENCE_CLEARANCE * 2
                );

        // inset the label into the face that prints on the bed, centered across the ring at the top
        translate([
            0,
            test_ring_r - test_ring_width / 2 - test_ring_label_offset_y,
            0
            ])
            _ScaleTopLabel(
                label,
                is_cutout = true,
                font_size = test_ring_label_font_size
                );

        // inset the version in the same face, at the bottom of the ring. mirrored like the label
        translate([
            0,
            -( test_ring_r - test_ring_width / 2 - test_ring_label_offset_y ),
            -DIFFERENCE_OFFSET
            ])
            mirror([ 1, 0, 0 ])
                _VersionLabel( label_depth + DIFFERENCE_OFFSET );
    }

    for( i = alignment_guide_angle_list )
    {
        rotate([ 0, 0, i ])
            translate([
                -alignment_guide_width / 2,
                test_ring_r - alignment_guide_clearance,
                0
                ])
                cube([
                    alignment_guide_width,
                    scale_r - test_ring_r - alignment_guide_clearance,
                    test_ring_alignment_guide_z
                    ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// centered in the top. mirrored because the top is modeled upside down, so it reads correctly once
// the top is flipped over the base. the cut version stands proud of the face so it has no coplanar
// surface to fight with; the printed one sits flush in the recess
module _ScaleTopLabel( label, is_cutout = false, font_size = label_font_size_top )
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
module _VersionLabel( depth )
{
    translate([
        -label_area_x / 2,
        -label_area_y / 2,
        0
        ])
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

// a cord hook at the size used on the scale, with its post on the +x side and the cord along y
module _CordHook()
{
    CordHook(
        cord_width = load_cell_wire_hook_x,
        cord_z = weight_module_cord_hook_z,
        wall_thickness = load_cell_wall_width,
        length = load_cell_wall_width,
        show_preview = false,
        clearance = cord_clip_clearance,
        arm_extra = cord_hook_arm_extra
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

    // pad that raises the board, left out under the solder pads on the left and right
    translate([
        weight_module_wall_width + weight_module_clearance + weight_module_pads_x,
        weight_module_wall_width,
        0
        ])
        cube([
            weight_module_x - weight_module_pads_x * 2,
            cavity_y,
            weight_module_offset_z
            ]);

    if( render_mode == "preview" )
    {
        %translate([
            weight_module_wall_width + weight_module_clearance,
            weight_module_wall_width + weight_module_clearance,
            weight_module_offset_z
            ])
            cube([ weight_module_x, weight_module_y, weight_module_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the usb end of the board faces -y, toward the cord, and is left open. the board sits on a pad
module _ESP32Holder()
{
    cavity_x = esp32_x
        + esp32_clearance * 2;
    cavity_y = esp32_y
        + esp32_extra_y
        + esp32_clearance * 2;

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

        // open both sides at the pads that get wired, from the board up so the wires can leave
        for( x = [
            -DIFFERENCE_CLEARANCE,
            esp32_holder_x - esp32_wall_width - DIFFERENCE_CLEARANCE
            ] )
            translate([
                x,
                esp32_wall_width
                    + esp32_clearance
                    + esp32_first_pin_y
                    + ( min( esp32_wired_pin_list ) - 0.5 ) * esp32_pin_pitch
                    - esp32_pin_cutout_margin,
                esp32_offset_z
                ])
                cube([
                    esp32_wall_width + DIFFERENCE_CLEARANCE * 2,
                    ( max( esp32_wired_pin_list ) - min( esp32_wired_pin_list ) + 1 )
                        * esp32_pin_pitch
                        + esp32_pin_cutout_margin * 2,
                    esp32_wall_z
                    ]);
    }

    // pad that raises the board, left out under the solder pads on the left and right
    translate([ esp32_wall_width + esp32_clearance + esp32_pads_x, esp32_wall_width, 0 ])
        cube([ esp32_x - esp32_pads_x * 2, cavity_y, esp32_offset_z ]);

    // clips over the corners at the back, just above the board, to keep it from popping out
    for( x = [ 0, esp32_holder_x - esp32_wall_width - esp32_clip_xy ] )
        translate([
            x,
            esp32_holder_y - esp32_wall_width - esp32_clip_xy,
            esp32_offset_z + esp32_board_only_z + esp32_clearance
            ])
            cube([
                esp32_wall_width + esp32_clip_xy,
                esp32_wall_width + esp32_clip_xy,
                esp32_clip_z
                ]);

    if( render_mode == "preview" )
    {
        %translate([
            esp32_wall_width + esp32_clearance,
            esp32_wall_width + esp32_clearance,
            esp32_offset_z
            ])
            cube([ esp32_x, esp32_y, esp32_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// holds the PCBs while their wires are soldered. just the base and stand so far
module SolderingJig()
{
    RoundedCube(
        soldering_jig_base_x,
        soldering_jig_base_y,
        soldering_jig_base_z,
        soldering_jig_base_rounding_r,
        round_top = false,
        round_bottom = false
        );

    // raised version on the base, centered near the front (-y) edge
    translate([
        soldering_jig_base_x / 2,
        soldering_jig_label_offset_y + label_area_y / 2,
        soldering_jig_base_z - DIFFERENCE_CLEARANCE
        ])
        _VersionLabel( label_depth + DIFFERENCE_CLEARANCE );

    // two posts for alligator clips, just above the version label
    for( x = [
        -soldering_jib_alligator_clip_spacing_x / 2,
        soldering_jib_alligator_clip_spacing_x / 2
        ] )
        translate([
            soldering_jig_base_x / 2 + x,
            soldering_jig_label_offset_y + label_area_y + soldering_jib_alligator_clip_r,
            soldering_jig_base_z - DIFFERENCE_CLEARANCE
            ])
            cylinder(
                r = soldering_jib_alligator_clip_r,
                h = soldering_jib_alligator_clip_z + DIFFERENCE_CLEARANCE
                );

    // stand, from the center of the base, to raise the jig up
    translate([
        soldering_jig_base_x / 2,
        soldering_jig_base_y / 2,
        soldering_jig_base_z - DIFFERENCE_CLEARANCE
        ])
        cylinder( r = soldering_jig_stand_r, h = soldering_jig_stand_z + DIFFERENCE_CLEARANCE );

    // the two holders make a T across the top of the stand. each side points away from the stand
    // and is tilted up at its free end, about the center of the top of the stand. the end of each
    // holder nearest the stand is moved out by the extension
    center_x = soldering_jig_base_x / 2;
    center_y = soldering_jig_base_y / 2;
    stand_top_z = soldering_jig_base_z + soldering_jig_stand_z - DIFFERENCE_CLEARANCE;
    board_z = soldering_jig_arm_width + soldering_jig_arm_clearance;

    translate([ center_x, center_y, stand_top_z ])
        rotate([ 0, -soldering_jig_tilt, 0 ])
            _SolderingJigSide( esp32_x, soldering_jig_esp32_arm_y )
                translate([ soldering_jig_extension_x + esp32_y, -esp32_x / 2, board_z ])
                    rotate([ 0, 0, 90 ])
                        _SolderingJigESP32();

    // built the same way as the other side, then mirrored to the -x side
    translate([ center_x, center_y, stand_top_z ])
        rotate([ 0, soldering_jig_tilt, 0 ])
            mirror([ 1, 0, 0 ])
                _SolderingJigSide( weight_module_y, soldering_jig_weightmodule_arm_y )
                    translate([
                        soldering_jig_extension_x + weight_module_x,
                        -weight_module_y / 2,
                        board_z
                        ])
                        rotate([ 0, 0, 90 ])
                            _SolderingJigWeightModule();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// one side of the crossbar, built on the +x side with the bottom of its floor at z = 0 and the
// center of the stand at x = 0. the child is the holder, already placed
module _SolderingJigSide( board_across, tube_y )
{
    holder_width = board_across + soldering_jig_arm_width * 2 + soldering_jig_arm_clearance * 2;
    reach = soldering_jig_extension_x + tube_y;

    // flat extension of the holders' floor, to move the holders apart
    translate([ 0, -holder_width / 2, 0 ])
        cube([
            soldering_jig_extension_x + DIFFERENCE_CLEARANCE,
            holder_width,
            soldering_jig_arm_width
            ]);

    // gusset under the crossbar: a 45 degree wedge from the stand, so it prints without support.
    // the part inside the stand just fuses it
    translate([ 0, 0, DIFFERENCE_CLEARANCE ])
        rotate([ 90, 0, 0 ])
            linear_extrude( height = soldering_jig_gusset_width, center = true )
                polygon([ [ 0, 0 ], [ 0, -reach ], [ reach, 0 ] ]);

    // ridge behind the board, on the floor, so it can't slide off the end nearest the stand
    translate([
        soldering_jig_extension_x - soldering_jig_arm_width,
        -( board_across + soldering_jig_arm_clearance * 2 ) / 2,
        soldering_jig_arm_width - DIFFERENCE_CLEARANCE
        ])
        cube([
            soldering_jig_arm_width,
            board_across + soldering_jig_arm_clearance * 2,
            soldering_jig_arm_clearance + soldering_jig_stop_z + DIFFERENCE_CLEARANCE
            ]);

    children();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _SolderingJigESP32()
{
    %cube([ esp32_x, esp32_y, esp32_z ]);

    difference()
    {
        translate([
            -soldering_jig_arm_width - soldering_jig_arm_clearance,
            esp32_y - soldering_jig_esp32_arm_y,
            -soldering_jig_arm_width - soldering_jig_arm_clearance
            ])
            cube([
                esp32_x + soldering_jig_arm_width * 2 + soldering_jig_arm_clearance * 2,
                soldering_jig_esp32_arm_y,
                esp32_pcb_z + soldering_jig_arm_width * 2 + soldering_jig_arm_clearance * 2 ]);

        // cut out the center
        translate([
            -soldering_jig_arm_clearance - DIFFERENCE_CLEARANCE,
            esp32_y - soldering_jig_esp32_arm_y - DIFFERENCE_CLEARANCE,
            -soldering_jig_arm_clearance - DIFFERENCE_CLEARANCE
            ])
            cube([
                esp32_x + soldering_jig_arm_clearance * 2 + DIFFERENCE_CLEARANCE * 2,
                soldering_jig_esp32_arm_y + DIFFERENCE_CLEARANCE * 2,
                esp32_pcb_z + soldering_jig_arm_clearance * 2 + DIFFERENCE_CLEARANCE * 2
                ]);

        // cut out the top
        translate([
            soldering_jig_esp32_arm_x,
            esp32_y - soldering_jig_esp32_arm_y - DIFFERENCE_CLEARANCE,
            esp32_pcb_z + soldering_jig_arm_clearance
            ])
            cube([
                esp32_x - soldering_jig_esp32_arm_x * 2,
                soldering_jig_esp32_arm_y + DIFFERENCE_CLEARANCE * 2,
                soldering_jig_arm_width + DIFFERENCE_CLEARANCE * 2
                ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the board is held by its long edges, at one narrow end, so the pads on the narrow ends stay open.
// across the holder the board is weight_module_y, and its length is weight_module_x
module _SolderingJigWeightModule()
{
    %cube([ weight_module_y, weight_module_x, weight_module_z ]);

    difference()
    {
        translate([
            -soldering_jig_arm_width - soldering_jig_arm_clearance,
            weight_module_x - soldering_jig_weightmodule_arm_y,
            -soldering_jig_arm_width - soldering_jig_arm_clearance
            ])
            cube([
                weight_module_y + soldering_jig_arm_width * 2 + soldering_jig_arm_clearance * 2,
                soldering_jig_weightmodule_arm_y,
                weight_module_pcb_z + soldering_jig_arm_width * 2 + soldering_jig_arm_clearance * 2
                ]);

        // cut out the center
        translate([
            -soldering_jig_arm_clearance - DIFFERENCE_CLEARANCE,
            weight_module_x - soldering_jig_weightmodule_arm_y - DIFFERENCE_CLEARANCE,
            -soldering_jig_arm_clearance - DIFFERENCE_CLEARANCE
            ])
            cube([
                weight_module_y + soldering_jig_arm_clearance * 2 + DIFFERENCE_CLEARANCE * 2,
                soldering_jig_weightmodule_arm_y + DIFFERENCE_CLEARANCE * 2,
                weight_module_pcb_z + soldering_jig_arm_clearance * 2 + DIFFERENCE_CLEARANCE * 2
                ]);

        // cut out the top
        translate([
            soldering_jig_weightmodule_arm_x,
            weight_module_x - soldering_jig_weightmodule_arm_y - DIFFERENCE_CLEARANCE,
            weight_module_pcb_z + soldering_jig_arm_clearance
            ])
            cube([
                weight_module_y - soldering_jig_weightmodule_arm_x * 2,
                soldering_jig_weightmodule_arm_y + DIFFERENCE_CLEARANCE * 2,
                soldering_jig_arm_width + DIFFERENCE_CLEARANCE * 2
                ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
