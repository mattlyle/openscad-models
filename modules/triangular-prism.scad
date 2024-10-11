module TriangularPrism( x, y, z )
{
    polyhedron(
        points = [
            [ 0, 0, z ],
            [ x, 0, z ],
            [ x, 0, 0 ],
            [ 0, 0, 0 ],
            [ 0, y, 0 ],
            [ x, y, 0 ]
            ],
        faces = [
            [ 0, 1, 2, 3 ],
            [ 1, 5, 2 ],
            [ 0, 4, 5, 1 ],
            [ 2, 5, 4, 3 ],
            [ 0, 3, 4 ]
            ]
        );
}
