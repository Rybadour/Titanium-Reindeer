package titanium_reindeer.core;

/**
 * Represents a object who can be identified uniquely but the getKey() function.
 */
interface IUnique<K>
{
	/**
	 * Intended to return a unique key for objects of implementing this interface.
	 */
	public function getKey():K;
}
