package titanium_reindeer.tiles;

import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.ai.pathing.*;

typedef TileCoords = {
	x:Int,
	y:Int
};

class TilePathingGraph implements IPathNodeGraph<PathNode>
{
	public var tileDefinition:TileMapDefinition;
	public var tilesAsNodes:Array<Array<Bool>>;

	public function new(tileDefinition:TileMapDefinition)
	{
		this.tileDefinition = tileDefinition;
		this.tilesAsNodes = new Array();
		this.resize();
	}

	private function resize():Void
	{
		for (r in 0...this.tileDefinition.height)
		{
			this.tilesAsNodes.push(new Array());
		}
	}

	public function setTiles(asNode:Bool, x:Int, y:Int, ?width:Int = 1, ?height:Int = 1)
	{
		for (r in y...y+height)
		{
			if (this.tilesAsNodes[r] == null)
				this.tilesAsNodes[r] = new Array();

			for (c in x...x+width)
			{
				this.tilesAsNodes[r][c] = asNode;
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
		var c = this.getTileCoordsFromPoint(pathNode);
		var x = c.x;
		var y = c.y;
		
		var adjacent:Array<PathNode> = new Array();
		if (this.isWalkable(x, y))
		{
			if (this.isWalkable(x-1, y))
				adjacent.push(this.tileCenterPoint(x-1, y));
			if (this.isWalkable(x, y-1))
				adjacent.push(this.tileCenterPoint(x, y-1));
			if (this.isWalkable(x+1, y))
				adjacent.push(this.tileCenterPoint(x+1, y));
			if (this.isWalkable(x, y+1))
				adjacent.push(this.tileCenterPoint(x, y+1));
		}
		return adjacent;
	}

	public function tileCenterPoint(x:Int, y:Int):PathNode
	{
		return new PathNode(x * tileWidth() + tileWidth()/2, y * tileHeight() + tileHeight()/2);
	}
	
	public function getClosestNode(point:Vector2):PathNode
	{
		return new PathNode(
			Math.round((point.x - tileWidth()/2) / tileWidth()) * tileWidth() + tileWidth()/2,
			Math.round((point.y - tileHeight()/2) / tileHeight()) * tileHeight() + tileHeight()/2
		);
	}

	public function getTileCoordsFromPoint(p:Vector2):TileCoords
	{
		var x:Int = Math.round( (p.x - this.tileWidth()/2) / this.tileWidth() );
		var y:Int = Math.round( (p.y - this.tileHeight()/2) / this.tileHeight() );
		return {x: x, y: y};
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
