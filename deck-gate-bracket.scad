include <modules/rounded-cube.scad>
include <modules/pie-slice-prism.scad>
include <modules/flattened-pyramid.scad>
include <modules/text-label.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// TODO: roll these into the module as M4 and M5
// TODO: somehow we need to stamp the version number into this and other models

// TODO: really should be able to have separate module calls for the bracket back above/below the cut

vertical_post_x = 39.0;
vertical_post_latch_side_y = 39.0;
vertical_post_spool_side_y = 48.5;
horizontal_post_y = 14.0;
horizontal_post_z = 14.0;
rear_post_x = 14.0;
rear_post_z = 14.0;

screw_hole_r = 3.86 / 2;
screw_washer_r = 8.9 / 2;

nut_r = 7.0 / 2;
nut_h = 3.0;

gate_screw_separation_spool_side_z = 19.5;

gate_screw_r = 4.8 / 2; // M4

gate_mount_screw_r = 5.2 / 2; // M5
gate_mount_screw_nut_h = 5.0;
gate_mount_screw_nut_r = 8.1 / 2; // measured as 7.8 but not fitting?!

latch_z = 70.8;
latch_main_x = 17.0;
latch_pyramid_x = 13.6;
latch_total_x = 47.9;
latch_bend_y = 23.0;
latch_bend_z = 40.6;
latch_y = 5.3;
latch_screw_separation_z = 51.0;
latch_base_flange_x = 3.5;
latch_base_flange_y = 18.8;
latch_holes_offset_x = 11.1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-latch-side-top";
// render_mode = "print-latch-side-bottom";
// render_mode = "print-spool-side";

MODE_LATCH_SIDE_TOP    = "LatchSideTop";
MODE_LATCH_SIDE_BOTTOM = "LatchSideBottom";
MODE_SPOOL_SIDE        = "SpoolSide";

bracket_latch_side_top_back_z    = 95.0;
bracket_latch_side_bottom_back_z = 75.0;
bracket_spool_side_z             = 75.0;

flange_screw_hole_top_percent_z    = 0.7;
flange_screw_hole_bottom_percent_z = 0.3;

bracket_thickness = 3.6;

vertical_post_preview_below_z = 90;
vertical_post_preview_above_z = 80;
horizontal_post_preview_x = 60;
horizontal_post_weld_preview_size = 6;
rear_post_preview_y = 60;
rear_post_weld_preview_size = 6;
rear_post_angle = -35;
latch_preview_y = -20;
latch_preview_top_z = 50;
latch_preview_bottom_z = 20;

bar_clearance = 0.2;

flange_width = 12.0;
flange_shroud_extra = 4.0;

preview_separation = 10.0;

screw_hole_clearance = 0.3;

washer_clearance = 0.4;
screw_nut_clearance = 0.7;

spool_side_back_side_reduction_z = 10.0;

latch_screw_window_separation_z = 10.0;

latch_top_offset_z = 40;
// latch_bottom_offset_z = 20;
latch_horizontal_bar_cutout_offset_top_z = 40;
// latch_horizontal_bar_cutout_offset_bottom_z = 30;
latch_horizontal_bar_cutout_z = 35;

spool_side_angle = 30;

preview_text_depth = 0.01;
preview_text_font_size = 10;
preview_text_font = "Liberation Sans";
preview_text_color = "white";

// version_tag = "v17";
// version_tag_depth = 0.4;
// version_tag_font_size = 4;
// version_tag_font = "Liberation Sans";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

bracket_x = vertical_post_x + bar_clearance * 2
    + bracket_thickness * 2;

front_face_y = bracket_thickness + gate_mount_screw_nut_h;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function IsLatchSide( mode ) = mode == MODE_LATCH_SIDE_TOP || mode == MODE_LATCH_SIDE_BOTTOM;

function BracketZ( mode, is_front ) =
    mode == MODE_LATCH_SIDE_TOP
        ? ( is_front
            ? bracket_latch_side_top_back_z
            : bracket_latch_side_top_back_z
            )
        : mode == MODE_LATCH_SIDE_BOTTOM
            ? ( is_front
                ? bracket_latch_side_bottom_back_z
                : bracket_latch_side_bottom_back_z
                )
            : bracket_spool_side_z;

