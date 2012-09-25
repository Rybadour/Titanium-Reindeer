package titanium_reindeer;

import titanium_reindeer.core.FastRect;
import titanium_reindeer.core.RectRegion;
import titanium_reindeer.core.ISpatialPartition;

class BinCoord
{
	public var x:Int;
	public var y:Int;
	
	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}
}

class Bin
{
	public var items:IntHash<Item>;

	public function new()
	{
		this.items = new IntHash();
	}

	public function addItem(item:Item):Void
	{
		this.items.set(item.value, item);
	}

	public function removeItem(value:Int):Void
	{
		this.items.remove(value);
	}
}

class Item
{
	public var bins:Array<Bin>;
	public var bounds:FastRect;
	public var value:Int;

	public function new(bins:Array<Bin>, bounds:FastRect, value:Int)
	{
		this.bins = bins;
		this.bounds = bounds;
		this.value = value;
	}
}

class BinPartition implements ISpatialPartition
{
	private var binSize:Int;
	private var originOffset:Vector2;
	private var width:Int;
	private var height:Int;

	private var bins:Array<Array<Bin>>;
	private var valueMap:IntHash<Item>;

	public function getBoundingRegion():RectRegion
	{
		var width:Float = binSize * width;
		var heigth:Float = binSize * height;

		return new RectRegion(width, height, originOffset.subtract( new Vector2(width/2, height/2) ));
	}

	public var debugCanvas:String;
	public var debugOffset:Vector2;
	public var debugSteps:Bool;

	public function new(binSize:Int, originOffset:Vector2, width:Int, height:Int)
	{
		this.binSize = binSize;
		this.originOffset = originOffset == null ? new Vector2(0, 0) : originOffset;
		this.width = width;
		this.height = height;

		this.bins = new Array();
		this.valueMap = new IntHash();
	}

	private function getBinsIntersectingRect(rect:FastRect):Array<Bin>
	{
		var collidingBins:IntHash<Int> = new IntHash();

		// Simple constant lookup
		if (rect.width < this.binSize && rect.height < this.binSize)
		{
			// Find the bins that the corners of this rect hit
			// Since it's smaller than the bin size there can only be a maximum of 4 bins it hits
			collidingBins.set( this.getBinIndex(new Vector2(rect.left, rect.top)), 1 );
			collidingBins.set( this.getBinIndex(new Vector2(rect.right, rect.top)), 1 );
			collidingBins.set( this.getBinIndex(new Vector2(rect.left, rect.bottom)), 1 );
			collidingBins.set( this.getBinIndex(new Vector2(rect.right, rect.bottom)), 1 );
		}
		// Search all bins inside a subregion of the total space
		else
		{
			var topLeft:BinCoord = this.getBinCoord(new Vector2(rect.left, rect.top));
			var topRight:BinCoord = this.getBinCoord(new Vector2(rect.right, rect.top));
			var bottomLeft:BinCoord = this.getBinCoord(new Vector2(rect.left, rect.bottom));

			for (x in topLeft.x...topRight.x+1)
			{
				for (y in topLeft.y...bottomLeft.y+1)
					collidingBins.set( indexFromCoord(x, y), 1 );
			}
		}

		var bins:Array<Bin> = new Array();
		var binCoord:BinCoord;
		for (index in collidingBins.keys())
			bins.push( this.getBin(coordFromIndex(index)) );

		return bins;
	}
	
	private function getBinCoord(p:Vector2):BinCoord
	{
		var coord:Vector2 = p.subtract(this.originOffset);

		return new BinCoord(Math.floor(coord.x/this.binSize), Math.floor(coord.y/this.binSize));
	}

	// Get the index of a specific bin if numbering when left to right
	// And top to bottom
	private function getBinIndex(p:Vector2):Int
	{
		var binCoord:BinCoord = this.getBinCoord(p);
		
		return binCoord.x + binCoord.y*this.binSize;
	}

	// Get the index of a specific bin if numbering when left to right
	// And top to bottom
	private function coordFromIndex(index:Int):BinCoord
	{
		return new BinCoord(index%this.binSize, Math.floor(index/this.binSize));
	}

	private function indexFromCoord(x:Int, y:Int):Int
	{
		return x + y*this.binSize;
	}

	private function getBin(binCoord:BinCoord):Bin
	{
		// TODO: Expand up
		if (binCoord.x < 0 || binCoord.y < 0)
		{
			return null;
		}

		// TODO: Expand down
		if (binCoord.x > this.width || binCoord.y > this.height)
		{
			return null;
		}

		// Make the row if it doesn't exist
		if (this.bins[binCoord.y] == null)
		{
			this.bins[binCoord.y] = new Array();
			this.bins[binCoord.y][binCoord.x] = new Bin();
		}
		// Make a bin if it doesn't exist
		else if (this.bins[binCoord.y][binCoord.x] == null)
		{
			this.bins[binCoord.y][binCoord.x] = new Bin();
		}

		return this.bins[binCoord.y][binCoord.x];
	}

	public function insert(rect:RectRegion, value:Int):Void
	{
		if (rect == null)
			return;

		var fr:FastRect = FastRect.fromRectRegion(rect);

		// Iterate over all the bins this rect collides with an insert it into them
		var bins:Array<Bin> = this.getBinsIntersectingRect(fr);
		var item:Item = new Item(bins, fr, value);
		for (bin in bins)
			bin.addItem(item);

		this.valueMap.set(value, item);
	}

	public function update(newBounds:RectRegion, value:Int):Void
	{
		if (newBounds == null || !this.valueMap.exists(value))
			return;

		this.remove(value);

		this.insert(newBounds, value);
	}

	public function remove(value:Int):Void
	{
		if (!this.valueMap.exists(value))
			return;

		// Remove the value from the old bins
		for (bin in this.valueMap.get(value).bins)
			bin.removeItem(value);
		this.valueMap.remove(value);
	}

	public function requestValuesIntersectingRect(rect:RectRegion):Array<Int>
	{
		if (rect == null)
			return new Array();

		var fr:FastRect = FastRect.fromRectRegion(rect);

		var items:IntHash<Bool> = new IntHash();
		var results:Array<Int> = new Array();
		for (bin in this.getBinsIntersectingRect(fr))
		{
			for (item in bin.items)
			{
				if ( !items.exists(item.value) && FastRect.isIntersecting(item.bounds, fr) )
				{
					items.set(item.value, true);
					results.push(item.value);
				}
			}
		}

		return results;
	}

	public function requestValuesIntersectingPoint(point:Vector2):Array<Int>
	{
		if (point == null)
			return new Array();

		var results:Array<Int> = new Array();
		var binCoord:BinCoord = this.getBinCoord(point);
		for (item in this.getBin(binCoord).items)
		{
			if ( item.bounds.isPointInside(point) )
				results.push(item.value);
		}

		return results;
	}

	public function drawDebug():Void
	{
	}
}
