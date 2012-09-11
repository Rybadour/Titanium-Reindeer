package titanium_reindeer.components;

interface IRenderer implements IHasId
{
	public var boundingShape(getBoundingShape, null):IShape;
	public function getBoundingShape():IShape;

	public var worldCenter(getWorldCenter, setWorldCenter):Vector2;
	public var getWorldCenter():Vector2;
	public var setWorldCenter(value:Vector2):Vector2;
}
