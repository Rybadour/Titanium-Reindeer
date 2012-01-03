package titanium_reindeer.ui;

import titanium_reindeer.RectRenderer;
import titanium_reindeer.CollisionRect;
import titanium_reindeer.Color;

class RectButton extends Button
{
	public var shownRect(default, null):RectRenderer;
	private var collisionRect(default, null):CollisionRect;

	public var width(default, setWidth):Float;
	private function setWidth(value:Float):Float
	{
		if (value != this.width)
		{
			this.width = value;
			this.shownRect.width = this.width;
			this.collisionRect.width = this.width;
		}

		return this.width;
	}

	public var height(default, setHeight):Float;
	private function setHeight(value:Float):Float
	{
		if (value != this.height)
		{
			this.height = value;
			this.shownRect.height = this.height;
			this.collisionRect.height = this.height;
		}

		return this.height;
	}

	public function new(width:Float, height:Float, bgLayer:Int, fgLayer:Int)
	{
		this.collisionRect = new CollisionRect(width, height, Button.UI_COLLISION_LAYER, Button.BUTTON_COLLISION_GROUP);

		super(fgLayer, collisionRect);

		this.shownRect = new RectRenderer(width, height, bgLayer);
		this.shownRect.fillColor = Color.White;
		this.shownRect.strokeColor = Color.Black;
		this.shownRect.lineWidth = 1;
		this.addComponent("__shown_rect__", shownRect);
	}

	private override function enable():Void
	{
		super.enable();

		if (this.shownRect != null)
		{
			var normalColor:Color = this.shownRect.fillColor;
			normalColor.red = Math.round(normalColor.red * 2.5);
			normalColor.green = Math.round(normalColor.green * 2.5);
			normalColor.blue = Math.round(normalColor.blue * 2.5);
			this.shownRect.fillColor = normalColor;
		}
	}

	private override function disable():Void
	{
		super.disable();

		if (this.shownRect != null)
		{
			var disableColor:Color = this.shownRect.fillColor;
			disableColor.red = Math.round(disableColor.red * 0.4);
			disableColor.green = Math.round(disableColor.green * 0.4);
			disableColor.blue = Math.round(disableColor.blue * 0.4);
			this.shownRect.fillColor = disableColor;
		}
	}

	private override function mouseOverStart():Void
	{
		super.mouseOverStart();

		this.shownRect.lineWidth += 1;
	}

	private override function mouseOverStop():Void
	{
		super.mouseOverStop();

		this.shownRect.lineWidth -= 1;
	}

	private override function heldDownStart():Void
	{
		super.heldDownStart();

		var idleColor:Color = this.shownRect.fillColor;
		idleColor.red = Math.round(idleColor.red * 0.8);
		idleColor.green = Math.round(idleColor.green * 0.8);
		idleColor.blue = Math.round(idleColor.blue * 0.8);
		this.shownRect.fillColor = idleColor;
	}

	private override function heldDownStop():Void
	{
		super.heldDownStop();

		var heldColor:Color = this.shownRect.fillColor;
		heldColor.red = Math.round(heldColor.red * 1.25);
		heldColor.green = Math.round(heldColor.green * 1.25);
		heldColor.blue = Math.round(heldColor.blue * 1.25);
		this.shownRect.fillColor = heldColor;
	}
}
