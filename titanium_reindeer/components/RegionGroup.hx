package titanium_reindeer.components;

import titanium_reindeer.core.IGroup;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IdProvider;

class RegionGroup implements IGroup<IRegion>, implements IRegion
{
	private var hasProvider:IHasIdProvider;

	public var id(default, null):Int;
	public var idProvider(default, null):IdProvider;
	public var name(default, null):String;

	private var partitioning:ISpatialPartition;
	private var shapeIntersecter:IShapeIntersecter;

	public var shape(getShape, null):IShape;
	public function getShape():IShape
	{
		return partitioning.getBoundingRect();
	}

	private var regions:IntHash<IRegion>;
	private var groups:IntHash<RegionGroup>;

	public function new(provider:IHasIdProvider, name:String, spatialPartition:ISpatialPartition, shapeIntersecter:IShapeIntersecter)
	{
		this.hasProvider = provider;
		this.id = this.hasProvider.idProvider.requestId();

		this.idProvider = new IdProvider();
		this.name = name;

		this.partitioning = spatialPartition;
		this.shapeIntersecter = shapeIntersecter;

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

	public function add(region:IRegion):Void
	{
		if (region == null || region.id == null)
			return;

		this.regions.set(region.id, region);
		this.partitioning.insert(region.shape.getBoundingRect(), region.id);
	}

	public function remove(region:IRegion):Void
	{
		if (region == null || !this.regions.exists(region.id))

		this.partitioning.remove(region.id);
		this.regions.remove(region.id);

		if ( this.groups.exists(region.id) )
			this.groups.remove(region.id);
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
		this.add(group);
	}

	public function removeGroup(group:RegionGroup):Void
	{
		if (group == null || !this.groups.exists(group.id))
			return;

		this.groups.remove(group.id);
		this.remove(group);
	}

	public function requestRegionsIntersectingPoint(point:Vector2):Array<IRegion>
	{
		var ids:Array<Int> = this.partitioning.requestValuesIntersectingPoint(point);

		var regions:Array<IRegion> = new Array();
		for (id in ids)
		{
			var region:IRegion = this.regions.get(id);
			if (region != null && region.shape.isPointInside(point))
			{
				if ( Std.is(region, RegionGroup) )
					regions.concat( cast(region, RegionGroup).requestRegionsIntersectingPoint(point) );	
				else
					regions.push(region);
			}
		}

		return regions;
	}

	public function requestRegionsIntersectingShape(shape:IShape):Array<IRegion>
	{
		var ids:Array<Int> = this.partitioning.requestValuesIntersectingRect(shape.getBoundingRect());

		var regions:Array<IRegion> = new Array();
		for (id in ids)
		{
			var region:IRegion = this.regions.get(id);
			if (region != null && this.shapeIntersecter.isIntersecting(region.shape, shape))
			{
				if ( Std.is(region, RegionGroup) )
					regions.concat( cast(region, RegionGroup).requestRegionsIntersectingShape(shape) );	
				else
					regions.push(region);
			}
		}

		return regions;
	}

	public function destroy():Void
	{
		this.hasProvider.idProvider.freeUpId(this);	
	}
}
