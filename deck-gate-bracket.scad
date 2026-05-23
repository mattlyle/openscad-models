include <modules/rounded-cube.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

bar_x = 39.0;
bar_single_y = 39.0;
bar_combined_y = 47.0;

screw_hole_r = 3.86 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print";

bracket_z = 30.0;

bracket_thickness = 3.6;

post_preview_z = 100;

bar_clearance = 0.3;

flange_width = 12.0;

preview_separation = 1.0;

screw_hole_clearance = 0.3;

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
    bracket_x = bar_x + bar_clearance * 2 + bracket_thickness * 2;
    bracket_y = ( is_single ? bar_single_y : bar_combined_y ) + bar_clearance * 2 + bracket_thickness * 2;

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

        translate([
            bracket_thickness + bar_clearance,
            bracket_thickness + bar_clearance,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                bar_x,
                is_single ? bar_single_y : bar_combined_y,
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
    }

    // left flange
    translate([
        -flange_width,
        bracket_y / 2 + ( is_front ? -bracket_thickness : 0 ),
        0
        ])
        DeckGateBracketFlange( true );

    // right flange
    translate([
        bracket_x,
        bracket_y / 2 + ( is_front ? -bracket_thickness : 0 ),
        0
        ])
        DeckGateBracketFlange( false );
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

module DeckGateBracketFlange( is_left = true )
{
    difference()
    {
        RoundedCubeAlt2(
            flange_width,
            bracket_thickness,
            bracket_z,
            r = 1.0,
            round_top = false,
            round_bottom = false,
            round_left = is_left,
            round_right = !is_left,
            round_front = true,
            round_back = true
            );

        // screw hole
        translate([
            flange_width / 2,
            -DIFFERENCE_CLEARANCE,
            bracket_z / 2
            ])
            rotate([ -90, 0, 0 ])
            cylinder(
                r = screw_hole_r + screw_hole_clearance,
                h = bracket_thickness + DIFFERENCE_CLEARANCE * 2
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
