include <modules/utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// measurements

recycling_can_hinge_pin_section1_z = 29;
recycling_can_hinge_pin_gap12_z = 5;
recycling_can_hinge_pin_section2_z = 36;

recycling_can_hinge_pin_section1_r = 23.0 / 2;
recycling_can_hinge_pin_section2_r = 21.6 / 2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// settings

render_mode = "preview";
// render_mode = "print";

recycling_can_hinge_pin_base_extra_r = 6.0;
recycling_can_hinge_pin_base_z = 3.0;

recycling_can_hinge_pin_extra_z = 40.0;

// spring latch: tongues cut into the section 1 wall flex inward through the outer lug hole, then
// the barbs spring out in the gap and catch on the inside face of the lug
recycling_can_hinge_pin_latch_count = 2;
recycling_can_hinge_pin_latch_wall = 2.5;
recycling_can_hinge_pin_latch_width = 10.0;
recycling_can_hinge_pin_latch_slot = 1.5;
recycling_can_hinge_pin_latch_slit = 1.5;
recycling_can_hinge_pin_latch_anchor_z = 5.0;
recycling_can_hinge_pin_latch_barb_h = 2.0;
recycling_can_hinge_pin_latch_barb_z = 3.0;
recycling_can_hinge_pin_latch_barb_offset_z = 0.5;
recycling_can_hinge_pin_latch_cut_extra_x = 1.0;
recycling_can_hinge_pin_latch_cut_extra_z = 0.1;
recycling_can_hinge_pin_latch_flex_clearance = 1.0;
recycling_can_hinge_pin_latch_slot_start_extra_x = 0.1;

// preview-only mock-up of the bin hinge, a rough guess at the real geometry
recycling_can_hinge_mockup_wall_r = 6.0;
recycling_can_hinge_mockup_inner_lug_z = 10.0;
recycling_can_hinge_mockup_alpha = 0.35;
recycling_can_hinge_mockup_cut_extra_z = 0.1;
recycling_can_hinge_mockup_bin_color = "royalblue";
recycling_can_hinge_mockup_lid_color = "dimgray";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculations

$fn = $preview ? 32 : 128;

recycling_can_hinge_pin_section1_top_z = recycling_can_hinge_pin_base_z
    + recycling_can_hinge_pin_section1_z;
recycling_can_hinge_pin_gap_top_z = recycling_can_hinge_pin_section1_top_z
    + recycling_can_hinge_pin_gap12_z;
recycling_can_hinge_pin_latch_anchor_abs_z = recycling_can_hinge_pin_base_z
    + recycling_can_hinge_pin_latch_anchor_z;
recycling_can_hinge_pin_latch_barb_base_z = recycling_can_hinge_pin_section1_top_z
    + recycling_can_hinge_pin_latch_barb_offset_z;
recycling_can_hinge_pin_latch_bore_r = recycling_can_hinge_pin_section1_r
    - recycling_can_hinge_pin_latch_wall;
recycling_can_hinge_pin_latch_barb_r = recycling_can_hinge_pin_section1_r
    + recycling_can_hinge_pin_latch_barb_h;

// solid core between the two pockets; the pockets only need to be as deep as the barbs flex
recycling_can_hinge_pin_latch_core_x = recycling_can_hinge_pin_latch_bore_r
    - recycling_can_hinge_pin_latch_barb_h
    - recycling_can_hinge_pin_latch_flex_clearance;
recycling_can_hinge_pin_latch_slot_start_x = recycling_can_hinge_pin_latch_core_x
    + recycling_can_hinge_pin_latch_slot_start_extra_x;
recycling_can_hinge_pin_latch_pocket_half_y = recycling_can_hinge_pin_latch_width / 2
    + recycling_can_hinge_pin_latch_slot / 4;
recycling_can_hinge_pin_latch_slit_half_y = recycling_can_hinge_pin_latch_width / 2
    + recycling_can_hinge_pin_latch_slot / 2;
recycling_can_hinge_pin_latch_barb_half_y = recycling_can_hinge_pin_latch_width / 2
    + recycling_can_hinge_pin_latch_slot * 3 / 4;

assert(
    recycling_can_hinge_pin_latch_slot_start_x > 0
        && recycling_can_hinge_pin_latch_slot_start_x <= sqrt(
            pow( recycling_can_hinge_pin_latch_bore_r, 2 )
                - pow( recycling_can_hinge_pin_latch_width / 2
                    + recycling_can_hinge_pin_latch_slot, 2 )
            ),
    "latch pocket is too shallow or too deep to leave the slots cutting clean through the wall"
    );

assert(
    recycling_can_hinge_pin_latch_barb_offset_z + recycling_can_hinge_pin_latch_barb_z
        + recycling_can_hinge_pin_latch_slit <= recycling_can_hinge_pin_gap12_z,
    "latch barb and slit don't fit in the section 1-2 gap"
    );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// models

