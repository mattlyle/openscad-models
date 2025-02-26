include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>
include <../modules/trapezoidal-prism.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements


mount_x = 50.4;
mount_y = 52.0;
mount_z = 3.5;

cutout_x = 4.0;
cutout_y = 34.6;
cutout_offset_x = 8.0;
cutout_offset_y = 8.8;

cord_r = 3.6 / 2;

difference_overlap = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

holder_extra_x = 6;
holder_extra_y = 5;

holder_arm_z = 3.0;
holder_arm_clearance = 0.3;
holder_arm_catch_y = 2.0;

cord_hook_wall_width = 1.6;
cord_hook_y = 6;
cord_hook_clearance = 0.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

holder_z_offset = multiboard_connector_back_z;

holder_x = mount_x + holder_extra_x * 2;
holder_y = mount_y + holder_extra_y * 2;

cutout_r = cutout_x / 2;

cord_hook_offset_y = ( holder_y - cord_hook_y ) / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // mount preview
    translate([ holder_extra_x, holder_extra_y, holder_z_offset ])
        EverythingPresenceLitePreview();

    // cord preview left
    % translate([ cord_hook_wall_width + cord_r, -holder_y / 2, holder_z_offset + cord_r ])
        rotate([ -90, 0, 0 ])
            cylinder( r = cord_r, h = holder_y * 2 );

    // cord preview right
    % translate([ holder_x - cord_hook_wall_width - cord_r, -holder_y / 2, holder_z_offset + cord_r ])
        rotate([ -90, 0, 0 ])
            cylinder( r = cord_r, h = holder_y * 2 );

    // holder
    EverythingPresenceLiteHolder();
}
else if( render_mode == "print" )
{
    translate([ 0, holder_z_offset, 0 ])
        rotate([ 90, 0, 0 ])
            EverythingPresenceLiteHolder();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EverythingPresenceLiteHolder()
{
    MultiboardConnectorBackAlt( holder_x, holder_y );

    // left arm
    translate([
        holder_extra_x + cutout_offset_x + holder_arm_clearance,
        holder_extra_y + cutout_offset_y,
        holder_z_offset
        ])
        EverythingPresenceLiteHolderArm();

    // right arm
    translate([ holder_extra_x + mount_x - cutout_offset_x - cutout_x + holder_arm_clearance, holder_extra_y + cutout_offset_y, holder_z_offset ])
        EverythingPresenceLiteHolderArm();

    // cord hook left
    translate([ 0, cord_hook_offset_y, holder_z_offset ])
        EverythingPresenceLiteHolderCordHook();

    // cord hook right
    translate([ holder_x, cord_hook_offset_y + cord_hook_y, holder_z_offset ])
        rotate([ 0, 0, 180 ])
            EverythingPresenceLiteHolderCordHook();

    // text label
    text_area_offset_y = holder_y - holder_extra_y + 1.2;
    translate([ 0, text_area_offset_y, holder_z_offset ])
        CenteredTextLabel( "Everything Presence Lite", holder_x, -1, font_size = 3.5, font = "Liberation Sans:style=Bold" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EverythingPresenceLiteHolderArm()
{
    arm_x = cutout_x - holder_arm_clearance * 2;
    arm_y = cutout_y - cutout_r * 2;
    arm_top_z = holder_arm_z;
    arm_bottom_z = mount_z + holder_arm_clearance;

    // bottom section of the arm
    hull()
    {
        // bottom
        translate([ arm_x / 2, cutout_r, 0 ])
            cylinder( r = arm_x / 2, h = arm_bottom_z );

        // top
        translate([ arm_x / 2, cutout_y - cutout_r, 0 ])
            cylinder( r = arm_x / 2, h = arm_bottom_z );
    }

    // top section of the arm with the catch
    hull()
    {
        // bottom
        translate([ arm_x / 2, cutout_r + holder_arm_catch_y, arm_bottom_z ])
            cylinder( r = arm_x / 2, h = arm_top_z );

        // top
        translate([ arm_x / 2, cutout_y - cutout_r + holder_arm_catch_y, arm_bottom_z ])
            cylinder( r = arm_x / 2, h = arm_top_z );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EverythingPresenceLiteHolderCordHook()
{
    hook_top_y = cord_hook_y / 2;
    hook_bottom_y = cord_hook_y;
    hook_z = cord_r * 2 + cord_hook_wall_width + cord_hook_clearance;

    translate([ cord_hook_wall_width, 0, 0 ])
        rotate([ 0, 0, 90 ])
            TrapezoidalPrism(
                hook_top_y,
                hook_bottom_y,
                cord_hook_wall_width,
                hook_z,
                center = false );


    translate([ cord_hook_wall_width, ( hook_bottom_y - hook_top_y ) / 2, hook_z - cord_hook_wall_width])
        cube([ cord_r, hook_top_y, cord_hook_wall_width  ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EverythingPresenceLitePreview()
{
    % difference()
    {
        RoundedCubeAlt3( mount_x, mount_y, mount_z, r_x = 10.0 );

        translate([ cutout_offset_x, cutout_offset_y, 0 ])
            EverythingPresenceLitePreviewCutout();

        translate([ mount_x - cutout_offset_x - cutout_x, cutout_offset_y, 0 ])
            EverythingPresenceLitePreviewCutout();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EverythingPresenceLitePreviewCutout()
{
    // translate([ 0, cutout_r, -difference_overlap])
    //     cube([ cutout_x, cutout_y - cutout_x, mount_z + difference_overlap * 2 ]);

    hull()
    {
        translate([ cutout_r, cutout_r, -difference_overlap ])
            cylinder( h = mount_z + difference_overlap * 2, r = cutout_r );
        translate([ cutout_r, cutout_y - cutout_r, -difference_overlap ])
            cylinder( h = mount_z + difference_overlap * 2, r = cutout_r );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
