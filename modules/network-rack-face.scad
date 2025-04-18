////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <rounded-cube.scad>
include <screw-connectors.scad>
include <text-label.scad>
include <svg.scad>
include <utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NETWORK_RACK_FACE_1U_Z = 44.8;
NETWORK_RACK_FACE_INSIDE_X = 430.0;
NETWORK_RACK_FACE_EAR_X = ( 482 - NETWORK_RACK_FACE_INSIDE_X ) / 2;

NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X = 4.0;
NETWORK_RACK_FACE_EAR_HOLE_X = 11.0;

NETWORK_RACK_FACE_EAR_HOLE_OFFSET_Z = 7.0;
NETWORK_RACK_FACE_EAR_HOLE_R = 3.0;

NETWORK_RACK_FACE_FACE_Y = 3.2;

NETWORK_RACK_FACE_BRACKET_X = M3x6_INSERT[ INSERT_LENGTH ];
NETWORK_RACK_FACE_BRACKET_Y = 16.0;

NETWORK_RACK_FACE_CAGE_WALL_WIDTH = 2.0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function NetworkRackFaceWidth( width_quarters ) = NETWORK_RACK_FACE_INSIDE_X / 4 * width_quarters;
function NetworkRackFaceWidthEar() = NETWORK_RACK_FACE_EAR_X;

function NetworkRackFaceOffsetX( left_ear ) = left_ear ? NETWORK_RACK_FACE_EAR_X : 0;

function NetworkRackFaceY() = NETWORK_RACK_FACE_FACE_Y;

function NetworkRackFaceZ() = NETWORK_RACK_FACE_1U_Z;

function NetworkRackFaceCageWidth() = NETWORK_RACK_FACE_CAGE_WALL_WIDTH;

function NetworkRackFaceCageX( object_x, part_fit_clearance ) =
    object_x
    + NETWORK_RACK_FACE_CAGE_WALL_WIDTH * 2
    + part_fit_clearance * 2;
function NetworkRackFaceCageY( object_y, part_fit_clearance ) =
    object_y
    + NETWORK_RACK_FACE_CAGE_WALL_WIDTH
    + part_fit_clearance * 2;
function NetworkRackFaceCageZ( object_z, part_fit_clearance ) =
    object_z
    + NETWORK_RACK_FACE_CAGE_WALL_WIDTH
    + part_fit_clearance * 2;

function NetworkRackFaceCageLeftX( object_offset_x, part_fit_clearance ) =
    object_offset_x
    - NETWORK_RACK_FACE_CAGE_WALL_WIDTH
    - part_fit_clearance;
function NetworkRackFaceCageRightX( object_x, object_offset_x, part_fit_clearance ) =
    NetworkRackFaceCageLeftX( object_offset_x, part_fit_clearance )
    + NetworkRackFaceCageX( object_x, part_fit_clearance )
    - NETWORK_RACK_FACE_CAGE_WALL_WIDTH;

function NetworkRackFaceCageFrontY( object_offset_y, part_fit_clearance ) =
    object_offset_y
    - part_fit_clearance;
function NetworkRackFaceCageBackY(object_offset_y, object_y, part_fit_clearance ) =
    object_offset_y
    + object_y
    + part_fit_clearance;