function BarY( mode ) =
    IsLatchSide( mode )
        ? vertical_post_latch_side_y
        : vertical_post_spool_side_y;

// function GenerateLabelText( mode ) =
//     str( mode == MODE_LATCH_SIDE_TOP
//         ? "latch-top"
//         : mode == MODE_LATCH_SIDE_BOTTOM
//             ? "latch-bottom"
//             : "spool"
//         , "-", version_tag );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    // latch-side top
    translate([ flange_width, 0, 0 ])
    {
        // post preview
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( MODE_LATCH_SIDE_TOP );

        // latch preview
        translate([
            vertical_post_x / 2 - latch_holes_offset_x / 2,
            latch_preview_y,
            latch_preview_top_z
            ])
            DeckGateLatchPreview();

        // front
        translate([ 0, 0, latch_top_offset_z ])
            DeckGateBracket( MODE_LATCH_SIDE_TOP, true );

        // back
        translate([ 0, preview_separation, latch_top_offset_z ])
            DeckGateBracket( MODE_LATCH_SIDE_TOP, false );

        translate([ 0, -75, 0 ])
            MultilineTextLabel(
                [ "Latch Side", "Top" ],
                centered_in_area_x = bracket_x,
                fixed_line_spacing = preview_text_font_size / 2,
                depth = preview_text_depth,
                font_size = preview_text_font_size,
                font = preview_text_font,
                color = preview_text_color
                );
    }

    // latch-side bottom
    translate([ 200, 0, 0 ])
    {
        // post preview
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( MODE_LATCH_SIDE_BOTTOM );

        // latch preview
        translate([
            vertical_post_x / 2 - latch_holes_offset_x / 2,
            latch_preview_y,
            latch_preview_bottom_z
            ])
            DeckGateLatchPreview();

        // front
        // translate([ 0, 0, -bracket_latch_side_bottom_front_extra_z ])
        //     DeckGateBracket( MODE_LATCH_SIDE_BOTTOM, true );

        // back
        // translate([ 0, preview_separation, 0 ])
        //     DeckGateBracket( MODE_LATCH_SIDE_BOTTOM, false );

        translate([ 0, -75, 0 ])
            MultilineTextLabel(
                [ "Latch Side", "Bottom" ],
                centered_in_area_x = bracket_x,
                fixed_line_spacing = preview_text_font_size / 2,
                depth = preview_text_depth,
                font_size = preview_text_font_size,
                font = preview_text_font,
                color = preview_text_color
                );
    }

    // spool side
    translate([ 400, 0, 0 ])
    {
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( MODE_SPOOL_SIDE );

        // front
        DeckGateBracket( MODE_SPOOL_SIDE, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( MODE_SPOOL_SIDE, false );

        translate([ 0, -75, 0 ])
            MultilineTextLabel(
                [ "Spool Side", "(Both)" ],
                centered_in_area_x = bracket_x,
                fixed_line_spacing = preview_text_font_size / 2,
                depth = preview_text_depth,
                font_size = preview_text_font_size,
                font = preview_text_font,
                color = preview_text_color
                );
    }
}
else if( render_mode == "print-latch-side-top" )
{
    translate([ flange_width, 0, 0 ])
    {
        // front
        DeckGateBracket( MODE_LATCH_SIDE_TOP, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( MODE_LATCH_SIDE_TOP, false );
    }
}
else if( render_mode == "print-latch-side-bottom" )
{
    translate([ flange_width, 0, 0 ])
    {
        // front
        DeckGateBracket( MODE_LATCH_SIDE_BOTTOM, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( MODE_LATCH_SIDE_BOTTOM, false );
    }
}
else if( render_mode == "print-spool-side" )
{
    translate([ flange_width, 0, 0 ])
    {
        // front
        DeckGateBracket( MODE_SPOOL_SIDE, true );

        // back
        translate([ 0, preview_separation, -spool_side_back_side_reduction_z ])
            DeckGateBracket( MODE_SPOOL_SIDE, false );
    }
}
else
{
    assert( false, str( "Invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracket( mode, is_front )
{
    bracket_z = BracketZ( mode, is_front );

    bracket_y = BarY( mode )
        + bar_clearance * 2
        + gate_mount_screw_nut_h
        + bracket_thickness * 2;

    front_bracket_offset_y = -bracket_thickness - flange_shroud_extra;

    // label_text = GenerateLabelText( mode );
    // label_offset_x = 0;//is_front ? front_bracket_offset_y : 0;

    // label_offset_y = mode == MODE_LATCH_SIDE_TOP
    //     ? front_face_y
    //     : mode == MODE_LATCH_SIDE_BOTTOM
    //         ? 100
    //         : 100;

    // translate([ bracket_x - bracket_thickness, label_offset_y, label_offset_x ])
    //     rotate([ 0, -90, 0 ])
    //         TextLabel(
    //             label_text,
    //             depth = version_tag_depth,
    //             font_size = version_tag_font_size,
    //             font = version_tag_font,
    //             color = "red"
    //             );

    difference()
    {
        union()
        {
            RoundedCubeAlt2(
                bracket_x,
                bracket_y,
                bracket_z,
                r = bracket_thickness,
                round_top = false,
                round_bottom = false,
                round_front = IsLatchSide( mode )
                );

            // left flange
            translate([
                -flange_width + DIFFERENCE_CLEARANCE * 2,
                bracket_y / 2 + ( is_front ? front_bracket_offset_y : 0 ),
                0
                ])
                DeckGateBracketFlange( true, mode, is_front );

            // right flange
            translate([
                bracket_x - DIFFERENCE_CLEARANCE * 2,
                bracket_y / 2 + ( is_front ? front_bracket_offset_y : 0 ),
                0
                ])
                DeckGateBracketFlange( false, mode, is_front );

            if( is_front && !IsLatchSide( mode ) )
            {
                translate([ bracket_x, 0, 0 ])
                    rotate([ 0, 0, 180 ])
                        PieSlicePrism(
                            bracket_x,
                            bracket_z,
                            spool_side_angle
                            );
            }
        }

        // cut out the post
        translate([
            bracket_thickness + bar_clearance,
            front_face_y,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                vertical_post_x + bar_clearance * 2,
                BarY( mode ) + bar_clearance * 2,
                bracket_z + DIFFERENCE_CLEARANCE * 2
                ]);

        // cut the front or back
        translate([
            -DIFFERENCE_CLEARANCE,
            ( is_front ? ( bracket_y / 2 ) : 0 ) - DIFFERENCE_CLEARANCE,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                bracket_x + DIFFERENCE_CLEARANCE * 2,
                bracket_y / 2 + DIFFERENCE_CLEARANCE * 2,
                bracket_z + DIFFERENCE_CLEARANCE * 2
                ]);

        if( is_front )
        {
            if( IsLatchSide( mode ) )
            {
                // top window
                DeckGateBracketMountLatchSideScrewWindow( mode, true );

                // bottom window
                DeckGateBracketMountLatchSideScrewWindow( mode, false );

                // cut out the sides for the horizontal bars
                translate([
                    -flange_width - DIFFERENCE_CLEARANCE,
                    front_face_y - DIFFERENCE_CLEARANCE,
                    latch_horizontal_bar_cutout_offset_top_z
                    ])
                    cube([
                        bracket_x + flange_width * 2 + DIFFERENCE_CLEARANCE * 2,
                        bracket_y,
                        latch_horizontal_bar_cutout_z
                        ]);
            }
            else
            {
                // spool side screw holes
                translate([ bracket_x, 0, 0 ])
                    rotate([ 0, 0, spool_side_angle ])
                        translate([ -bracket_x / 2, 0, 0 ])
                        {
                            // top
                            DeckGateBracketMountSpoolSideScrewHole( mode, false );

                            // bottom
                            DeckGateBracketMountSpoolSideScrewHole( mode, true );
                        }
            }
        }
        else
        {
            if( IsLatchSide( mode ) )
            {
                // cut out the sides for the horizontal bars
                translate([
                    -flange_width - DIFFERENCE_CLEARANCE,
                    front_face_y - DIFFERENCE_CLEARANCE,
                    latch_horizontal_bar_cutout_offset_top_z
                    ])
                    cube([
                        bracket_x + flange_width * 2 + DIFFERENCE_CLEARANCE * 2,
                        bracket_y,
                        latch_horizontal_bar_cutout_z
                        ]);

            }
            else
            {
                // chop off the bottom
                translate([
                    -flange_width - DIFFERENCE_CLEARANCE,
                    bracket_y / 2 - DIFFERENCE_CLEARANCE,
                    -DIFFERENCE_CLEARANCE
                    ])
                    cube([
                        bracket_x + flange_width * 2 + DIFFERENCE_CLEARANCE * 2,
                        bracket_y / 2 + DIFFERENCE_CLEARANCE * 2,
                        spool_side_back_side_reduction_z + DIFFERENCE_CLEARANCE
                        ]);

                // chop off the top
                translate([
                    -flange_width - DIFFERENCE_CLEARANCE,
                    bracket_y / 2 - DIFFERENCE_CLEARANCE,
                    bracket_z - spool_side_back_side_reduction_z
                    ])
                    cube([
                        bracket_x + flange_width * 2 + DIFFERENCE_CLEARANCE * 2,
                        bracket_y / 2 + DIFFERENCE_CLEARANCE * 2,
                        spool_side_back_side_reduction_z + DIFFERENCE_CLEARANCE
                        ]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGatePostPreview( mode )
{
    bracket_y = BarY( mode );

    // vertical post
    % translate([
        bracket_thickness + bar_clearance,
        front_face_y + bar_clearance,
        0
        ])
        cube([
            vertical_post_x,
            bracket_y,
            vertical_post_preview_below_z + horizontal_post_z + vertical_post_preview_above_z
            ]);

    // left horizontal weld
    %translate([
        bracket_thickness + bar_clearance,
        front_face_y
            + bar_clearance
            + ( bracket_y - horizontal_post_y - horizontal_post_weld_preview_size * 2 ) / 2,
        vertical_post_preview_below_z - horizontal_post_weld_preview_size
        ])
        rotate([ 0, -90, 0 ])
            FlattenedPyramid(
                horizontal_post_y + horizontal_post_weld_preview_size * 2,
                horizontal_post_y + horizontal_post_weld_preview_size * 2,
                horizontal_post_z,
                horizontal_post_y,
                horizontal_post_weld_preview_size
                );

    // left horizontal post
    % translate([
        bracket_thickness + bar_clearance - horizontal_post_preview_x,
        front_face_y
            + bar_clearance
            + ( bracket_y - horizontal_post_y ) / 2,
        vertical_post_preview_below_z
        ])
        cube([
            horizontal_post_preview_x - horizontal_post_weld_preview_size,
            horizontal_post_y,
            horizontal_post_z
            ]);

    // back slanted weld
    % translate([
        bracket_thickness
            + bar_clearance
            + vertical_post_x / 2
            - ( horizontal_post_y + horizontal_post_weld_preview_size * 2 ) / 2,
        front_face_y + bar_clearance + bracket_y,
        vertical_post_preview_below_z
            - horizontal_post_weld_preview_size
            + horizontal_post_y
            + horizontal_post_weld_preview_size * 2
        ])
        rotate([ -90, 0, 0 ])
            FlattenedPyramid(
                horizontal_post_y + horizontal_post_weld_preview_size * 2,
                horizontal_post_y + horizontal_post_weld_preview_size * 2,
                horizontal_post_z,
                horizontal_post_y,
                horizontal_post_weld_preview_size
                );

    // back slanted post
    % translate([
        bracket_thickness
            + bar_clearance
            + vertical_post_x / 2
            - rear_post_x / 2,
        front_face_y + bar_clearance + bracket_y + horizontal_post_weld_preview_size,
        vertical_post_preview_below_z
        ])
        multmatrix([
            [ 1, 0, 0, 0 ],
            [ 0, 1, 0, 0 ],
            [ 0, tan( rear_post_angle ), 1, 0 ],
            [ 0, 0, 0, 1 ]
            ])
            cube([
                rear_post_x,
                rear_post_preview_y,
                rear_post_z
                ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateLatchPreview()
{
    // flat main
    # difference()
    {
        translate([ 0, 0, 0 ])
            cube([
                latch_main_x,
                latch_y,
                latch_z
                ]);

        // cut out the bottom screw holes
        translate([
            latch_holes_offset_x,
            -DIFFERENCE_CLEARANCE,
            ( latch_z - latch_screw_separation_z ) / 2
            ])
            rotate([ -90, 0, 0 ])
                cylinder( r = gate_mount_screw_r, h = latch_y + DIFFERENCE_CLEARANCE * 2 );

        // cut out the top screw holes
        translate([
            latch_holes_offset_x,
            -DIFFERENCE_CLEARANCE,
            latch_z - ( latch_z - latch_screw_separation_z ) / 2
            ])
            rotate([ -90, 0, 0 ])
                cylinder( r = gate_mount_screw_r, h = latch_y + DIFFERENCE_CLEARANCE * 2 );
    }

    // base flange
    # translate([
        0,
        -latch_base_flange_y + latch_y,
        0
        ])
        cube([
            latch_base_flange_x,
            latch_base_flange_y - latch_y,
            latch_z
            ]);

    // pyramid
    # translate([
        latch_main_x,
        0,
        latch_z
        ])
        rotate([ 0, 90, 0 ])
            FlattenedPyramid(
                latch_z,
                latch_y,
                latch_bend_z,
                latch_y,
                latch_pyramid_x
                );

    // arc (just fake it with a rounded cube)
    # translate([
        latch_main_x + latch_pyramid_x,
        -latch_bend_y + latch_y,
        ( latch_z - latch_bend_z ) / 2
        ])
            RoundedCubeAlt2(
                latch_total_x - latch_main_x - latch_pyramid_x,
                latch_bend_y,
                latch_bend_z,
                r = 10.0,
                round_top = false,
                round_bottom = false,
                round_left = false,
                round_right = true,
                round_front = true,
                round_back = true
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracketFlange( is_left, mode, is_front )
{
    bracket_back_z = BracketZ( mode, false );

    above_cutout_latch_side_top_z = latch_horizontal_bar_cutout_offset_top_z + latch_horizontal_bar_cutout_z;

    flange_screw_hole_top_z = mode == MODE_LATCH_SIDE_TOP
        ? above_cutout_latch_side_top_z + ( bracket_back_z - above_cutout_latch_side_top_z ) / 2
        : mode == MODE_LATCH_SIDE_BOTTOM
            ? bracket_back_z * flange_screw_hole_top_percent_z
            : bracket_back_z * flange_screw_hole_top_percent_z;
    
    flange_screw_hole_bottom_z =  mode == MODE_LATCH_SIDE_TOP
        ? latch_horizontal_bar_cutout_offset_top_z / 2
        : mode == MODE_LATCH_SIDE_BOTTOM
            ? bracket_back_z * flange_screw_hole_bottom_percent_z
            : bracket_back_z * flange_screw_hole_bottom_percent_z;

    flange_offset_z = mode == MODE_LATCH_SIDE_BOTTOM && is_front
        ? bracket_latch_side_bottom_front_extra_z
        : 0;

    // # translate([0,0,0]) sphere(r=1);
    // # translate([0,0,latch_horizontal_bar_cutout_offset_top_z]) sphere(r=1);
    // # translate([0,0,latch_horizontal_bar_cutout_offset_top_z+latch_horizontal_bar_cutout_z]) sphere(r=1);
    // # translate([0,0,bracket_back_z]) sphere(r=1);
 

    difference()
    {
        translate([ 0, 0, flange_offset_z ])
            RoundedCubeAlt2(
                flange_width,
                bracket_thickness + flange_shroud_extra,
                bracket_back_z,
                r = 1.0,
                round_top = false,
                round_bottom = false,
                round_left = is_left,
                round_right = !is_left,
                round_front = true,
                round_back = true
                );

        // top screw hole
        translate([ 0, 0, flange_screw_hole_top_z + flange_offset_z ])
            DeckGateBracketFlangeScrewHole( is_front );

        // bottom screw hole
        translate([ 0, 0, flange_screw_hole_bottom_z + flange_offset_z ])
            DeckGateBracketFlangeScrewHole( is_front );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracketFlangeScrewHole( is_front = true )
{
    // screw hole
    translate([
        flange_width / 2,
        -DIFFERENCE_CLEARANCE,
        0
        ])
        rotate([ -90, 0, 0 ])
            cylinder(
                r = screw_hole_r + screw_hole_clearance,
                h = bracket_thickness + flange_shroud_extra + DIFFERENCE_CLEARANCE * 2
                );

    if( is_front )
    {
        // washer shroud cutout
        translate([
            flange_width / 2,
            -DIFFERENCE_CLEARANCE,
            0
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = screw_washer_r + washer_clearance,
                    h = flange_shroud_extra + DIFFERENCE_CLEARANCE
                    );
    }
    else
    {
        // nut shroud cutout
        translate([
            flange_width / 2,
            bracket_thickness + DIFFERENCE_CLEARANCE,
            0
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = nut_r + screw_nut_clearance,
                    h = flange_shroud_extra + DIFFERENCE_CLEARANCE,
                    $fn = 6
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracketMountLatchSideScrewWindow( mode, is_top_window )
{
    assert( mode == MODE_LATCH_SIDE_TOP || mode == MODE_LATCH_SIDE_BOTTOM, str( "invalid mode: ", mode ) );

    bracket_z = BracketZ( mode, true );
    window_z = ( bracket_z - latch_screw_window_separation_z * 3 ) / 2;

    if( is_top_window )
    {
        translate([
            bracket_x / 2,
            -DIFFERENCE_CLEARANCE,
            window_z + latch_screw_window_separation_z * 2
            ])
            _DeckGateBracketMountLatchSideScrewWindowHelper( bracket_z, window_z );
    }
    else
    {
        translate([
            bracket_x / 2,
            -DIFFERENCE_CLEARANCE,
            latch_screw_window_separation_z
            ])
            _DeckGateBracketMountLatchSideScrewWindowHelper( bracket_z, window_z );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _DeckGateBracketMountLatchSideScrewWindowHelper( bracket_z, window_z )
{
    window_screw_hole_r = gate_screw_r + screw_hole_clearance;
    window_nut_hole_r = gate_mount_screw_nut_r + screw_nut_clearance * 0.25;

    // screw hole
    hull()
    {
        // top
        translate([
            0,
            -DIFFERENCE_CLEARANCE,
            window_z - gate_screw_r
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = window_screw_hole_r,
                    h = bracket_thickness + DIFFERENCE_CLEARANCE * 2
                    );

        // bottom
        translate([
            0,
            -DIFFERENCE_CLEARANCE,
            gate_screw_r
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = window_screw_hole_r,
                    h = bracket_thickness + DIFFERENCE_CLEARANCE * 2
                    );
    }

    // nut
    hull()
    {
        // top
        translate([
            0,
            bracket_thickness,
            window_z - gate_screw_r
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = window_nut_hole_r,
                    h = gate_mount_screw_nut_h + DIFFERENCE_CLEARANCE * 2,
                    $fn = 6
                    );

        // bottom
        translate([
            0,
            bracket_thickness,
            gate_screw_r
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = window_nut_hole_r,
                    h = gate_mount_screw_nut_h + DIFFERENCE_CLEARANCE * 2,
                    $fn = 6
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracketMountSpoolSideScrewHole( mode, is_top )
{
    bracket_z = BracketZ( mode, true );

    hex_cutout = 26; // I don't know how to calculate this, it's just big enough to fit the nut

    hole_z = is_top
        ? ( bracket_z / 2 - gate_screw_separation_spool_side_z / 2 )
        : ( bracket_z / 2 + gate_screw_separation_spool_side_z / 2 );

    translate([ 0, 0, hole_z ])
    {
        rotate([ -90, 0, 0 ])
        {
            // screw hole
            translate([
                0,
                0,
                -DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = screw_hole_r + screw_hole_clearance,
                    h = bracket_thickness + DIFFERENCE_CLEARANCE * 2
                    );

            translate([
                0,
                0,
                bracket_thickness - DIFFERENCE_CLEARANCE
                ])
                cylinder(
                    r = nut_r + screw_nut_clearance * 2,
                    h = hex_cutout,
                    $fn = 6
                    );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
