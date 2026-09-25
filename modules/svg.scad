////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SVG( svg_path, depth = 0.5 )
{
    linear_extrude( depth )
        import( svg_path );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// an svg placed by hand
//
// there is no svgmetrics to ask an svg how big it is, so there is nothing to center against and
// no way to know where a turned one lands - scale it, turn it, then nudge it into place by eye
//
// it scales and turns about its own origin, so changing the angle moves it and the offsets want
// another look

module SVGLabel(
    svg_path,
    svg_scale = 1.0,
    rotation_angle = 0,
    offset_x = 0,
    offset_y = 0,
    depth = 0.5,
    color = undef
    )
{
    color( color )
        translate([ offset_x, offset_y, 0 ])
            rotate([ 0, 0, rotation_angle ])
                scale([ svg_scale, svg_scale, 1.0 ])
                    SVG( svg_path, depth );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