function NetworkRackFaceCageBottomZ( object_offset_z, part_fit_clearance ) =
    object_offset_z
    - NETWORK_RACK_FACE_CAGE_WALL_WIDTH
    - part_fit_clearance;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackHolder(
    width_quarters,
    cutout_x,
    cutout_z,
    cutout_offset_x,
    cutout_offset_z,
    object_x,
    object_y,
    object_z,
    object_offset_x,
    object_offset_y,
    object_offset_z,
    part_fit_clearance = 0.1,
    left_ear = false,
    right_ear = false,
    left_bracket = false,
    right_bracket = false,
    include_cage = false,
    cage_finger_hole = false
    )
{
    // face
    difference()
    {
        NetworkRackFace1U( width_quarters, left_ear, right_ear, left_bracket, right_bracket );

        // cut out the front where the object show
        translate([ cutout_offset_x, -DIFFERENCE_CLEARANCE, cutout_offset_z ])
            cube([ cutout_x, NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2, cutout_z ]);
        // TODO: should be rounded!

        // cut out more of the front so it fits more snug
        translate([ -part_fit_clearance, 0, -part_fit_clearance ])
            translate([ object_offset_x, object_offset_y, object_offset_z ])
                cube([
                    object_x + part_fit_clearance * 2,
                    object_y,
                    object_z + part_fit_clearance * 2
                    ]);
    }

    if( include_cage )
    {
        // cage
        NetworkRackFaceCage(
            object_x,
            object_y,
            object_z,
            object_offset_x,
            object_offset_y,
            object_offset_z,
            part_fit_clearance,
            cage_finger_hole
            );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackFaceCage(
    object_x,
    object_y,
    object_z,
    object_offset_x,
    object_offset_y,
    object_offset_z,
    part_fit_clearance = 0.1,
    include_finger_hole = false
    )
{
    cage_x = NetworkRackFaceCageX( object_x, part_fit_clearance );
    cage_y = NetworkRackFaceCageY( object_y, part_fit_clearance );
    cage_z = NetworkRackFaceCageZ( object_z, part_fit_clearance );

    cage_left_x = NetworkRackFaceCageLeftX( object_offset_x, part_fit_clearance );
    cage_right_x = NetworkRackFaceCageRightX( object_x, object_offset_x, part_fit_clearance );

    cage_front_y = NetworkRackFaceCageFrontY( object_offset_y, part_fit_clearance );
    cage_back_y = NetworkRackFaceCageBackY( object_offset_y, object_y, part_fit_clearance );

    cage_bottom_z = NetworkRackFaceCageBottomZ( object_offset_z, part_fit_clearance );

    // cage bottom
    translate([ cage_left_x, cage_front_y, cage_bottom_z ])
        cube([ cage_x, cage_y, NETWORK_RACK_FACE_CAGE_WALL_WIDTH ]);

    // cage left side
    translate([ cage_left_x, cage_front_y, cage_bottom_z ])
        cube([ NETWORK_RACK_FACE_CAGE_WALL_WIDTH, cage_y, cage_z ]);

    // cage right side
    translate([ cage_right_x, cage_front_y, cage_bottom_z ])
        cube([ NETWORK_RACK_FACE_CAGE_WALL_WIDTH, cage_y, cage_z ]);

    // cage back/bottom
    difference()
    {
        translate([ cage_left_x, cage_back_y, cage_bottom_z ])
            cube([ cage_x, NETWORK_RACK_FACE_CAGE_WALL_WIDTH, cage_z ]);

        // remove the finger hole
        if( include_finger_hole )
        {
            translate([
                cage_left_x + cage_x / 2,
                cage_back_y - DIFFERENCE_CLEARANCE,
                cage_bottom_z + cage_z
                ])
                rotate([ -90, 0, 0 ])
                    cylinder(
                        r = finger_hole_r,
                        h = NetworkRackFaceCageWidth() + DIFFERENCE_CLEARANCE * 2
                        );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackFace1U(
    width_quarters,
    left_ear = false,
    right_ear = false,
    left_bracket = false,
    right_bracket = false
    )
{
    x = NETWORK_RACK_FACE_INSIDE_X / 4 * width_quarters;

    // face
    cube([ x, NETWORK_RACK_FACE_FACE_Y, NETWORK_RACK_FACE_1U_Z ]);

    // left ear
    if( left_ear )
    {
        _NetworkRackFaceEar1U();
    }

    // right ear
    if( right_ear )
    {
        translate([ x, 0, NETWORK_RACK_FACE_1U_Z ])
            rotate([ 0, 180, 0 ])
                _NetworkRackFaceEar1U();
    }

    // left bracket
    if( left_bracket )
    {
        translate([ 0, NETWORK_RACK_FACE_FACE_Y, 0 ])
            _NetworkRackFaceBracket( true );
    }

    // right bracket
    if( right_bracket )
    {
        translate([ x - NETWORK_RACK_FACE_BRACKET_X, NETWORK_RACK_FACE_FACE_Y, 0 ])
            _NetworkRackFaceBracket( false );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _NetworkRackFaceEar1U()
{
    ear_hole_top_z = NETWORK_RACK_FACE_1U_Z - NETWORK_RACK_FACE_EAR_HOLE_OFFSET_Z;
    ear_hole_bottom_z = NETWORK_RACK_FACE_EAR_HOLE_OFFSET_Z;

    difference()
    {
        translate([ -NETWORK_RACK_FACE_EAR_X, NETWORK_RACK_FACE_FACE_Y, 0 ])
            rotate([ 90, 0, 0 ])
                RoundedCubeAlt2(
                    x = NETWORK_RACK_FACE_EAR_X,
                    y = NETWORK_RACK_FACE_1U_Z,
                    z = NETWORK_RACK_FACE_FACE_Y,
                    round_top = false,
                    round_bottom = false,
                    round_left = true,
                    round_right = false,
                    r = NETWORK_RACK_FACE_FACE_Y / 2 - DIFFERENCE_CLEARANCE
                    );

        // top ear hole
        hull()
        {
            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_top_z
                ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2
                        );
            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_X - NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_top_z
                ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2
                        );
        }

        // bottom ear hole
        hull()
        {
            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_bottom_z
                ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2
                        );

            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_X - NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_bottom_z
                ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2
                        );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _NetworkRackFaceBracket( is_left_side )
{
    r = M3x6_INSERT[ is_left_side ? INSERT_OUTER_DIAMETER : INSERT_SCREW_DIAMETER ] / 2;

    bracket_x = NETWORK_RACK_FACE_BRACKET_X - DIFFERENCE_CLEARANCE * 2;
    bracket_y = NETWORK_RACK_FACE_BRACKET_Y;
    bracket_z = NETWORK_RACK_FACE_1U_Z;

    insert_top_z = bracket_z * 0.85;
    insert_bottom_z = bracket_z * 0.15;

    // left side = insert side
    // right side = screw side

    difference()
    {
        translate([ DIFFERENCE_CLEARANCE, 0, 0 ])
            cube([ bracket_x, bracket_y, bracket_z ]);

        if( is_left_side )
        {
            // top insert
            translate([ 0, bracket_y / 2, insert_top_z ])
                rotate([ 0, 90, 0 ])
                    ScrewShaft( M3x6_INSERT );

            // bottom insert
            translate([ 0, bracket_y / 2, insert_bottom_z ])
                rotate([ 0, 90, 0 ])
                    ScrewShaft( M3x6_INSERT );
        }
        else
        {
            // top insert
            translate([ 0, bracket_y / 2, insert_top_z ])
                rotate([ 0, 90, 0 ])
                    HeatedInsert( M3x6_INSERT );

            // bottom insert
            translate([ 0, bracket_y / 2, insert_bottom_z ])
                rotate([ 0, 90, 0 ])
                    HeatedInsert( M3x6_INSERT );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackFaceLabel(
    text_lines,
    centered_in_area_x,
    text_depth = 0.4,
    color = [ 0, 0, 0 ]
    )
{
    translate([ 0, text_depth, 0 ])
    {
        rotate([ 90, 0, 0 ])
        {
            MultilineTextLabel(
                text_lines = text_lines,
                centered_in_area_x = centered_in_area_x,
                centered_in_area_y = NetworkRackFaceZ(),
                depth = text_depth + DIFFERENCE_CLEARANCE,
                font_size = 11,
                font = "Liberation Sans:style=bold",
                color = color
                );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackFaceSVG(
    svg_path,
    offset_x,
    offset_z,
    depth = 0.4,
    scale_xy = 1,
    rotate_degrees = 0,
    )
{
    translate([
        offset_x,
        depth - DIFFERENCE_CLEARANCE,
        offset_z
        ])
        rotate([ 90, rotate_degrees, 0 ])
            scale([ scale_xy, scale_xy, 1 ])
                SVG( svg_path, depth );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
