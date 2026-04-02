////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

anker_wall_charger_width = 104;
anker_wall_charger_height = 80;
anker_wall_charger_depth = 29;

monitor_mount_r = 35 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// render_mode = "preview";
render_mode = "print-holder";

cord_preview_length = 80;

// lip_height = 2.0;
lip_height = 12.0;
holder_thickness = 2.0;
padding = 0.8;

corner_radius = 1.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 128 : 256;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    MonitorMountPreview();

    translate([ holder_thickness + padding, holder_thickness + padding, holder_thickness + padding ])
        WallChargerPreview();

    WallChargerMonitorMount();
}
else if( render_mode == "print-holder" )
{
    WallChargerMonitorMount();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WallChargerPreview()
{
    // body
    % cube([ anker_wall_charger_width, anker_wall_charger_depth, anker_wall_charger_height ]);

    // input cord
    % translate([ anker_wall_charger_width, anker_wall_charger_depth / 2, anker_wall_charger_height / 2 ])
        rotate([ 0, 90, 0 ])
            scale([ 1, 0.6, 1 ])
                cylinder( r = 5, h = cord_preview_length );

    // output cords
    for( i = [ 0 : 4 ] )
    {
        z = anker_wall_charger_height / 5 * ( i + 0.5 );

        % translate([ -cord_preview_length, anker_wall_charger_depth / 2, z ])
            rotate([ 0, 90, 0 ])
                scale([ 0.6, 1, 1 ])
                    cylinder( r = 5, h = cord_preview_length );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MonitorMountPreview()
{
    % cylinder( r = monitor_mount_r, h = 200 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WallChargerMonitorMount()
{
    difference()
    {
        RoundedCubeAlt2(
            anker_wall_charger_width + holder_thickness * 2 + padding * 2,
            anker_wall_charger_depth + holder_thickness * 2 + padding * 2,
            anker_wall_charger_height + holder_thickness * 2 + padding * 2,
            corner_radius
            );

        // remove the front cutout, offset above the lip
        translate([
            -DIFFERENCE_CLEARANCE,
            holder_thickness,
            holder_thickness + lip_height
            ])
            cube([
                holder_thickness,
                anker_wall_charger_depth + padding * 2,
                anker_wall_charger_height + padding * 2 - lip_height
                ]);

        // remove the main charger space
        translate([
            holder_thickness - DIFFERENCE_CLEARANCE,
            holder_thickness,
            holder_thickness
            ])
            cube([
                anker_wall_charger_width + padding * 2,
                anker_wall_charger_depth + padding * 2,
                anker_wall_charger_height + padding * 2
                ]);

        // remove the input cord space
        translate([
            anker_wall_charger_width + holder_thickness + padding * 2 - DIFFERENCE_CLEARANCE,
            anker_wall_charger_depth / 2 + holder_thickness + padding,
            anker_wall_charger_height / 2 + holder_thickness + padding
            ])
            rotate([ 0, 90, 0 ])
                cylinder( r = anker_wall_charger_depth / 2 - holder_thickness, h = holder_thickness + DIFFERENCE_CLEARANCE * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
