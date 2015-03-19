package unit_testing.ai;

import titanium_reindeer.ai.pathing.*;
import titanium_reindeer.tiles.*;

class PathingTests extends haxe.unit.TestCase
{
	public var testGraph:TilePathingGraph;
	public var routeFinder:RouteFinder<PathNode>;

	public override function setup()
	{
		var definition = new TileMapDefinition();
		definition.orientation = TileMapOrientation.Orthogonal;
		definition.width = 10;
		definition.height = 10;
		definition.tileWidth = 2;
		definition.tileHeight = 2;
		this.testGraph = new TilePathingGraph(definition);

		// Make whole graph open first
		this.testGraph.setTiles(true, 0, 0, 5, 5);
		// Make a wall at the top
		this.testGraph.setTiles(false, 0, 1, 4, 1);
	}

	public function testAStar()
	{
		assertTrue(this.testGraph.isWalkable(4, 1));
		assertFalse(this.testGraph.isWalkable(3, 1));
		assertTrue(this.testGraph.isWalkable(3, 2));

		var routeA = RoutingAlgorithms.aStar(new PathNode(1, 1), new PathNode(7, 5), this.testGraph);
		assertTrue(this.areNodesTheSame(routeA, [
			new PathNode(1, 1),
			new PathNode(3, 1),
			new PathNode(5, 1),
			new PathNode(7, 1),
			new PathNode(9, 1),
			new PathNode(9, 3),
			new PathNode(9, 5),
			new PathNode(7, 5),
		], true));

		// TODO: More cases to show that shorter paths are preferred
	}

	private function areNodesTheSame(route:Array<PathNode>, testArray:Array<PathNode>, print:Bool)
	{
		if (route.length != testArray.length)
		{
			if (print)
			{
				this.print("Failed during length check");
				this.print(route);
				this.print(testArray);
			}
			return false;
		}

		var i = 0;
		for (node in route)
		{
			var testNode = testArray.shift();

			if (Math.floor(node.x) != testNode.x || Math.floor(node.y) != testNode.y)
			{
				if (print)
				{
					this.print("Failed during step "+i+", ("+node.x+","+node.y+") against ("+testNode.x+", "+testNode.y+")");
				}
				return false;
			}
		}
		return true;
	}
}
