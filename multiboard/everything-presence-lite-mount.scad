include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements


mount_x = 50.3;
mount_y = 52.2;
mount_z = 3.6;

cutout_x = 4.0;
cutout_y = 32.0;
cutout_offset_x = 8.0;
cutout_offset_y = 8.8;

difference_overlap = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

holder_extra_x = 5;
holder_extra_y = 5;

holder_arm_width_z = 3.0;
holder_arm_clearance = 0.5;
holder_arm_catch_y = 2.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

holder_z_offset = multiboard_connector_back_z;

holder_x = mount_x + holder_extra_x * 2;
holder_y = mount_y + holder_extra_y * 2;

cutout_r = cutout_x / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ holder_extra_x, holder_extra_y, holder_z_offset ])
        EverythingPresenceLitePreview();

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
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EverythingPresenceLiteHolderArm()
{
    arm_x = cutout_x - holder_arm_clearance * 2;
    arm_y = cutout_y - cutout_r * 2;
    arm_z = mount_z + holder_arm_width_z;

    hull()
    {
        // bottom
        translate([ arm_x / 2, cutout_r, 0 ])
            cylinder( r = arm_x / 2, h = arm_z );

        // top
        translate([ arm_x / 2, cutout_y - cutout_r, 0 ])
            cylinder( r = arm_x / 2, h = arm_z );
    }

    // top catch
    translate([ arm_x / 2, cutout_y - cutout_r + holder_arm_catch_y, mount_z ])
        cylinder( r = arm_x / 2, h = holder_arm_width_z );

    translate([ 0, cutout_y - cutout_r, mount_z ])
        cube([ arm_x, holder_arm_catch_y, holder_arm_width_z ]);
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
