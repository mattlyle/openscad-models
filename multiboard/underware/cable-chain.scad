////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// inspiration: https://makerworld.com/en/models/806588#profileId-747219
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

// prong_x = 10.0;
prong_y = 2.4;
prong_z = 1.0;
// prong_angle_y = -30;

prong_cutout_overlap = 1.8;

render_overlap = 0.01;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 64;

prong_r = ( link_x - link_edge_x * 4 ) * 0.35;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ChainLink();
}
else
{
    assert( false, "Unknown render mode!" );
}



// % translate([ link_offset_x, 15, link_z ])
//     cube([ link_x, 0.1, 0.1 ]);
// % translate([ link_offset_x + link_edge_x, 26, link_z ])
//     cube([ link_x, 0.1, 0.1 ]);
// % translate([ link_offset_x, link_offset_y, link_z / 2 ])
//     cube([ link_x, link_y, 0.1 ]);
// % translate([ link_offset_x, link_offset_y, link_z / 2 ])
//     cube([ link_x, link_y, 0.1 ]);
// % translate([ link_offset_x + link_edge_x, link_offset_y + link_cutout_offset_y, link_z / 2 ])
//     cube([ link_edge_x, 0.01, 0.01 ]);
// % translate([ link_offset_x, link_offset_y + link_hole_offset_y, link_z / 2 ])
//     rotate([ 0, 90, 0 ])
//         cylinder( r = link_hole_r, h = link_x );
// % translate([ link_offset_x + link_edge_x, link_offset_y + link_hole_offset_y, link_z / 2 ])
//     rotate([ 0, 90, 0 ])
//         cylinder( r = link_cutout_r, h = /*link_x - link_edge_x * 2*/1 );



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChainLink()
{
    translate([ -100, -160, 0 ])
        import( "../../assets/cable-chain-link-original.stl" );

    // left prong
    // #translate([ 3, 16.8, 14 ])
    //     rotate([ 0, prong_angle_y, 0 ])
    //         cube([ prong_x, prong_y, prong_z ]);

    difference()
    {
        translate([
            link_offset_x + link_edge_x * 2 + prong_r,
            link_offset_y + link_cutout_offset_y - prong_cutout_overlap,
            link_z - prong_r
            ])
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
            link_offset_x + link_x - prong_r - link_edge_x * 2,
            link_offset_y + link_y - link_cutout_offset_y + prong_y,
            link_z - prong_r
            ])
            rotate([ 0, 0, 180 ])
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
    difference()
    {
        translate([ -prong_r, 0, -prong_z ])
            cube([ prong_r, prong_y, prong_r + prong_z ]);

        translate([ 0, -render_overlap, -prong_z ])
            rotate([ -90, 0, 0 ])
                cylinder( r = prong_r, h = prong_y + render_overlap * 2 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
