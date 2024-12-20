include <../../modules/multiboard.scad>
include <../../modules/trapezoidal-prism.scad>

////////////////////////////////////////////////////////////////////////////////
// measurements

powerstrip_x_top = 184;
powerstrip_x_bottom = 204;
powerstrip_y = 49;
powerstrip_z = 34;

wall_width = 1.4;
wall_clearance = 0.6;

////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";

////////////////////////////////////////////////////////////////////////////////
// calculations

holder_x_top = powerstrip_x_top + wall_width * 2 + wall_clearance * 2;
holder_x_bottom = powerstrip_x_bottom + wall_width * 2 + wall_clearance * 2;
holder_y = powerstrip_y + wall_width * 2 + wall_clearance;
// holder_z = 0;

////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // translate([ 0, 0, -multiboard_cell_height ])
    //     color([ 112.0/255.0, 128.0/255.0, 144.0/255.0 ])
    //         MultiboardMockUpTile( 12, 4 );

    translate([ wall_width + wall_clearance, wall_width + wall_clearance, multiboard_connector_back_z ])
        PowerStripPreview();

    PowerStripHolder();
}


////////////////////////////////////////////////////////////////////////////////

module PowerStripPreview()
{
    % TrapezoidalPrism( powerstrip_x_top, powerstrip_x_bottom, powerstrip_y, powerstrip_z, center = false );
}

////////////////////////////////////////////////////////////////////////////////

module PowerStripHolder()
{
    // back
    MultiboardConnectorBackAlt( holder_x_bottom, holder_y );

}

////////////////////////////////////////////////////////////////////////////////
