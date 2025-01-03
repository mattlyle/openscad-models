include <../../modules/multiboard.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

adapter_x = 100.0;
adapter_y = 60.1;
adapter_z = 29.9;

adapter_power_in_r = 16.0 / 2;
adapter_power_out_r = 3.5 / 2;

wall_width = 2.2;
wall_clearance = 0.6;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

adapter_r = adapter_z / 2;

$fn = $preview ? 16 : 32;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

CricutPowerAdapterPreview();

if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
            MultiboardMockUpTile( 12, 4 );

    // translate([ MultiboardConnectorBackAltXOffset( holder_x_bottom ), 0, 0 ])
    // {
    // translate([ wall_width + wall_clearance, wall_width + wall_clearance, holder_z_offset ])
    //     CricutPowerAdapterPreview();

    // CricutPowerAdapter();
    // }
}
else if( render_mode == "print" )
{
    // rotate([ 90, 0, 0 ])
    //     CricutPowerAdapter();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module CricutPowerAdapter()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module CricutPowerAdapterPreview()
{
    // % cube([ adapter_x, adapter_y, adapter_z ]);

    // adapter
    hull()
    {
        translate([ 0, adapter_r, adapter_z / 2 ])
            rotate([ 0, 90, 0 ])
                cylinder( h = adapter_x, r = adapter_r );

        translate([ 0, adapter_y - adapter_r, adapter_z / 2 ])
            rotate([ 0, 90, 0 ])
                cylinder( h = adapter_x, r = adapter_r );
    }

    // power in
    translate([ adapter_x, adapter_y / 2, adapter_z / 2 ])
        rotate([ 0, 90, 0 ])
            cylinder( h = adapter_x, r = adapter_power_in_r );

    // power out
    translate([ 0, adapter_y + adapter_power_out_r, adapter_z / 2 ])
        rotate([ 0, 90, 0 ])
            cylinder( h = adapter_x * 2, r = adapter_power_out_r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////
