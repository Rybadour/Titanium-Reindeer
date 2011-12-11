package titanium_reindeer;

enum PatternOption
{
	Repeat; RepeatX; RepeatY; NoRepeat;
}

class Pattern
{
	public var imageSource:ImageSource;
	public var option:PatternOption;

	public function new(imageSource:ImageSource, option:PatternOption)
	{
		this.imageSource = imageSource;
		this.option = option;
	}

	public function getStyle(pen:Dynamic):Dynamic
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

		return pen.createPattern(imageSource.image, option);
	}

	public function identify():String
	{
		return "Pattern("+imageSource.identify()+","+Type.enumConstructor(option)+");";
	}
}
