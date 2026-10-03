////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// an svg, extruded where it sits
//
// there is no svgmetrics to ask an svg how big it is, so there is nothing to center against -
// scale it, turn it and place it from the caller:
//
//     color( ... )
//         translate( ... )
//             rotate( ... )
//                 scale( ... )
//                     SVG( path, depth );

module SVG( svg_path, depth = 0.5 )
{
    linear_extrude( depth )
        import( svg_path );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
