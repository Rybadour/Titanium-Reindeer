package titanium_reindeer.spatial;

// TODO: Completely refactor
class RegionGroup implements IGroup<IRegion>, implements IHasId, implements IRegion
{
	private var hasProvider:IHasIdProvider;

	public var id(default, null):Int;
	public var idProvider(default, null):IdProvider;
	public var name(default, null):String;

	private var partitioning:ISpatialPartition;
	private var regionIntersecter:IRegionIntersecter;

	// IRegion
	public function getBoundingRect():Rect
	{
		return this.getBoundingRectRegion();
	}
	public function isPointInside(p:Vector2):Bool
	{
		return this.partitioning.getBoundingRectRegion().isPointInside(p);
	}
	public function getArea():Float
	{
		return this.getBoundingRect().getArea();
	}
	public function getBoundingRectRegion():RectRegion
	{
		return this.partitioning.getBoundingRectRegion();
	}
	public var center(getCenter, null):Vector2;
	public function getCenter():Vector2 { return this.partitioning.getBoundingRectRegion().center; }

	private var regions:IntHash<IRegion>;
	private var groups:IntHash<RegionGroup>;

	public function new(provider:IHasIdProvider, name:String, spatialPartition:ISpatialPartition, regionIntersecter:IRegionIntersecter)
	{
		this.hasProvider = provider;
		this.id = this.hasProvider.idProvider.requestId();

		this.idProvider = new IdProvider();
		this.name = name;

		this.partitioning = spatialPartition;
		this.regionIntersecter = regionIntersecter;

		this.regions = new IntHash();
		this.groups = new IntHash();
	}

	// IRegion methods
	public function get(id:Int):IRegion
	{
		if ( !this.regions.exists(id) )
			return null;

		return this.regions.get(id);
	}

	public function add(id:Int, region:IRegion):Void
	{
		if (region == null)
			return;

		this.regions.set(id, region);
		this.partitioning.insert(region.getBoundingRectRegion(), id);
	}

	public function remove(id:Int):Void
	{
		if (!this.regions.exists(id))
			return;

		this.partitioning.remove(id);
		this.regions.remove(id);

		if ( this.groups.exists(id) )
			this.groups.remove(id);
	}

	// RegionGroup methods
	public function getGroup(id:Int):RegionGroup
	{
		if ( !this.groups.exists(id) )
			return null;

		return this.groups.get(id);
	}

	public function addGroup(group:RegionGroup):Void
	{
		if (group == null || group == this)
			return;

		this.groups.set(group.id, group);
		this.add(group.id, group);
	}

	public function removeGroup(group:RegionGroup):Void
	{
		if (group == null || !this.groups.exists(group.id))
			return;

		this.groups.remove(group.id);
		this.remove(group.id);
	}

	public function requestRegionsIntersectingPoint(point:Vector2):Array<IRegion>
	{
		var ids:Array<Int> = this.partitioning.requestValuesIntersectingPoint(point);

		var regions:Array<IRegion> = new Array();
		for (id in ids)
		{
			var region:IRegion = this.regions.get(id);
			if (region != null && region.isPointInside(point))
			{
				if ( Std.is(region, RegionGroup) )
					regions.concat( cast(region, RegionGroup).requestRegionsIntersectingPoint(point) );	
				else
					regions.push(region);
			}
		}

		return regions;
	}

	public function requestRegionsIntersectingRegion(region:IRegion):Array<IRegion>
	{
		var ids:Array<Int> = this.partitioning.requestValuesIntersectingRect(region.getBoundingRectRegion());

		var regions:Array<IRegion> = new Array();
		for (id in ids)
		{
			var r:IRegion = this.regions.get(id);
			if (r != null && this.regionIntersecter.isIntersecting(r, region))
			{
				if ( Std.is(r, RegionGroup) )
					regions.concat( cast(r, RegionGroup).requestRegionsIntersectingRegion(region) );	
				else
					regions.push(r);
			}
		}

		return regions;
	}

	public function destroy():Void
	{
		this.hasProvider.idProvider.freeUpId(this);	
	}
}
