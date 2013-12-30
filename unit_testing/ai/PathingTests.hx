package unit_testing.ai;

import titanium_reindeer.ai.pathing.*;

class PathingTests extends haxe.unit.TestCase
{
	//public var stupidGraph(default, null):StupidGraph;
	//public var linearGraph(default, null):LinearGraph;
	//public var complexGraph(default, null):ComplexGraph;

	public var a:PathNode;
	public var b:PathNode;
	public var c:PathNode;
	public var d:PathNode;
	public var e:PathNode;
	public var f:PathNode;
	public var g:PathNode;

	public override function setup()
	{
		this.a = new PathNode(0, 0);
		this.b = new PathNode(-10, -10);
		this.c = new PathNode(10, 10);
		this.d = new PathNode(20, 10);
		this.e = new PathNode(30, 10);
		this.f = new PathNode(100, 100);
		this.g = new PathNode(130, 132);

		//this.stupidGraph = new StupidGraph([a, b, c, d, e, f, g]);
		//this.linearGraph = new LinearGraph([a, b, c, d, e, f, g]);
		//this.complexGraph = new ComplexGraph();
		// TODO: Add connections
	}

	public function testAStar()
	{
	}

	public function testWayPointsGraph()
	{
	}
}
