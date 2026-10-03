include <../modules/utils.scad>
include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>
include <../modules/svg.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

battery_x = 77.8;
battery_y = 43.6;

// battery_slot_top_x = 66.1;
// battery_slot_bottom_x = 58.3;

// battery_slot_y = 56.7;

// battery_slot_top_z = 6.2;
// battery_slot_bottom_z = 6.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-tool-holder";
// render_mode = "print-tool-holder-logo";
// render_mode = "print-battery-holder";
// render_mode = "print-battery-holder-logo";

num_tools = 3;

num_batteries = 3;

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

holder_connector_row_setups = [ [ 3, 2 ], [ 1 ] ];

// the height of the battery bin, including the floor the batteries rest on
battery_holder_z = 50;

battery_wall_width = 2.0;
battery_clearance = 1.0;

// the wall between neighbouring batteries; the outside stays a battery_wall_width all the way round
battery_spacing = 2.0;

svg_path = "../assets/ridgid-logo.svg";
svg_depth = 0.6;
logo_size = 60;
logo_offset_z = 2;

// the battery holder has a plain face, so its logo is not boxed in by the arms like the tool one
battery_logo_size = 120;
battery_logo_offset_z = 8;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

tool_total_x = tool_slot_x * num_tools;

tool_total_z =
    tool_arm_support_z
    + tool_arm_z
    + extra_z_top
    + extra_z_bottom;

echo( str( "Tool Total X: ", tool_total_x ) );
echo( str( "Tool Total Z: ", tool_total_z ) );

// one pocket per battery, none of them given a depth so they all run down to the floor
battery_cutout_list = [
    for( i = [ 0 : num_batteries - 1 ] )
        BinHelperCube(
            battery_x + battery_clearance * 2,
            battery_y + battery_clearance * 2
            )
    ];

battery_cutout_location_list = BinHelperEquallySpacedLocations(
    battery_cutout_list,
    battery_spacing,
    battery_wall_width
    );

battery_bin_size_vector = MultiboardConnectorHelperBinSize(
    battery_cutout_list,
    battery_holder_z,
    battery_spacing,
    battery_wall_width
    );

echo( str( "Battery Holder Size: ", battery_bin_size_vector ) );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    RidgidToolHolders();

    color( "black" )
        RidgidToolHoldersLogo();

    translate([ tool_total_x + 50, 0, 0 ])
    {
        RidgidBatteryHolders();

        color( "black" )
            RidgidBatteryHoldersLogo();
    }
}
else if( render_mode == "print-tool-holder" )
{
    RidgidToolHolders();
}
else if( render_mode == "print-tool-holder-logo" )
{
    RidgidToolHoldersLogo();
}
else if( render_mode == "print-battery-holder" )
{
    RidgidBatteryHolders();
}
else if( render_mode == "print-battery-holder-logo" )
{
    RidgidBatteryHoldersLogo();
}
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
                MultiboardConnectorBackAlt2( tool_total_x, tool_total_z, holder_connector_row_setups );

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
    if( num_tools % 2 == 1 )
    {
        // odd, so only draw the center one
        _RidgidLogo( tool_total_x, logo_size, logo_offset_z, is_cutout );
    }
    else
    {
        // even, so draw every one?
        for( i = [ 0 : num_tools - 1 ] )
        {
            translate([ i * tool_slot_x, 0, 0 ])
                _RidgidLogo( tool_slot_x, logo_size, logo_offset_z, is_cutout );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RidgidBatteryHoldersLogo( is_cutout = false )
{
    _RidgidLogo(
        battery_bin_size_vector.x,
        battery_logo_size,
        battery_logo_offset_z,
        is_cutout
        );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// the logo sitting in its recess, centered across the face it is given
//
// the cut version stands proud of the face so it has no coplanar surface to fight with; the
// printed one sits flush in the recess

module _RidgidLogo( centered_in_area_x, size_x, offset_z, is_cutout = false )
{
    translate([
        CalculateOffsetToCenter( centered_in_area_x, size_x ),
        svg_depth,
        offset_z
        ])
        rotate([ 90, 0, 0 ])
            resize([ size_x, 0 ], auto = true )
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

module RidgidBatteryHolders()
{
    difference()
    {
        MultiboardConnectorHelperBin(
            battery_bin_size_vector,
            battery_cutout_list,
            battery_cutout_location_list,
            battery_wall_width
            );

        RidgidBatteryHoldersLogo( true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
