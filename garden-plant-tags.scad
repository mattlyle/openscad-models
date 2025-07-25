////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/rounded-cylinder.scad>
include <modules/rounded-cube.scad>
include <modules/text-label.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-body-vertical";
// render_mode = "print-body-horizontal";
// render_mode = "print-text-vertical";
// render_mode = "print-text-horizontal";

label_first_line = "Fresh Salsa";
// label_first_line = "SuperSauce";
label_second_line = "Roma Tomato";

// label_first_line = "Two Tasty";
// label_first_line = "Veranda Red";
// label_first_line = "Sungold";
// label_second_line = "Cherry Tomato";

// label_first_line = "Bodacious";
// label_second_line = "Slicing Tomato";

// label_first_line = "Tiger Eye";
// label_second_line = "Sunflower";

// label_first_line = "Alaska";
// label_second_line = "Nasturtium";

// label_first_line = "Asclepias";
// label_second_line = "Butterfly Weed";

horizontal_extra_y = 5;
horizontal_overlap_x = 2;

stake_section_x = 100;
stake_section_taper_x = 10;
stake_section_taper_y = 4;
tag_height = 28;
tag_z = 6;
rounded_top_vertical_scale_x = 0.4;
rounded_top_horizontal_scale_x = 0.2;

label_first_line_font_size = 12;
label_second_line_font_size = 6;
fontname = "Liberation Sans:style=bold";

label_first_line_offset_y = -1;
label_second_line_offset_y = 1;

outline_width = 0.8;

rounding_r = 1.4;
stake_point_r = 0.2;

decoration_depth = 0.4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculateMaxLabelLength() =
    max(
        textmetrics( text = label_first_line, size = label_first_line_font_size, font = fontname ).size[ 0 ],
        textmetrics( text = label_second_line, size = label_second_line_font_size, font = fontname ).size[ 0 ]
        );

function CalculateRoundedTopX( tag_y, scale_x ) =  tag_y / 2 * scale_x;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 128;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

