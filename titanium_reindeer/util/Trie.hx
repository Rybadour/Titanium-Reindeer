package titanium_reindeer.util;

import Map;

/**
 * My implementation of the Trie data structure. It has several advantages over other key value
 * mappings and is very simple to implement and can be sorted very easily.
 */
class Trie<T> implements IMap<String, T>
{
	/**
	 * The root node of the trie.
	 * Should have no value or prefix.
	 */
	private var root:TrieNode<T>;

	public function new()
	{
		this.root = {prefix: "", children: new Array(), valueExists: {exists: false, value: null}};
	}

	/**
	 * Returns true if the specified key is found within the Trie, and false otherwise;
	 */
	public function exists(k:String):Bool
	{
		var node = this.recursiveFind(k, this.root);
		if ( node == null )
			return false;
		return node.valueExists.exists;
	}
	
	/**
	 * Retrieve the value of the specified key.
	 * Returns null if the key was not found.
	 */
	public function get(k:String):T
	{
		var node = this.recursiveFind(k, this.root);
		if ( node == null || !node.valueExists.exists )
			return null;
		return node.valueExists.value;
	}

	/**
	 * Returns the values stored at the leaves of the Trie.
	 */
	public function iterator():Iterator<T>
	{
		var pairs = this.recursiveFold(this.root);
		var result:Array<T> = new Array();
		for (pair in pairs)
			result.push(pair.value);
		return result.iterator();
	}

	/**
	 * Returns the keys of the Trie. This requires recursing through the whole structure while
	 * appending each node's prefix to it's children.
	 */
	public function keys():Iterator<String>
	{
		var pairs = this.recursiveFold(this.root);
		var result:Array<String> = new Array();
		for (pair in pairs)
			result.push(pair.key);
		return result.iterator();
	}

	/**
	 * If the key is found it's associated value is remove from the Trie.
	 * Returns true if the key was found, false otherwise.
	 */
	public function remove(k:String):Bool
	{
		var node = this.recursiveFind(k, this.root);
		if ( node == null || !node.valueExists.exists )
			return false;

		node.valueExists.exists = false;
		node.valueExists.value = null;
		
		return true;
	}

	/**
	 * Adds or changes the value of a given key. For new keys more nodes maybe be generated
	 * internally.
	 */
	public function set(k:String, v:T):Void
	{
		var node = this.recursiveFind(k, this.root, true);
		node.valueExists.exists = true;
		node.valueExists.value = v;
	}

	/**
	 * Returns the keys and values of the Trie like JSON.
	 */
	public function toString():String
	{
		var pairs = this.recursiveFold(this.root);
		var result_pairs = new Array();
		for (pair in pairs)
			result_pairs.push(pair.key+':'+pair.value);
		return '{'+(result_pairs.join(','))+'}';
	}

	/**
	 * Search the trie for a node matching exactly the given str key.
	 * If createWhileSearching is true a non-matching search will generate a new path for the string
	 * key.
	 */
	private function recursiveFind(str:String, node:TrieNode<T>, ?createWhileSearching:Bool = false):TrieNode<T>
	{
		var matched:Bool = true;
		if (node.prefix != '')
		{
			if ( str.indexOf(node.prefix) == 0 )
				str = StringTools.replace(str, node.prefix, '');
			else
				matched = false;
		}

		if (matched)
		{
			// Base case, str will get trimmed until it's empty
			if ( str == '' )
			{
				// Existance check requires non-null value
				return node;
			}
			else
			{
				// Recursive step
				for (child in node.children)
				{
					var tuple = this.recursiveFind(str, child);
					if ( tuple.valueExists.exists )
						return tuple;
				}
			}
		}

		// If we need to generate a new path while searching
		if ( createWhileSearching )
		{
			// Make a new node for every character in the string left over
			var newNode = null;
			for (c in 0...str.length)
			{
				var newNode = {prefix: str.charAt(c), children: new Array(), valueExists: {exists: false, value: null}};
				node.children.push(newNode);
				// Previous parent
				node = newNode;
			}
			return newNode;
		}

		// If no matching child paths trim str to empty then fallback to null
		return null;
	}

	/**
	 * Returns a list of key-value pairs of the entire trie using a depth first traversal.
	 */
	private function recursiveFold(node:TrieNode<T>, ?prefix:String = ''):Array<TrieKeyValue<T>>
	{
		var list = new Array();
		prefix += node.prefix;

		// This node might have a value itself
		if (node.valueExists.exists)
			list.push({key: prefix, value: node.valueExists.value});

		for (child in node.children)
		{
			var subList = this.recursiveFold(child, prefix);
			list = list.concat(subList);
		}

		return list;
	}
}

typedef TrieNode<T> = {
	var prefix:String;
	var children:Array<TrieNode<T>>;
	var valueExists:ExistsTuple<T>;
}

typedef ExistsTuple<T> = {
	var exists:Bool;
	var value:T;
}

typedef TrieKeyValue<T> = {
	var key:String;
	var value:T;
}
