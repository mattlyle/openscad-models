use <../../3rd-party/gridfinity_extended_openscad/modules/module_gridfinity_cup.scad>
include <../../3rd-party/gridfinity_extended_openscad/modules/gridfinity_constants.scad>

include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>
include <../modules/gridfinity-extended.scad>
include <../modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

magnet_radius = 6.0 / 2;
magnet_height = 2.0;

jig2_baseplate_wall_width = 2.85;
jig2_corner_size = 12.0;
jig2_size_outer = 36.3;
jig2_size_inner = 18;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

tool_length = 80.0;
tool_radius = 8.0 / 2;

jig_height = 25;
jig_peg_height = 1.0;

jig2_height = 3;
jig2_clearance = 0.1;

// only choose one
render_mode = "preview";
// render_mode = "tool-top";
// render_mode = "tool-bottom";
// render_mode = "jig-bottom";
// render_mode = "jig-top-base";
// render_mode = "jig-top-bin";
// render_mode = "jig2"; // for baseplates
// render_mode = "jig3";
// render_mode = "jig4"; // for multiboard shelves using gridfinity-extended

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

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

    translate([ 120, 0, 0 ])
        GridfinityMagnetJig2();

    translate([ 170, 0, 0 ])
        GridfinityMagnetJig3();

    translate([ 220, 0, 0 ])
        GridfinityMagnetJig4();
}
else if( render_mode == "tool-top" )
{
    translate([ 0, 0, tool_length ])
        rotate([ 180, 0, 0 ])
            GridfinityMagnetToolHalf();
}
else if( render_mode == "tool-bottom" )
{
    GridfinityMagnetToolHalf();
}
else if( render_mode == "jig-bottom" || render_mode == "jig-top-base" )
{
    GridfinityMagnetJig( "BASE" );
}
else if( render_mode == "jig-bottom" || render_mode == "jig-top-bin" )
{
    GridfinityMagnetJig( "BIN" );
}
else if( render_mode == "jig2" )
{
    GridfinityMagnetJig2();
}
else if( render_mode == "jig3" )
{
    GridfinityMagnetJig3();
}
else if( render_mode == "jig4" )
{
    GridfinityMagnetJig4();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
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

    if( render_mode == "preview" )
    {
        # translate([ bin_size, 0, jig_height + gf_zpitch ])
            rotate([ 180, 0, 0 ])
                import( "../assets/baseplate-1-1.stl" );
    }

    // base
    if( render_mode == "preview" || render_mode == "jig-bottom" )
    {
        RoundedCube([ bin_size, bin_size, jig_height ], r = 4);
    }

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
            CenteredTextLabel( label_text, font_size = 8, font = "Georgia:style=Bold", bin_size, bin_size - ( magnet_corner_offset + magnet_radius ) * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityMagnetJig2()
{
    magnet_corner_offset = gf_cupbase_upper_taper_height + gf_cupbase_lower_taper_height + gf_cupbase_magnet_position;
    bin_size = gf_pitch;

    bottom_height = 2.8;

    render()
    {
        difference()
        {
            translate([ gf_pitch, gf_pitch, 0 ])
                import( "../assets/baseplate-1-1.stl" );

            // remove the top
            translate([ -1, -1, bottom_height ])
                cube([ gf_pitch + 2, gf_pitch + 2, 10 ]);
        }
    }

    union()
    {
        // horizontal - bottom
        translate([ 0, jig2_corner_size, 0 ])
            cube([ bin_size, jig2_size_inner, bottom_height ]);

        // vertical - bottom
        translate([ jig2_corner_size, 0, 0 ])
            cube([ jig2_size_inner, bin_size, bottom_height ]);

        // horizontal - top guide
        translate([ jig2_baseplate_wall_width + jig2_clearance, jig2_corner_size + jig2_clearance, bottom_height ])
            cube([ bin_size - jig2_baseplate_wall_width * 2 - jig2_clearance * 2, jig2_size_inner - jig2_clearance * 2, jig2_height ]);

        // vertical - top guide
        translate([ jig2_corner_size + jig2_clearance, jig2_baseplate_wall_width + jig2_clearance, bottom_height ])
            cube([ jig2_size_inner - jig2_clearance * 2, bin_size - jig2_baseplate_wall_width * 2 - jig2_clearance * 2, jig2_height ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityMagnetJig3()
{
    bottom_height = 2.8;

    render()
    {
        difference()
        {
            translate([ gf_pitch, gf_pitch, 0 ])
                import( "../assets/baseplate-1-1.stl" );

            // remove the top
            translate([ -1, -1, bottom_height ])
                cube([ gf_pitch + 2, gf_pitch + 2, 10 ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module GridfinityMagnetJig4()
{
    bin_size = gf_pitch;

    bottom_height = 2.35 + DIFFERENCE_CLEARANCE;

    core_bottom_size = 14.4;
    core_top_size = 10;
    core_top_height = 5;
    core_top_edge_offset = 3.2;

    core_bottom_offset = ( bin_size - core_bottom_size ) / 2;
    core_top_offset = ( bin_size - core_top_size ) / 2;
    core_top_length = bin_size - core_top_edge_offset * 2;

    union()
    {
        difference()
        {
            GridfinityBaseplate( 1, 1 );

            // cut off the top
            translate([ -DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE, bottom_height ])
                cube([
                    bin_size + DIFFERENCE_CLEARANCE * 2,
                    bin_size + DIFFERENCE_CLEARANCE * 2,
                    5
                    ]);
        }

        // vertical core - bottom
        translate([ core_bottom_offset, DIFFERENCE_CLEARANCE, 0 ])
            cube([ core_bottom_size, bin_size - DIFFERENCE_CLEARANCE * 2, bottom_height - DIFFERENCE_CLEARANCE ]);

        // horizontal core - bottom
        translate([ DIFFERENCE_CLEARANCE, core_bottom_offset, 0 ])
            cube([ bin_size - DIFFERENCE_CLEARANCE * 2, core_bottom_size, bottom_height - DIFFERENCE_CLEARANCE ]);

        // vertical core - top
        translate([ core_top_offset, core_top_edge_offset, bottom_height ])
            cube([ core_top_size, core_top_length, core_top_height ]);

        // horizontal core - bottom
        translate([ core_top_edge_offset, core_top_offset, bottom_height ])
            cube([ core_top_length,core_top_size,  core_top_height ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
