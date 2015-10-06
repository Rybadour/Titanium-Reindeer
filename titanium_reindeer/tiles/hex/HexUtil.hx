package titanium_reindeer.tiles.hex;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.util.MoreMath;

/**
 * Core class for all hex tile based calculations.
 * Implementation details borrowed from: http://www.redblobgames.com/grids/hexagons/
 */
class HexUtil
{
    public static var HEX_EDGE_RADIANS:Float = Math.PI/3;
    public static var OFF_SPACING_RATIO:Float = Math.sqrt(3) / 2;

         
    public static function getHexCorner(center:Vector2, edgeLength:Float, i:Int, isFlatTopped:Bool = true):Vector2
    {
        var angle:Float = HEX_EDGE_RADIANS * i;
        if (!isFlatTopped)
        {
            angle -= HEX_EDGE_RADIANS/2;
        }
        return new Vector2(center.x + edgeLength * Math.cos(angle), center.y + edgeLength * Math.sin(angle));
    }

    public static function getHexWidth(edgeLength:Float, isFlatTopped:Bool = true):Float
    {
        return (isFlatTopped ? edgeLength * 2 : HexUtil.getHexHeight(edgeLength, isFlatTopped) * HexUtil.OFF_SPACING_RATIO);
    }
    
    public static function getHexHeight(edgeLength:Float, isFlatTopped:Bool = true):Float
    {
        return (isFlatTopped ? HexUtil.getHexWidth(edgeLength, isFlatTopped) * HexUtil.OFF_SPACING_RATIO : edgeLength * 2);
    }

    public static function getHorizontalSpacing(edgeLength:Float, isFlatTopped:Bool = true):Float
    {
        var width = HexUtil.getHexWidth(edgeLength, isFlatTopped);
        return (isFlatTopped ? width * 3/4 : width);
    }

    public static function getVerticalSpacing(edgeLength:Float, isFlatTopped:Bool = true):Float
    {
        var height = HexUtil.getHexHeight(edgeLength, isFlatTopped);
        return (isFlatTopped ? height : height * 3/4);
    }

    public static function getCenterFromOffsetCoords(x:Int, y:Int, edgeLength:Float, isFlatTopped:Bool = true, isOddInset:Bool = true):Vector2
    {
        // Starting from 0,0 place centers of tiles
        var horizSpacing:Float = HexUtil.getHorizontalSpacing(edgeLength, isFlatTopped);
        var centerX = x * horizSpacing;
        if (!isFlatTopped)
        {
            // Either odd or even tiles get moved in half to keep tiles in line.
            if ((isOddInset && MoreMath.isOdd(y)) || (!isOddInset && MoreMath.isEven(y)))
                centerX += horizSpacing/2;
        }

        var vertSpacing:Float = HexUtil.getVerticalSpacing(edgeLength, isFlatTopped);
        var centerY = y * vertSpacing;
        if (isFlatTopped)
        {
            // Either odd or even tiles get moved in half to keep tiles in line.
            if ((isOddInset && MoreMath.isOdd(y)) || (!isOddInset && MoreMath.isEven(y)))
                centerY += vertSpacing/2;
        }

        return new Vector2(centerX, centerY);
    }

    public static function renderHexOutline(canvas:Canvas2D, center:Vector2, edgeLength:Float, isFlatTopped:Bool = true):Void
    {
        var firstCorner = HexUtil.getHexCorner(center, edgeLength, 0, isFlatTopped);
        canvas.save();
        canvas.ctx.beginPath();
        canvas.moveTo(firstCorner);
        canvas.lineTo(HexUtil.getHexCorner(center, edgeLength, 1, isFlatTopped));
        canvas.lineTo(HexUtil.getHexCorner(center, edgeLength, 2, isFlatTopped));
        canvas.lineTo(HexUtil.getHexCorner(center, edgeLength, 3, isFlatTopped));
        canvas.lineTo(HexUtil.getHexCorner(center, edgeLength, 4, isFlatTopped));
        canvas.lineTo(HexUtil.getHexCorner(center, edgeLength, 5, isFlatTopped));
        canvas.lineTo(firstCorner);
        canvas.ctx.closePath();
        canvas.ctx.stroke();
        canvas.restore();
    }
}
