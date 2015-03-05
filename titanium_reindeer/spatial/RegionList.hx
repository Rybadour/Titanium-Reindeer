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

	public function getAll():Array<T>
	{
		var array:Array<T> = new Array();
		for (pair in this.mapping)
		{
			array.push(pair.thing);
		}
		return array;
	}

	public function getThing(key:Int):T
	{
		return (this.mapping.exists(key) ? this.mapping.get(key).thing : null);
	}

	public function getIntersectingRect(rect:RectRegion):Array<T>
	{
		var intersecting = new Array();
		// Perform more accurate check against the actual shape
		for (pair in this.pairsIntersectingRegion(rect))
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
		for (pair in this.pairsIntersectingRegion(circle))
		{
			if (pair.region.intersectsCircleRegion(circle))
				intersecting.push(pair.thing);
		}
		return intersecting;
	}

	public function getIntersectingPoint(point:Vector2):Array<T>
	{
		var intersecting = new Array();
		for (pair in this.pairsIntersectingPoint(point))
		{
			if (pair.region.intersectsPoint(point))
				intersecting.push(pair.thing);
		}
		return intersecting;
	}

	/**
	 * Less specific check for a point intersecting the regions in this list.
	 * For internal re-use.
	 */
	private function pairsIntersectingPoint(point:Vector2):Iterator<RegionPair<T>>
	{
		return this.mapping.iterator();
	}

	private function pairsIntersectingRegion(region:IRegion):Iterator<RegionPair<T>>
	{
		return this.mapping.iterator();
	}
}

typedef RegionPair<T> = {
	var region:IRegion;
	var thing:T;
}
