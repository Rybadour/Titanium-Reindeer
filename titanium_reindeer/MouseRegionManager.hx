package titanium_reindeer;

import titanium_reindeer.Enums;

enum MouseAction
{
	Move;
	Down;
	Up;
}

class ComponentHandlerPair
{
	public var component:CollisionComponent;
	public var handler:MouseRegionHandler;

	public function new(component:CollisionComponent, handler:MouseRegionHandler)
	{
		this.component = component;
		this.handler = handler;
	}
}

class MouseRegionManager
{
	public var collisionManager(default, null):CollisionComponentManager;

	// [layerName] -> IntHash( [componentId] -> [ComponentHandlerPair] )
	private var layerToPairsMap:Hash<IntHash<ComponentHandlerPair>>;

	public function new(manager:CollisionComponentManager)
	{
		this.collisionManager = manager;
		this.collisionManager.gameObjectManager.game.inputManager.registerMouseMoveEvent(mouseMoveHandle);
		this.collisionManager.gameObjectManager.game.inputManager.registerMouseButtonAnyEvent(mouseButtonHandle);

		this.layerToPairsMap = new Hash();
	}

	public function getHandler(component:CollisionComponent):MouseRegionHandler
	{
		if (component == null)
			return null;

		// It is impossible to gaurentee that each component will get one and only one unique handler
		// So we have to turn down the request for a handler until it's initialized
		if (component.id == null)
		{
			return null;
		}

		var handler:MouseRegionHandler;
		var pairs:IntHash<ComponentHandlerPair>;
		if (this.layerToPairsMap.exists(component.layerName))
		{
			pairs = this.layerToPairsMap.get(component.layerName);
			if (pairs.exists(component.id))
			{
				handler = pairs.get(component.id).handler;
			}
			else
			{
				handler = new MouseRegionHandler(component);
				pairs.set(component.id, new ComponentHandlerPair(component, handler));
			}
		}
		else
		{
			handler = new MouseRegionHandler(component);

			pairs = new IntHash();
			pairs.set(component.id, new ComponentHandlerPair(component, handler));
			this.layerToPairsMap.set(component.layerName, pairs);
		}

		return handler;
	}

	private function mouseMoveHandle(mousePos:Vector2):Void
	{
		handleAction(MouseAction.Move, mousePos, MouseButton.None);
	}

	private function mouseButtonHandle(button:MouseButton, buttonState:MouseButtonState, mousePos:Vector2):Void
	{
		var action:MouseAction;
		if (buttonState == MouseButtonState.Down)
			action = MouseAction.Down;
		else if (buttonState == MouseButtonState.Up)
			action = MouseAction.Up;
		else
			return;

		handleAction(action, mousePos, button);
	}

	private function handleAction(action:MouseAction, mousePos:Vector2, button:MouseButton):Void
	{
		var collidingIds:Array<Int>;	
		for (layerName in this.layerToPairsMap.keys())
		{
			var pairs:IntHash<ComponentHandlerPair> = this.layerToPairsMap.get(layerName);
			var foundPairs:IntHash<Bool> = new IntHash();
			collidingIds = this.collisionManager.getLayer(layerName).getIdsIntersectingPoint(mousePos);
			for (id in collidingIds)
			{
				if (pairs.exists(id))
				{
					foundPairs.set(id, true);
				}
			}

			// Communicate to all handlers for this layer, that the mouse was moved
			// Tell them if their component was intersected
			for (id in pairs.keys())
			{
				switch (action)
				{
					case MouseAction.Move:
						pairs.get(id).handler.mouseMove(mousePos, foundPairs.exists(id));

					case MouseAction.Down:
						pairs.get(id).handler.mouseDown(mousePos, button, foundPairs.exists(id));

					case MouseAction.Up:
						pairs.get(id).handler.mouseUp(mousePos, button, foundPairs.exists(id));
				}
			}
		}
	}

	public function destroy():Void
	{
		this.collisionManager.gameObjectManager.game.inputManager.unregisterMouseMoveEvent(mouseMoveHandle);
		this.collisionManager.gameObjectManager.game.inputManager.unregisterMouseButtonAnyEvent(mouseButtonHandle);

		this.collisionManager = null;
			
		for (layerName in this.layerToPairsMap.keys())
		{
			var pairs:IntHash<ComponentHandlerPair> = this.layerToPairsMap.get(layerName);
			for (id in pairs.keys())
			{
				pairs.get(id).handler.destroy();
				pairs.get(id).handler = null;
				pairs.get(id).component = null;
				pairs.remove(id);
			}
			pairs = null;
			
			this.layerToPairsMap.remove(layerName);
		}
		this.layerToPairsMap = null;
	}
}
