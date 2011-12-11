package titanium_reindeer;

class TrieNode<T>
{
	public var prefix:String;
	public var value(default, setValue):T;
	private function setValue(value:T):T
	{
		this.value = value;
		this.isSet = true;

		return value;
	}

	public var isSet(default, null):Bool;

	public var children:IntHash<TrieNode<T>>;

	public function new()
	{
		children = new IntHash();
	}

	public function unSet():Void
	{
		this.value = null;
		this.isSet = false;
	}
}

class TrieDict<T>
{
	private var root:TrieNode<T>;

	public function new()
	{
		root = new TrieNode();
	}

	public function set(key:String, value:T):Void
	{
		var node:TrieNode<T> = this.root;

		for (i in 0...key.length)
		{
			if (node.children.get(key.charCodeAt(i)) == null)
				node.children.set(key.charCodeAt(i), new TrieNode());

			node = node.children.get(key.charCodeAt(i)); 
		}

		node.value = value;
	}

	public function exists(key:String):Bool
	{
		var node:TrieNode<T> = this.root;

		for (i in 0...key.length)
		{
			if (node.children.get(key.charCodeAt(i)) == null)
				return false;

			node = node.children.get(key.charCodeAt(i)); 
		}

		return node.isSet;
	}

	public function get(key:String):T
	{
		var node:TrieNode<T> = this.root;

		for (i in 0...key.length)
		{
			if (node.children.get(key.charCodeAt(i)) == null)
				return null;

			node = node.children.get(key.charCodeAt(i)); 
		}

		return node.isSet ? node.value : null;
	}

	public function remove(key:String):Bool
	{
		var node:TrieNode<T> = this.root;

		for (i in 0...key.length)
		{
			if (node.children.get(key.charCodeAt(i)) == null)
				return false;

			node = node.children.get(key.charCodeAt(i)); 
		}

		if (node.isSet)
		{
			node.unSet();
			return true;
		}
		
		return false;
	}

	public function getValues():Array<T>
	{
		var values:Array<T> = getValuesRecursive(root);	
		if (root.value != null)
			values.push(root.value);
		return values;
	}

	private function getValuesRecursive(node:TrieNode<T>):Array<T>
	{
		var values:Array<T> = new Array();

		if (node.children != null)
		{
			for (child in node.children)
			{
				if (child.value != null)
					values.push(child.value);
				values = values.concat( getValuesRecursive(child) );
			}
		}

		return values;
	}

	public function destroy():Void
	{
		this.recursiveNodeDestroy(root);
		this.root = null;
	}

	private function recursiveNodeDestroy(node:TrieNode<T>):Void
	{
		for (childChar in node.children.keys())
		{
			this.recursiveNodeDestroy(node.children.get(childChar));
			node.children.remove(childChar);
		}
		node.children = null;
	}
}
