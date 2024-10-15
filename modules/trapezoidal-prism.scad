////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TrapezoidalPrism( x_top, x_bottom, y, z, center = true)
{
    translate( center ? [ 0, 0, -z ] : [ x_bottom / 2, y / 2, 0 ] )
        polyhedron(
            points = [
                [ -x_bottom / 2, -y / 2, 0 ],  // 0: bottom back left
                [ x_bottom / 2, -y / 2, 0 ],   // 1: bottom back right
                [ x_bottom / 2, y / 2, 0 ],    // 2: bottom front right
                [ -x_bottom / 2, y / 2, 0 ],   // 3: bottom front left
                
                [ -x_top / 2, -y / 2, z ],  // 4: top back left
                [ x_top / 2, -y / 2, z ],   // 5: top back right
                [ x_top / 2, y / 2, z ],    // 6: top front right
                [ -x_top / 2, y / 2, z ]    // 7: top front left
            ],
            faces = [
                [ 0, 3, 2, 1 ], // bottom
                [ 4, 5, 6, 7 ], // top

                [ 0, 1, 5, 4 ],  // back
                [ 1, 2, 6, 5 ],  // right
                [ 2, 3, 7, 6 ],  // front
                [ 3, 0, 4, 7 ]   // left
            ]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
