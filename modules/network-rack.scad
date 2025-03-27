////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <utils.scad>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NETWORK_RACK_MODULE_1U_Z = 44.8;
NETWORK_RACK_MODULE_INSIDE_X = 430.0;
NETWORK_RACK_MODULE_EAR_X = ( 482 - NETWORK_RACK_MODULE_INSIDE_X ) / 2;

NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_X = 4.0;
NETWORK_RACK_MODULE_EAR_HOLE_X = 11.0;

NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_Z = 7.0;
NETWORK_RACK_MODULE_EAR_HOLE_R = 3.0;

NETWORK_RACK_MODULE_FACE_Y = 3.2;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackModule1U( width_quarters, left_ear = false, right_ear = false )
{
    x = NETWORK_RACK_MODULE_INSIDE_X / 4 * width_quarters;

    // face
    cube([ x, NETWORK_RACK_MODULE_FACE_Y, NETWORK_RACK_MODULE_1U_Z ]);

    // left ear
    if( left_ear )
    {
        NetworkRackModule1UEar();
    }

    // right ear
    if( right_ear )
    {
        translate([ x, 0, NETWORK_RACK_MODULE_1U_Z ])
            rotate([ 0, 180, 0 ])
                NetworkRackModule1UEar();
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NetworkRackModule1UEar()
{
    ear_hole_top_z = NETWORK_RACK_MODULE_1U_Z - NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_Z;
    ear_hole_bottom_z = NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_Z;

    // TODO: round?
    difference()
    {
        translate([ -NETWORK_RACK_MODULE_EAR_X, 0, 0 ])
            cube([ NETWORK_RACK_MODULE_EAR_X, NETWORK_RACK_MODULE_FACE_Y, NETWORK_RACK_MODULE_1U_Z ]);

        // top ear hole
        hull()
        {
            translate([
                -NETWORK_RACK_MODULE_EAR_X + NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_X + NETWORK_RACK_MODULE_EAR_HOLE_R,
                NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_top_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_MODULE_EAR_HOLE_R,
                        h = NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );
            translate([
                -NETWORK_RACK_MODULE_EAR_X + NETWORK_RACK_MODULE_EAR_HOLE_X - NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_X + NETWORK_RACK_MODULE_EAR_HOLE_R,
                NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_top_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_MODULE_EAR_HOLE_R,
                        h = NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );
        }

        // bottom ear hole
        hull()
        {
            translate([
                -NETWORK_RACK_MODULE_EAR_X + NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_X + NETWORK_RACK_MODULE_EAR_HOLE_R,
                NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_bottom_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_MODULE_EAR_HOLE_R,
                        h = NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );
            translate([
                -NETWORK_RACK_MODULE_EAR_X + NETWORK_RACK_MODULE_EAR_HOLE_X - NETWORK_RACK_MODULE_EAR_HOLE_OFFSET_X + NETWORK_RACK_MODULE_EAR_HOLE_R,
                NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE,
                ear_hole_bottom_z ])
                rotate([ 90, 0, 0 ])
                    cylinder(
                        r = NETWORK_RACK_MODULE_EAR_HOLE_R,
                        h = NETWORK_RACK_MODULE_FACE_Y + DIFFERENCE_CLEARANCE * 2,
                        $fn = 32 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
