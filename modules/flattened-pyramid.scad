////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FlattenedPyramid( bottom_x, bottom_y, top_x, top_y, z, center = false )
{
    top_x_offset = ( bottom_x - top_x ) / 2;
    top_y_offset = ( bottom_y - top_y ) / 2;

    translate( center ? [ -bottom_x / 2, -bottom_y / 2, -z / 2 ] : [ 0, 0, 0 ] )
        polyhedron(
            points = [
                [ top_x_offset, top_y_offset + top_y, z ],         // 0: bottom back left
                [ top_x_offset + top_x, top_y_offset + top_y, z ], // 1: bottom back right
                [ top_x_offset + top_x, top_y_offset, z ],         // 2: bottom front right
                [ top_x_offset, top_y_offset, z ],                 // 3: bottom front left

                [ 0, bottom_y, 0 ],        // 4: top back left
                [ bottom_x, bottom_y, 0 ], // 5: top back right
                [ bottom_x, 0, 0 ],        // 6: top front right
                [ 0, 0, 0 ]                // 7: top front left
            ],
            faces = [
                [ 0, 1, 2, 3 ], // top
                [ 5, 4, 7, 6 ], // bottom
                [ 1, 0, 4, 5 ], // back
                [ 1, 5, 6, 2 ], // right
                [ 3, 2, 6, 7 ], // front
                [ 0, 3, 7, 4 ]  // left
            ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
