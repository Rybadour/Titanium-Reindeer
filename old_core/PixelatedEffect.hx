package titanium_reindeer;

class PixelatedEffect extends BitmapEffect
{
	private var amount:Int;

	public function new(amount:Int)
	{
		super();

		this.amount = amount;
	}

	override public function apply(bitmapData:BitmapData):Void
	{
		if (bitmapData == null)
			return;

		var rows:Int = Math.ceil( bitmapData.height/this.amount );
		var cols:Int = Math.ceil( bitmapData.width/this.amount );
		for (r in 0...rows)
		{
			for (c in 0...cols)
			{ 
				var currentSize:Int = 0;
				var averageRed:Float = 0;
				var averageGreen:Float = 0;
				var averageBlue:Float = 0;
				for (i in 0...this.amount)
				{
					var horizontal:Int = (c*this.amount + i);
					if (horizontal > bitmapData.width)
						continue;

					for (j in 0...this.amount)
					{
						var vertical:Int = (r*this.amount + j);
						if (vertical > bitmapData.height)
							continue;

						var index:Int = (horizontal + vertical*bitmapData.width) * 4;

						if (bitmapData.data[index+3] > 0)
						{
							averageRed += bitmapData.data[index]; 
							averageGreen += bitmapData.data[index+1]; 
							averageBlue += bitmapData.data[index+2]; 

							++currentSize;
						}
					}
				}
				
				for (i in 0...this.amount)
				{
					var horizontal:Int = (c*this.amount + i);
					if (horizontal > bitmapData.width)
						continue;

					for (j in 0...this.amount)
					{
						var vertical:Int = (r*this.amount + j);
						if (vertical > bitmapData.height)
							continue;

						var index:Int = (horizontal + vertical*bitmapData.width) * 4;

						if (bitmapData.data[index+3] > 0)
						{
							bitmapData.data[index] = Utility.clampFloat(averageRed/currentSize, 0, 255);
							bitmapData.data[index+1] = Utility.clampFloat(averageGreen/currentSize, 0, 255);
							bitmapData.data[index+2] = Utility.clampFloat(averageBlue/currentSize, 0, 255);
						}
					}
				}
			} 
		}
	}

	override public function identify():String
	{
		return "Pixelate("+this.amount+");";
	}
}
