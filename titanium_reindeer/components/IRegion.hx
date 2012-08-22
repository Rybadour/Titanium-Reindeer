package titanium_reindeer.components;

import titanium_reindeer.core.IHasId;

interface IRegion implements IHasId
{
	public var shape(getShape, null):IShape;
	public function getShape():IShape;
}
