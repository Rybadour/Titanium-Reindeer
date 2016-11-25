package titanium_reindeer.tiles.hex;

class HexUtil
{
	public static function getCoordsInRangeCube(center:CubeCoords, range:Int):Array<CubeCoords>
	{
		if (center == null || range < 1)
			return [];

		var results:Array<CubeCoords> = [];
		for (dx in -range...range+1)
		{
			var lower = Math.round(Math.max(-range, -dx - range));
			var upper = Math.round(Math.min(range, -dx + range));
			for (dy in lower...upper+1)
			{
				var dz = -dx - dy;
				results.push(center.addf(dx, dy, dz));
			}
		}

		return results;
	}
	
	/**
	 * Returns the opposite direction index. A valid direction is between 0 and 5 inclusive.
	 */
	public static function getOppositeDirection(direction:Int):Int
	{
		direction += 3;
		return direction % 6;
	}
}
