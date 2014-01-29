package titanium_reindeer.spatial;

import titanium_reindeer.core.IUnique;
import titanium_reindeer.spatial.RegionList;

/**
 * A group of things paired with an IRegion stored in a partition for faster intersection checks.
 */
class RegionPartition<T:IUnique<Int>> extends RegionList<T>
{
	public var partition(default, null):ISpatialPartition<Int>;

	public function new(partition:ISpatialPartition<Int>)
	{
		super();

		this.partition = partition;
	}

	public override function add(thing:T, region:IRegion):Void
	{
		var key = thing.getKey();
		if (this.mapping.exists(key))
			this.partition.update(region.getBoundingRectRegion(), key);
		else
			this.partition.insert(region.getBoundingRectRegion(), key);

		super.add(thing, region);
	}

	public override function remove(thing:T):Void
	{
		var key = thing.getKey();
		if (this.mapping.exists(key))
		{
			this.partition.remove(key);
		}
		super.remove(thing);
	}

	private override function pairsIntersectingPoint(point:Vector2):Array<T>
	{
		return this.getValuesFromKeys(this.partition.requestKeysIntersectingPoint(point));
	}

	private override function pairsIntersectingRegion(region:IRegion):Iterator<RegionPair<T>>
	{
		return this.getValuesFromKeys(this.partition.requestKeysIntersectingRect(region.getBoundingRectRegion()));
	}

	private function getValuesFromKeys(keys:Array<Int>):Iterator<RegionPair<T>>
	{
		var values = new Array();
		for (k in keys)
			values.push(this.mapping.get(k));
		return values.iterator();
	}
}
