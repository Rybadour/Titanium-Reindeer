package titanium_reindeer.tiles.hex;

import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.util.MoreMath;

/**
 * Cube Coordinates
 *
 * TODO Write description
 */

typedef CubeCoords = {
    var x:Int;
    var y:Int;
    var z:Int;
}

class CubeCoordsUtil
{
    public static function getCenterFromCubeCoords(x:Int, y:Int, z:Int, edgeLength:Float, isFlatTopped:Bool = true):Vector2
    {
        var horizSpacing:Float = HexUtil.getHorizontalSpacing(edgeLength, isFlatTopped);
        var vertSpacing:Float = HexUtil.getVerticalSpacing(edgeLength, isFlatTopped);

        var halfHorizSpacing:Float = horizSpacing / 2;
        var halfVertSpacing:Float = vertSpacing / 2;

        var center:Vector2 = new Vector2(0, 0);
        if (isFlatTopped)
        {
            // X one-one with world x axis
            center.x = x * horizSpacing;
            // Y one-one with world y axis by half
            center.y = y * halfVertSpacing;
            // Z negative goes positive by half
            center.y -= z * halfVertSpacing;
        }
        else
        {
            // X one-one with world x axis by half
            center.x = x * halfHorizSpacing;
            // Y negative goes positive in x axis by half
            center.x -= y * halfHorizSpacing;
            // Z one-one with world y axis
            center.y = z * vertSpacing;
        }

        return center;
    }

    public static function getCubeCoordsFromCenter(center:Vector2, edgeLength:Float, isFlatTopped:Bool = true):CubeCoords
    {
        // TODO: The whole thing
        var horizSpacing:Float = HexUtil.getHorizontalSpacing(edgeLength, isFlatTopped);
        var vertSpacing:Float = HexUtil.getVerticalSpacing(edgeLength, isFlatTopped);

        var halfHorizSpacing:Float = horizSpacing / 2;
        var halfVertSpacing:Float = vertSpacing / 2;

        var coords:CubeCoords = {x: 0, y: 0, z: 0};

        // TODO: Use implementation from redblob

        return coords;
    }

    public static function roundCubeCoords(x:Float, y:Float, z:Float):CubeCoords
    {
        var coords = {x: Math.round(x), y: Math.round(y), z: Math.round(z)};

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

    public static function isValidCubeCoords(x:Int, y:Int, z:Int):Bool
    {
        return (x + y + z) == 0;
    }
}
