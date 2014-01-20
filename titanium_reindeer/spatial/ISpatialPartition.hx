package titanium_reindeer.spatial;

interface ISpatialPartition<K>
{
	function insert(rect:RectRegion, key:K):Void;
	function update(newBounds:RectRegion, key:K):Void;
	function remove(key:K):Void;

	function requestKeysIntersectingRect(rect:RectRegion):Array<K>;
	function requestKeysIntersectingPoint(point:Vector2):Array<K>;

	function getBoundingRectRegion():RectRegion;
}
