package titanium_reindeer.spatial;

interface IRegion
{
	public function getBoundingRectRegion():RectRegion;
	public var center(get, null):Vector2;

	public function intersectsRectRegion(rect:RectRegion):Bool;
	public function intersectsCircleRegion(circle:CircleRegion):Bool;
	public function intersectsPoint(p:Vector2):Bool;
}
