package titanium_reindeer.spatial;

interface IRegionGroup<T>
{
	public function getIntersectingRect(rect:RectRegion):Array<T>;
	public function getIntersectingCircle(cirle:CircleRegion):Array<T>;
}
