package star_control;

import titanium_reindeer.Scene;
import titanium_reindeer.ImageSource;

class StarControlScene extends Scene
{
	public override function getImage(filePath:String):ImageSource
	{
		return super.getImage(StarControlGame.IMAGE_BASE + filePath);
	}
}
