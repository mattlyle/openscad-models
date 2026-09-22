////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PINCH_CONNECTOR_WALL_THICKNESS = 1.2;

PINCH_CONNECTOR_OVERLAP_Y = 0.5;
PINCH_CONNECTOR_OVERLAP_STOPPER_Y = 1.2;

PINCH_CONNECTOR_OVERLAP_Z = 2.0;
PINCH_CONNECTOR_LEDGE_Z = 1.6;

PINCH_CONNECTOR_CLEARANCE = 0.1;
// PINCH_CONNECTOR_CLEARANCE=0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CalculatePinchConnectorTrayBottomY( tray_y ) =
    tray_y
    + PINCH_CONNECTOR_WALL_THICKNESS * 2
    + PINCH_CONNECTOR_OVERLAP_STOPPER_Y * 2;

function CalculatePinchConnectorTrayBottomZ( z ) =
    z
    + PINCH_CONNECTOR_WALL_THICKNESS;

function CalculatePinchConnectorTrayTopY( tray_y ) =
    tray_y
    + PINCH_CONNECTOR_WALL_THICKNESS * 4
    + PINCH_CONNECTOR_OVERLAP_Y * 2
    + PINCH_CONNECTOR_CLEARANCE * 2;

function CalculatePinchConnectorTrayTopYOffset() =
    PINCH_CONNECTOR_OVERLAP_Y
    + PINCH_CONNECTOR_CLEARANCE;

function CalculatePinchConnectorTrayTopZ() =
    PINCH_CONNECTOR_WALL_THICKNESS
    + PINCH_CONNECTOR_OVERLAP_Z
    + PINCH_CONNECTOR_LEDGE_Z * 2
    - PINCH_CONNECTOR_CLEARANCE / 2;

