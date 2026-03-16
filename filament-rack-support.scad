////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/utils.scad>
include <modules/pie-slice-prism.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

dowel_r = 22.3 / 2;

filament_spool_r = 200 / 2;
filament_spool_x = 68;

screw_r = 3;

// TODO able to mount a label

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-holder";

bracket_x = 20;
dowel_spacing_y = 135;

bracket_dowel_gripper_r = 3;

dowel_gripper_angle_cutout = 135;

// distance from the back dowel center to the wall
bracket_offset_y = 50;

// distance from the dowel center point to where the bracket meets the wall (screw hole is still below)
bracket_bottom_z = 80;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 64 : 256;

// TODO figure out how to actually calculate these?!?!
filament_spool_offset_z = 88.32;

dowel_gripper_angle = atan2( filament_spool_offset_z, dowel_spacing_y / 2 );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    DowelPreview();

    translate([ 0, dowel_spacing_y, 0 ])
        DowelPreview();

    translate([ 0, dowel_spacing_y / 2, filament_spool_offset_z ])
        FilamentSpoolPreview();

    translate([ -bracket_x, 0, 0 ])
        FilamentSpoolBracket();
}
else if( render_mode == "print-holder" )
{
    // TODO implement print-holder mode
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DowelPreview()
{
    % rotate([ 0, 90, 0 ])
        cylinder( r = dowel_r, h = 1000 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FilamentSpoolPreview()
{
    % rotate([ 0, 90, 0 ])
        cylinder( r = filament_spool_r, h = filament_spool_x );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FilamentSpoolBracket()
{
    gripper_outer_r = dowel_r + bracket_dowel_gripper_r;

    span_angle = 2 * ( 90 - dowel_gripper_angle );

    difference()
    {
        union()
        {
            // near gripper
            rotate([ 0, 90, 0 ])
            {
                difference()
                {
                    // outer cylinder
                    cylinder( r = gripper_outer_r, h = bracket_x );

                    // cut out the area to let the filamet slide past
                    rotate([
                        -DIFFERENCE_CLEARANCE,
                        0,
                        90 + dowel_gripper_angle - dowel_gripper_angle_cutout / 2
                        ])
                        PieSlicePrism(
                            width = gripper_outer_r * 2, // doubled just to make sure the cut out doesn't clip
                            height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                            angle = dowel_gripper_angle_cutout
                            );
                }
            }

            // back gripper
            translate([ 0, dowel_spacing_y, 0 ])
            {
                rotate([ 0, 90, 0 ])
                {
                    difference()
                    {
                        // outer cylinder
                        cylinder( r = gripper_outer_r, h = bracket_x );

                        // cut out the area to let the filamet slide past
                        rotate([
                            -DIFFERENCE_CLEARANCE,
                            0,
                            -90 - dowel_gripper_angle - dowel_gripper_angle_cutout / 2
                            ])
                            PieSlicePrism(
                                width = gripper_outer_r * 2, // doubled just to make sure the cut out doesn't clip
                                height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                                angle = dowel_gripper_angle_cutout
                                );
                    }
                }
            }

            // span top
            difference()
            {
                translate([ 0, dowel_spacing_y / 2, filament_spool_offset_z ])
                    rotate([ -90 + dowel_gripper_angle, 0, 0 ])
                        rotate([ 0, 90, 0 ])
                            PieSlicePrism(
                                width = filament_spool_r + dowel_r + bracket_dowel_gripper_r,
                                height = bracket_x,
                                angle = span_angle
                                );

                translate([ -DIFFERENCE_CLEARANCE, dowel_spacing_y / 2, filament_spool_offset_z + DIFFERENCE_CLEARANCE ])
                    rotate([ -90 + dowel_gripper_angle - DIFFERENCE_CLEARANCE, 0, 0 ])
                        rotate([ 0, 90, 0 ])
                            PieSlicePrism(
                                width = filament_spool_r + dowel_r,
                                height = bracket_x + DIFFERENCE_CLEARANCE * 2,
                                angle = span_angle + DIFFERENCE_CLEARANCE * 2
                                );
            }
        }

        // cut out the dowel
        rotate([ 0, 90, 0 ])
            difference()
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder( r = dowel_r, h = bracket_x + DIFFERENCE_CLEARANCE * 2);

        // cut out the dowel
        translate([ 0, dowel_spacing_y, 0 ])
            rotate([ 0, 90, 0 ])
                translate([ 0, 0, -DIFFERENCE_CLEARANCE ])
                    cylinder( r = dowel_r, h = bracket_x + DIFFERENCE_CLEARANCE * 2);

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
