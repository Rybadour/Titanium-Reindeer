package titanium_reindeer.ai.pathing;

interface IRouteProvider
{
	public function findRoute(start:Vector2, end:Vector2):Route;
}
