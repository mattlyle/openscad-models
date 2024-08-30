module TrianglePrism( width, height, depth )
{
    polyhedron(
        points = [
            [ 0, 0, depth ],
            [ width, 0, depth ],
            [ width, 0, 0 ],
            [ 0, 0, 0 ],
            [ 0, height, 0 ],
            [ width, height, 0 ]
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
