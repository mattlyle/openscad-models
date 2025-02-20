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

double_link_center_guide_x = 1.4;
double_link_center_guide_z = 16;

double_link_left_edge_ = 4.15;
double_link_right_edge_ = 32.4;

double_end_left_edge_x = 3.9;
double_end_right_edge_x = 22.1;
double_end_x = 25.55;
double_end_holes_x = 7.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-chain-link";
// render_mode = "print-chain-double-link";
// render_mode = "print-chain-double-link-start";
// render_mode = "print-chain-double-link-end";
// render_mode = "print-chain-top-velcro-tie";

prong_y = 2.4;
prong_z = 1.0;
// prong_angle_y = -30;

prong_angle_z = 20;

prong_cutout_overlap = 1.8;

render_overlap = 0.01;

cable_tie_y = 15;

double_link_center_x = 26;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

double_link_center_guide_offset_x = double_link_left_edge_ + ( double_link_right_edge_ - double_link_left_edge_ - double_link_center_guide_x ) / 2;

prong_r = ( link_x - link_edge_x * 4 ) * 0.5;
angle_offset = prong_y * sin( prong_angle_z );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

render()
{
    if( render_mode == "preview" )
    {
        ChainLink();

        translate([ 50, 0, 0 ])
            DoubleChainLink();

        translate([ 100, 0, 0 ])
            DoubleChainLinkStart();

        translate([ 150, 0, 0 ])
            DoubleChainLinkEnd();

        translate([ 200, 0, 0 ])
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
    else if( render_mode == "print-chain-double-link-start" )
    {
        DoubleChainLinkStart();
    }
    else if( render_mode == "print-chain-double-link-end" )
    {
        DoubleChainLinkEnd();
    }
    else if( render_mode == "print-chain-top-velcro-tie" )
    {
        ChainTopVelcroTie();
    }
    else
    {
        assert( false, "Unknown render mode!" );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChainLink()
{
    translate([ -100, -160, 0 ])
        import( "../../assets/cable-chain-link-original.stl" );

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
    // left side
    difference()
    {
        translate([ -100, -160, 0 ])
            import( "../../assets/cable-chain-link-original.stl" );

        translate([ 5, 0, -1 ])
            cube([ 25, 40, 20 ]);
    }

    // right side
    translate([ double_link_center_x - 16, 0, 0 ])
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
    translate([ double_link_center_x - 17, 0, 0 ])
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
    translate([ double_link_center_guide_offset_x, 17.2, 0 ])
        cube([ double_link_center_guide_x, 10.3, double_link_center_guide_z ]);

    // % translate([ double_link_left_edge_, 18, 0 ])
    //     cube([ double_link_center_guide_offset_x - double_link_left_edge_, 20, double_link_center_guide_z ]);
    // % translate([ double_link_center_guide_offset_x + double_link_center_guide_x, 18, 0])
    //     cube([ double_link_right_edge_ - double_link_center_guide_offset_x - double_link_center_guide_x, 20, double_link_center_guide_z ]);
    // echo( str( "left: ", double_link_center_guide_offset_x - double_link_left_edge_ ) );
    // echo( str( "right: ", double_link_right_edge_ - double_link_center_guide_offset_x - double_link_center_guide_x ) );

    // left side prongs
    ChainLinkProngLeft();
    translate([ double_link_center_guide_offset_x - 22, 3.45, 0 ])
        ChainLinkProngRight();

    // right side prongs
    translate([ double_link_center_guide_offset_x - 3, 0.6, 0 ])
    {
        ChainLinkProngLeft();
        translate([ double_link_center_guide_offset_x - 22, 3.45, 0 ])
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

module DoubleChainLinkStart()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DoubleChainLinkEnd()
{
    double_end_center_x = double_link_center_x + 2;

    assert( double_end_center_x >= double_end_holes_x, "center needs to be wider than the holes section" );

    // side_overlap = ( double_end_center_x - double_end_holes_x ) / 2;
    side_overlap = 5.5;

    // left side
    intersection()
    {
        translate([ 235, -122, 0 ])
            rotate([ 0, 0, 90 ])
                import( "../../assets/cable-chain-end.stl" );

        translate([ 0, 0, 0 ])
            cube([ double_end_left_edge_x + side_overlap, 50, 20 ]);
    }

    // right side
    translate([ double_end_center_x - 18, 0, 0 ])
    {
        intersection()
        {
            translate([ 235, -122, 0 ])
                rotate([ 0, 0, 90 ])
                    import( "../../assets/cable-chain-end.stl" );

            translate([ double_end_right_edge_x - side_overlap, 0, 0 ])
                cube([ double_end_x - double_end_right_edge_x + side_overlap, 50, 20 ]);
        }
    }

    // center with holes
    translate([ side_overlap, 0, 0 ])
    {
        intersection()
        {
            translate([ 235, -122, 0 ])
                rotate([ 0, 0, 90 ])
                    import( "../../assets/cable-chain-end.stl" );

            translate([ double_end_left_edge_x, 0, 0 ])
                cube([ double_end_right_edge_x - double_end_left_edge_x, 50, 20 ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
