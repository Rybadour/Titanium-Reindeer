package titanium_reindeer;

class BitmapData
{
	public var rawData(default, null):Dynamic;

	public var data(getData, null):Dynamic;
	private function getData():Dynamic
	{
		// Looks stupid, I know, but trust me it makes sense
		return rawData.data;
	}

	public var width(getWidth, never):Int;
	private function getWidth():Int
	{
		return rawData.width;
	}

	public var height(getHeight, never):Int;
	private function getHeight():Int
	{
		return rawData.height;
	}


	public function new(?pen:Dynamic, ?sourceRect:Rect)
	{
		if (pen != null && sourceRect != null)
		{
			this.rawData = pen.getImageData(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height);
		}
	}

	public function getCopy():BitmapData
	{
		var newData:BitmapData = new BitmapData();
		newData.rawData = this.rawData;
		return newData;
	}

	public function destroy():Void
	{
		rawData = null;
	}
}
