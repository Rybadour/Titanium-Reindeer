package unit_testing.util;

import titanium_reindeer.util.Trie;

class TrieTests extends haxe.unit.TestCase
{
	private var trie:Trie<Int>;

	public override function setup()
	{
		this.trie = new Trie();

		this.trie.set("", 0);
		this.trie.set("r", 2);
		this.trie.set("ryan", 23);
		this.trie.set("bob", 70);
	}

	public function testExists()
	{
		assertTrue(this.trie.exists("ryan"));
		assertFalse(this.trie.exists("bobert"));
		assertTrue(this.trie.exists("bob"));
	}

	public function testInserts()
	{
		this.trie.set("ryguy", 14);
		this.trie.set("rybadour", 2135);
		this.trie.set("bobcat", 2);

		this.trie.set("ashley", 6);
		this.trie.set("ashley", 15);
	}
}
