include <modules/rounded-cube.scad>
include <modules/pie-slice-prism.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// TODO: roll these into the module as M4 and M5
// TODO: somehow we need to stamp the version number into this and other models

bar_x = 39.0;
bar_latch_side_y = 39.0;
bar_spool_side_y = 48.5;

screw_hole_r = 3.86 / 2;
screw_washer_r = 8.9 / 2;

nut_r = 7.0 / 2;
nut_h = 3.0;

gate_screw_separation_latch_side_z = 51.0;
gate_screw_separation_spool_side_z = 19.5;

gate_screw_r = 4.8 / 2; // M4

gate_mount_screw_r = 5.2 / 2; // M5
gate_mount_screw_nut_h = 5.0;
gate_mount_screw_nut_r = 8.1 / 2; // measured as 7.8 but not fitting?!

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-latch-side-top";
// render_mode = "print-latch-side-bottom";
// render_mode = "print-spool-side";

MODE_LATCH_SIDE_TOP    = "LatchSideTop";
MODE_LATCH_SIDE_BOTTOM = "LatchSideBottom";
MODE_SPOOL_SIDE        = "SpoolSide";

bracket_latch_side_top_back_z    = 75.0;
bracket_latch_side_bottom_back_z = 75.0;
bracket_spool_side_z             = 75.0;

bracket_latch_side_top_front_extra_z = 15.0;
bracket_latch_side_bottom_front_extra_z = 60.0;

flange_screw_hole_top_percent_z    = 0.7;
flange_screw_hole_bottom_percent_z = 0.3;

bracket_thickness = 3.6;

post_preview_z = 180;
post_preview_offset_z = -40;

bar_clearance = 0.2;

flange_width = 12.0;
flange_shroud_extra = 4.0;

preview_separation = 10.0;

screw_hole_clearance = 0.3;

washer_clearance = 0.4;
screw_nut_clearance = 0.7;

back_side_reduction_z = 10.0;

latch_screw_window_z = 25.0;
latch_screw_window_separation_z = 10.0;

spool_side_angle = 30;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

bracket_x = bar_x + bar_clearance * 2
    + bracket_thickness * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// functions

function IsLatchSide( mode ) = mode == MODE_LATCH_SIDE_TOP || mode == MODE_LATCH_SIDE_BOTTOM;

function BracketZ( mode, is_front ) =
    mode == MODE_LATCH_SIDE_TOP
        ? ( is_front ? ( bracket_latch_side_top_back_z + bracket_latch_side_top_front_extra_z ) : bracket_latch_side_top_back_z )
        : mode == MODE_LATCH_SIDE_BOTTOM
            ? ( is_front ? ( bracket_latch_side_bottom_back_z + bracket_latch_side_bottom_front_extra_z ) : bracket_latch_side_bottom_back_z )
            : bracket_spool_side_z;

