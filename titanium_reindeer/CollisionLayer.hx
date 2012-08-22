package titanium_reindeer;

import titanium_reindeer.components.ISpatialPartition;

// Each layer of collision components may collide with each other.
// Groups of them are set and the developer chooses which group to make collide with which other
class CollisionLayer
{
	public var manager(default, null):CollisionComponentManager;
	public var name(default, null):String;

	private var componentsPartition:ISpatialPartition;
	public var groups(default, null):Hash<CollisionGroup>;

	private var debugView:Bool;

	public function new(manager:CollisionComponentManager, name:String)
	{
		this.manager = manager;
		this.name = name;

		this.componentsPartition = new BinPartition(10, new Vector2(-20, -20), 1000, 1000);
		this.groups = new Hash();

		this.debugView = false;
	}

	// If the group doesn't exist it's created
	public function getGroup(groupName:String):CollisionGroup
	{
		if (this.groups.exists(groupName))
			return this.groups.get(groupName);
		else
		{
			var group = new CollisionGroup(groupName, this);
			this.groups.set(groupName, group);
			return group;
		}
	}

	// Retrieves probable ids from the RTree and then does more accurate checks on the components themselves
	public function getIdsIntersectingPoint(point:Vector2):Array<Int>
	{
		var ids:Array<Int> = componentsPartition.requestValuesIntersectingPoint(point);

		var collidingIds:Array<Int> = new Array();
		for (id in ids)
		{
			var component:CollisionComponent = manager.getComponent(id);
			if (component != null && component.isPointIntersecting(point))
			{
				collidingIds.push(id);
			}
		}

		return collidingIds;
	}

	// Retrieves probable ids from the RTree and then does more accurate checks on the components themselves
	/*
	public function getIdsIntersectingRect(rect:Rect):Array<Int>
	{
		var ids:Array<Int> = componentsPartition.getRectIntersectingValues(rect);

		var collidingIds:Array<Int> = new Array();
		for (id in ids)
		{
			var component:CollisionComponent = manager.getComponent(id);
			if (component != null && component.isRectIntersecting(rect))
			{
				collidingIds.push(id);
			}
		}

		return collidingIds;
	}
	*/

	// Internal functions only
	public function addComponent(component:CollisionComponent):Void
	{
		var group:CollisionGroup = this.getGroup(component.groupName);

		if (group.members.exists(component.id))
			trace("---ERROR---: component id "+component.id+" already exists in group "+component.groupName+"!");
		else
		{
			group.members.set(component.id, component);
			this.componentsPartition.insert(component.getMinBoundingRect(), component.id);
		}
	}

	public function updateComponent(component:CollisionComponent):Void
	{
		this.componentsPartition.update(component.getMinBoundingRect(), component.id);
	}

	public function removeComponent(component:CollisionComponent):Void
	{
		var group:CollisionGroup = this.getGroup(component.groupName);
		group.members.remove(component.id);
		this.componentsPartition.remove(component.id);
	}

	public function enableDebugView(debugCanvas:String, debugOffset:Vector2)
	{
		this.debugView = true;
		this.componentsPartition.debugCanvas = debugCanvas;
		this.componentsPartition.debugOffset = debugOffset;
	}

	public function update():Void
	{
		for (group in this.groups)
		{
			for (component in group.members)
			{
				var collidingIds:Array<Int> = this.componentsPartition.requestValuesIntersectingRect(component.getMinBoundingRect());  
				for (id in collidingIds)
				{
					// Only reguster a collision if it isn't colliding with itself
					if (id == component.id)
						continue;

					var found:Bool = false;
					for (collidingGroup in group.collidingGroups)
					{
						if (collidingGroup.members.exists(id))
						{
							found = true;
							break;
						}
					}

					if (found)
						component.collide(id);
				}
			}
		}

		if (this.debugView)
		{
			this.componentsPartition.drawDebug();
		}
	}

	public function destroy():Void
	{
		for (groupName in this.groups.keys())
		{
			this.groups.get(groupName).destroy();
			this.groups.remove(groupName);
		}
		this.groups = null;

		this.manager = null;
	}
}
