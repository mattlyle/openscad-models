////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

cube_shelf_vertical_support_x = 12.4;

power_cable_x = 3.0;
power_cable_y = 10.0;

// tray_z = 125.0;
tray_z = 170.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

// only choose one
render_mode = "preview";
// render_mode = "print";

wall_width = 1.8;

cube_shelf_pinch_angle = 6.0;
cube_shelf_back_clearance = 1.0;

power_cable_entry_gap = 4.0;
power_cable_clearance = 3.0;

wall_preview_y = 120;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

power_cable_channel_x = power_cable_x + power_cable_clearance * 2;
power_cable_channel_y = power_cable_y + power_cable_clearance * 2;

tray_y = power_cable_channel_y + wall_width * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// modules

if( render_mode == "preview" )
{
    // preview the cube shelf wall
    % translate([ wall_width + cube_shelf_back_clearance, -wall_preview_y + power_cable_channel_y + wall_width, 0 ])
        cube([ cube_shelf_vertical_support_x, wall_preview_y, tray_z ]);

    // preview the cable
    % translate([ wall_width * 2 + cube_shelf_vertical_support_x + cube_shelf_back_clearance, wall_width, 0 ])
        // cylinder( h = tray_z, r = power_cable_y );
        cube([ power_cable_x, power_cable_y, tray_z ]);

    CubeShelfPowerCableTray();
}
else if( render_mode == "print" )
{
    CubeShelfPowerCableTray();
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CubeShelfPowerCableTray()
{
    center_wall_x = wall_width + cube_shelf_vertical_support_x + cube_shelf_back_clearance;
    right_wall_x = center_wall_x + wall_width + power_cable_channel_x;
    gap_wall_x = center_wall_x + wall_width + power_cable_entry_gap;

    back_wall_y = wall_width + power_cable_channel_y;

    // left wall
    translate([ wall_width, tray_y, 0 ])
        rotate([ 0, 0, 180 + cube_shelf_pinch_angle ])
            cube([ wall_width, tray_y, tray_z ]);

    // behind cube shelf
    translate([ 0, back_wall_y, 0 ])
        cube([ center_wall_x, wall_width, tray_z ]);

    // center wall
    translate([ center_wall_x, 0, 0 ])
        cube([ wall_width, tray_y, tray_z ]);

    // in front of cable
    translate([ center_wall_x, 0, 0 ])
        cube([ wall_width * 2 + power_cable_channel_x, wall_width, tray_z ]);

    // right of cable
    translate([ right_wall_x, 0, 0 ])
        cube([ wall_width, tray_y, tray_z ]);

    // behind cable
    translate([ gap_wall_x, back_wall_y, 0 ])
        cube([ right_wall_x - gap_wall_x, wall_width, tray_z ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
