package titanium_reindeer.components;

interface IShape
{
	public function getBoundingRect():Rect;
	public function center(getCenter, setCenter):Vector2;
	public function isPointInside(point:Vector2):Bool;
}
