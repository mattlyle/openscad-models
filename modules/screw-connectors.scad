////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SCREW_CLEARANCE = 0.15;

// [ shaft diameter, head diameter, shaft length, head height ]

SCREW_SHAFT_DIAMETER = 0;
SCREW_HEAD_DIAMETER = 1;
SCREW_SHAFT_LENGTH = 2;
SCREW_HEAD_HEIGHT = 3;

M3x8 = [ 2.9, 5.5, 8, 3.0 ];
M3x16 = [ 2.9, 5.5, 16, 3.0 ];

// [ inner diameter, outer diameter, length ]
INSERT_SCREW_DIAMETER = 0;
INSERT_OUTER_DIAMETER = 1;
INSERT_LENGTH = 2;

M3x6_INSERT = [ 2.4, 4.2, 6.0 ];

WASHER_INNER_DIAMETER = 0;
WASHER_OUTER_DIAMETER = 1;
WASHER_HEIGHT = 2;

M3_WASHER = [ 3.0, 7.0, 0.5 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewShaft( screw_def, include_clearance = true )
{
    cylinder( h = screw_def[ SCREW_SHAFT_LENGTH ], r = screw_def[ SCREW_SHAFT_DIAMETER ] / 2 + ( include_clearance ? SCREW_CLEARANCE : 0 ), $fn = 32 );
}

module HeatedInsert( screw_def )
{
    cylinder( h = screw_def[ INSERT_LENGTH ], r = screw_def[ INSERT_OUTER_DIAMETER ] / 2, $fn = 32 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewScrew( screw_def, washer_def = [] )
{
    % cylinder( h = screw_def[ SCREW_SHAFT_LENGTH ], r = screw_def[ SCREW_SHAFT_DIAMETER ] / 2, $fn = 32 );

    % translate([ 0, 0, screw_def[ SCREW_SHAFT_LENGTH ] ])
        cylinder( h = screw_def[ SCREW_HEAD_HEIGHT ], r = screw_def[ SCREW_HEAD_DIAMETER ] / 2, $fn = 32 );

    if( len( washer_def ) > 0 )
    {
        % translate([ 0, 0, screw_def[ SCREW_SHAFT_LENGTH ] - washer_def[ WASHER_HEIGHT ] ])
            cylinder( h = washer_def[ WASHER_HEIGHT ], r = washer_def[ WASHER_OUTER_DIAMETER ] / 2, $fn = 32 );
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PreviewHeatedInsert( insert_def )
{
    % render()
    {
        difference()
        {
            cylinder( h = insert_def[ INSERT_LENGTH ], r = insert_def[ INSERT_OUTER_DIAMETER ] / 2, $fn = 32 );

            cylinder( h = insert_def[ INSERT_LENGTH ], r = insert_def[ INSERT_SCREW_DIAMETER ] / 2, $fn = 32 );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
