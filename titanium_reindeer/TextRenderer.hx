package titanium_reindeer;

enum FontStyle
{
	Normal; Italics; Oblique;
}

enum FontVariant
{
	Normal; SmallCaps;
}

enum FontWeight
{
	Normal; Bold; Size(s:Int);
}

class TextRenderer extends StrokeFillRenderer
{
	public var text(default, setText):String;
	private function setText(value:String):String
	{
		if (this.text != value)
		{
			this.text = value;
			recalculateSize();
		}
		return text;
	}

	public var fontStyle(default, setFontStyle):FontStyle;
	private function setFontStyle(value:FontStyle):FontStyle
	{
		if (this.fontStyle != value)
		{
			this.fontStyle = value;
			recalculateSize();
		}
		return this.fontStyle;
	}

	public var fontVariant(default, setFontVariant):FontVariant;
	private function setFontVariant(value:FontVariant):FontVariant
	{
		if (this.fontVariant != value)
		{
			this.fontVariant = value;
			recalculateSize();
		}
		return this.fontVariant;
	}

	public var fontWeight(default, setFontWeight):FontWeight;
	private function setFontWeight(value:FontWeight):FontWeight
	{
		if (this.fontWeight != value)
		{
			this.fontWeight = value;
			recalculateSize();
		}
		return this.fontWeight;
	}

	public var fontSize(default, setFontSize):Int;
	private function setFontSize(value:Int):Int
	{
		if (this.fontSize != value)
		{
			this.fontSize = value;
			recalculateSize();
		}
		return fontSize;
	}

	public var fontFamily(default, setFontFamily):String;
	private function setFontFamily(value:String):String
	{
		if (this.fontFamily != value)
		{
			this.fontFamily = value;
			recalculateSize();
		}
		return this.fontFamily;
	}

	public function new(text:String, layer:Int)
	{
		super(0, fontSize, layer);

		this.text = text;
		this.fontStyle = FontStyle.Normal;
		this.fontVariant = FontVariant.Normal;
		this.fontWeight = FontWeight.Normal;
		this.fontSize = 10;
		this.fontFamily = "sans-serif";
	}

	override public function initialize():Void
	{
		super.initialize();

		recalculateSize();
	}

	private function setFontAttributes():Void
	{
		var font:String = "";
		switch (fontStyle)
		{
			case Normal: font += "normal";
			case Italics: font += "italics";
			case Oblique: font += "oblique";
		}
		font += " ";

		switch (fontVariant)
		{
			case Normal: font += "normal";
			case SmallCaps: font += "small-caps";
		}
		font += " ";

		switch (fontWeight)
		{
			case Normal: font += "normal";
			case Bold: font += "bold";
			case Size(s): font += Math.max(100, Math.min(s, 900));
		}
		font += " ";
		
		pen.font = font +fontSize+"px "+fontFamily;
		pen.textAlign = "center";
		pen.textBaseline = "middle";
	}

	private function recalculateSize():Void
	{
		if (pen != null)
		{
			setFontAttributes();

			var measuredFont:Dynamic = pen.measureText(text); 

			this.initialDrawnWidth = measuredFont.width + (lineWidth > 0 ? lineWidth : 0);
			this.initialDrawnHeight = this.fontSize + (lineWidth > 0 ? lineWidth : 0);

			this.timeForRedraw = true;
		}
	}

	override public function render():Void
	{
		super.render();

		setFontAttributes();

		pen.fillText(this.text, 0, 0);
		if (lineWidth > 0)
			pen.strokeText(this.text, 0, 0);
	}

	override public function identify():String
	{
		var identity:String = "Text(";
		switch (fontStyle)
		{
			case Normal: identity += "normal";
			case Italics: identity += "italics";
			case Oblique: identity += "oblique";
		}
		identity += ",";

		switch (fontVariant)
		{
			case Normal: identity += "normal";
			case SmallCaps: identity += "small-caps";
		}
		identity += ",";

		switch (fontWeight)
		{
			case Normal: identity += "normal";
			case Bold: identity += "bold";
			case Size(s): identity += Math.max(100, Math.min(s, 900));
		}
		
		return super.identify() + identity+","+fontSize+","+fontFamily+");";
	}
}
