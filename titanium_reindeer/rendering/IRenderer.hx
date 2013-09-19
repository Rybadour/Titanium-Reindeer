package titanium_reindeer.rendering;

import titanium_reindeer.spatial.IRegion;

interface IRenderer
{
	public var boundingRegion(getBoundingRegion, never):IRegion;
	public function getBoundingRegion():IRegion;
}