function BarY( mode ) =
    IsLatchSide( mode )
        ? bar_latch_side_y
        : bar_spool_side_y;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    // latch-side top
    translate([ flange_width, 0, 0 ])
    {
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( MODE_LATCH_SIDE_TOP );

        // front
        DeckGateBracket( MODE_LATCH_SIDE_TOP, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( MODE_LATCH_SIDE_TOP, false );
    }

    // latch-side bottom
    translate([ 100, 0, 0 ])
    {
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( MODE_LATCH_SIDE_BOTTOM );

        // front
        translate([ 0, 0, -bracket_latch_side_bottom_front_extra_z ])
            DeckGateBracket( MODE_LATCH_SIDE_BOTTOM, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( MODE_LATCH_SIDE_BOTTOM, false );
    }

    // spool side
    translate([ 200, 0, 0 ])
    {
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( MODE_SPOOL_SIDE );

        // front
        DeckGateBracket( MODE_SPOOL_SIDE, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( MODE_SPOOL_SIDE, false );
    }
}
else if( render_mode == "print-latch-side-top" )
{
    translate([ flange_width, 0, 0 ])
    {
        // front
        DeckGateBracket( MODE_LATCH_SIDE_TOP, true );

        // back
        translate([ 0, preview_separation, -back_side_reduction_z ])
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
        translate([ 0, preview_separation, -back_side_reduction_z ])
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
        translate([ 0, preview_separation, -back_side_reduction_z ])
            DeckGateBracket( MODE_SPOOL_SIDE, false );
    }
}
else
{
    assert( false, str( "Invalid render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracket( mode, is_front = true )
{
    bracket_z = BracketZ( mode, is_front );

    bracket_y = BarY( mode )
        + bar_clearance * 2
        + gate_mount_screw_nut_h
        + bracket_thickness * 2;

    front_bracket_offset_y = -bracket_thickness - flange_shroud_extra;

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
            bracket_thickness + gate_mount_screw_nut_h,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                bar_x + bar_clearance * 2,
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
            // chop off the bottom
            translate([
                -flange_width - DIFFERENCE_CLEARANCE,
                bracket_y / 2 - DIFFERENCE_CLEARANCE,
                -DIFFERENCE_CLEARANCE
                ])
                cube([
                    bracket_x + flange_width * 2 + DIFFERENCE_CLEARANCE * 2,
                    bracket_y / 2 + DIFFERENCE_CLEARANCE * 2,
                    back_side_reduction_z + DIFFERENCE_CLEARANCE
                    ]);

            // chop off the top
            translate([
                -flange_width - DIFFERENCE_CLEARANCE,
                bracket_y / 2 - DIFFERENCE_CLEARANCE,
                bracket_z - back_side_reduction_z
                ])
                cube([
                    bracket_x + flange_width * 2 + DIFFERENCE_CLEARANCE * 2,
                    bracket_y / 2 + DIFFERENCE_CLEARANCE * 2,
                    back_side_reduction_z + DIFFERENCE_CLEARANCE
                    ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGatePostPreview( mode )
{
    % translate([
        bracket_thickness + bar_clearance,
        bracket_thickness + gate_mount_screw_nut_h + bar_clearance,
        post_preview_offset_z
        ])
        cube([
            bar_x,
            BarY( mode ),
            post_preview_z
            ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracketFlange( is_left, mode, is_front )
{
    // bracket_z = BracketZ( mode, is_front );

    bracket_back_z = BracketZ( mode, false );
    flange_screw_hole_top_z = bracket_back_z * flange_screw_hole_top_percent_z;
    flange_screw_hole_bottom_z = bracket_back_z * flange_screw_hole_bottom_percent_z;

    flange_offset_z = mode == MODE_LATCH_SIDE_BOTTOM && is_front
        ? bracket_latch_side_bottom_front_extra_z
        : 0;

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

module DeckGateBracketMountLatchSideScrewWindow( mode, is_top )
{
    assert( mode == MODE_LATCH_SIDE_TOP || mode == MODE_LATCH_SIDE_BOTTOM, str( "invalid mode: ", mode ) );

    bracket_z = BracketZ( mode, true );

    // if the mode is top, then anchor to top, else anchor to bottom

    top_window_offset_z = mode == MODE_LATCH_SIDE_TOP
        ? bracket_z - latch_screw_window_z - latch_screw_window_separation_z
        : latch_screw_window_separation_z * 2 + latch_screw_window_z;
    
    bottom_window_offset_z = mode == MODE_LATCH_SIDE_TOP
        ? top_window_offset_z - latch_screw_window_separation_z - latch_screw_window_z
        : latch_screw_window_separation_z;

    if( is_top )
    {
        translate([
            bracket_x / 2,
            -DIFFERENCE_CLEARANCE,
            top_window_offset_z
            ])
            _DeckGateBracketMountLatchSideScrewWindowHelper();
    }
    else
    {
        translate([
            bracket_x / 2,
            -DIFFERENCE_CLEARANCE,
            bottom_window_offset_z
            ])
            _DeckGateBracketMountLatchSideScrewWindowHelper();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _DeckGateBracketMountLatchSideScrewWindowHelper()
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
            latch_screw_window_z
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
            0
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
            latch_screw_window_z
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
            0
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
