package titanium_reindeer.core;

interface ISpatialPartition
{
	var debugCanvas:String;
	var debugOffset:Vector2;
	var debugSteps:Bool;

	function insert(rect:RectRegion, value:Int):Void;
	function update(newBounds:RectRegion, value:Int):Void;
	function remove(value:Int):Void;

	function requestValuesIntersectingRect(rect:RectRegion):Array<Int>;
	function requestValuesIntersectingPoint(point:Vector2):Array<Int>;

	function getBoundingRegion():RectRegion;

	function drawDebug():Void;
}
