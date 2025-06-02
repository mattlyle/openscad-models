////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/pie-slice-prism.scad>
include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

stake_r = 11.2 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-support";

support_length = 220;
support_width = 14.0;
support_depth = 3.0;

back_support_size = 2.0;

connector_cutout_angle = 90;
connector_wall_thickness = 1.8;

max_vertical_support_spacing = 30;

label_text = "v5";
label_depth = 0.12;
label_font_size = 8;
label_font = "Liberation Sans:style=Bold";

clearance = 0.15;

////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

beam_x = support_length - ( stake_r + clearance ) * 2;

connector_outer_r = stake_r + connector_wall_thickness + clearance;
connector_inner_r = stake_r + clearance;

num_vertical_supports = ceil( support_length / max_vertical_support_spacing );
echo( str( "Num vertical supports: ", num_vertical_supports ) );

////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    // translate([ 0, 0, 0 ])
    //     TomatoStakePreview();

    // translate([ support_length, 0, 0 ])
    //     TomatoStakePreview();

    TomatoStakeSupport();
}
else if( render_mode == "print-support" )
{
    TomatoStakeSupport();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module TomatoStakePreview()
{
    % cylinder( r = stake_r, h = 2000 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module TomatoStakeSupport()
{
    // connector - left
    _TomatoStakeSupportConnector();

    // connector - right
    translate([ support_length, 0, 0 ])
        _TomatoStakeSupportConnector();

    // beam
    _TomatoStakeSupportBeam();

    // vertical supports
    for( i = [ 0 : num_vertical_supports - 1 ] )
    {
        support_x = ( i + 1 )
            / ( num_vertical_supports + 1 )
            * support_length
            - back_support_size / 2;
        
        translate([ support_x, support_depth / 2, 0 ])
            cube([ back_support_size, back_support_size, support_width ]);
    }

    // label
    label_area_x = beam_x - connector_wall_thickness * 2;
    // #translate([ connector_outer_r, -support_depth / 2 - label_depth, 0 ])
    //     cube([ label_area_x, label_depth, support_width ]);
    translate([ connector_outer_r, -support_depth / 2, 0 ])
        rotate([ 90, 0, 0 ])
            CenteredTextLabel(
                label_text,
                centered_in_area_x = label_area_x,
                centered_in_area_y = support_width,
                depth = label_depth,
                font_size = label_font_size,
                font = label_font
                );

}

////////////////////////////////////////////////////////////////////////////////////////////////////

module _TomatoStakeSupportBeam()
{
    translate([ stake_r + clearance, -support_depth / 2, 0 ])
        cube([ beam_x, support_depth, support_width ]);

    // beam - back brace
    translate([ stake_r + clearance, support_depth / 2, support_width / 2 - support_depth / 2 ])
        cube([ beam_x, back_support_size, support_depth ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module _TomatoStakeSupportConnector()
{
    difference()
    {
        cylinder( r = connector_outer_r, h = support_width );

        // cut out inside
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            cylinder( r = connector_inner_r, h = support_width + DIFFERENCE_CLEARANCE * 2);

        // cut out pie slice
        translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
            rotate([ 0, 0, -90 - connector_cutout_angle / 2 ])
                PieSlicePrism(
                    20,
                    support_width + DIFFERENCE_CLEARANCE * 2,
                    connector_cutout_angle
                    );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
