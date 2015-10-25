package titanium_reindeer.tiles.hex;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.util.MoreMath;

class HexLayout
{
    public static var HEX_EDGE_RADIANS:Float = Math.PI/3;
    public static var OFF_SPACING_RATIO:Float = Math.sqrt(3) / 2;

    public static function rotateLeft(starting:Int, amount:Int):Int
    {
        starting += amount;
        return starting % 6;
    }

    public static function rotateRight(starting:Int, amount:Int):Int
    {
        return HexLayout.rotateLeft(starting, -amount);
    }


    public var edgeLength:Float;
    public var isFlatTopped:Bool;
    public var isOddInset:Bool;

    public function new(edgeLength:Float, isFlatTopped:Bool = true, isOddInset:Bool = true)
    {
        this.edgeLength = edgeLength;
        this.isFlatTopped = isFlatTopped;
        this.isOddInset = isOddInset;
    }

    public function getHexCorner(center:Vector2, i:Int):Vector2
    {
        var angle:Float = HEX_EDGE_RADIANS * i;
        if (!this.isFlatTopped)
        {
            angle -= HEX_EDGE_RADIANS/2;
        }
        return new Vector2(center.x + this.edgeLength * Math.cos(angle), center.y + this.edgeLength * Math.sin(angle));
    }

    public function getHexWidth():Float
    {
        return (this.isFlatTopped ? this.edgeLength * 2 : this.getHexHeight() * OFF_SPACING_RATIO);
    }
    
    public function getHexHeight():Float
    {
        return (this.isFlatTopped ? this.getHexWidth() * OFF_SPACING_RATIO : this.edgeLength * 2);
    }

    public function getHorizontalSpacing():Float
    {
        var width = this.getHexWidth();
        return (this.isFlatTopped ? width * 3/4 : width);
    }

    public function getVerticalSpacing():Float
    {
        var height = this.getHexHeight();
        return (this.isFlatTopped ? height : height * 3/4);
    }

    public function getCenterFromOffsetCoords(x:Int, y:Int):Vector2
    {
        // Starting from 0,0 place centers of tiles
        var horizSpacing:Float = this.getHorizontalSpacing();
        var centerX = x * horizSpacing;
        if (!this.isFlatTopped)
        {
            // Either odd or even tiles get moved in half to keep tiles in line.
            if ((this.isOddInset && MoreMath.isOdd(y)) || (!this.isOddInset && MoreMath.isEven(y)))
                centerX += horizSpacing/2;
        }

        var vertSpacing:Float = this.getVerticalSpacing();
        var centerY = y * vertSpacing;
        if (this.isFlatTopped)
        {
            // Either odd or even tiles get moved in half to keep tiles in line.
            if ((this.isOddInset && MoreMath.isOdd(y)) || (!this.isOddInset && MoreMath.isEven(y)))
                centerY += vertSpacing/2;
        }

        return new Vector2(centerX, centerY);
    }

    public function renderHexOutlineCube(canvas:Canvas2D, cube:CubeCoords):Void
    {
        this.renderHexOutline(canvas, cube.getCenter(this));
    }

    public function renderHexOutline(canvas:Canvas2D, center:Vector2):Void
    {
        var firstCorner = this.getHexCorner(center, 0);
        canvas.save();
        canvas.ctx.beginPath();
        canvas.moveTo(firstCorner);
        canvas.lineTo(this.getHexCorner(center, 1));
        canvas.lineTo(this.getHexCorner(center, 2));
        canvas.lineTo(this.getHexCorner(center, 3));
        canvas.lineTo(this.getHexCorner(center, 4));
        canvas.lineTo(this.getHexCorner(center, 5));
        canvas.lineTo(firstCorner);
        canvas.ctx.closePath();
        canvas.ctx.stroke();
        canvas.restore();
    }
}
