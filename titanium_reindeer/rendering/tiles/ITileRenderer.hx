package titanium_reindeer.rendering.tiles;

/**
 * A tile renderer is intended to be a class that is capable of rendering a tile given it's index.
 */
interface ITileRenderer
{
	/**
	 * Intended to render a tile indetified by a tile index.
	 */
	public function render(canvas:Canvas2D, tileIndex:Int):Void;
}
