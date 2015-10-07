package titanium_reindeer.tiles.hex;

import titanium_reindeer.spatial.Vector2;

/**
 * A field of hexagonal tiles with a "origin" hex with center 0,0
 */
class HexTileField
{
    public var hexLayout:HexLayout;

    public function new(layout:HexLayout)
    {
        this.hexLayout = hexLayout;
    }

    public function renderRectRegionOfField(x:Int, y:Int, width:Int, height:Int):Array<Vector2>
    {
        var tileWidth = this.hexLayout.getWidth();
        var tileHeight = this.hexLayout.getHeight();

        var horizSpacing = this.hexLayout.getHorizontalSpacing();
        var vertSpacing = this.hexLayout.getVerticalSpacing();

        // First find the center at the farthest top-left possible given x and y

    }
}
