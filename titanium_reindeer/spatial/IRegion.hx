package titanium_reindeer.spatial;

interface IRegion implements IShape
{
	public function getBoundingRectRegion():RectRegion;
	public var center(getCenter, null):Vector2;
}
