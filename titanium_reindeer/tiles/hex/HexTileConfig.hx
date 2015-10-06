package titanium_reindeer.tiles.hex;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.spatial.Vector2;

class HexTileConfig
{
    public var edgeLength:Float;
    public var isFlatTopped:Bool;
    public var isOddInset:Bool;

    public function new(edgeLength:Float, isFlatTopped:Bool = true, isOddInset:Bool = true)
    {
        this.edgeLength = edgeLength;
        this.isFlatTopped = isFlatTopped;
        this.isOddInset = isOddInset;
    }

    public function getCorder(center:Vector2, i:Int):Vector2
    {
        return HexUtil.getHexCorner(center, this.edgeLength, i, this.isFlatTopped);
    }

    public function getWidth():Float
    {
        return HexUtil.getHexWidth(this.edgeLength, this.isFlatTopped);
    }

    public function getHeight():Float
    {
        return HexUtil.getHexHeight(this.edgeLength, this.isFlatTopped);
    }

    public function getHorizontalSpacing():Float
    {
        return HexUtil.getHorizontalSpacing(this.edgeLength, this.isFlatTopped);
    }

    public function getVerticalSpacing():Float
    {
        return HexUtil.getVerticalSpacing(this.edgeLength, this.isFlatTopped);
    }

    public function getCenterFromOffsetCoords(x:Int, y:Int):Vector2
    {
        return HexUtil.getCenterFromOffsetCoords(x, y, this.edgeLength, this.isFlatTopped, this.isOddInset);
    }

    public function getCenterFromCubeCoords(x:Int, y:Int, z:Int):Vector2
    {
        return CubeCoordsUtil.getCenterFromCubeCoords(x, y, z, this.edgeLength, this.isFlatTopped);
    }

    public function renderHexOutline(canvas:Canvas2D, center:Vector2):Void
    {
        HexUtil.renderHexOutline(canvas, center, this.edgeLength, this.isFlatTopped);
    }
}
