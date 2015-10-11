package titanium_reindeer.tiles.hex;

import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.util.MoreMath;

/**
 * Cube Coordinates
 *
 * TODO Write description
 */
class CubeCoords
{
    // Adjacent tile offsets. Starts east/south-east and goes clock-wise.
    public static var directions:Array<CubeCoords> = [
        new CubeCoords( 1,  0, -1),
        new CubeCoords( 0,  1, -1),
        new CubeCoords(-1,  1,  0),
        new CubeCoords(-1,  0,  1),
        new CubeCoords( 0, -1,  1),
        new CubeCoords( 1, -1,  0),
    ];
    private static var sqrt3:Float = Math.sqrt(3);


    public var x:Int;
    public var y:Int;
    public var z:Int;

    public function new(x:Int, y:Int, z:Int)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function isValid():Bool
    {
        return (this.x + this.y + this.z) == 0;
    }

    public function getCopy():CubeCoords
    {
        return new CubeCoords(this.x, this.y, this.z);
    }

    public function add(b:CubeCoords):CubeCoords
    {
        return new CubeCoords(this.x + b.x, this.y + b.y, this.z + b.z);
    }

    public function addTo(b:CubeCoords):Void
    {
        this.x += b.x;
        this.y += b.y;
        this.z += b.z;
    }

    public function subtract(b:CubeCoords):CubeCoords
    {
        return new CubeCoords(this.x - b.x, this.y - b.y, this.z - b.z);
    }

    public function subtractFrom(b:CubeCoords):Void
    {
        this.x -= b.x;
        this.y -= b.y;
        this.z -= b.z;
    }

    public function equals(b:CubeCoords):Bool
    {
        return (this.x == b.x && this.y == b.y && this.z == b.z);
    }

    public function getCenter(layout:HexLayout):Vector2
    {
        var oneAndHalfLength = layout.edgeLength * 3/2;

        var center:Vector2 = new Vector2(0, 0);
        if (layout.isFlatTopped)
        {
            center.x = oneAndHalfLength * this.x;
            center.y = layout.edgeLength * sqrt3 * (this.y + this.x/2);
        }
        else
        {
            center.x = layout.edgeLength * sqrt3 * (this.x + this.y/2);
            center.y = oneAndHalfLength * this.y;
        }

        return center;
    }

    public function getAdjacent(direction:Int):CubeCoords
    {
        direction %= 6;
        var neighbour = CubeCoords.directions[direction];
        return this.add(neighbour);
    }

    public static function getCubeCoordsFromPoint(p:Vector2, layout:HexLayout):CubeCoords
    {
        var x:Float = 0;
        var y:Float = 0;
        var z:Float = 0;

        if (layout.isFlatTopped)
        {
            x = p.x * 2/3 / layout.edgeLength;
            y = (-p.x / 3 + sqrt3/3 * p.y) / layout.edgeLength;
        }
        else
        {
            x = (p.x * sqrt3/3 - p.y / 3) / layout.edgeLength;
            y = p.y * 2/3 / layout.edgeLength;
        }

        z = -x + -y;
        return CubeCoords.roundCubeCoords(x, y, z);
    }

    public static function roundCubeCoords(x:Float, y:Float, z:Float):CubeCoords
    {
        var coords = new CubeCoords(Math.round(x), Math.round(y), Math.round(z));

        var xDiff = Math.abs(coords.x - x);
        var yDiff = Math.abs(coords.y - y);
        var zDiff = Math.abs(coords.z - z);

        if (xDiff > yDiff && xDiff > zDiff)
            coords.x = -coords.y + -coords.z;
        else if (yDiff > zDiff)
            coords.y = -coords.x + -coords.z;
        else
            coords.z = -coords.x + -coords.y;

        return coords;
    }
}
