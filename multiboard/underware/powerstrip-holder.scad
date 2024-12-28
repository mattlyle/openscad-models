include <../../modules/multiboard.scad>
include <../../modules/rounded-cube.scad>
include <../../modules/screw-connectors.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

powerstrip_x_top = 184;
powerstrip_x_bottom = 204;
powerstrip_y = 49;
powerstrip_z = 34;

powerstrip_screw_radius = 3.0 / 2;
powerstrip_screw_separation_x = 194;
powerstrip_screw_separation_y = 28;

wall_width = 2.2;
wall_clearance = 0.6;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

// need a bit of clearance so we don't push the heated insert through the back
z_clearance = 2.0;

holder_side_z = 6.0;
holder_corner_x = 10.0;

insert = M3x6_INSERT;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

holder_x_bottom = powerstrip_x_bottom + wall_width * 2 + wall_clearance * 2;
holder_y = powerstrip_y + wall_width * 2 + wall_clearance * 2;

holder_z_offset = multiboard_connector_back_z + z_clearance + M3x6_INSERT[ INSERT_LENGTH ];

screwhole_offset_x = ( powerstrip_x_bottom - powerstrip_screw_separation_x ) / 2;
screwhole_offset_y = ( powerstrip_y - powerstrip_screw_separation_y ) / 2;

powerstrip_mounting_bar_x = holder_corner_x + wall_width;
powerstrip_mounting_bar_z = insert[ INSERT_LENGTH ] + z_clearance;

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
            MultiboardMockUpTile( 12, 4 );

    // translate([ MultiboardConnectorBackAltXOffset( holder_x_bottom ), 0, 0 ])
    // {
        translate([ wall_width + wall_clearance, wall_width + wall_clearance, holder_z_offset ])
            PowerStripPreview();

        PowerStripHolder();
    // }
}
else if( render_mode == "print" )
{
    rotate([ 90, 0, 0 ])
        PowerStripHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerStripPreview()
{
    powerstrip_screw_preview_z = 0.1;

    % TrapezoidalPrism(
        powerstrip_x_top,
        powerstrip_x_bottom,
        powerstrip_y,
        powerstrip_z,
        center = false );

    color([ 0.4, 0.4, 0.4 ])
    {
        translate([ screwhole_offset_x, screwhole_offset_y, powerstrip_screw_preview_z ])
            cylinder( r = powerstrip_screw_radius, powerstrip_screw_preview_z, $fn = 12 );
        translate([ screwhole_offset_x, powerstrip_y - screwhole_offset_y, powerstrip_screw_preview_z ])
            cylinder( r = powerstrip_screw_radius, powerstrip_screw_preview_z, $fn = 12 );

        translate([ powerstrip_x_bottom - screwhole_offset_x, screwhole_offset_y, powerstrip_screw_preview_z ])
            cylinder( r = powerstrip_screw_radius, powerstrip_screw_preview_z, $fn = 12 );
        translate([ powerstrip_x_bottom - screwhole_offset_x, powerstrip_y - screwhole_offset_y, powerstrip_screw_preview_z ])
            cylinder( r = powerstrip_screw_radius, powerstrip_screw_preview_z, $fn = 12 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerStripHolder()
{
    // back
    MultiboardConnectorBackAlt( holder_x_bottom, holder_y );

    // mounting bars
    translate([ 0, 0, multiboard_connector_back_z ])
    {
        _PowerStripHolderMountingBar();

        translate([ holder_x_bottom, holder_y, 0 ])
            rotate([ 0, 0, 180 ])
                _PowerStripHolderMountingBar();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module _PowerStripHolderMountingBar()
{
    render()
    {
        difference()
        {
            RoundedCubeAlt2(
                powerstrip_mounting_bar_x,
                holder_y,
                powerstrip_mounting_bar_z,
                round_top = false,
                round_bottom = false
                );

            translate([ wall_width + wall_clearance + screwhole_offset_x, wall_width + wall_clearance + screwhole_offset_y, z_clearance ])
                HeatedInsert( insert );

            translate([ wall_width + wall_clearance + screwhole_offset_x, holder_y - wall_width - wall_clearance - screwhole_offset_y, z_clearance ])
                HeatedInsert( insert );

        }

        translate([ 0, 0, powerstrip_mounting_bar_z ])
        {
            // TODO these will print as overhangs?!

            // sides
            RoundedCubeAlt2(powerstrip_mounting_bar_x, wall_width, holder_side_z, round_top = false, round_bottom = false );
            translate([ 0, holder_y - wall_width, 0 ])
                RoundedCubeAlt2( powerstrip_mounting_bar_x, wall_width, holder_side_z, round_top = false, round_bottom = false );

            // long edge
            RoundedCubeAlt2( wall_width, holder_y, holder_side_z, round_top = false, round_bottom = false);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
