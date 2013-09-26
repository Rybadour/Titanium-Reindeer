package titanium_reindeer.rendering;

import titanium_reindeer.ai.pathing.PathNode;
import titanium_reindeer.ai.pathing.IPathNodeGraph;

class PathNodeGraphRenderer<T:PathNode, S:IRenderState> extends CanvasRenderer<CanvasRenderState>
{
	public var startNode:T;
	public var graph(default, null):IPathNodeGraph<T>;
	public var nodeRenderer(default, null):CanvasRenderer<S>;
	public var edgeState(default, null):StrokeFillState;
	private var visitedMap:Map<String, T>;

	public function new(startNode:T, graph:IPathNodeGraph<T>, nodeRenderer:CanvasRenderer<S>, edgeState:StrokeFillState)
	{
		super(new CanvasRenderState());

		this.startNode = startNode;
		this.graph = graph;
		this.nodeRenderer = nodeRenderer;
		this.edgeState = edgeState;
	}

	private function resetVisited():Void
	{
		this.visitedMap = new Map();
	}

	private function visit(node:T):Void
	{
		this.visitedMap.set(node.x+','+node.y, node);
	}

	private function isVisited(node:T):Bool
	{
		return this.visitedMap.exists(node.x+','+node.y);
	}

	private override function _render(canvas:Canvas2D):Void
	{
		this.resetVisited();

		// TODO: Throw exception if start node is not defined
		// Render nodes and edges
		this.renderGraphNode(canvas, this.graph, this.startNode);
	}

	private function renderGraphNode(canvas:Canvas2D, graph:IPathNodeGraph<T>, node:T):Void
	{
		this.visit(node);
		for (newNode in graph.getAdjacentNodes(node))
		{
			if (!this.isVisited(newNode))
			{
				canvas.ctx.save();
				edgeState.apply(canvas);
				canvas.ctx.beginPath();
				canvas.moveTo(node);
				canvas.lineTo(newNode);
				canvas.ctx.stroke();
				canvas.ctx.restore();

				this.renderGraphNode(canvas, graph, newNode);
			}
		}

		canvas.ctx.save();
		canvas.translate(node);
		this.nodeRenderer.render(canvas);
		canvas.ctx.restore();
	}
}
