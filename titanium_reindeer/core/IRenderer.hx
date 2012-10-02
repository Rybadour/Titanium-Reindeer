package titanium_reindeer.core;

interface IRenderer
{
	public var boundingShape(getBoundingShape, null):IShape;
	public function getBoundingShape():IShape;
}
