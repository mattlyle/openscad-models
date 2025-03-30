////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <rounded-cube.scad>
include <utils.scad>
include <screw-connectors.scad>

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function NetworkRackFaceWidthU( width_u ) = NETWORK_RACK_FACE_INSIDE_X / 4 * width_u;
function NetworkRackFaceWidthEar() = NETWORK_RACK_FACE_EAR_X;

function NetworkRackFaceOffsetX( left_ear ) = left_ear ? NETWORK_RACK_FACE_EAR_X : 0;

function NetworkRackFaceY() = NETWORK_RACK_FACE_FACE_Y;

function NetworkRackFaceZ() = NETWORK_RACK_FACE_1U_Z;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackFace1U(
    width_quarters,
    left_ear = false,
    right_ear = false,
    left_bracket = false,
    right_bracket = false )
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
                    r = NETWORK_RACK_FACE_FACE_Y / 2 - DIFFERENCE_CLEARANCE );

        // top ear hole
        hull()
        {
            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_top_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );
            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_X - NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_top_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );
        }

        // bottom ear hole
        hull()
        {
            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_bottom_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );

            translate([
                -NETWORK_RACK_FACE_EAR_X + NETWORK_RACK_FACE_EAR_HOLE_X - NETWORK_RACK_FACE_EAR_HOLE_OFFSET_X + NETWORK_RACK_FACE_EAR_HOLE_R,
                NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_bottom_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_FACE_EAR_HOLE_R,
                        h = NETWORK_RACK_FACE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );
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

    difference()
    {
        translate([ DIFFERENCE_CLEARANCE, 0, 0 ])
            cube([ bracket_x, bracket_y, bracket_z ]);

        if( is_left_side )
        {
            // top insert
            translate([ 0, bracket_y / 2, bracket_z / 3 * 2 ])
                rotate([ 0, 90, 0 ])
                    HeatedInsert( M3x6_INSERT );

            // bottom insert
            translate([ 0, bracket_y / 2, bracket_z / 3 ])
                rotate([ 0, 90, 0 ])
                    HeatedInsert( M3x6_INSERT );
        }
        else
        {
            // top insert
            translate([ 0, bracket_y / 2, bracket_z / 3 * 2 ])
                rotate([ 0, 90, 0 ])
                    ScrewShaft( M3x6_INSERT );

            // bottom insert
            translate([ 0, bracket_y / 2, bracket_z / 3 ])
                rotate([ 0, 90, 0 ])
                    ScrewShaft( M3x6_INSERT );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetoworkRackFaceLabel( text_lines, centered_in_area_x, text_depth = 0.4, color = [ 0, 0, 0 ] )
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
                font_size = 10,
                font = "Liberation Sans:style=bold",
                color = color );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
