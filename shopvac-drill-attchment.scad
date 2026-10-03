////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

shopvac_tube_inner_r = 31.3 / 2;
// shopvac_tube_outer_r = 15;
shopvac_tube_insert_z = 20.0;

shopvac_tube_insert_y = 26.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 256;

new_shopvac_tube_outer_r = shopvac_tube_inner_r + 1.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ShopvacDrillAttachment();
}
else if( render_mode == "print" )
{
    ShopvacDrillAttachment();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ShopvacDrillAttachment()
{
    difference()
    {
        union()
        {
            import( "assets/Bigfoot_30mm_fixed.stl" );

            translate([ 0, shopvac_tube_insert_y, 0 ])
                cylinder(
                    r = new_shopvac_tube_outer_r,
                    h = shopvac_tube_insert_z,
                    );
        }

        // cut out the larger shopvac insert
        translate([ 0, shopvac_tube_insert_y, -0.01 ])
            cylinder(
                r = shopvac_tube_inner_r,
                h = shopvac_tube_insert_z + 0.02,
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
