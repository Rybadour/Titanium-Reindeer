package star_control;

import titanium_reindeer.GameObject;
import titanium_reindeer.ImageRenderer;
import titanium_reindeer.CollisionCircle;
import titanium_reindeer.CollisionComponent;
import titanium_reindeer.Vector2;
import titanium_reindeer.Geometry;

class BladeTailSegment extends GameObject
{
	public static inline var DISTANCE_CONSTRAINT 	= 50;
	public static inline var ANGLE_CONSTRAINT 		= Math.PI/6;
	public static inline var DISTANCE_ADJUST_RATE	= 40;			// adjustment /s
	public static inline var ANGLE_ADJUST_RATE 		= Math.PI/4;	// adjustment /s
	public static inline var COLLISION_RADIUS 		= 40;

	private var head:BladeTail;
	private var segmentNumber:Int;
	private var nextSegment:BladeTailSegment;

	private var sprite:ImageRenderer;
	private var collision:CollisionCircle;

	private var joinAngle:Float;

	public function new(head:BladeTail, segmentNumber:Int, nextSegment:BladeTailSegment)
	{
		super(this.head.game.globalScene);

		this.head = head;
		this.segmentNumber = segmentNumber;
		this.nextSegment = nextSegment;

		this.sprite = new ImageRenderer(this.head.bladeTailSegmentSource, BattleScene.SHIPS_LAYER);
		this.addComponent("segmentSprite_"+segmentNumber, this.sprite);

		this.collision = new CollisionCircle(COLLISION_RADIUS, "main", CollisionGroups.SHIPS);
		this.collision.registerCallback(this.collide);
		this.addComponent("segmentCollision_"+segmentNumber, this.collision);

		this.updatePosition();
	}

	public function headMoved():Void
	{
		var nextPos:Vector2 = (this.nextSegment == null) ? this.head.position : this.nextSegment.position;
		var diffPos:Vector2 = this.position.subtract( nextPos );
		
		// Adjust distance
		/* *
		if (diffPos.magnitude() > DISTANCE_CONSTRAINT || Geometry.isAngleWithin(diffPos.getAngle(), ))
		{
			this.
		}
		/* */

		this.updatePosition();
	}

	public function headTurned():Void
	{
		this.updatePosition();
	}

	private function updatePosition():Void
	{
		var nextDir:Float = (this.nextSegment == null ? this.head.facing : this.nextSegment.joinAngle);

		var vTail:Vector2 = new Vector2(1, 0);
		vTail.rotate(nextDir);
		vTail.extend(DISTANCE_CONSTRAINT/2);
		vTail.reverse();

		var followPoint:Vector2;
		if (this.nextSegment == null)
			followPoint = vTail.add(this.head.position);
		else
			followPoint = vTail.add(this.nextSegment.position);

		var vFollowDir:Vector2 = followPoint.subtract(this.position);
		if (vFollowDir.getMagnitude() != DISTANCE_CONSTRAINT/2)
		{
			vFollowDir = vFollowDir.getNormalized().getExtend(DISTANCE_CONSTRAINT/2);
		}

		if ( !Geometry.isAngleWithin(nextDir, vFollowDir.getRadians(), ANGLE_CONSTRAINT) )
		{
			var closestsBoundAngle:Float = Geometry.closestAngle(vFollowDir.getRadians(), [nextDir+ANGLE_CONSTRAINT, nextDir-ANGLE_CONSTRAINT]);
			vFollowDir = new Vector2(vFollowDir.getMagnitude(), 0); 
			vFollowDir.rotate(closestsBoundAngle);
		}

		this.position = followPoint.add(vFollowDir.getReverse());
		this.joinAngle = vFollowDir.getRadians();

		this.sprite.rotation = this.joinAngle;
	}

	private function collide(other:CollisionComponent):Void
	{
		this.head.segmentCollided(other);
	}

	public function startShooting():Void
	{
		this.sprite.image = this.head.bladeTailSegmentOnSource;
	}

	public function endShooting():Void
	{
		this.sprite.image = this.head.bladeTailSegmentSource;
	}
}
