package titanium_reindeer.tiling.tmx;

class TmxAsset extends XmlAsset
{
	public var tmxMap:TmxMap;
	public var expectedVersion:String;

	public function new(expectedVersion:String)
	{
		this.expectedVersion = expectedVersion;
	}

	private override function onLoad(event:Event)
	{
		super.onLoad(event);

		// Should be data?
		this.tmxMap = new TmxMap(new TmxXml(Xml.parse(this.data)));//, this.expectedVersion));
	}
}
