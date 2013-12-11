package titanium_reindeer.spatial;

interface IRegion extends IShape
{
	public function getBoundingRectRegion():RectRegion;
	public var center(get, null):Vector2;
}
