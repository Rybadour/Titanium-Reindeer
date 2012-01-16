package titanium_reindeer;

class Shape
{
	public function getMinBoundingRect():Rect
	{
		throw "Error: This function should not be called, inheriting classes should override and not call!";
		return null;
	}

	public function isPointInside(p:Vector2):Bool
	{
		return false;
	}
}
