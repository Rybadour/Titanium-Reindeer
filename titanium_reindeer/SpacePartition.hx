package titanium_reindeer;

interface SpacePartition
{
	var debugCanvas:String;
	var debugOffset:Vector2;
	var debugSteps:Bool;

	function insert(rect:Rect, value:Int):Void;
	function update(newBounds:Rect, value:Int):Void;
	function remove(value:Int):Void;

	function getRectIntersectingValues(rect:Rect):Array<Int>;
	function getPointIntersectingValues(point:Vector2):Array<Int>;

	function drawDebug():Void;
}
