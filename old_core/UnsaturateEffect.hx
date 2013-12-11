package titanium_reindeer;

class UnsaturateEffect extends BitmapEffect
{
	override public function apply(bitmapData:BitmapData):Void
	{
		if (bitmapData == null)
			return;

		for (r in 0...bitmapData.height)
		{
			for (c in 0...bitmapData.width)
			{ 
				var index:Int = (r*bitmapData.width + c) * 4;

				var red:Int = bitmapData.data[index]; 
				var green:Int = bitmapData.data[index+1]; 
				var blue:Int = bitmapData.data[index+2]; 

				var average:Int = Math.round((red+green+blue)/3); 

				bitmapData.data[index] = average; 
				bitmapData.data[index+1] = average; 
				bitmapData.data[index+2] = average; 
			} 
		}
	}

	override public function identify():String
	{
		return "Unsaturate();";
	}
}
