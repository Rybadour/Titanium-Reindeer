package titanium_reindeer.tiles.hex;

import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.util.MoreMath;

/**
 * Axial Coordinates
 * A natural feeling coordinate system for hexagonal tile fields.
 * There are no invalid coordinates and "up" / "down" are across egdes instead of "up" and "down" in
 * the world.
 */

typedef AxialCoords = {
    var q:Int;
    var r:Int;
}

class AxialCoordsUtil
{
    public static function getCenterFromAxialCoords(x:Int, y:Int, z:Int, edgeLength:Float, isFlatTopped:Bool = true):Vector2
    {
    }

    public static function getAxialCoordsFromCenter(center:Vector2, edgeLength:Float, isFlatTopped:Bool = true):AxialCoords
    {
    }

    public static function roundAxialCoords(x:Float, y:Float, z:Float):CubeCoords
    {
    }
}
