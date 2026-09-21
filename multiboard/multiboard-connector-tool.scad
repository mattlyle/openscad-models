use <MCAD/regular_shapes.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

connector_diameter = 22.5;
connector_full_depth = 13.2;
connector_thread_depth = 6.0;

peg_depth = 1.7;
peg_diameter = 5.8;
peg_offset = 5.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-v1";
// render_mode = "print-v2";

box_x = 35;
box_y = 35;
box_z = 15;

measurement_tolerance = 0.5;

holder_radius = 15;
v2_offset_x = 60; // spacing between v1 and v2 in the preview
v2_box_z = 20;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

connector_handle_depth = connector_full_depth - connector_thread_depth;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ConnectorToolV1();

    translate([ v2_offset_x, 0, 0 ])
        ConnectorToolV2();
}
else if( render_mode == "print-v1" )
{
    ConnectorToolV1();
}
else if( render_mode == "print-v2" )
{
    ConnectorToolV2();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// v1: square box
module ConnectorToolV1()
{
    render()
    {
        difference()
        {
            cube([ box_x, box_y, box_z ]);

            // cut out the cylinder
            translate([ box_x / 2, box_y / 2, box_z - connector_handle_depth ])
                cylinder( h = connector_handle_depth, r = connector_diameter / 2 + measurement_tolerance, $fn = 96 );
        }
    }

    color([ 0.5, 0, 0 ])
        translate([ box_x / 2 - peg_offset, box_y / 2, box_z - connector_handle_depth ])
            cylinder( h = peg_depth, r = peg_diameter / 2 - measurement_tolerance, $fn = 24 );

    color([ 0, 0, 0.5 ])
        translate([ box_x / 2 + peg_offset, box_y / 2, box_z - connector_handle_depth ])
            cylinder( h = peg_depth, r = peg_diameter / 2 - measurement_tolerance, $fn = 24 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// v2: hexagon
module ConnectorToolV2()
{
    render()
    {
        difference()
        {
            translate([ 0, holder_radius, 0 ])
                hexagon_prism( radius = holder_radius, height = v2_box_z ); // NOTE: octagon_prism also works great!

            // cut out the cylinder
            translate([ 0, holder_radius, v2_box_z - connector_handle_depth ])
                cylinder( h = connector_handle_depth, r = connector_diameter / 2 + measurement_tolerance, $fn = 96 );
        }
    }

    color([ 0.5, 0, 0 ])
        translate([ -peg_offset, holder_radius, v2_box_z - connector_handle_depth ])
            cylinder( h = peg_depth, r = peg_diameter / 2 - measurement_tolerance, $fn = 24 );

    color([ 0, 0, 0.5 ])
        translate([ peg_offset, holder_radius, v2_box_z - connector_handle_depth ])
            cylinder( h = peg_depth, r = peg_diameter / 2 - measurement_tolerance, $fn = 24 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
