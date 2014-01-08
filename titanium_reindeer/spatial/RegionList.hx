package titanium_reindeer.spatial;

import titanium_reindeer.core.IUnique;

class RegionList<T:IUnique<Int>> implements IRegionGroup<T>
{
	private var mapping:Map<Int, RegionPair<T>>;

	public function new()
	{
		this.mapping = new Map();
	}

	public function add(thing:T, region:IRegion):Void
	{
		this.mapping.set(thing.getKey(), {thing: thing, region: region});
	}

	public function remove(thing:T):Void
	{
		this.mapping.remove(thing.getKey());
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

	private function getIntersectingRegion(region:IRegion):Iterator<RegionPair<T>>
	{
		return this.mapping.iterator();
	}
}

typedef RegionPair<T> = {
	var region:IRegion;
	var thing:T;
}
