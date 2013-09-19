package titanium_reindeer.rendering;

enum PatternOption
{
	Repeat; RepeatX; RepeatY; NoRepeat;
}

class Pattern
{
	public var imageSource:ImageSource;
	public var option:PatternOption;

	private var cachedStyle:Dynamic;

	public function new(imageSource:ImageSource, option:PatternOption)
	{
		this.imageSource = imageSource;
		this.option = option;
	}

	public function getStyle(pen:Dynamic):Dynamic
	{
		// TODO: properly cache
		if (this.cachedStyle == null || true)
		{
			var option:String;
			switch (this.option)
			{
				case PatternOption.Repeat:
					option = "repeat";

				case PatternOption.RepeatX:
					option = "repeat-x";

				case PatternOption.RepeatY:
					option = "repeat-y";

				case PatternOption.NoRepeat:
					option = "no-repeat";
			}
			this.cachedStyle = pen.createPattern(imageSource.image, option);
		}
		return this.cachedStyle;
	}

	public function identify():String
	{
		return "Pattern("+imageSource.identify()+","+Type.enumConstructor(option)+");";
	}
}