function CalculatePinchConnectorTrayTopZOffset( tray_z ) =
    tray_z + 4;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PinchConnectorTrayBottom( x, tray_y, z )
{
    // bottom
    translate([
        0,
        PINCH_CONNECTOR_WALL_THICKNESS + PINCH_CONNECTOR_OVERLAP_STOPPER_Y,
        0
        ])
        cube([ x, tray_y, PINCH_CONNECTOR_WALL_THICKNESS ]);

    // near wall
    _PinchConnectorTrayBottomWall( x, tray_y, z );

    // far wall
    translate([ x, tray_y + PINCH_CONNECTOR_WALL_THICKNESS * 5 - PINCH_CONNECTOR_OVERLAP_STOPPER_Y, 0 ])
        rotate([ 0, 0, 180 ])
            _PinchConnectorTrayBottomWall( x, tray_y, z );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PinchConnectorTrayTop( x, tray_y )
{
    // bottom
    translate([
        0,
        PINCH_CONNECTOR_WALL_THICKNESS - PINCH_CONNECTOR_OVERLAP_Y - PINCH_CONNECTOR_CLEARANCE,
        0
        ])
        cube([
            x,
            tray_y + PINCH_CONNECTOR_WALL_THICKNESS * 2 + PINCH_CONNECTOR_OVERLAP_Y * 2 + PINCH_CONNECTOR_CLEARANCE * 2,
            PINCH_CONNECTOR_WALL_THICKNESS
            ]);

    // near wall
    translate([ 0, -PINCH_CONNECTOR_CLEARANCE, 0 ])
        _PinchConnectorTrayTopWall( x, tray_y );

    // far wall
    translate([
        x,
        tray_y + PINCH_CONNECTOR_WALL_THICKNESS * 5 - PINCH_CONNECTOR_OVERLAP_STOPPER_Y + PINCH_CONNECTOR_CLEARANCE,
        0
        ])
        rotate([ 0, 0, 180 ])
            _PinchConnectorTrayTopWall( x, tray_y );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _PinchConnectorTrayBottomWall( x, tray_y, z )
{
    transition_edge = sqrt( PINCH_CONNECTOR_WALL_THICKNESS * PINCH_CONNECTOR_WALL_THICKNESS * 2 );

    // wall
    translate([
        0,
        PINCH_CONNECTOR_OVERLAP_STOPPER_Y,
        PINCH_CONNECTOR_WALL_THICKNESS
        ])
        cube([ x, PINCH_CONNECTOR_WALL_THICKNESS, z ]);

    // bottom transition
    translate([
        0,
        PINCH_CONNECTOR_WALL_THICKNESS + PINCH_CONNECTOR_OVERLAP_STOPPER_Y,
        0
        ])
        rotate([ 45, 0, 0 ])
            cube([ x, transition_edge, transition_edge ]);

    // wall overlap
    translate([
        0,
        PINCH_CONNECTOR_OVERLAP_STOPPER_Y - PINCH_CONNECTOR_OVERLAP_Y,
        PINCH_CONNECTOR_WALL_THICKNESS + z - PINCH_CONNECTOR_OVERLAP_Z
        ])
        cube([ x, PINCH_CONNECTOR_OVERLAP_Y, PINCH_CONNECTOR_OVERLAP_Z ]);

    // wall ledge
    difference()
    {
        translate([
            0,
            PINCH_CONNECTOR_OVERLAP_STOPPER_Y - PINCH_CONNECTOR_OVERLAP_Y,
            PINCH_CONNECTOR_WALL_THICKNESS + z - PINCH_CONNECTOR_OVERLAP_Z - PINCH_CONNECTOR_LEDGE_Z
            ])
            cube([ x, PINCH_CONNECTOR_OVERLAP_Y, PINCH_CONNECTOR_LEDGE_Z ]);

        translate([
            -0.01,
            PINCH_CONNECTOR_OVERLAP_STOPPER_Y - PINCH_CONNECTOR_OVERLAP_Y,
            PINCH_CONNECTOR_WALL_THICKNESS + z - PINCH_CONNECTOR_OVERLAP_Z - PINCH_CONNECTOR_LEDGE_Z / 2
            ])
            scale([ 1, PINCH_CONNECTOR_OVERLAP_Y / PINCH_CONNECTOR_LEDGE_Z * 2, 1 ])
                rotate([ 0, 90, 0 ])
                    cylinder( h = x + 0.02, r = PINCH_CONNECTOR_LEDGE_Z / 2, $fn = 32 );
    }

    stopper_z = PINCH_CONNECTOR_WALL_THICKNESS + z - PINCH_CONNECTOR_OVERLAP_Z - PINCH_CONNECTOR_LEDGE_Z;

    // wall stopper
    points = [
        [ 0, PINCH_CONNECTOR_OVERLAP_STOPPER_Y, stopper_z ],
        [ 0, 0, stopper_z ],
        [ 0, PINCH_CONNECTOR_OVERLAP_STOPPER_Y, PINCH_CONNECTOR_WALL_THICKNESS ],
        [ x, PINCH_CONNECTOR_OVERLAP_STOPPER_Y, stopper_z ],
        [ x, 0, stopper_z ],
        [ x, PINCH_CONNECTOR_OVERLAP_STOPPER_Y, PINCH_CONNECTOR_WALL_THICKNESS ]
    ];

    polyhedron(
        points = points,
        faces = [
            [ 0, 1, 2 ],
            [ 4, 3, 5 ],
            [ 3, 4, 1, 0 ],
            [ 2, 1, 4, 5 ],
            [ 5, 3, 0, 2 ]
            ] );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module _PinchConnectorTrayTopWall( x, tray_y )
{
    transition_edge = sqrt( PINCH_CONNECTOR_WALL_THICKNESS * PINCH_CONNECTOR_WALL_THICKNESS * 2 );

    // wall
    translate([
        0,
        -PINCH_CONNECTOR_OVERLAP_Y,
        PINCH_CONNECTOR_WALL_THICKNESS
        ])
        cube([
            x,
            PINCH_CONNECTOR_WALL_THICKNESS,
            PINCH_CONNECTOR_OVERLAP_Z + PINCH_CONNECTOR_LEDGE_Z * 2 - PINCH_CONNECTOR_CLEARANCE / 2
            ]);

    // bottom transition
    translate([
        0,
        PINCH_CONNECTOR_WALL_THICKNESS - PINCH_CONNECTOR_OVERLAP_Y,
        0
        ])
        rotate([ 45, 0, 0 ])
            cube([ x, transition_edge, transition_edge ]);

    // ledge
    translate([
        0,
        PINCH_CONNECTOR_OVERLAP_STOPPER_Y - PINCH_CONNECTOR_OVERLAP_Y,
        PINCH_CONNECTOR_WALL_THICKNESS + PINCH_CONNECTOR_OVERLAP_Z + PINCH_CONNECTOR_LEDGE_Z * 3 / 2
        ])
        scale([ 1, PINCH_CONNECTOR_OVERLAP_Y / PINCH_CONNECTOR_LEDGE_Z * 2, 1 ])
            rotate([ 0, 90, 0 ])
                cylinder( h = x, r = PINCH_CONNECTOR_LEDGE_Z / 2 - PINCH_CONNECTOR_CLEARANCE / 2, $fn = 32 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

