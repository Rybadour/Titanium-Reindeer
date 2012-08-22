package titanium_reindeer.components;

import titanium_reindeer.core.IGroup;
import titanium_reindeer.core.IProvidesIds;

class RegionGroup implements IGroup, implements IRegion
{
	public var idProvider(default, null):IProvidesIds;
	public var id(default, null):Int;
	public var name(default, null):String;

	private var partitioning:ISpatialPartition;
	private var shapeIntersecter:IShapeIntersecter;

	public var shape(getShape, null):IShape;
	public function getShape():IShape
	{
		return partitioning.getBoundingRect();
	}

	private var regions:IntHash<IRegion>;

	public function new(provider:IProvidesIds, name:String, spatialPartition:ISpatialPartition, shapeIntersecter:IShapeIntersecter)
	{
		this.idProvider = provider;
		this.id = this.idProvider.requestId();
		this.name = name;

		this.partitioning = spatialPartition;
		this.shapeIntersecter = shapeIntersecter;

		this.regions = new IntHash();
	}

	public function add(region:IRegion):Void
	{
		if (region.id == null)
			return;

		if ( Std.is(region, RegionGroup) && region == this )
			return;

		this.regions.set(region.id, region);
		this.partitioning.insert(region.shape.getBoundingRect(), region.id);
	}

	public function remove(region:IRegion):Void
	{
		this.partitioning.remove(region.id);
		this.regions.remove(region.id);
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

	public function update(msTimeStep:Int):Void
	{
	}

	public function destroy():Void
	{
		this.idProvider.freeUpId(this);	
	}
}
