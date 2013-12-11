package titanium_reindeer;

class CollisionGroup
{
	public var name(default, null):String;
	private var layer:CollisionLayer;

	public var members(default, null):IntHash<CollisionComponent>;
	private var mCollidingGroups:Hash<CollisionGroup>;
	public var collidingGroups(getCollidingGroups, null):Hash<CollisionGroup>;
	private function getCollidingGroups():Hash<CollisionGroup>
	{
		var groups:Hash<CollisionGroup> = new Hash();
		for (group in this.mCollidingGroups)
		{	
			groups.set(group.name, group);
		}
		return groups;
	}

	public function new(name:String, layer:CollisionLayer)
	{
		this.name = name;
		this.layer = layer;

		this.members = new IntHash();
		this.mCollidingGroups = new Hash();
	}

	// Set the selected group to register collision events for the specified group
	// If the group was set to collide with all this will override it
	public function addCollidingGroup(collidingGroupName:String):Void
	{
		var collidingGroup:CollisionGroup = this.layer.getGroup(collidingGroupName);

		this.mCollidingGroups.set(collidingGroupName, collidingGroup);
	}

	public function removeCollidingGroup(collidingGroupName:String):Void
	{
		var collidingGroup:CollisionGroup = this.layer.getGroup(collidingGroupName);

		if (this.mCollidingGroups.exists(collidingGroupName))
			this.mCollidingGroups.remove(collidingGroupName);
	}

	public function addAllCollidingGroups():Void
	{
		for (group in layer.groups)
		{
			if (!this.mCollidingGroups.exists(group.name))
			{
				this.mCollidingGroups.set(group.name, group);
			}
		}
	}

	public function clearCollidingGroups():Void
	{
		this.mCollidingGroups = new Hash();
	}

	public function destroy():Void
	{
		for (id in members.keys())
		{
			members.remove(id);
		}

		for (groupName in this.mCollidingGroups.keys())
		{
			this.mCollidingGroups.remove(groupName);
		}
	}
}
