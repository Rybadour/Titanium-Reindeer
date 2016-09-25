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
}
