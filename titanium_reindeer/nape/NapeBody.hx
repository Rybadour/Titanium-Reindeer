package titanium_reindeer.nape;

import nape.phys.*;
import nape.shape.*;
import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.spatial.Circle in TRCircle;

/**
 * NapeBody is a wrapper class for nape.Body which can be extended. It provides a set of useful
 * functions to operate on the nape.Body instance using TR data types.
 */
class NapeBody
{
	// The nape.Body instance
	public var nBody(default, null):Body;

	// A mapping of the position of the nape.Body instance to TR.Vector2
	public var position(get, set):Vector2;
	function get_position() { return Vec2ToVector2.toVector2(this.nBody.position); }
	function set_position(value) { this.nBody.position = Vector2ToVec2.toVec2(value); return value; }

	public function new(?type:BodyType = null, ?position:Vector2ToVec2 = null)
	{
		if (type == null)
			type = BodyType.DYNAMIC;

		this.nBody = new Body(type, position);
		// Requires mass and inertia for application of force
		this.nBody.mass = 1;
		this.nBody.inertia = 1;
	}

	/**
	 * Adds a circle shape to the nape body instance given the radius.
	 */
	public function addCirclef(rad:Float):Void
	{
		this.addShape(new Circle(rad));
	}

	/**
	 * Adds a circle shape to the nape body instance given an instance of a circle from TR.
	 */
	public function addCircle(c:TRCircle):Void
	{
		this.addCirclef(c.radius);
	}

	/**
	 * Common function for adding a shape to the nape body instance.
	 * Note: That calling this or any other add[Shape] functions ellicts the body for collisions.
	 */
	public function addShape(s:Shape):Void
	{
		this.nBody.shapes.add(s);
	}

	/**
	 * Causes the body to stop spinning/rotating.
	 */
	public function stopRotating():Void
	{
		this.nBody.angularVel = 0;
	}
}
