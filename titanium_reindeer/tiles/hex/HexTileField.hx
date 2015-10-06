package titanium_reindeer.tiles.hex;

import titanium_reindeer.spatial.Vector2;

/**
 * A field of hexagonal tiles with a "origin" hex with center 0,0
 */
class HexTileField
{
    public var hexTileConfig:HexTileConfig;

    public function new(hexTileConfig:HexTileConfig)
    {
        this.hexTileConfig = hexTileConfig;
    }

    public function getTileCentersInsideRectangle(x:Int, y:Int, width:Int, height:Int):Array<Vector2>
    {
        var tileWidth = this.hexTileConfig.getWidth();
        var tileHeight = this.hexTileConfig.getHeight();

        var horizSpacing = this.hexTileConfig.getHorizontalSpacing();
        var vertSpacing = this.hexTileConfig.getVerticalSpacing();

        // First find the center at the farthest top-left possible given x and y

    }


    /*
     * Current Plan:
     *  - Special function to render a field inside a rect
     *      - To prevent having to store centers as an intermediate rep. then render duplicate edges
     *
     *  - What representation is actually useful for game entities on the grid?
     *      - Probably coords
     */
}
