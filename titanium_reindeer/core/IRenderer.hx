package titanium_reindeer.core;

interface IRenderer
{
	public var boundingRegion(getBoundingRegion, never):IRegion;
	public function getBoundingRegion():IRegion;
}
