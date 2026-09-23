include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>
include <../modules/svg.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-tool-holder";
// render_mode = "print-tool-holder-logo";
// x_render_mode = "print-battery-holder";

num_tools = 1;

num_batteries = 2;

tool_arm_spacing_x = 50;
tool_arm_y = 100;
tool_arm_z = 8.0;
tool_arm_angle = 8;

tool_arm_support_x = 4;
tool_arm_support_y_percent = 0.8;
tool_arm_support_z = 60;
tool_arm_support_offset_x = -10;

tool_slot_x = 110;

extra_z_top = 5;
extra_z_bottom = 5;

holder_connector_row_setups = [ [3,2], [ 1 ] ];

svg_path = "../assets/ridgid-logo.svg";
svg_depth = 0.6;
logo_size = 60;
logo_offset_z = 2;

// TODO add ridgid logo

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

total_x = tool_slot_x * num_tools;

total_y = -1; // TODO finish

total_z =
    tool_arm_support_z
    + tool_arm_z
    + extra_z_top
    + extra_z_bottom;

echo( str( "Total X: ", total_x ) );
echo( str( "Total Y: ", total_y ) );
echo( str( "Total Z: ", total_z ) );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    RidgidToolHolders();

    color( "black" )
        RidgidToolHoldersLogo();
}
else if( render_mode == "print-tool-holder" )
{
    RidgidToolHolders();
}
else if( render_mode == "print-tool-holder-logo" )
{
    RidgidToolHoldersLogo();
}
// else if( render_mode == "print-battery-holder" )
// {
//     RidgidBatteryHolders();
// }
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RidgidToolHolders()
{
    difference()
    {
        translate([ 0, multiboard_connector_back_z, 0 ])
            rotate([ 90, 0, 0 ])
                MultiboardConnectorBackAlt2( total_x, total_z, holder_connector_row_setups );

        RidgidToolHoldersLogo( true );
    }
    
    // arms
    for( i = [ 0 : num_tools - 1 ] )
    {
        translate([
            i * tool_slot_x,
            0,
            tool_arm_support_z + extra_z_bottom
            ])
        {
            translate([
                ( tool_slot_x - tool_arm_spacing_x ) / 2,
                0,
                0
                ])
                _RidgidToolHolderArm( true, i > 0 );
            
            translate([
                ( tool_slot_x - tool_arm_spacing_x ) / 2 + tool_arm_spacing_x,
                0,
                0
                ])
                _RidgidToolHolderArm( false, i < num_tools - 1 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RidgidToolHoldersLogo( is_cutout = false )
{
    translate([
        CalculateOffsetToCenter( total_x, logo_size ),
        svg_depth,
        logo_offset_z
        ])
        rotate([ 90, 0, 0 ])
            resize([ logo_size, 0 ], auto = true )
                SVG( svg_path, depth = svg_depth + ( is_cutout ? DIFFERENCE_CLEARANCE: 0 ) );

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _RidgidToolHolderArm( is_left, is_shared )
{
    side_x = ( tool_slot_x - tool_arm_spacing_x ) / 2;

    // flat top
    translate([
        is_left ? 0 : side_x,
        0,
        0
        ])
        rotate([
            tool_arm_angle,
            0,
            180
            ])
            RoundedCube(
                side_x,
                tool_arm_y,
                tool_arm_z,
                round_front = false,
                round_left = ( !is_left && !is_shared ) || is_left,
                round_right = ( is_left && !is_shared ) || !is_left,
                );

    // support
    translate([
        is_left ? tool_arm_support_offset_x : -tool_arm_support_offset_x,
        0,
        0
        ])
    {
        hull()
        {
            // back top
            translate([
                0,
                0,
                0
                ])
                sphere( r = tool_arm_support_x / 2 );

            adjusted_arm_length = tool_arm_y * tool_arm_support_y_percent
                - tool_arm_support_x / 2;

            // front top
            translate([
                0,
                -adjusted_arm_length * cos( tool_arm_angle ),
                adjusted_arm_length * sin( tool_arm_angle )
                ])
                sphere( r = tool_arm_support_x / 2 );

            // bottom
            translate([
                0,
                0,
                -tool_arm_support_z
                ])
                sphere( r = tool_arm_support_x / 2 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
