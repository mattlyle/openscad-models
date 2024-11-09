////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

magnet_radius = 6.0 / 2;
magnet_height = 2.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

tool_length = 80.0;
tool_radius = 8.0 / 2;

// only choose one
// render_mode = "preview";
render_mode = "tool-top";
// render_mode = "tool-bottom";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

magnet_ridge_overlap = magnet_height / 2;
tool_magnet_cutout_radius = magnet_radius + 0.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // lower magnet preview
    % translate([ 0, 0, -magnet_ridge_overlap ])
        cylinder( h = magnet_height, r = magnet_radius, $fn = 24 );

    // upper magnet preview
    translate([ 0, 0, tool_length - magnet_ridge_overlap])
        % cylinder( h = magnet_height, r = magnet_radius, $fn = 24 );

    // bottom half
    color([ 0.2, 0.2, 0.2 ])
        GridfinityMagnetToolHalf();

    // top half
    color([ 0.8, 0.0, 0.0 ])
        translate([ 0, 0, tool_length ])
            rotate([ 180, 0, 0 ])
                GridfinityMagnetToolHalf();
}

if( render_mode == "tool-top" )
{
    translate([ 0, 0, tool_length ])
        rotate([ 180, 0, 0 ])
            GridfinityMagnetToolHalf();
}

if( render_mode == "tool-bottom" )
{
    GridfinityMagnetToolHalf();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityMagnetToolHalf()
{
    render()
    {
        difference()
        {
            // tool body
            cylinder( h = tool_length / 2, r = tool_radius, $fn = 48 );

            // cutout
            cylinder( h = magnet_ridge_overlap, r = tool_magnet_cutout_radius, $fn = 48 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
