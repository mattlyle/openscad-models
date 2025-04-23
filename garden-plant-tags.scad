////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/text-label.scad>
include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-body";
// render_mode = "print-text";

label_first_line = "Sunflower";
label_second_line = "Tiger Eye Hybrid";
// svg_file = "plant.svg";

label_section_x = 120;
stake_section_x = 80;
tag_y = 25;
tag_z = 10;
rounded_top_scale_x = 0.7;

label_first_line_font_size = 12;
label_second_line_font_size = 6;

label_first_line_offset_y = 1;
label_second_line_offset_y = 3;

outline_width = 0.8;

decoration_depth = 0.4;

// TODO: rounded corners

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

rounded_top_r = tag_y / 2;
// svg_section_x = tag_y;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    PlantTag();
}
else if( render_mode == "print-body" )
{
    PlantTag();
}
else if( render_mode == "print-text" )
{
    // top decoration
    translate([ 0, 0, -decoration_depth ])
        PlantTagDecoration( false );

    // bottom decoration
    translate([ 0, tag_y, tag_z + decoration_depth ])
        rotate([ 180, 0, 0 ])
            PlantTagDecoration( false );
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlantTag()
{
    // main_body_x = svg_section_x + label_section_x;
    main_body_x = label_section_x;

    difference()
    {
        union()
        {
            // rounded top
            translate([ rounded_top_r, rounded_top_r, 0 ])
                scale([ rounded_top_scale_x, 1.0, 1.0 ])
                    cylinder(
                        r = rounded_top_r,
                        h = tag_z
                        );

            // main body
            translate([ rounded_top_r, 0, 0 ])
                cube([ main_body_x, tag_y, tag_z ]);
        }

        // cut out the top
        translate([ 0, 0, -decoration_depth ])
                PlantTagDecoration( true );

        // cut out the bottom
        translate([ 0, tag_y, tag_z + decoration_depth ])
            rotate([ 180, 0, 0 ])
                    PlantTagDecoration( true );
    }

    // stake section
    // stake_left_x = rounded_top_r + svg_section_x + label_section_x;
    stake_left_x = rounded_top_r + label_section_x;
    // stake_right_x = rounded_top_r + svg_section_x + label_section_x + stake_section_x;
    stake_right_x = rounded_top_r + label_section_x + stake_section_x;

    polyhedron(
        points = [
            [ stake_left_x, tag_y, tag_z ],
            [ stake_right_x, tag_y / 2, tag_z ],
            [ stake_left_x, 0, tag_z ],
            [ stake_left_x, tag_y, 0 ],
            [ stake_right_x, tag_y / 2, 0 ],
            [ stake_left_x, 0, 0 ]
            ],
        faces = [
            [ 0, 1, 2 ],
            [ 1, 0, 3, 4 ],
            [ 2, 1, 4, 5 ],
            [ 0, 2, 5, 3 ],
            [ 3, 5, 4 ],
            ]
        );

    if( render_mode == "preview" )
    {
        // top decoration
        translate([ 0, 0, -decoration_depth ])
            PlantTagDecoration( false );

        // bottom decoration
        translate([ 0, tag_y, tag_z + decoration_depth ])
            rotate([ 180, 0, 0 ])
                PlantTagDecoration( false );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlantTagDecoration( for_cutout )
{
    colorname = for_cutout ? undef : [ 0.2, 0, 0 ];

    // offset_x = rounded_top_r + svg_section_x;
    offset_x = rounded_top_r;

    first_line_y = tag_y * 0.6;
    second_line_y = tag_y - first_line_y;

    first_line_offset_y = tag_y - first_line_y;
    second_line_offset_y = 0;

    // first line
    if( !for_cutout )
    {
        # translate([ offset_x, first_line_offset_y, tag_z  ])
            cube([ label_section_x, first_line_y, 0 ]);
    }

    translate([ offset_x, first_line_offset_y + label_first_line_offset_y, tag_z  ])
        CenteredTextLabel(
            text_string = label_first_line,
            centered_in_area_x = label_section_x,
            centered_in_area_y = -1,
            depth = decoration_depth + DIFFERENCE_CLEARANCE,
            font_size = label_first_line_font_size,
            font = "Liberation Sans:style=bold",
            color = colorname
            );
    // TODO: text needs to specify depth

    // second line
    if( !for_cutout )
    {
        % translate([ offset_x, second_line_offset_y, tag_z  ])
            cube([ label_section_x, second_line_y, 0 ]);
    }
    translate([ offset_x, second_line_offset_y + label_second_line_offset_y, tag_z  ])
        CenteredTextLabel(
            text_string = label_second_line,
            centered_in_area_x = label_section_x,
            centered_in_area_y = -1,
            depth = decoration_depth + DIFFERENCE_CLEARANCE,
            font_size = label_second_line_font_size,
            font = "Liberation Sans:style=bold",
            color = colorname
            );
    // TODO: text needs to specify depth

    // svg
    // TODO: finish!

    color( colorname )
    {
        difference()
        {
            // outer
            translate([ rounded_top_r, rounded_top_r, tag_z ])
                scale([ rounded_top_scale_x, 1.0, 1.0 ])
                    cylinder(
                        r = rounded_top_r + DIFFERENCE_CLEARANCE,
                        h = decoration_depth + DIFFERENCE_CLEARANCE
                        );

            // cut out inside
            translate([ rounded_top_r, rounded_top_r, tag_z - DIFFERENCE_CLEARANCE ])
                scale([ rounded_top_scale_x, 1.0, 1.0 ])
                    cylinder(
                        r = rounded_top_r - outline_width,
                        h = outline_width + DIFFERENCE_CLEARANCE * 2
                        );

            // cut off right half
            translate([ rounded_top_r, 0, tag_z - DIFFERENCE_CLEARANCE ])
                cube([ rounded_top_r, tag_y, outline_width + DIFFERENCE_CLEARANCE * 2 ]);
        }

        // top outline
        translate([ rounded_top_r - DIFFERENCE_CLEARANCE, tag_y - outline_width, tag_z ])
            cube([
                label_section_x + DIFFERENCE_CLEARANCE * 2,
                outline_width + DIFFERENCE_CLEARANCE,
                decoration_depth + DIFFERENCE_CLEARANCE
                ]);

        // bottom outline
        translate([ rounded_top_r - DIFFERENCE_CLEARANCE, -DIFFERENCE_CLEARANCE, tag_z ])
            cube([
                label_section_x + DIFFERENCE_CLEARANCE * 2,
                outline_width + DIFFERENCE_CLEARANCE,
                decoration_depth + DIFFERENCE_CLEARANCE
                ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
