package titanium_reindeer;

import titanium_reindeer.Enums;

enum MouseRegionMoveEvent
{
	Move;
	Enter;
	Exit;
}
enum MouseRegionButtonEvent
{
	Down;
	Up;
	Click;
}

class MouseRegionHandler
{
	private var collisionRegion:CollisionComponent;

	private var registeredMouseMoveEvents:Array<Vector2 -> Void>;
	private var registeredMouseEnterEvents:Array<Vector2 -> Void>;
	private var registeredMouseExitEvents:Array<Vector2 -> Void>;
	private var registeredMouseDownEvents:Array<Vector2 -> MouseButton -> Void>;
	private var registeredMouseUpEvents:Array<Vector2 -> MouseButton -> Void>;
	private var registeredMouseClickEvents:Array<Vector2 -> MouseButton -> Void>;

	public var isMouseInside(default, null):Bool;
	private var isMouseButtonsDownInside:IntHash<Bool>;
	public function getIsMouseDownInside(mouseButton:MouseButton):Bool
	{
		return isMouseButtonsDownInside.get(Type.enumIndex(mouseButton));
	}

	public function new(collisionComponent:CollisionComponent)
	{
		this.collisionRegion = collisionComponent;
		this.isMouseInside = false;
		this.isMouseButtonsDownInside = new IntHash();

		this.registeredMouseMoveEvents = new Array();
		this.registeredMouseEnterEvents = new Array();
		this.registeredMouseExitEvents = new Array();
		this.registeredMouseDownEvents = new Array();
		this.registeredMouseUpEvents = new Array();
		this.registeredMouseClickEvents = new Array();
	}

	public function mouseMove(mousePos:Vector2, colliding:Bool):Void
	{
		if (colliding)
		{
			// Mouse Move Events
			for (func in this.registeredMouseMoveEvents)
			{
				func(mousePos);
			}
		}

		if (this.isMouseInside && !colliding)
		{
			// Mouse Exit Events
			for (func in this.registeredMouseExitEvents)
			{
				func(mousePos);
			}
		}
		else if (!this.isMouseInside && colliding)
		{
			// Mouse Enter Events
			for (func in this.registeredMouseEnterEvents)
			{
				func(mousePos);
			}
		}

		this.isMouseInside = colliding;
	}

	public function mouseDown(mousePos:Vector2, button:MouseButton, colliding:Bool):Void
	{
		if (colliding)
		{
			// Mouse Down Events
			for (func in this.registeredMouseDownEvents)
			{
				func(mousePos, button);
			}
		}

		this.isMouseButtonsDownInside.set(Type.enumIndex(button), colliding);
	}

	public function mouseUp(mousePos:Vector2, button:MouseButton, colliding:Bool):Void
	{
		if (colliding)
		{
			// Mouse Up events
			for (func in this.registeredMouseDownEvents)
			{
				func(mousePos, button);
			}
		}

		if (colliding && this.isMouseButtonsDownInside.get(Type.enumIndex(button)))
		{
			// Mouse Click events
			for (func in this.registeredMouseClickEvents)
			{
				func(mousePos, button);
			}
		}
		this.isMouseButtonsDownInside.set(Type.enumIndex(button), false);
	}

	// Public functions
	// ----------------------------------
	public function registerMouseMoveEvent(mouseEvent:MouseRegionMoveEvent, func:Vector2 -> Void):Void
	{
		if (func == null)
			return;

		switch (mouseEvent)
		{
			case MouseRegionMoveEvent.Move:
				this.registeredMouseMoveEvents.push(func);

			case MouseRegionMoveEvent.Enter:
				this.registeredMouseEnterEvents.push(func);

			case MouseRegionMoveEvent.Exit:
				this.registeredMouseExitEvents.push(func);
		}
	}

	public function registerMouseButtonEvent(mouseEvent:MouseRegionButtonEvent, func:Vector2 -> MouseButton -> Void):Void
	{
		if (func == null)
			return;

		switch (mouseEvent)
		{
			case MouseRegionButtonEvent.Down:
				this.registeredMouseDownEvents.push(func);

			case MouseRegionButtonEvent.Up:
				this.registeredMouseUpEvents.push(func);

			case MouseRegionButtonEvent.Click:
				this.registeredMouseClickEvents.push(func);
		}
	}

	public function unregisterMouseEvent(mouseEvent:MouseRegionMoveEvent, func:Vector2 -> Void):Void
	{
		if (func == null)
			return;

		var events:Array<Vector2 -> Void>;
		switch (mouseEvent)
		{
			case MouseRegionMoveEvent.Move:
				events = this.registeredMouseMoveEvents;

			case MouseRegionMoveEvent.Enter:
				events = this.registeredMouseEnterEvents;

			case MouseRegionMoveEvent.Exit:
				events = this.registeredMouseExitEvents;
		}

		for (i in 0...events.length)
		{
			// A pretty neat way of ensuring that i doesn't skip over the next element if a found method was spliced
			// because indexes are then moved down
			while (i < events.length)
			{
				if (Reflect.compareMethods(events[i], func))
					events.splice(i, 1);
				else
					break;
			}
		}
	}

	public function unregisterMouseButtonEvent(mouseEvent:MouseRegionButtonEvent, func:Vector2 -> MouseButton -> Void):Void
	{
		if (func == null)
			return;

		var events:Array<Vector2 -> MouseButton -> Void>;
		switch (mouseEvent)
		{
			case MouseRegionButtonEvent.Down:
				events = this.registeredMouseDownEvents;

			case MouseRegionButtonEvent.Up:
				events = this.registeredMouseUpEvents;

			case MouseRegionButtonEvent.Click:
				events = this.registeredMouseClickEvents;
		}

		for (i in 0...events.length)
		{
			// A pretty neat way of ensuring that i doesn't skip over the next element if a found method was spliced
			// because indexes are then moved down
			while (i < events.length)
			{
				if (Reflect.compareMethods(events[i], func))
					events.splice(i, 1);
				else
					break;
			}
		}
	}

	public function destroy():Void
	{
		this.collisionRegion = null;

		this.registeredMouseMoveEvents.splice(0, this.registeredMouseMoveEvents.length);
		this.registeredMouseMoveEvents = null;

		this.registeredMouseEnterEvents.splice(0, this.registeredMouseEnterEvents.length);
		this.registeredMouseEnterEvents = null;

		this.registeredMouseExitEvents.splice(0, this.registeredMouseExitEvents.length);
		this.registeredMouseExitEvents = null;

		this.registeredMouseDownEvents.splice(0, this.registeredMouseDownEvents.length);
		this.registeredMouseDownEvents = null;

		this.registeredMouseUpEvents.splice(0, this.registeredMouseUpEvents.length);
		this.registeredMouseUpEvents = null;

		this.registeredMouseClickEvents.splice(0, this.registeredMouseClickEvents.length);
		this.registeredMouseClickEvents = null;
	}
}
