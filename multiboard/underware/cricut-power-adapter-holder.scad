include <../../modules/multiboard.scad>
include <../../modules/rounded-cube.scad>
include <../../modules/triangular-prism.scad>
include <../../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

adapter_x = 60.1;
adapter_y = 100.0;
adapter_z = 29.9;

adapter_power_in_r = 16.0 / 2;
adapter_power_out_r = 3.5 / 2;

wall_width = 2.2;
wall_clearance = 0.75;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

lip_z = 3.0;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

adapter_r = adapter_z / 2;

holder_x = wall_width * 2 + wall_clearance * 2 + adapter_x + adapter_power_out_r * 2;
holder_y = wall_width * 2 + wall_clearance + adapter_y;
holder_z = wall_width + wall_clearance * 2 + adapter_z + lip_z;

holder_z_offset = multiboard_connector_back_z;

$fn = $preview ? 16 : 32;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
            MultiboardMockUpTile( 6, 6 );

    // translate([ MultiboardConnectorBackAltXOffset( holder_x_bottom ), 0, 0 ])
    // {
    translate([ wall_width + wall_clearance, wall_width + wall_clearance, holder_z_offset ])
        CricutPowerAdapterPreview();

    CricutPowerAdapterHolder();
    // }
}
else if( render_mode == "print" )
{
    translate([ 0, holder_z + holder_z_offset, 0 ])
        rotate([ 90, 0, 0 ])
            CricutPowerAdapterHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module CricutPowerAdapterHolder()
{
    // back
    MultiboardConnectorBackAlt( holder_x, holder_y );

    holder_inside_x = holder_x - wall_width * 2 - wall_clearance * 2;
    holder_inside_z = holder_z - wall_width - wall_clearance;

    render()
    {
        difference()
        {
            translate([ 0, 0, holder_z_offset ])
                RoundedCubeAlt2( x = holder_x, y = holder_y, z = holder_z, round_bottom = false );

            translate([ wall_width + wall_clearance, wall_width, holder_z_offset ])
                cube([ holder_inside_x, holder_y, holder_inside_z ]);
        }
    }

    // back lip
    translate([ wall_width + wall_clearance, holder_y, holder_z_offset + holder_inside_z ])
        rotate([ 0, 180, 180 ])
            TriangularPrism( holder_inside_x, wall_width, lip_z );

    // text label
    translate([ 48, holder_y, holder_z_offset + holder_z ])
        rotate([ 0, 0, -90 ])
            CenteredTextLabel( "Cricut", holder_y, -1, font_size = 16, font = "Liberation Sans:style=Bold" );
    translate([ 28, holder_y, holder_z_offset + holder_z ])
        rotate([ 0, 0, -90 ])
            CenteredTextLabel( "Power", holder_y, -1, font_size = 16, font = "Liberation Sans:style=Bold" );
    translate([ 8, holder_y, holder_z_offset + holder_z ])
        rotate([ 0, 0, -90 ])
            CenteredTextLabel( "Adapter", holder_y, -1, font_size = 16, font = "Liberation Sans:style=Bold" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module CricutPowerAdapterPreview()
{
    // % cube([ adapter_x, adapter_y, adapter_z ]);

    // adapter
    % hull()
    {
        translate([ adapter_r, 0, adapter_z / 2 ])
            rotate([ -90, 0, 0 ])
                cylinder( h = adapter_y, r = adapter_r );

        translate([ adapter_x - adapter_r, 0, adapter_z / 2 ])
            rotate([ -90, 0, 0 ])
                cylinder( h = adapter_y, r = adapter_r );
    }

    // power in
    % translate([ adapter_x / 2, adapter_y, adapter_z / 2 ])
        rotate([ -90, 0, 0 ])
            cylinder( h = adapter_y, r = adapter_power_in_r );

    // power out
    % translate([ adapter_x + adapter_power_out_r, 0, adapter_z / 2 ])
        rotate([ -90, 0, 0 ])
            cylinder( h = adapter_y * 2, r = adapter_power_out_r );
}

////////////////////////////////////////////////////////////////////////////////////////////////////
