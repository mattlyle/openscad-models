include <modules/utils.scad>
include <modules/rounded-cube.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

co2_tank_r = 135 / 2;
n2_tank_r = 150 / 2;
keg_r = 220 / 2;

load_cell_xy = 34.1;
load_cell_z = 8.7;
load_cell_wire_cutout_x = 4;

weight_module_x = 34.2;
weight_module_y = 21.3;
weight_module_z = 3.2;

esp32_x = 28.3;
esp32_y = 51.5;
esp32_z = 12.6;

cord_r = 3.6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print-keg-base";
// render_mode = "print-keg-top";
// render_mode = "print-co2-base";
// render_mode = "print-co2-top";
// render_mode = "print-n2-base";
// render_mode = "print-n2-top";

scale_extra_r = 5;

base_lid_z = 3;
// top_lid_z = 3;

wall_width = 2;

// base_struts_width = 2;
// base_struts_z = 4;
// num_base_struts = 2;

// top_struts_width = 2;
// top_struts_z = 4;
// num_top_struts = 2;

load_cell_clearance = 0.2;
load_cell_wall_width = 2.0;
load_cell_wall_z = 5.0;
load_cell_offset_y = 5;

weight_module_clearance = 0.2;
weight_module_wall_width = 2.0;
weight_module_wall_z = 5.0;
weight_module_corner_length = 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

base_z = base_lid_z + load_cell_z;

weight_module_holder_x =
    weight_module_x
    + weight_module_wall_width * 2
    + weight_module_clearance * 2;
weight_module_holder_y =
    weight_module_y
    + weight_module_wall_width * 2
    + weight_module_clearance * 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    ScaleBase( keg_r );

    translate([ 250, 0, 0 ])
        ScaleBase( keg_r );

    translate([ 500, 0, 0 ])
        ScaleTop( keg_r );
}
else if( render_mode == "print-keg-base" )
{
    ScaleBase( keg_r );
}
else if( render_mode == "print-keg-top" )
{
    ScaleTop( keg_r );
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleBase( scale_r )
{
    difference()
    {
        // full base
        cylinder(
            r = scale_r + scale_extra_r + wall_width,
            h = base_z
            );
        
        // cut out the inside
        translate([ 0, 0, base_lid_z ])
            cylinder(
                r = scale_r + scale_extra_r,
                h = base_z
                );

        // cut out the cord
        translate([
            -cord_r / 2,
            -scale_r - scale_extra_r - wall_width,
            base_lid_z
            ])
            cube([
                cord_r,
                wall_width * 2,
                base_z - base_lid_z + DIFFERENCE_CLEARANCE
                ]);
    }


    // add back the load cell holders
    for( i = [ 45, 135, 225, 315 ])
    {
        rotate([ 0, 0, i ])
            translate([
                -load_cell_xy / 2,
                scale_r
                    + scale_extra_r
                    - load_cell_xy
                    - load_cell_wall_width * 2
                    - load_cell_clearance * 2
                    - load_cell_offset_y,
                base_lid_z - DIFFERENCE_CLEARANCE
                ])
                _LoadCellHolder();
    }

    // add back the ESP32 holder
    // TODO: finish!

    // add back the weight module holder, dead center
    translate([
        -weight_module_holder_x / 2,
        -weight_module_holder_y / 2,
        base_lid_z - DIFFERENCE_CLEARANCE
        ])
        _WeightModuleHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScaleTop( scale_r )
{
    // TODO: finish!
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _LoadCellHolder()
{
    difference()
    {
        cube([
            load_cell_xy + load_cell_wall_width * 2,
            load_cell_xy + load_cell_wall_width * 2,
            load_cell_wall_z
            ]);

        translate([
            load_cell_wall_width,
            load_cell_wall_width,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                load_cell_xy,
                load_cell_xy,
                load_cell_wall_z + DIFFERENCE_CLEARANCE * 2
                ]);

        // cut out the wires
        translate([
            ( load_cell_xy + load_cell_wall_width * 2 - load_cell_wire_cutout_x ) / 2,
            -DIFFERENCE_CLEARANCE,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                load_cell_wire_cutout_x,
                load_cell_wall_width + DIFFERENCE_CLEARANCE * 2,
                load_cell_wall_z + DIFFERENCE_CLEARANCE * 2
                ]);
    }

    // TODO: should add clips to keep the load cell in place

    if( render_mode == "preview" )
    {
        %translate([
            load_cell_wall_width + load_cell_clearance,
            load_cell_wall_width + load_cell_clearance,
            0
            ])
            RoundedCube(
                load_cell_xy,
                load_cell_xy,
                load_cell_z,
                8,
                round_top = false,
                round_bottom = false
            );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _WeightModuleHolder()
{
    cavity_x = weight_module_x + weight_module_clearance * 2;
    cavity_y = weight_module_y + weight_module_clearance * 2;

    difference()
    {
        cube([
            weight_module_holder_x,
            weight_module_holder_y,
            weight_module_wall_z
            ]);

        translate([
            weight_module_wall_width,
            weight_module_wall_width,
            -DIFFERENCE_CLEARANCE
            ])
            cube([
                cavity_x,
                cavity_y,
                weight_module_wall_z + DIFFERENCE_CLEARANCE * 2
                ]);

        // cut out the left and right walls, leaving only the corners
        for( x = [
            -DIFFERENCE_CLEARANCE,
            weight_module_holder_x - weight_module_wall_width - DIFFERENCE_CLEARANCE
            ] )
            translate([
                x,
                weight_module_wall_width + weight_module_corner_length,
                -DIFFERENCE_CLEARANCE
                ])
                cube([
                    weight_module_wall_width + DIFFERENCE_CLEARANCE * 2,
                    cavity_y - weight_module_corner_length * 2,
                    weight_module_wall_z + DIFFERENCE_CLEARANCE * 2
                    ]);
    }

    if( render_mode == "preview" )
    {
        %translate([
            weight_module_wall_width + weight_module_clearance,
            weight_module_wall_width + weight_module_clearance,
            0
            ])
            cube([ weight_module_x, weight_module_y, weight_module_z ]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _ESP32Holder()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
