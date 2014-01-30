package titanium_reindeer.core;

// TODO: The key type should be determined by a type parameter
class UniqueEntityGroup<E:IUnique<Int>>
{
	private var entities:Map<Int, E>;
	private var nextId:Int;

	public function new()
	{
		this.entities = new Map();
		this.nextId = 0;
	}

	public function getNextId():Int
	{
		return this.nextId++;
	}

	public function add(entity:E):Void
	{
		this.entities.set(entity.getKey(), entity);
	}

	public function exists(entity:E):Bool
	{
		return this.entities.exists(entity.getKey());
	}

	public function remove(entity:E):Void
	{
		this.entities.remove(entity.getKey());
	}
}
