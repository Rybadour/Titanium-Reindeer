package titanium_reindeer.rendering;

/**
 * The following enums allow typed configuration of some font properties of text.
 */
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

/**
 * A TextState object encompasses the configuration options for rendering text.
 * A TextState is also a StrokeFillState so the strokes and fill properties of the text can be
 * configured through the properties exposed by the StrokeFillState class.
 */
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

		// Same as the defaults of the html5 specification
		this.fontStyle   = FontStyle.Normal;
		this.fontVariant = FontVariant.Normal;
		this.fontWeight  = FontWeight.Normal;
		this.fontSize    = 10;
		this.fontFamily  = "sans-serif";
	}

	/**
	 * This function applies the current state of this object to a given canvas element.
	 */
	public override function apply(canvas:Canvas2D)
	{
		super.apply(canvas);

		// Get the string representation of each property
		var fontParts:Array<String> = new Array();
		switch (fontStyle)
		{
			case Normal:  fontParts.push("normal");
			case Italics: fontParts.push("italics");
			case Oblique: fontParts.push("oblique");
		}

		switch (fontVariant)
		{
			case Normal:    fontParts.push("normal");
			case SmallCaps: fontParts.push("small-caps");
		}

		switch (fontWeight)
		{
			case Normal:  fontParts.push("normal");
			case Bold:    fontParts.push("bold");
			case Size(s): fontParts.push(""+Math.max(100, Math.min(s, 900)));
		}

		fontParts.push(fontSize+"px");
		fontParts.push(fontFamily);
		
		canvas.ctx.font = fontParts.join(" ");
		// TODO: Either use this and apply an offset in UIText (and any where else)
		//       Or don't center the text by default
		//canvas.ctx.textAlign = "center";
		//
		// TODO: These properties should be managed publicly through this class
		//canvas.ctx.textBaseline = "middle";
		
	}
}
