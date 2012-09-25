package titanium_reindeer.core;

interface IRegion implements IShape
{
	public function getBoundingRegion():RectRegion;
	public var center(getCenter, null):Vector2;
}
