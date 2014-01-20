package titanium_reindeer.ai.pathing;

class RouteFollower<N:PathNode>
{
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
}
