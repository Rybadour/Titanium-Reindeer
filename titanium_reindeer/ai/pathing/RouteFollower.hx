package titanium_reindeer.ai.pathing;

import titanium_reindeer.spatial.Vector2;

class RouteFollower<N:PathNode>
{
	public var position:Vector2;

	public var route(default, null):Route<N>;
	public var routeIndex(default, null):Int;

	public function new()
	{
	}

	public inline function isFollowingRoute():Bool
	{
		return this.route != null;
	}

	public function changeRoute(route:Route<N>):Void
	{
		this.route = route;
		this.routeIndex = 0;
	}

	public function stopFollowingRoute():Void
	{
		this.changeRoute(null);
	}

	public function moveTargetAhead():Void
	{
		this.routeIndex++;
		if ( this.routeIndex > this.route.nodes.length )
			this.routeIndex = this.route.nodes.length;
	}

	public function prevTarget():N
	{
		if ( !this.isFollowingRoute() || this.routeIndex <= 0 )
			return null;

		return this.route.nodes[this.routeIndex-1];
	}

	public function currentTarget():N
	{
		if ( this.isFollowingRoute() )
			return this.route.nodes[this.routeIndex];
		else
			return null;
	}

	public function nextTarget():N
	{
		if ( !this.isFollowingRoute() || this.routeIndex+1 >= this.route.nodes.length )
			return null;

		return this.route.nodes[this.routeIndex+1];
	}

	public function atEnd():Bool
	{
		return ( this.isFollowingRoute() && this.routeIndex+1 >= this.route.nodes.length );
	}

	public static function moveFollower<N:PathNode, F:RouteFollower<N>>(msTimeStep:Int, follower:F, speed:Int)
	{
		if (follower.isFollowingRoute())
		{
			var route = follower.route;
			var position = follower.position;
			var current:Vector2 = follower.currentTarget();
			var next:Vector2 = follower.nextTarget();

			var velo:Vector2 = Vector2.normalizedDiff(position, current);
			var dist:Float = Vector2.getDistance(position, current);

			// Reached current node
			// TODO: Requires projection to ensure follower don't miss targets
			if (dist <= 1)
			{
				// Next node is current target
				if (follower.atEnd())
					follower.stopFollowingRoute();
				else
					follower.moveTargetAhead();
			}

			// Velocity towards current target
			velo.extend(speed * msTimeStep/1000);
			follower.position.addTo(velo);
		}
	}
}
