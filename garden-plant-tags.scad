////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/text-label.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-body";
// render_mode = "print-text";

label_first_line = "Sunflower";
label_second_line = "Tiger Eye Hybrid";
svg_file = "plant.svg";

label_section_x = 120;
stake_section_x = 50;
tag_y = 25;
tag_z = 10;

label_first_line_font_size = 12;
label_second_line_font_size = 6;

// TODO: rounded corners

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

rounded_top_r = tag_y / 2;
svg_section_x = tag_y;

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
    // top
    PlantTagDecoration();

    // bottom
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlantTag()
{
    // label section
    union()
    {
        // tounded top
        translate([ rounded_top_r, rounded_top_r, 0 ])
            cylinder(
                r = rounded_top_r,
                h = tag_z
            );

        // main body
        translate([ rounded_top_r, 0, 0 ])
            cube([ svg_section_x + label_section_x, tag_y, tag_z ]);
    }

    // stake section
    stake_left_x = rounded_top_r + svg_section_x + label_section_x;
    stake_right_x = rounded_top_r + svg_section_x + label_section_x + stake_section_x;
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

    // labels and svg
    PlantTagDecoration();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlantTagDecoration()
{
    offset_x = rounded_top_r + svg_section_x;

    first_line_y = tag_y * 0.6;
    second_line_y = tag_y - first_line_y;

    first_line_offset_y = tag_y - first_line_y;
    second_line_offset_y = 0;

    // first line
    # translate([ offset_x, first_line_offset_y, tag_z+0.1  ])
        cube([ label_section_x, first_line_y, 0.1 ]);

    translate([ offset_x, first_line_offset_y, tag_z+0.1  ])
        CenteredTextLabel(
            text_string = label_first_line,
            centered_in_area_x = label_section_x,
            centered_in_area_y = first_line_y,
            font_size = label_first_line_font_size,
            font = "Liberation Sans:style=bold"
            );

    // second line
    % translate([ offset_x, second_line_offset_y, tag_z+0.1  ])
        cube([ label_section_x, second_line_y, 0.1 ]);
    translate([ offset_x, second_line_offset_y, tag_z+0.1  ])
        CenteredTextLabel(
            text_string = label_second_line,
            centered_in_area_x = label_section_x,
            centered_in_area_y = second_line_y,
            font_size = label_second_line_font_size,
            font = "Liberation Sans:style=bold"
            );

    // svg
    // TODO: finish!

    // outline
    // TODO: finish!
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