intersection()
{
    cube([ BUILD_PLATE_X, BUILD_PLATE_Y, tag_z ]);

    if( render_mode == "preview" )
    {
        VerticalPlantTag();

        translate([ 0, 50, 0 ])
            HorizontalPlantTag();
    }
    else if( render_mode == "print-body-vertical" )
    {
        VerticalPlantTag();
    }
    else if( render_mode == "print-body-horizontal" )
    {
        HorizontalPlantTag();
    }
    else if( render_mode == "print-text-vertical" )
    {
        // top decoration
        translate([ 0, 0, -decoration_depth ])
            _PlantTagDecoration( false, true );

        // bottom decoration
        translate([ 0, tag_height, tag_z + decoration_depth ])
            rotate([ 180, 0, 0 ])
                _PlantTagDecoration( false, true );
    }
    else if( render_mode == "print-text-horizontal" )
    {
        tag_y = CalculateMaxLabelLength() + horizontal_extra_y;
        offset_x = CalculateRoundedTopX( tag_y, rounded_top_horizontal_scale_x )
            - horizontal_overlap_x;

        // top decoration
        translate([ offset_x + tag_height, 0, -decoration_depth ])
            rotate([ 0, 0, 90 ])
                _PlantTagDecoration( false, false );

        // bottom decoration
        translate([ offset_x + tag_height, tag_y, tag_z + decoration_depth ])
            rotate([ 180, 0, -90 ])
                _PlantTagDecoration( false, false );
    }
    else
    {
        assert( false, str( "Unknown render mode: ", render_mode ) );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module VerticalPlantTag()
{
    label_section_x = CalculateMaxLabelLength();

    difference()
    {
        _PlantTag( label_section_x, tag_height, true );

        // cut out the top
        translate([ 0, 0, -decoration_depth ])
            _PlantTagDecoration( true, true );

        // cut out the bottom
        translate([ 0, tag_height, tag_z + decoration_depth ])
            rotate([ 180, 0, 0 ])
                _PlantTagDecoration( true, true );
    }

    if( render_mode == "preview" )
    {
        // top decoration
        translate([ 0, 0, decoration_depth ])
            _PlantTagDecoration( false, true );

        // bottom decoration
        translate([ 0, tag_height, tag_z - decoration_depth ])
            rotate([ 180, 0, 0 ])
                _PlantTagDecoration( false, true );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _PlantTagDecoration( for_cutout, is_vertical_label )
{
    colorname = for_cutout ? undef : [ 0.2, 0, 0 ];

    offset_x = CalculateRoundedTopX(
        tag_height,
        is_vertical_label
            ? rounded_top_vertical_scale_x
            : rounded_top_horizontal_scale_x );

    first_line_y = tag_height * 0.6;
    second_line_y = tag_height - first_line_y;

    first_line_offset_y = tag_height - first_line_y;
    second_line_offset_y = 0;

    label_section_x = CalculateMaxLabelLength();

    // show the full sections the text will be in
    // if( render_mode == "preview" && !for_cutout )
    // {
    //     # translate([
    //         offset_x,
    //         first_line_offset_y + label_first_line_offset_y,
    //         tag_z - decoration_depth + 0.01
    //         ])
    //         cube([
    //             label_section_x,
    //             first_line_y,
    //             0.01
    //             ]);

    //     % translate([
    //         offset_x,
    //         second_line_offset_y + label_second_line_offset_y,
    //         tag_z - decoration_depth + 0.01
    //         ])
    //         cube([
    //             label_section_x,
    //             second_line_y,
    //             0.01
    //             ]);
    // }

    // first line
    translate([ offset_x, first_line_offset_y + label_first_line_offset_y, tag_z  ])
        CenteredTextLabel(
            text_string = label_first_line,
            centered_in_area_x = label_section_x,
            centered_in_area_y = first_line_y,
            depth = decoration_depth + DIFFERENCE_CLEARANCE,
            font_size = label_first_line_font_size,
            font = fontname,
            color = colorname
            );

    // second line
    translate([ offset_x, second_line_offset_y + label_second_line_offset_y, tag_z ])
        CenteredTextLabel(
            text_string = label_second_line,
            centered_in_area_x = label_section_x,
            centered_in_area_y = second_line_y,
            depth = decoration_depth + DIFFERENCE_CLEARANCE,
            font_size = label_second_line_font_size,
            font = fontname,
            color = colorname
            );

    // outline
    // color( colorname )
    // {
    //     difference()
    //     {
    //         // outer
    //         translate([ vertical_rounded_top_r, vertical_rounded_top_r, tag_z ])
    //             scale([ rounded_top_vertical_scale_x, 1.0, 1.0 ])
    //                 cylinder(
    //                     r = vertical_rounded_top_r + DIFFERENCE_CLEARANCE,
    //                     h = decoration_depth + DIFFERENCE_CLEARANCE
    //                     );

    //         // cut out inside
    //         translate([ vertical_rounded_top_r, vertical_rounded_top_r, tag_z - DIFFERENCE_CLEARANCE ])
    //             scale([ rounded_top_vertical_scale_x, 1.0, 1.0 ])
    //                 cylinder(
    //                     r = vertical_rounded_top_r - outline_width,
    //                     h = outline_width + DIFFERENCE_CLEARANCE * 2
    //                     );

    //         // cut off right half
    //         translate([ vertical_rounded_top_r, 0, tag_z - DIFFERENCE_CLEARANCE ])
    //             cube([ vertical_rounded_top_r, tag_height, outline_width + DIFFERENCE_CLEARANCE * 2 ]);
    //     }

    //     // top outline
    //     translate([ vertical_rounded_top_r - DIFFERENCE_CLEARANCE, tag_height - outline_width, tag_z ])
    //         cube([
    //             label_section_x + DIFFERENCE_CLEARANCE * 2,
    //             outline_width + DIFFERENCE_CLEARANCE,
    //             decoration_depth + DIFFERENCE_CLEARANCE
    //             ]);

    //     // bottom outline
    //     translate([ vertical_rounded_top_r - DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE, tag_z ])
    //         cube([
    //             label_section_x + DIFFERENCE_CLEARANCE * 2,
    //             outline_width + DIFFERENCE_CLEARANCE,
    //             decoration_depth + DIFFERENCE_CLEARANCE
    //             ]);
    // }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HorizontalPlantTag()
{
    tag_x = tag_height - horizontal_overlap_x * 2;
    tag_y = CalculateMaxLabelLength() + horizontal_extra_y;
    offset_x = CalculateRoundedTopX( tag_y, rounded_top_horizontal_scale_x )
        - horizontal_overlap_x;

    difference()
    {
        _PlantTag( tag_x, tag_y, false );

        // cut out the top
        translate([ offset_x + tag_height, 0, -decoration_depth ])
            rotate([ 0, 0, 90 ])
                _PlantTagDecoration( true, false );

        // cut out the bottom
        translate([ offset_x + tag_height, tag_y, tag_z + decoration_depth ])
            rotate([ 180, 0, -90 ])
                _PlantTagDecoration( true, false );
    }

    if( render_mode == "preview" )
    {
        // top decoration
        translate([ offset_x + tag_height, 0, decoration_depth ])
            rotate([ 0, 0, 90 ])
                _PlantTagDecoration( false, false );

        // bottom decoration
        translate([ offset_x + tag_height, tag_y, tag_z - decoration_depth ])
            rotate([ 180, 0, -90 ])
                _PlantTagDecoration( false, false );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _PlantTag( tag_x, tag_y, is_vertical_label )
{
    union()
    {
        rounded_top_y = tag_y / 2;
        rounded_top_x = CalculateRoundedTopX(
            tag_y,
            is_vertical_label
                ? rounded_top_vertical_scale_x
                : rounded_top_horizontal_scale_x
            );

        // rounded top
        difference()
        {
            rounded_top_scale_x = is_vertical_label
                ? rounded_top_vertical_scale_x
                : rounded_top_horizontal_scale_x;

            translate([ rounded_top_x, rounded_top_y, 0 ])
                scale([ rounded_top_scale_x, 1.0, 1.0 ])
                    RoundedCylinder(
                        r = rounded_top_y,
                        h = tag_z,
                        rounding_r = rounding_r
                        );

            // cut off the right side
            translate([ rounded_top_x, -DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE ])
                cube([
                    rounded_top_x + DIFFERENCE_CLEARANCE,
                    tag_y + DIFFERENCE_CLEARANCE * 2,
                    tag_z + DIFFERENCE_CLEARANCE * 2
                    ]);
        }

        // main body
        translate([ rounded_top_x, 0, 0 ])
            RoundedCubeAlt2(
                x = tag_x,
                y = tag_y,
                z = tag_z,
                r = rounding_r,
                round_top = true,
                round_bottom = true,
                round_left = false,
                round_right = false
                );

        // stake section
        stake_offset_x = rounded_top_x + tag_x;

        stake_left_x = stake_offset_x;
        stake_right_x = stake_offset_x + stake_section_x;
        stake_taper_x = stake_offset_x
            + stake_section_taper_x
            + ( is_vertical_label ? 0 : -horizontal_overlap_x * 2 );

        stake_near_y = rounding_r;
        stake_point_y = tag_y / 2;
        stake_far_y = tag_y - rounding_r;
        stake_taper_near_y = tag_y / 2 - stake_section_taper_y / 2;
        stake_taper_far_y = tag_y / 2 + stake_section_taper_y / 2;

        stake_top_z = tag_z - rounding_r;
        stake_point_top_z = tag_z;
        stake_point_bottom_z = 0;
        stake_bottom_z = rounding_r;

        if( is_vertical_label )
        {
            // before taper
            points_before_taper = [
                [ stake_left_x, stake_far_y, stake_top_z, rounding_r ],
                [ stake_taper_x, stake_taper_far_y, stake_top_z, rounding_r ],
                [ stake_taper_x, stake_taper_near_y, stake_top_z, rounding_r ],
                [ stake_left_x, stake_near_y, stake_top_z, rounding_r ],

                [ stake_left_x, stake_far_y, stake_bottom_z, rounding_r ],
                [ stake_taper_x, stake_taper_far_y, stake_bottom_z, rounding_r ],
                [ stake_taper_x, stake_taper_near_y, stake_bottom_z, rounding_r ],
                [ stake_left_x, stake_near_y, stake_bottom_z,rounding_r ],
                ];
            hull()
            {
                for( point = points_before_taper )
                {
                    translate([ point.x, point.y, point.z ])
                        sphere( r = point[ 3 ] );
                }
            }
        }
        else
        {
            // rounded bottom
            difference()
            {
                rounded_top_scale_x = is_vertical_label
                    ? rounded_top_vertical_scale_x
                    : rounded_top_horizontal_scale_x;

                translate([ stake_offset_x, rounded_top_y, 0 ])
                    scale([ rounded_top_scale_x, 1.0, 1.0 ])
                        RoundedCylinder(
                            r = rounded_top_y,
                            h = tag_z,
                            rounding_r = rounding_r
                            );

                // cut off the left side
                translate([ tag_x - DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE ])
                    cube([
                        rounded_top_x + DIFFERENCE_CLEARANCE,
                        tag_y + DIFFERENCE_CLEARANCE * 2,
                        tag_z + DIFFERENCE_CLEARANCE * 2
                        ]);
            }
        }

        // after taper
        points_after_taper = [
            [ stake_taper_x, stake_taper_far_y, stake_top_z, rounding_r ],
            [ stake_right_x, stake_point_y, stake_point_top_z, stake_point_r ],
            [ stake_taper_x, stake_taper_near_y, stake_top_z, rounding_r ],

            [ stake_taper_x, stake_taper_far_y, stake_bottom_z, rounding_r ],
            [ stake_right_x, stake_point_y, stake_point_bottom_z, stake_point_r ],
            [ stake_taper_x, stake_taper_near_y, stake_bottom_z, rounding_r ],
            ];
        hull()
        {
            for( point = points_after_taper )
            {
                translate([ point.x, point.y, point.z ])
                    sphere( r = point[ 3 ] );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
