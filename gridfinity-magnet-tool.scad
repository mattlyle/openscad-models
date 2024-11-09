use <../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <modules/rounded-cube.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

magnet_radius = 6.0 / 2;
magnet_height = 2.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

tool_length = 80.0;
tool_radius = 8.0 / 2;

jig_height = 25;
jig_peg_height = 1.0;

// only choose one
// render_mode = "preview";
// render_mode = "tool-top";
// render_mode = "tool-bottom";
// render_mode = "jig-bottom";
// render_mode = "jig-top-base";
render_mode = "jig-top-bin";

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

    translate([ 20, 0, 0 ])
        GridfinityMagnetJig( "BIN" );

    translate([ 70, 0, 0 ])
        GridfinityMagnetJig( "BASE" );
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

if( render_mode == "jig-bottom" || render_mode == "jig-top-base" )
{
    GridfinityMagnetJig( "BASE" );
}

if( render_mode == "jig-bottom" || render_mode == "jig-top-bin" )
{
    GridfinityMagnetJig( "BIN" );
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

module GridfinityMagnetJig( label_text )
{
    magnet_corner_offset = gf_cupbase_upper_taper_height + gf_cupbase_lower_taper_height + gf_cupbase_magnet_position;
    bin_size = gf_pitch - gf_tolerance;

    // # translate([ 0, 0, gf_zpitch + jig_peg_height ])
    //     gridfinity_cup( width = 1, depth = 1, height = 1, position = "zero", filled_in = true, lip_style = "none" );

    // base
    if( render_mode == "preview" || render_mode == "jig-bottom" )
    {
        RoundedCube([ bin_size, bin_size, jig_height ]);
    }

    echo(render_mode);

    if( render_mode == "preview" || render_mode == "jig-top-base" || render_mode == "jig-top-bin" )
    {
        // lower-left peg
        translate([ magnet_corner_offset, magnet_corner_offset, jig_height ])
            cylinder( h = jig_peg_height, r = magnet_radius, $fn = 24 );

        // lower-right peg
        translate([ bin_size - magnet_corner_offset, magnet_corner_offset, jig_height ])
            cylinder( h = jig_peg_height, r = magnet_radius, $fn = 24 );
        
        // upper-left peg
        translate([ magnet_corner_offset, bin_size - magnet_corner_offset, jig_height ])
            cylinder( h = jig_peg_height, r = magnet_radius, $fn = 24 );
        
        // upper-right peg
        translate([ bin_size - magnet_corner_offset, bin_size - magnet_corner_offset, jig_height ])
            cylinder( h = jig_peg_height, r = magnet_radius, $fn = 24 );

        // % translate([ 0, magnet_corner_offset + magnet_radius, jig_height ])
        //     cube([ bin_size, bin_size - ( magnet_corner_offset + magnet_radius ) * 2, 0.1 ]);

        // text
        translate([ 0, magnet_corner_offset + magnet_radius, jig_height ])
            CenteredTextLabel( label_text, 9, "Georgia:style=Bold", bin_size, bin_size - ( magnet_corner_offset + magnet_radius ) * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
