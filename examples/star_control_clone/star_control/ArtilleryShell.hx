package star_control;

import titanium_reindeer.RectRenderer;
import titanium_reindeer.LinearGradient;
import titanium_reindeer.ColorStop;
import titanium_reindeer.Color;

class ArtilleryShell extends Projectile
{
	public static inline var SPEED 		= 400; 	// pixels /s
	public static inline var DAMAGE 	= 4;
	public static inline var LIFE_TIME 	= 2000; // ms

	public function new(owner:Ship)
	{
		var sprite:RectRenderer = new RectRenderer(18, 10, BattleScene.SHIPS_LAYER);

		var colorStops:Array<ColorStop> = new Array(); 
		colorStops.push(new ColorStop(new Color(255, 127, 0), 0));
		colorStops.push(new ColorStop(new Color(255, 204, 153), 0.5));
		colorStops.push(new ColorStop(new Color(255, 127, 0), 1));
		sprite.fillGradient = new LinearGradient(0, -5, 0, 5, colorStops);

		super(owner, sprite, SPEED, DAMAGE, LIFE_TIME);
	}
}
