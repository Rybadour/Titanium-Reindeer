package titanium_reindeer.spatial;

interface IShape
{
	public function getBoundingRect():Rect;
	public function isPointInside(point:Vector2):Bool;
	public function getArea():Float;
}
