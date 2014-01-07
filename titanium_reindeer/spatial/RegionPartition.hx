package titanium_reindeer.spatial;

import Map;

/**
 * A group of things paired with an IRegion stored in a partition for faster intersection checks.
 */
class RegionPartition<T:IPartitionable<Int>> implements IRegionGroup<T>
{
	public var partition(default, null):ISpatialPartition<Int>;
	private var mapping:Map<Int, RegionPair<T>>;

	public function new(partition:ISpatialPartition<Int>)
	{
		this.partition = partition;
		this.mapping = new Map();
	}

	public function add(thing:T, region:IRegion):Void
	{
		this.mapping.set(thing.getKey(), {thing: thing, region: region});
		this.partition.insert(region.getBoundingRectRegion(), thing.getKey());
	}

	public function getIntersectingRect(rect:RectRegion):Array<T>
	{
		var intersecting = new Array();
		// Perform more accurate check against the actual shape
		for (pair in this.getIntersectingRegion(rect))
		{
			if (pair.region.intersectsRectRegion(rect))
				intersecting.push(pair.thing);
		}
		return intersecting;
	}
	
	public function getIntersectingCircle(circle:CircleRegion):Array<T>
	{
		var intersecting = new Array();
		// Perform more accurate check against the actual shape
		for (pair in this.getIntersectingRegion(circle))
		{
			if (pair.region.intersectsCircleRegion(circle))
				intersecting.push(pair.thing);
		}
		return intersecting;
	}

	private function getIntersectingRegion(region:IRegion):Array<RegionPair<T>>
	{
		return this.getValuesFromKeys(this.partition.requestKeysIntersectingRect(region.getBoundingRectRegion()));
	}

	private function getValuesFromKeys(keys:Array<Int>):Array<RegionPair<T>>
	{
		var values = new Array();
		for (k in keys)
			values.push(this.mapping.get(k));
		return values;
	}
}

typedef RegionPair<T> = {
	var region:IRegion;
	var thing:T;
}
