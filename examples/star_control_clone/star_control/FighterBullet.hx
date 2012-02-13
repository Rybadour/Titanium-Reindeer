package star_control;

import titanium_reindeer.CircleRenderer;
import titanium_reindeer.Color;

class FighterBullet extends Projectile
{
	public static inline var SPEED 		= 300; 	// pixels /s
	public static inline var DAMAGE 	= 1;
	public static inline var LIFE_TIME 	= 1500; // ms

	public static inline var RADIUS		= 5;

	public function new(owner:Ship)
	{
		var sprite:CircleRenderer = new CircleRenderer(RADIUS, BattleScene.SHIPS_LAYER);
		sprite.fillColor = new Color(0, 0, 0, 0);
		sprite.strokeColor = Color.White;
		sprite.lineWidth = 2;

		super(owner, sprite, SPEED, DAMAGE, LIFE_TIME);
	}
}
