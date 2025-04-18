include <../modules/multiboard.scad>
include <../modules/rounded-cube.scad>
include <../modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////
// measurements

doxie_x = 57.9;
doxie_y = 310;
doxie_z = 43.8;

////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";

holder_y = 80;

wall_width = 2.0;
clearance = 1.5;

corner_rounding_radius = 2.0;

////////////////////////////////////////////////////////////////////////////////
// calculations

size_x = doxie_x + wall_width * 2 + clearance * 2;
size_y = holder_y + wall_width;
size_z = doxie_z + wall_width * 2 + clearance * 2;

offset_x = multiboard_cell_size - MultiboardConnectorBackAltXOffset( size_x );

////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    translate([ 0, 0, -multiboard_cell_height ])
        color( workroom_multiboard_color )
            MultiboardMockUpTile( 12, 4 );

    translate([ offset_x, 0, 0  ])
    {
        DoxieMultiboardHolder();

        translate([ wall_width + clearance, wall_width, multiboard_connector_back_z ])
            DoxiePreview();
    }
}

if( render_mode == "print-holder" )
{
    translate([ 0, size_z + multiboard_connector_back_z, 0 ])
        rotate([ 90, 0, 0 ])
            DoxieMultiboardHolder();
}

////////////////////////////////////////////////////////////////////////////////
// doxie module

module DoxieMultiboardHolder()
{
    render()
    {
        // back
        MultiboardConnectorBackAlt( size_x, size_y );

        difference()
        {
            translate([ 0, 0, multiboard_connector_back_z ])
                RoundedCubeAlt2(
                    x = size_x,
                    y = size_y,
                    z = size_z,
                    r = multiboard_corner_rounding_r,
                    round_bottom = false,
                    fn = 36
                    );

            // cut out the middle
            translate([ wall_width, wall_width, multiboard_connector_back_z ])
                    cube([ doxie_x + clearance * 2, doxie_y, doxie_z + clearance * 2]);
        }

        // add the text
        // #translate([ 0, 0, multiboard_connector_back_z + size_z ])
        //     cube([ size_x, size_y, 0.1 ]);
        color([ 0.1, 0.1, 0.1 ])
            translate([ -1.5, 0, 0 ]) // for some reason the textmetrics are broken?
                translate([ 0, 0, multiboard_connector_back_z + size_z ])
                    CenteredTextLabel(
                        "Doxie",
                        centered_in_area_x = size_x,
                        centered_in_area_y = size_y,
                        font_size = 13,
                        font = "DejaVu Sans:style=Bold"
                        );
    }
}

////////////////////////////////////////////////////////////////////////////////
// doxie preview

module DoxiePreview()
{
    % cube([ doxie_x, doxie_y, doxie_z ] );
}

////////////////////////////////////////////////////////////////////////////////
