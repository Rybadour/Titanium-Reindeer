package titanium_reindeer;

class ObjectManager
{
	private var nextId:Int;

	private var objects:IntHash<ManagedObject>;
	private var objectsToRemove:IntHash<Int>;

	public function new()
	{
		this.nextId = 0;

		this.objects = new IntHash();
	}

	public function getNextId():Int
	{
		return nextId++;
	}

	private function getObject(id:Int):ManagedObject
	{
		if (objects.exists(id))
			return objects.get(id);
		else
			return null;
	}

	public function objectIdExists(id:Int):Bool
	{
		return objects.exists(id);
	}

	private function addObject(object:ManagedObject):Void
	{
		object.setManager(this);

		objects.set(object.id, object);
	}

	private function removeObject(obj:ManagedObject):Void
	{
		if (objectsToRemove == null)
			objectsToRemove = new IntHash();

		if (objects.exists(obj.id) && !objectsToRemove.exists(obj.id))
			objectsToRemove.set(obj.id, obj.id);
	}

	public function removeObjects():Void
	{
		if (objectsToRemove != null && Lambda.count(objectsToRemove) > 0)
		{
			for (objId in objectsToRemove)
			{
				var obj:ManagedObject = objects.get(objId);
				if (obj.toBeDestroyed)
				{
					obj.finalDestroy();

					objects.remove(objId);
					objectsToRemove.remove(objId);
				}
			}
		}
	}

	public function destroy():Void
	{
		for (i in objects.keys())
		{
			objects.get(i).destroy();
			objects.remove(i);
		}
		objects = null;

		for (i in objectsToRemove.keys())
		{
			objectsToRemove.remove(i);
		}
		objectsToRemove = null;
	}
}
