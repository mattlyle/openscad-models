////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TextLabel(
    text_string,
    depth = 0.5,
    font_size,
    font = "Liberation Sans",
    color = undef
    )
{
    color( color )
        linear_extrude( depth )
            text( text_string, size = font_size, font = font );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CenteredTextLabel(
    text_string,
    centered_in_area_x,
    centered_in_area_y = -1,
    depth = 0.5,
    font_size = 8,
    font = "Liberation Sans",
    color = [ 0, 0, 0 ] )
{
    metrics = textmetrics( text = text_string, size = font_size, font = font );
    text_string_metrics_size = metrics.size;

    x = ( centered_in_area_x - text_string_metrics_size.x ) / 2 - metrics.position.x;
    y = centered_in_area_y <= 0
        ? 0
        : ( centered_in_area_y - text_string_metrics_size.y ) / 2 - metrics.descent;

    // # cube([ centered_in_area_x, centered_in_area_y, 0.01 ]);

    translate([ x, y, 0 ])
        TextLabel(
            text_string = text_string,
            depth = depth,
            font_size = font_size,
            font = font,
            color = color
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function _GetListOfLineHeights( text_lines, font_size, font ) =
    [
        for( line = text_lines )
            textmetrics( text = line, size = font_size, font = font ).size[ 1 ]
        ];

module MultilineTextLabel(
    text_lines,
    centered_in_area_x,
    centered_in_area_y = -1,
    fixed_line_spacing = -1,
    depth = 0.5,
    font_size = 8,
    font = "Liberation Sans",
    color = [ 0, 0, 0 ]
    )
{
    reversed_text_lines = reverse( text_lines );

    line_heights = _GetListOfLineHeights( reversed_text_lines, font_size = font_size, font = font );
    line_height_total = sumList( line_heights );

    line_spacing = fixed_line_spacing > 0
        ? fixed_line_spacing
        : ( centered_in_area_y - line_height_total ) / ( len( text_lines ) + 1 );

    // # cube([ centered_in_area_x, centered_in_area_y, 0.01 ]);

    for( i = [ 0 : len( reversed_text_lines ) - 1 ] )
    {
        line = reversed_text_lines[ i ];

        line_metrics = textmetrics( text = line, size = font_size, font = font ).size;

        translate([ 0, sumTo( line_heights, i ) + line_spacing * ( i + 1 ), 0 ])
            CenteredTextLabel(
                text_string = line,
                centered_in_area_x = centered_in_area_x,
                centered_in_area_y = -1,
                depth = depth,
                font_size = font_size,
                font = font,
                color = color
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
