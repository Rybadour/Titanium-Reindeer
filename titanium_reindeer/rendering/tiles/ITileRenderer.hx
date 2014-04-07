package titanium_reindeer.rendering.tiles;

interface ITileRenderer
{
	public function render(canvas:Canvas2D, tileId:Int, width:Int, height:Int):Void;
}
