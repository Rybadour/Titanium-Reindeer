package titanium_reindeer.components;

interface IShape
{
	public function getBoundingRect():Rect;
	public function isPointInside(point:Vector2):Bool;
}
