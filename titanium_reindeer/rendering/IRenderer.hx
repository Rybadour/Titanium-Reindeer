package titanium_reindeer.rendering;

import titanium_reindeer.spatial.IRegion;

interface IRenderer
{
	public var boundingRegion(get, never):IRegion;
	public function get_boundingRegion():IRegion;
}
