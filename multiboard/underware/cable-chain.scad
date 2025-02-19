////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// inspiration: https://makerworld.com/en/models/806588#profileId-747219
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <../../modules/trapezoidal-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

link_edge_x = 1.68;
link_x = 25;
link_y = 35;
link_z = 16;
link_cutout_offset_y = 16.3;
link_cutout_r = 8.3;
link_hole_offset_y = 8;
link_hole_r = 3;

link_offset_x = 0.782;
link_offset_y = 2.5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-chain-link";
// render_mode = "print-chain-top-velcro-tie";

prong_y = 2.4;
prong_z = 1.0;
// prong_angle_y = -30;

prong_angle_z = 20;

prong_cutout_overlap = 1.8;

render_overlap = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

prong_r = ( link_x - link_edge_x * 4 ) * 0.5;
angle_offset = prong_y * sin( prong_angle_z );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ChainLink();

    translate([ 50, 0, 0 ])
        DoubleChainLink();

    translate([ 120, 0, 0 ])
        ChainTopVelcroTie();
}
else if( render_mode == "print-chain-link" )
{
    ChainLink();
}
else if( render_mode == "print-chain-double-link" )
{
    DoubleChainLink();
}
else if( render_mode == "print-chain-top-velcro-tie" )
{
    ChainTopVelcroTie();
}
else
{
    assert( false, "Unknown render mode!" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChainLink()
{
    translate([ -100, -160, 0 ])
        import( "../../assets/cable-chain-link-original.stl" );


    // echo(angle_offset);

    ChainLinkProngLeft();
    ChainLinkProngRight();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChainLinkProngLeft()
{
    difference()
    {
        translate([
            link_offset_x + link_edge_x * 2 - angle_offset,
            link_offset_y + link_cutout_offset_y - prong_cutout_overlap,
            link_z - prong_r
            ])
            rotate([ 0, 0, -prong_angle_z ])
                ChainLinkProng();

        translate([ link_offset_x + link_edge_x, link_offset_y + link_hole_offset_y, link_z / 2 ])
            rotate([ 0, 90, 0 ])
                cylinder( r = link_cutout_r, h = link_x - link_edge_x * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChainLinkProngRight()
{
    difference()
    {
        translate([
            link_offset_x + link_x - link_edge_x * 2 + angle_offset,
            link_offset_y + link_y - link_cutout_offset_y + prong_y,
            link_z - prong_r
            ])
            rotate([ 0, 0, 180 - prong_angle_z ])
                ChainLinkProng();

        translate([ link_offset_x + link_edge_x, link_offset_y + link_y - link_hole_offset_y, link_z / 2 ])
            rotate([ 0, 90, 0 ])
                cylinder( r = link_cutout_r, h = link_x - link_edge_x * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DoubleChainLink()
{
    center_x = 26;
    center_guide_x = 1.4;
    center_guide_z = 16;

    // left side
    difference()
    {
        translate([ -100, -160, 0 ])
            import( "../../assets/cable-chain-link-original.stl" );

        translate([ 5, 0, -1 ])
            cube([ 25, 40, 20 ]);
    }

    // right side
    translate([ center_x - 16, 0, 0 ])
    {
        difference()
        {
            translate([ -100, -160, 0 ])
                import( "../../assets/cable-chain-link-original.stl" );

            translate([ -1, 0, -1 ])
                cube([ 22, 40, 20 ]);
        }
    }

    // note: this is hacky... I should probably use scale() but it's a cutout in the center of the STL, so that's very complicated

    // bottom bar - left
    difference()
    {
        translate([ -100, -160, 0 ])
            import( "../../assets/cable-chain-link-original.stl" );

        translate([ -1, 0, -1 ])
            cube([ 6, 40, 20 ]);
        translate([ 22, 0, -1 ])
            cube([ 6, 40, 20 ]);
    }

    // bottom bar - right
    translate([ center_x - 17, 0, 0 ])
    {
        difference()
        {
            translate([ -100, -160, 0 ])
                import( "../../assets/cable-chain-link-original.stl" );

            translate([ -1, 0, -1 ])
                cube([ 6, 40, 20 ]);
            translate([ 22, 0, -1 ])
                cube([ 6, 40, 20 ]);
        }
    }

    // center guide
    left_edge = 4.15;
    right_edge = 32.4;
    center_guide_offset_x = left_edge + ( right_edge - left_edge - center_guide_x ) / 2;
    translate([ center_guide_offset_x, 17.2, 0 ])
        cube([ center_guide_x, 10.3, center_guide_z ]);

    // % translate([ left_edge, 18, 0 ])
    //     cube([ center_guide_offset_x - left_edge, 20, center_guide_z ]);
    // % translate([ center_guide_offset_x + center_guide_x, 18, 0])
    //     cube([ right_edge - center_guide_offset_x - center_guide_x, 20, center_guide_z ]);
    // echo( str( "left: ", center_guide_offset_x - left_edge ) );
    // echo( str( "right: ", right_edge - center_guide_offset_x - center_guide_x ) );

    // left side prongs
    ChainLinkProngLeft();
    translate([ center_guide_offset_x - 22, 3.45, 0 ])
        ChainLinkProngRight();

    // right side prongs
    translate([ center_guide_offset_x - 3, 0.6, 0 ])
    {
        ChainLinkProngLeft();
        translate([ center_guide_offset_x - 22, 3.45, 0 ])
            ChainLinkProngRight();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChainLinkProng()
{
    // outer
    translate([ prong_r, 0, 0 ])
    {
        difference()
        {
            translate([ -prong_r, 0, -prong_z ])
                cube([ prong_r, prong_y, prong_r + prong_z ]);

            translate([ 0, -render_overlap, -prong_z ])
                rotate([ -90, 0, 0 ])
                    cylinder( r = prong_r, h = prong_y + render_overlap * 2 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module ChainTopVelcroTie()
{
    cable_tie_y = 15;

    difference()
    {
        translate([ 235, -122, 0 ])
            rotate([ 0, 0, 90 ])
                import( "../../assets/cable-chain-end.stl" );

        translate([ -2, 41, 4 ])
            rotate([ 0, 0, -90 ])
                TrapezoidalPrism( cable_tie_y * 0.6, cable_tie_y, 30, 12, center = false );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
