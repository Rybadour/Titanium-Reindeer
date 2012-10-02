package titanium_reindeer.components;

import titanium_reindeer.core.IRenderer;

interface ICanvasRenderer implements IRenderer
{
	public var state(getState, null):CanvasRenderState;
}
