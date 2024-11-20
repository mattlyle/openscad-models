////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SCREW_CLEARANCE = 0.15;

// [ shaft diameter, head diameter, shaft length, head height ]

SHAFT_DIAMETER = 0;
HEAD_DIAMETER = 1;
SHAFT_LENGTH = 2;
HEAD_HEIGHT = 3;

M3x8 = [ 2.9, 5.5, 8, 3.0 ];
M3x12 = [ 2.9, 5.5, 12, 3.0 ];
M3x16 = [ 2.9, 5.5, 16, 3.0 ];

// [ inner diameter, outer diameter, length ]
INSERT_SCREW_DIAMETER = 0;
INSERT_OUTER_DIAMETER = 1;
INSERT_LENGTH = 1;
M3x6_INSERT = [ 2.4, 4.2, 6.0 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewShaft( screw_def, include_clearance = true )
{
    cylinder( h = screw_def[ SHAFT_LENGTH ], r = screw_def[ SHAFT_DIAMETER ] / 2 + ( include_clearance ? SCREW_CLEARANCE : 0 ), $fn = 24 );
}

module ScrewHead( screw_def, include_clearance = true )
{
    cylinder( h = screw_def[ HEAD_HEIGHT ], r = screw_def[ HEAD_DIAMETER ] / 2 + ( include_clearance ? SCREW_CLEARANCE : 0 ), $fn = 24 );
}

module HeatedInsert( screw_def )
{
    cylinder( h = screw_def[ INSERT_LENGTH ], r = screw_def[ INSERT_OUTER_DIAMETER ] / 2, $fn = 24 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewScrew( screw_def )
{
    % cylinder( h = screw_def[ SHAFT_LENGTH ], r = screw_def[ SHAFT_DIAMETER ] / 2, $fn = 24 );

    % translate([ 0, 0, screw_def[ SHAFT_LENGTH ] ])
        cylinder( h = screw_def[ HEAD_HEIGHT ], r = screw_def[ HEAD_DIAMETER ] / 2, $fn = 24 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewHeatedInsert( insert_def )
{
    % render()
    {
        difference()
        {
            cylinder( h = insert_def[ INSERT_LENGTH ], r = insert_def[ INSERT_OUTER_DIAMETER ] / 2, $fn = 24 );

            cylinder( h = insert_def[ INSERT_LENGTH ], r = insert_def[ INSERT_SCREW_DIAMETER ] / 2, $fn = 24 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
