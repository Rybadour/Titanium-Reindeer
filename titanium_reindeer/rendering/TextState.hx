package titanium_reindeer.rendering;

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

class TextState extends StrokeFillState
{
	public var fontStyle:FontStyle;
	public var fontVariant:FontVariant;
	public var fontWeight:FontWeight;
	public var fontSize:Int;
	public var fontFamily:String;

	public function new()
	{
		super();

		this.fontStyle = FontStyle.Normal;
		this.fontVariant = FontVariant.Normal;
		this.fontWeight = FontWeight.Normal;
		this.fontSize = 10;
		this.fontFamily = "sans-serif";
	}

	public override function apply(canvas:Canvas2D)
	{
		super.apply(canvas);

		var fontParts:Array<String> = new Array();
		switch (fontStyle)
		{
			case Normal: fontParts.push("normal");
			case Italics: fontParts.push("italics");
			case Oblique: fontParts.push("oblique");
		}

		switch (fontVariant)
		{
			case Normal: fontParts.push("normal");
			case SmallCaps: fontParts.push("small-caps");
		}

		switch (fontWeight)
		{
			case Normal: fontParts.push("normal");
			case Bold: fontParts.push("bold");
			case Size(s): fontParts.push(""+Math.max(100, Math.min(s, 900)));
		}

		fontParts.push(fontSize+"px");
		fontParts.push(fontFamily);
		
		canvas.ctx.font = fontParts.join(" ");
		canvas.ctx.textAlign = "center";
		canvas.ctx.textBaseline = "middle";
	}
}
