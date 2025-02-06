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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ChainLink();

    translate([ 50, 0, 0 ])
        ChainTopVelcroTie();
}
else if( render_mode == "print-chain-link" )
{
    ChainLink();
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

    // left prong
    // #translate([ 3, 16.8, 14 ])
    //     rotate([ 0, prong_angle_y, 0 ])
    //         cube([ prong_x, prong_y, prong_z ]);

    angle_offset = prong_y * sin( prong_angle_z );
    echo(angle_offset);

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

    // right prong
    // # translate([ 23.5, 24, 14 ])
    //     rotate([ 0, prong_angle_y, 180 ])
    //         cube([ prong_x, prong_y, prong_z ]);

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
