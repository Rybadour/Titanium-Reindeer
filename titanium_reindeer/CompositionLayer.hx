package titanium_reindeer;

import titanium_reindeer.Enums;

class CompositionLayer
{
	public var renderer(default, null):RendererComponent;
	public var renderComposition(default, null):Composition;

	public function new(renderer:RendererComponent, ?composition:Composition)
	{
		this.renderer = renderer;
		this.renderComposition = (composition == null ? Composition.SourceOver : composition);
	}
}
