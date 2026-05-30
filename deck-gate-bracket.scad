include <modules/rounded-cube.scad>
include <modules/pie-slice-prism.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

// TODO: roll these into the module as M4 and M5

// TODO: latch side really needs to be split into two versions... a top-latch and bottom-latch
// TODO: top latch side needs to be extended up 1cm+
// TODO: bottom latch side needs to be extended down and possibly have a cutout to wrap around the horizontal bar
// TODO: somehow we need to stamp the version number into this and other models
// TODO: for the latch side window cutouts, the back side is too big

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
// render_mode = "print-latch-side";
// render_mode = "print-spool-side";

bracket_z = 75.0;

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

latch_screw_opening_percent = 0.28;

spool_side_angle = 30;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

bracket_x = bar_x + bar_clearance * 2
    + bracket_thickness * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    // latch-side
    translate([ flange_width, 0, 0 ])
    {
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( true );

        // front
        DeckGateBracket( true, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( true, false );
    }

    // spool side
    translate([ 100, 0, 0 ])
    {
        translate([ bar_clearance, 0, 0 ])
            DeckGatePostPreview( false );

        // front
        DeckGateBracket( false, true );

        // back
        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( false, false );
    }
}
else if( render_mode == "print-latch-side" )
{
    translate([ flange_width, 0, 0 ])
    {
        // front
        DeckGateBracket( true, true );

        // back
        translate([ 0, preview_separation, -back_side_reduction_z ])
            DeckGateBracket( true, false );
    }
}
else if( render_mode == "print-spool-side" )
{
    translate([ flange_width, 0, 0 ])
    {
        // front
        DeckGateBracket( false, true );

        // back
        translate([ 0, preview_separation, -back_side_reduction_z ])
            DeckGateBracket( false, false );
    }
}
else
{
    assert( false, "Invalid render mode: ", render_mode );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracket( is_latch_side = true, is_front = true )
{
    bracket_y = ( is_latch_side ? bar_latch_side_y : bar_spool_side_y )
        + bar_clearance * 2
        + gate_mount_screw_nut_h
        + bracket_thickness * 2;

    front_bracket_offset = -bracket_thickness - flange_shroud_extra;

    difference()
    {
        union()
        {
            translate([ 0, 0, 0 ])
                RoundedCubeAlt2(
                    bracket_x,
                    bracket_y,
                    bracket_z,
                    r = bracket_thickness,
                    round_top = false,
                    round_bottom = false,
                    round_front = is_latch_side
                    );

            // left flange
            translate([
                -flange_width + DIFFERENCE_CLEARANCE * 2,
                bracket_y / 2 + ( is_front ? front_bracket_offset : 0 ),
                0
                ])
                DeckGateBracketFlange( true, is_front );

            // right flange
            translate([
                bracket_x - DIFFERENCE_CLEARANCE * 2,
                bracket_y / 2 + ( is_front ? front_bracket_offset : 0 ),
                0
                ])
                DeckGateBracketFlange( false, is_front );

            if( is_front && !is_latch_side )
            {
                // spool_side_angle
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
                ( is_latch_side ? bar_latch_side_y : bar_spool_side_y ) + bar_clearance * 2,
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
            if( is_latch_side )
            {
                // latch_screw_opening_percent
                bottom_percent = ( 0.5 - latch_screw_opening_percent ) / 2;
                top_percent = latch_screw_opening_percent + ( 0.5 - latch_screw_opening_percent ) / 2;

                // top
                DeckGateBracketMountLatchSideScrewWindow( true );

                // bottom
                DeckGateBracketMountLatchSideScrewWindow( false );
            }
            else
            {
                // spool side screw holes
                translate([ bracket_x, 0, 0 ])
                    rotate([ 0, 0, spool_side_angle ])
                        translate([ -bracket_x / 2, 0, 0 ])
                        {
                            // top
                            DeckGateBracketMountSpoolSideScrewHole( false );

                            // bottom
                            DeckGateBracketMountSpoolSideScrewHole( true );
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

module DeckGatePostPreview( is_latch_side = true )
{
    % translate([
        bracket_thickness + bar_clearance,
        bracket_thickness + bar_clearance,
        post_preview_offset_z
        ])
        cube([
            bar_x,
            is_latch_side ? bar_latch_side_y : bar_spool_side_y,
            post_preview_z
            ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracketFlange( is_left = true, is_front = true )
{
    difference()
    {
        RoundedCubeAlt2(
            flange_width,
            bracket_thickness + flange_shroud_extra,
            bracket_z,
            r = 1.0,
            round_top = false,
            round_bottom = false,
            round_left = is_left,
            round_right = !is_left,
            round_front = true,
            round_back = true
            );

        // top screw hole
        translate([ 0, 0, bracket_z * 0.7 ])
            DeckGateBracketFlangeScrewHole( is_front );

        // bottom screw hole
        translate([ 0, 0, bracket_z * 0.3 ])
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

module DeckGateBracketMountLatchSideScrewWindow( is_top )
{
    bottom_percent = ( 0.5 - latch_screw_opening_percent ) / 2
        + ( is_top ? 0.5 : 0 );
    top_percent = latch_screw_opening_percent
        + ( 0.5 - latch_screw_opening_percent ) / 2
        + ( is_top ? 0.5 : 0 );

    // screw hole
    hull()
    {
        // top
        translate([
            bracket_x / 2,
            -DIFFERENCE_CLEARANCE,
            top_percent * bracket_z
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = gate_screw_r + screw_hole_clearance,
                    h = bracket_thickness + DIFFERENCE_CLEARANCE
                    );

        // bottom
        translate([
            bracket_x / 2,
            -DIFFERENCE_CLEARANCE,
            bottom_percent * bracket_z
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = gate_screw_r + screw_hole_clearance,
                    h = bracket_thickness + DIFFERENCE_CLEARANCE
                    );
    }

    // nut
    hull()
    {
        // top
        translate([
            bracket_x / 2,
            bracket_thickness - DIFFERENCE_CLEARANCE,
            top_percent * bracket_z
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = gate_mount_screw_nut_r + screw_nut_clearance,
                    h = gate_mount_screw_nut_h + DIFFERENCE_CLEARANCE * 2,
                    $fn = 6
                    );

        // bottom
        translate([
            bracket_x / 2,
            bracket_thickness - DIFFERENCE_CLEARANCE,
            bottom_percent * bracket_z
            ])
            rotate([ -90, 0, 0 ])
                cylinder(
                    r = gate_mount_screw_nut_r + screw_nut_clearance,
                    h = gate_mount_screw_nut_h + DIFFERENCE_CLEARANCE * 2,
                    $fn = 6
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracketMountSpoolSideScrewHole( is_top )
{
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
