include <modules/rounded-cube.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

bar_x = 39.0;
bar_single_y = 39.0;
bar_combined_y = 48.5;

screw_hole_r = 3.86 / 2;
screw_washer_r = 8.9 / 2;

nut_r = 7.0 / 2;
nut_h = 3.0;

gate_screw_separation_z = 51.0;
gate_screw_r = 4 / 2;

gate_mount_screw_r = 4.9 / 2;
gate_mount_screw_nut_h = 5.0;
gate_mount_screw_nut_washer_r = 10.0 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
// render_mode = "print-single";
render_mode = "print-combined";

bracket_z = 75.0;

bracket_thickness = 3.6;

post_preview_z = 100;

bar_clearance = 0.2;

flange_width = 12.0;
flange_shroud_extra = 4.0;

preview_separation = 10.0;

screw_hole_clearance = 0.3;

washer_clearance = 0.4;
screw_nut_clearance = 0.7;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if( render_mode == "preview" )
{
    // single
    translate([ flange_width, 0, 0 ])
    {
        DeckGatePostPreview( true );

        DeckGateBracket( true, true );

        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( true, false );
    }

    // combined
    translate([ 100, 0, 0 ])
    {
        DeckGatePostPreview( false );

        DeckGateBracket( false, true );

        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( false, false );
    }
}
else if( render_mode == "print-single" )
{
    translate([ flange_width, 0, 0 ])
    {
        DeckGateBracket( true, true );

        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( true, false );
    }
}
else if( render_mode == "print-combined" )
{
    translate([ flange_width, 0, 0 ])
    {
        DeckGateBracket( false, true );

        translate([ 0, preview_separation, 0 ])
            DeckGateBracket( false, false );
    }
}
else
{
    assert( false, "Invalid render mode: ", render_mode );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGateBracket( is_single = true, is_front = true )
{
    bracket_x = bar_x + bar_clearance * 2
        + bracket_thickness * 2;

    bracket_y = ( is_single ? bar_single_y : bar_combined_y )
        + bar_clearance * 2
        + gate_mount_screw_nut_h
        + bracket_thickness * 2;

    difference()
    {
        translate([ 0, 0, 0 ])
            RoundedCubeAlt2(
                bracket_x,
                bracket_y,
                bracket_z,
                r = bracket_thickness,
                round_top = false,
                round_bottom = false
                );

        // cut out the post
        translate([
            bracket_thickness + bar_clearance,
            bracket_thickness + gate_mount_screw_nut_h,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                bar_x + bar_clearance * 2,
                ( is_single ? bar_single_y : bar_combined_y ) + bar_clearance * 2,
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
            // top gate screw hole
            translate([
                bracket_x / 2,
                bracket_thickness + gate_mount_screw_nut_h + DIFFERENCE_CLEARANCE,
                bracket_z - ( bracket_z - gate_screw_separation_z ) / 2
                ])
                DeckGateBracketMountScrewHole();

            // bottom gate screw hole
            translate([
                bracket_x / 2,
                bracket_thickness + gate_mount_screw_nut_h + DIFFERENCE_CLEARANCE,
                ( bracket_z - gate_screw_separation_z ) / 2
                ])
                DeckGateBracketMountScrewHole();
        }
    }

    front_bracket_offset = -bracket_thickness - flange_shroud_extra;

    // left flange
    translate([
        -flange_width,
        bracket_y / 2 + ( is_front ? front_bracket_offset : 0 ),
        0
        ])
        DeckGateBracketFlange( true, is_front );

    // right flange
    translate([
        bracket_x,
        bracket_y / 2 + ( is_front ? front_bracket_offset : 0 ),
        0
        ])
        DeckGateBracketFlange( false, is_front );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DeckGatePostPreview( is_single = true )
{
    % translate([
        bracket_thickness + bar_clearance,
        bracket_thickness + bar_clearance,
        -( post_preview_z - bracket_z ) / 2
        ])
        cube([
            bar_x,
            is_single ? bar_single_y : bar_combined_y,
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

module DeckGateBracketMountScrewHole()
{
    // washer/nut
    rotate([ 90, 0, 0 ])
        cylinder(
            r = gate_mount_screw_nut_washer_r + washer_clearance,
            h = gate_mount_screw_nut_h + DIFFERENCE_CLEARANCE
            );

    // screw hole
    translate([ 0, -gate_mount_screw_nut_h - bracket_thickness, 0 ])
        rotate([ -90, 0, 0 ])
            cylinder(
                r = gate_screw_r + screw_hole_clearance,
                h = bracket_thickness + DIFFERENCE_CLEARANCE
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
