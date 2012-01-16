package titanium_reindeer.ui;

import titanium_reindeer.TextRenderer;
import titanium_reindeer.CollisionComponent;
import titanium_reindeer.MouseRegionHandler;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.Enums;

class Button extends GameObject
{
	public static inline var UI_COLLISION_LAYER:String 	= "__primary_ui_collision_layer__";
	public static inline var BUTTON_COLLISION_GROUP:String 	= "__primary_button_collision_group__";


	public var shownText(default, null):TextRenderer;
	public var text(default, setText):String;
	public function setText(value:String):String
	{
		if (value != this.text)
		{
			this.text = value;

			if (this.shownText != null)
				this.shownText.text = this.text;
		}

		return this.text;
	}

	public var collisionShape(default, null):CollisionComponent;
	public var mouseHandler(default, null):MouseRegionHandler;

	private var registeredMouseClickEvents:Array<Vector2 -> Void>;

	public var isMouseOver(default, null):Bool;
	public var isHeldDown(default, null):Bool;

	public var enabled(default, setEnabled):Bool;
	private function setEnabled(value:Bool):Bool
	{
		if (value != this.enabled)
		{
			this.enabled = value;

			if (this.enabled)
				this.enable();
			else
				this.disable();
		}

		return this.enabled;
	}
	

	public function new(fgLayer:Int, collision:CollisionComponent)
	{
		super();

		this.text = "";
		this.shownText = new TextRenderer(this.text, fgLayer);
		this.shownText.fillColor = Color.Black;
		this.addComponent("__shown_text__", this.shownText);

		this.collisionShape = collision;
		this.addComponent("__collision_shape__", this.collisionShape);

		this.registeredMouseClickEvents = new Array();

		this.isMouseOver = false;
		this.isHeldDown = false;

		this.enabled = true;
	}

	// Publicly usable methods
	public function registerMouseClickEvent(func:Vector2 -> Void):Void
	{
		if (func == null)
			return;
			
		this.registeredMouseClickEvents.push(func);	
	}

	// Internal methods
	private override function hasInitialized():Void
	{
		super.hasInitialized();

		var collisionManager:CollisionComponentManager = cast(this.objectManager.getManager(CollisionComponentManager), CollisionComponentManager);
		this.mouseHandler = collisionManager.mouseRegionManager.getHandler(this.collisionShape);
		this.mouseHandler.registerMouseMoveEvent(MouseRegionMoveEvent.Enter, mouseEnter);
		this.mouseHandler.registerMouseMoveEvent(MouseRegionMoveEvent.Exit, mouseExit);
		this.mouseHandler.registerMouseButtonEvent(MouseRegionButtonEvent.Down, mouseDown);
		this.mouseHandler.registerMouseButtonEvent(MouseRegionButtonEvent.Up, mouseUp);

		this.objectManager.game.inputManager.registerMouseButtonEvent(MouseButton.Left, MouseButtonState.Up, mouseUpGlobal);
	}

	private function enable():Void
	{
	}

	private function disable():Void
	{
		if (this.isMouseOver)
		{
			this.isMouseOver = false;
			this.mouseOverStop();
		}

		if (this.isHeldDown)
		{
			this.isHeldDown = false;
			this.heldDownStop();
		}
	}

	private function mouseEnter(mousePos:Vector2):Void
	{
		if (!this.isMouseOver && this.enabled)
		{
			this.isMouseOver = true;
			this.mouseOverStart();
		}
	}

	private function mouseExit(mousePos:Vector2):Void
	{
		if (this.isMouseOver && this.enabled)
		{
			this.isMouseOver = false;
			this.mouseOverStop();
		}
	}

	private function mouseDown(mousePos:Vector2, button:MouseButton):Void
	{
		if (button == MouseButton.Left && !this.isHeldDown && this.enabled)
		{
			this.isHeldDown = true;
			this.heldDownStart();
		}
	}

	private function mouseUp(mousePos:Vector2, button:MouseButton):Void
	{
		if (button == MouseButton.Left && this.isHeldDown && this.enabled)
		{
			this.isHeldDown = false;
			this.heldDownStop();
			this.click(mousePos);
		}
	}
	private function mouseUpGlobal(mousePos:Vector2):Void
	{
		if (this.isHeldDown && this.enabled)
		{
			this.isHeldDown = false;
			this.heldDownStop();
		}
	}

	private function mouseOverStart():Void
	{
	}

	private function mouseOverStop():Void
	{
	}

	private function heldDownStart():Void
	{
	}

	private function heldDownStop():Void
	{
	}

	private function click(mousePos:Vector2):Void
	{
		if (!this.enabled)
			return;

		for (func in this.registeredMouseClickEvents)
		{
			func(mousePos);
		}
	}

	public override function destroy():Void
	{
		super.destroy();

		this.flushAndDestroyComponents();

		this.mouseHandler.unregisterMouseMoveEvent(MouseRegionMoveEvent.Enter, mouseEnter);
		this.mouseHandler.unregisterMouseMoveEvent(MouseRegionMoveEvent.Exit, mouseExit);
		this.mouseHandler.unregisterMouseButtonEvent(MouseRegionButtonEvent.Down, mouseDown);
		this.mouseHandler.unregisterMouseButtonEvent(MouseRegionButtonEvent.Up, mouseUp);

		this.objectManager.game.inputManager.unregisterMouseButtonEvent(MouseButton.Left, MouseButtonState.Up, mouseUpGlobal);
	}
}