if( render_mode == "preview" )
{
    RecyclingCanHingePin();

    RecyclingCanHingeMockup();
}
else if( render_mode == "print" )
{
    RecyclingCanHingePin();
}
else
{
    assert( false, str( "Unknown render mode: ", render_mode ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecyclingCanHingePin()
{
    // barbs go in before the cuts so the slots trim them flush with the tongue
    difference()
    {
        union()
        {
            RecyclingCanHingePinBody();

            RecyclingCanHingePinLatchBarbs();
        }

        RecyclingCanHingePinLatchCuts();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecyclingCanHingePinBody()
{
    // base
    cylinder(
        r = recycling_can_hinge_pin_section1_r + recycling_can_hinge_pin_base_extra_r,
        h = recycling_can_hinge_pin_base_z
        );

    // main pin section 1
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
        ])
        cylinder(
            r = recycling_can_hinge_pin_section1_r,
            h = recycling_can_hinge_pin_section1_z
            );

    // main pin section 1-2 gap
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
            + recycling_can_hinge_pin_section1_z
        ])
        cylinder(
            r1 = recycling_can_hinge_pin_section1_r,
            r2 = recycling_can_hinge_pin_section2_r,
            h = recycling_can_hinge_pin_gap12_z
            );

    // main pin section 2
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
            + recycling_can_hinge_pin_section1_z
            + recycling_can_hinge_pin_gap12_z
        ])
        cylinder(
            r = recycling_can_hinge_pin_section2_r,
            h = recycling_can_hinge_pin_section2_z
            );

    // extra section beyond 2
    translate([
        0,
        0,
        recycling_can_hinge_pin_base_z
            + recycling_can_hinge_pin_section1_z
            + recycling_can_hinge_pin_gap12_z
            + recycling_can_hinge_pin_section2_z
        ])
        cylinder(
            r = recycling_can_hinge_pin_section2_r,
            h = recycling_can_hinge_pin_extra_z
            );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecyclingCanHingeMockup()
{
    // outer bin lug, section 1 diameter
    color( recycling_can_hinge_mockup_bin_color, recycling_can_hinge_mockup_alpha )
        translate([
            0,
            0,
            recycling_can_hinge_pin_base_z
            ])
            RecyclingCanHingeMockupTube(
                hole_r = recycling_can_hinge_pin_section1_r,
                z = recycling_can_hinge_pin_section1_z
                );

    // lid hinge barrel, section 2 diameter
    color( recycling_can_hinge_mockup_lid_color, recycling_can_hinge_mockup_alpha )
        translate([
            0,
            0,
            recycling_can_hinge_pin_base_z
                + recycling_can_hinge_pin_section1_z
                + recycling_can_hinge_pin_gap12_z
            ])
            RecyclingCanHingeMockupTube(
                hole_r = recycling_can_hinge_pin_section2_r,
                z = recycling_can_hinge_pin_section2_z
                );

    // inner bin lug, same hole as section 2
    color( recycling_can_hinge_mockup_bin_color, recycling_can_hinge_mockup_alpha )
        translate([
            0,
            0,
            recycling_can_hinge_pin_base_z
                + recycling_can_hinge_pin_section1_z
                + recycling_can_hinge_pin_gap12_z
                + recycling_can_hinge_pin_section2_z
            ])
            RecyclingCanHingeMockupTube(
                hole_r = recycling_can_hinge_pin_section2_r,
                z = recycling_can_hinge_mockup_inner_lug_z
                );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecyclingCanHingeMockupTube( hole_r, z )
{
    difference()
    {
        cylinder(
            r = hole_r + recycling_can_hinge_mockup_wall_r,
            h = z
            );

        translate([
            0,
            0,
            -recycling_can_hinge_mockup_cut_extra_z
            ])
            cylinder(
                r = hole_r,
                h = z + 2 * recycling_can_hinge_mockup_cut_extra_z
                );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecyclingCanHingePinLatchCuts()
{
    for( latch_index = [ 0 : recycling_can_hinge_pin_latch_count - 1 ] )
    {
        rotate([
            0,
            0,
            latch_index * 360 / recycling_can_hinge_pin_latch_count
            ])
        {
            // pocket behind the tongue for it to flex into; the cone ceiling prints without
            // bridging, and the slab leaves the solid core in the middle of the pin
            intersection()
            {
                rotate_extrude()
                    polygon([
                        [
                            0,
                            recycling_can_hinge_pin_latch_anchor_abs_z
                                - recycling_can_hinge_pin_latch_cut_extra_z
                        ],
                        [
                            recycling_can_hinge_pin_latch_bore_r,
                            recycling_can_hinge_pin_latch_anchor_abs_z
                                - recycling_can_hinge_pin_latch_cut_extra_z
                        ],
                        [
                            recycling_can_hinge_pin_latch_bore_r,
                            recycling_can_hinge_pin_gap_top_z
                        ],
                        [
                            0,
                            recycling_can_hinge_pin_gap_top_z
                                + recycling_can_hinge_pin_latch_bore_r
                        ]
                        ]);

                translate([
                    recycling_can_hinge_pin_latch_core_x,
                    -recycling_can_hinge_pin_latch_pocket_half_y,
                    recycling_can_hinge_pin_latch_anchor_abs_z
                        - 2 * recycling_can_hinge_pin_latch_cut_extra_z
                    ])
                    cube([
                        recycling_can_hinge_pin_latch_barb_r
                            + recycling_can_hinge_pin_latch_cut_extra_x,
                        2 * recycling_can_hinge_pin_latch_pocket_half_y,
                        recycling_can_hinge_pin_gap_top_z
                            + recycling_can_hinge_pin_latch_bore_r
                    ]);
            }

            // slots down both sides of the tongue, ending halfway into the slit
            for( side = [ -1, 1 ] )
            {
                translate([
                    recycling_can_hinge_pin_latch_slot_start_x,
                    side * ( recycling_can_hinge_pin_latch_width
                        + recycling_can_hinge_pin_latch_slot ) / 2
                        - recycling_can_hinge_pin_latch_slot / 2,
                    recycling_can_hinge_pin_latch_anchor_abs_z
                    ])
                    cube([
                        recycling_can_hinge_pin_latch_barb_r
                            + recycling_can_hinge_pin_latch_cut_extra_x
                            - recycling_can_hinge_pin_latch_slot_start_x,
                        recycling_can_hinge_pin_latch_slot,
                        recycling_can_hinge_pin_gap_top_z
                            - recycling_can_hinge_pin_latch_slit / 2
                            - recycling_can_hinge_pin_latch_anchor_abs_z
                        ]);
            }

            // slit across the top frees the tongue end from the solid pin above it, reaching the
            // middle of each slot
            translate([
                recycling_can_hinge_pin_latch_slot_start_x,
                -recycling_can_hinge_pin_latch_slit_half_y,
                recycling_can_hinge_pin_gap_top_z
                    - recycling_can_hinge_pin_latch_slit
                ])
                cube([
                    recycling_can_hinge_pin_latch_barb_r
                        + recycling_can_hinge_pin_latch_cut_extra_x
                        - recycling_can_hinge_pin_latch_slot_start_x,
                    2 * recycling_can_hinge_pin_latch_slit_half_y,
                    recycling_can_hinge_pin_latch_slit
                    ]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecyclingCanHingePinLatchBarbs()
{
    for( latch_index = [ 0 : recycling_can_hinge_pin_latch_count - 1 ] )
    {
        rotate([
            0,
            0,
            latch_index * 360 / recycling_can_hinge_pin_latch_count
            ])
            intersection()
            {
                // wedge: flat shoulder facing the head, ramp toward the tip; it is wider than the
                // tongue and taller than the barb so the slots and slit trim its sides and top
                rotate([ 90, 0, 0 ])
                    linear_extrude(
                        height = 2 * recycling_can_hinge_pin_latch_barb_half_y,
                        center = true
                        )
                        polygon([
                            [
                                recycling_can_hinge_pin_latch_bore_r
                                    + recycling_can_hinge_pin_latch_wall / 2,
                                recycling_can_hinge_pin_latch_barb_base_z
                            ],
                            [
                                recycling_can_hinge_pin_latch_barb_r,
                                recycling_can_hinge_pin_latch_barb_base_z
                            ],
                            [
                                recycling_can_hinge_pin_section2_r,
                                recycling_can_hinge_pin_latch_barb_base_z
                                    + recycling_can_hinge_pin_latch_barb_z
                            ],
                            [
                                recycling_can_hinge_pin_section2_r,
                                recycling_can_hinge_pin_latch_barb_base_z
                                    + recycling_can_hinge_pin_latch_barb_z
                                    + recycling_can_hinge_pin_latch_cut_extra_z
                            ],
                            [
                                recycling_can_hinge_pin_latch_bore_r
                                    + recycling_can_hinge_pin_latch_wall / 2,
                                recycling_can_hinge_pin_latch_barb_base_z
                                    + recycling_can_hinge_pin_latch_barb_z
                                    + recycling_can_hinge_pin_latch_cut_extra_z
                            ]
                            ]);

                // round the barb off to the pin's circle instead of a flat-sided prism
                translate([
                    0,
                    0,
                    recycling_can_hinge_pin_latch_barb_base_z
                        - recycling_can_hinge_pin_latch_cut_extra_z
                    ])
                    cylinder(
                        r = recycling_can_hinge_pin_latch_barb_r,
                        h = recycling_can_hinge_pin_latch_barb_z
                            + 2 * recycling_can_hinge_pin_latch_cut_extra_z
                        );
            }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
