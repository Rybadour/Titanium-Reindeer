package titanium_reindeer;

import titanium_reindeer.Enums;

enum MouseAction
{
	Move;
	Down;
	Up;
}

class ExclusionsMaxDepthPair
{
	public var exclusions:IntHash<Array<MouseExclusionRegion>>;
	public var maxDepth:Int;

	public function new(exclusions:IntHash<Array<MouseExclusionRegion>>, maxDepth:Int)
	{
		this.exclusions = exclusions;
		this.maxDepth = maxDepth;
	}
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
	private var layerToPairsMap:Hash< IntHash<ComponentHandlerPair> >;

	private var exclusionRegions:IntHash<MouseExclusionRegion>;
	private var exclusionRTree:RTreeFastInt;
	private var nextExclusionId:Int;

	public function new(manager:CollisionComponentManager)
	{
		this.collisionManager = manager;
		this.collisionManager.gameObjectManager.game.inputManager.registerMouseMoveEvent(mouseMoveHandle);
		this.collisionManager.gameObjectManager.game.inputManager.registerMouseButtonAnyEvent(mouseButtonHandle);

		this.layerToPairsMap = new Hash();

		this.exclusionRegions = new IntHash();
		this.exclusionRTree = new RTreeFastInt();
		this.nextExclusionId = 0;
	}

	public function getHandler(component:CollisionComponent):MouseRegionHandler
	{
		if (component == null)
			return null;

		// It is impossible to gaurentee that each component will get one and only one unique handler unless it's initialized
		// So we have to turn down the request for a handler until it's initialized
		if (component.id == null)
		{
			return null;
		}

		var handler:MouseRegionHandler;
		var pairs:IntHash<ComponentHandlerPair>;
		if (this.layerToPairsMap.exists(component.layerName))
			pairs = this.layerToPairsMap.get(component.layerName);
		else
		{
			pairs = new IntHash();
			this.layerToPairsMap.set(component.layerName, pairs);
		}

		if (pairs.exists(component.id))
			handler = pairs.get(component.id).handler;
		else
		{
			handler = new MouseRegionHandler(this, component);
			pairs.set(component.id, new ComponentHandlerPair(component, handler));
		}

		return handler;
	}

	public function createExclusionRegion(depth:Int, shape:Shape):MouseExclusionRegion
	{
		if (shape == null)
			return null;

		var newExclusionRegion:MouseExclusionRegion = new MouseExclusionRegion(this, this.nextExclusionId, depth, shape);

		this.exclusionRegions.set(this.nextExclusionId, newExclusionRegion);
		this.exclusionRTree.insert(shape.getMinBoundingRect(), this.nextExclusionId);
		this.nextExclusionId += 1;

		return newExclusionRegion;
	}

	// Internal use only
	public function updateExclusionRegionShape(exclusionRegion:MouseExclusionRegion):Void
	{
		if (exclusionRegion == null || !this.exclusionRegions.exists(exclusionRegion.id))
			return;

		this.exclusionRTree.update(exclusionRegion.shape.getMinBoundingRect(), exclusionRegion.id);
	}

	public function removeExclusionRegion(exclusionRegion:MouseExclusionRegion):Void
	{
		if (exclusionRegion == null || !this.exclusionRegions.exists(exclusionRegion.id))
			return;
	
		this.exclusionRegions.remove(exclusionRegion.id);
		this.exclusionRTree.remove(exclusionRegion.id);
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
		if (Lambda.count(this.layerToPairsMap) <= 0)
			return;

		for (layerName in this.layerToPairsMap.keys())
		{
			var pairs:IntHash<ComponentHandlerPair> = this.layerToPairsMap.get(layerName);
			var foundPairs:IntHash<Bool> = new IntHash();

			var collidingIds:Array<Int> = this.collisionManager.getLayer(layerName).getIdsIntersectingPoint(mousePos);
			for (id in collidingIds)
			{
				if (pairs.exists(id))
				{
					foundPairs.set(id, true);
				}
			}

			// Communicate to all handlers for this layer, that the mouse was moved
			// Tell them if their component was intersected
			var exclusionResults:ExclusionsMaxDepthPair = null;
			for (id in pairs.keys())
			{
				var colliding:Bool = foundPairs.exists(id);
				var handler:MouseRegionHandler = pairs.get(id).handler;

				// Check for blocking exclusion regions if this handler is hit
				if (colliding)
				{
					// We only perform this expensive construction if we have any handlers hit
					if (exclusionResults == null)
						exclusionResults = this.organizeIntersectingExclusions(mousePos);

					var handlersExclusion:Int = -1;
					if (handler.isBlockingBelow)
						handlersExclusion = handler.exclusionRegion.id;

					for (d in handler.depth...exclusionResults.maxDepth+1)
					{
						if (exclusionResults.exclusions.exists(d))
						{
							for (exclusion in exclusionResults.exclusions.get(d))
							{
								if (exclusion.id != handlersExclusion)
								{
									colliding = false;
									break;
								}
							}

							if (!colliding)
								break;
						}
					}
				}

				switch (action)
				{
					case MouseAction.Move:
						handler.mouseMove(mousePos, colliding);

					case MouseAction.Down:
						handler.mouseDown(mousePos, button, colliding);

					case MouseAction.Up:
						handler.mouseUp(mousePos, button, colliding);
				}
			}
		}
	}

	// Builds a structure containing intersecting exclusions for quick lookup
	private function organizeIntersectingExclusions(mousePos:Vector2):ExclusionsMaxDepthPair
	{
		var exclusionIds:Array<Int> = this.exclusionRTree.getPointIntersectingValues(mousePos);
		var exclusionRegions:IntHash<Array<MouseExclusionRegion>> = new IntHash();
		var regions:Array<MouseExclusionRegion>;
		var maxDepth:Int = 0;
		for (id in exclusionIds)
		{
			var exclusionRegion:MouseExclusionRegion = this.exclusionRegions.get(id);
			if (exclusionRegions.exists(exclusionRegion.depth))
				regions = exclusionRegions.get(exclusionRegion.depth);
			else
			{
				regions = new Array();
				exclusionRegions.set(exclusionRegion.depth, regions);
			}

			regions.push(exclusionRegion);

			if (exclusionRegion.depth > maxDepth)
				maxDepth = exclusionRegion.depth;
		}

		return new ExclusionsMaxDepthPair(exclusionRegions, maxDepth);
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
