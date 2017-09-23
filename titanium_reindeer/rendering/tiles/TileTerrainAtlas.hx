package titanium_reindeer.rendering.tiles;

class TileTerrainAtlas extends UniformTextureAtlas
{
	public static var NORTH      = 1;
	public static var EAST       = 2;
	public static var SOUTH      = 4;
	public static var WEST       = 8;
	public static var NORTH_EAST = 16;
	public static var SOUTH_EAST = 32;
	public static var SOUTH_WEST = 64;
	public static var NORTH_WEST = 128;

	public static function getTileAdjacencyIndex(x:Int, y:Int, mergeCheck:Int -> Int -> Bool):Int
	{
		var mergeKey = 0;
		if (mergeCheck(x, y-1))
			mergeKey |= NORTH;
		if (mergeCheck(x+1, y))
			mergeKey |= EAST;
		if (mergeCheck(x, y+1))
			mergeKey |= SOUTH;
		if (mergeCheck(x-1, y))
			mergeKey |= WEST;
		if (mergeCheck(x+1, y-1))
			mergeKey |= NORTH_EAST;
		if (mergeCheck(x+1, y+1))
			mergeKey |= SOUTH_EAST;
		if (mergeCheck(x-1, y+1))
			mergeKey |= SOUTH_WEST;
		if (mergeCheck(x-1, y-1))
			mergeKey |= NORTH_WEST;
		return mergeKey;
	}


	private var allGenerated:Bool;
	private var generated:Map<Int, Bool>;

	public var baseRendering:Canvas2D -> Void;
	public var edgeRenderings:Array<Canvas2D -> Void>;

	public function new(tileWidth:Int, tileHeight:Int, baseRendering:Canvas2D -> Void, edgeRenderings:Array<Canvas2D -> Void>)
	{
		super(tileWidth, tileHeight);
		this.createCanvas(tileWidth * this.getNumPermutations(), tileHeight);

		this.allGenerated = false;
		this.generated = new Map();

		this.baseRendering = baseRendering;
		this.edgeRenderings = edgeRenderings;
	}

	public function getNumPermutations():Int
	{
		// 8 is derived from the 8 possible adjacent tiles
		return Math.floor(Math.pow(2, 8));
	}

	public function generateAllTerrain():Void
	{
		for (i in 0...this.getNumPermutations())
		{
			this.generateTile(i);
		}
		this.allGenerated = true;
	}

	public function generateTile(index:Int):Void
	{
		var tileRendering = new Canvas2D("tileRendering", this.sourceTileWidth, this.sourceTileHeight);
		this.baseRendering(tileRendering);
		// If north is empty render edge on that side (and so on)
		if (index & NORTH == 0)
			this.edgeRenderings[0](tileRendering);
		if (index & EAST == 0)
			this.edgeRenderings[1](tileRendering);
		if (index & SOUTH == 0)
			this.edgeRenderings[2](tileRendering);
		if (index & WEST == 0)
			this.edgeRenderings[3](tileRendering);

		this.renderCorner(tileRendering, index, NORTH, NORTH_EAST, EAST, this.edgeRenderings[4], this.edgeRenderings[8]);
		this.renderCorner(tileRendering, index, EAST, SOUTH_EAST, SOUTH, this.edgeRenderings[5], this.edgeRenderings[9]);
		this.renderCorner(tileRendering, index, SOUTH, SOUTH_WEST, WEST, this.edgeRenderings[6], this.edgeRenderings[10]);
		this.renderCorner(tileRendering, index, WEST, NORTH_WEST, NORTH, this.edgeRenderings[7], this.edgeRenderings[11]);

		this.imagesCanvas.save();
		this.imagesCanvas.translatef(index * this.sourceTileWidth, 0);
		this.imagesCanvas.renderCanvas(tileRendering);
		this.imagesCanvas.restore();
		this.generated.set(index, true);
	}

	private function renderCorner(tile:Canvas2D, index:Int, left:Int, corner:Int, right:Int, innerRendering:Canvas2D -> Void, outerRendering:Canvas2D -> Void)
	{
		// If both sides are empty around the corner then render the inner
		if ((index & left == 0) && (index & right == 0))
		{
			innerRendering(tile);
		}
		// If both sides are filled but the corner is empty then render the outer
		else if ((index & left != 0) && (index & right != 0) && (index & corner == 0))
		{
			outerRendering(tile);
		}
	}

	public override function renderTexture(canvas:Canvas2D, index:Int, destWidth:Int, destHeight:Int):Void
	{
		if (!this.allGenerated && !this.generated.exists(index))
		{
			this.generateTile(index);
		}

		super.renderTexture(canvas, index, destWidth, destHeight);
	}
}
