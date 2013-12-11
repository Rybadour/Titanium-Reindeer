package titanium_reindeer.components;

class CollisionReporter implements IHasUpdaterAndId
{
	public var id(default, null):Int;
	public var updater(default, null):Updater;

	private var region:IRegion;
	private var collidingGroups:Array<RegionGroup>;
	private var overlappingRegions:IntHash<IRegion>;
	private var enterFunc:IRegion -> IRegion -> Void;
	private var exitFunc:IRegion -> IRegion -> Void;

	public function new(provider:IHasIdProvider, region:IRegion, collidingGroups:Array<RegionGroup>, 
		onEnter:IRegion -> IRegion -> Void, onExit:IRegion -> IRegion -> Void)
	{
		this.id = provider.requestId();
		this.updater = new Updater(null, update, null);

		this.region = region;
		this.collidingGroups = new Array();
		if (this.collidingGroups != null)
		{
			for (group in collidingGroups)
				this.collidingGroups.push(group);
		}

		this.enterFunc = onEnter;
		this.exitFunc = onExit;
	}

	public function isColliding(region:IRegion):Bool
	{
		return this.overlappingRegions.exists(region.id);
	}

	private function update(msTimeStep:Int):Void
	{
		var intersectingRegions:IntHash<IRegion>;
		for (group in this.collidingGroups)
		{
			intersectingRegions = new IntHash();
			for (region in group.requestRegionsIntersectingShape(this.region.shape))
			{
				intersectingRegions.set(region.id, region);

				if (this.enterFunc != null && !this.overlappingRegions.exists(region.id))
				{
					this.enterFunc(this.region, region);
					this.overlappingRegions.set(region.id, region);
				}
			}

			if (this.exitFunc == null)
				continue;

			for (region in this.overlappingRegions)
			{
				if ( !intersectingRegions.exists(region.id) )
				{
					this.exitFunc(this.region, region);
					this.overlappingRegions.remove(region.id);
				}
			}
		}
	}
}
