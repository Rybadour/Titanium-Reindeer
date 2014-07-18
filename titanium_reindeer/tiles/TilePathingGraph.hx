package titanium_reindeer.tiles;

import titanium_reindeer.ai.pathing.*;

class TilePathingGraph implements IPathNodeGraph<PathNode>
{
	public var tileDefinition:TileMapDefinition;
	public var tilesAsNodes:Array<Array<Bool>>;

	public function new(tileDefinition:TileMapDefinition)
	{
		this.tileDefinition = tileDefinition;
		this.tilesAsNodes = new Array();
	}

	public function setTiles(asNode:Bool, x:Int, y:Int, ?width:Int = 1, ?height:Int = 1)
	{
		for (r in y...y+height)
		{
			for (c in x...x+width)
			{
				this.tilesAsNodes[y][x] = asNode;
			}
		}
	}
	
	public function isWalkable(x:Int, y:Int):Bool
	{
		if (0 > y || y > this.tilesAsNodes.length)
			return false;
		if (this.tilesAsNodes[y] == null || 0 > x || x > this.tilesAsNodes[y].length)
			return false;

		return this.tilesAsNodes[y][x];
	}

	public function getAdjacentNodes(pathNode:PathNode):Array<PathNode>
	{
		var x:Int = Math.round((pathNode.x - tileWidth()/2) % tileWidth());
		var y:Int = Math.round((pathNode.y - tileHeight()/2) % tileHeight());
		
		var adjacent:Array<PathNode> = new Array();
		if (this.isWalkable(x, y))
		{
			if (this.isWalkable(x-1, y))
				adjacent.push(this.tileCenterPoint(x-1, y));
			if (this.isWalkable(x, y-1))
				adjacent.push(this.tileCenterPoint(x-1, y));
			if (this.isWalkable(x+1, y))
				adjacent.push(this.tileCenterPoint(x-1, y));
			if (this.isWalkable(x, y+1))
				adjacent.push(this.tileCenterPoint(x-1, y));
		}
		return adjacent;
	}

	public function tileCenterPoint(x:Int, y:Int):PathNode
	{
		return new PathNode(x * tileWidth() + tileWidth()/2, y * tileHeight() + tileHeight()/2);
	}

	private inline function tileWidth():Int
	{
		return this.tileDefinition.tileWidth;
	}

	private inline function tileHeight():Int
	{
		return this.tileDefinition.tileHeight;
	}
}
