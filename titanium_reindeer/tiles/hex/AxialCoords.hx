package titanium_reindeer.tiles.hex;

import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.util.MoreMath;

/**
 * Axial Coordinates
 * A natural feeling coordinate system for hexagonal tile fields.
 * There are no invalid coordinates and "up" / "down" are across egdes instead of "up" and "down" in
 * the world.
 */
class AxialCoords
{
    public var q:Int;
    public var r:Int;

    public function new(q:Int, r:Int)
    {
        this.q = q;
        this.r = r;
    }

    public function add(b:AxialCoords):AxialCoords
    {
        return new AxialCoords(this.q + b.q, this.r + b.r);
    }

    public function addTo(b:AxialCoords):Void
    {
        this.q += b.q;
        this.r += b.r;
    }

    public function subtract(b:AxialCoords):AxialCoords
    {
        return new AxialCoords(this.q - b.q, this.r - b.r);
    }

    public function subtractFrom(b:AxialCoords):Void
    {
        this.q -= b.q;
        this.r -= b.r;
    }

    public function getCenter(layout:HexLayout):Vector2
    {
        // TODO
        return new Vector2(0, 0);
    }

    public function getCubeCoords():CubeCoords
    {
        return new CubeCoords(q, -q + -r, r);
    }

    public static function getAxialCoordsFromCenter(center:Vector2, edgeLength:Float, isFlatTopped:Bool = true):AxialCoords
    {
        // TODO
        return new AxialCoords(0, 0);
    }

    public static function roundAxialCoords(q:Float, r:Float):AxialCoords
    {
        // TODO
        return new AxialCoords(0, 0);
    }
}
