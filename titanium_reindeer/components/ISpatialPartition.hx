package titanium_reindeer.components;

interface ISpatialPartition
{
	var debugCanvas:String;
	var debugOffset:Vector2;
	var debugSteps:Bool;

	function insert(rect:Rect, value:Int):Void;
	function update(newBounds:Rect, value:Int):Void;
	function remove(value:Int):Void;

	function requestValuesIntersectingRect(rect:Rect):Array<Int>;
	function requestValuesIntersectingPoint(point:Vector2):Array<Int>;

	function getBoundingRect():Rect;

	function drawDebug():Void;
}
