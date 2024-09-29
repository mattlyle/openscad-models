////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TextLabel( text_string, font_size, font = "Liberation Sans" )
{
    color([ 0, 0, 0 ])
        linear_extrude( 0.5 )
            text( text_string, size = font_size, font = font );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CenteredTextLabel( text_string, font_size, font = "Liberation Sans", centered_in_area_x, centered_in_area_y = -1 )
{
    text_string_metrics_size = textmetrics( text = text_string, size = font_size, font = font ).size;

    x = ( centered_in_area_x - text_string_metrics_size[ 0 ] ) / 2;
    y = centered_in_area_y <= 0 ? 0 : ( centered_in_area_y - text_string_metrics_size[ 1 ] ) / 2;
    
    translate([ x, y, 0 ])
        TextLabel( text_string, font_size, font );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
