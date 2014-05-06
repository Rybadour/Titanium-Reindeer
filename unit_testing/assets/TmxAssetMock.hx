import titanium_reindeer.assets.*;

class TmxAssetMock extends TmxAsset
{
	private var loading:Bool;
	private var delayRemainingMs:Int;

	public function new(tmxFile:String, imageLoader:ImageLoader)
	{
		super('', imageLoader);

		this.data = tmxFile;
		this.loading = false;
	}

	/**
	 * Prevent the natural loading of this http asset.
	 * Include an arbitrary 1 second delay in the fake loading process.
	 */
	public override function load()
	{
		this.delayRemainingMs = 1000;
		this.loading = true;
	}

	/**
	 * Update the faked state of the Tmx file.
	 */
	public function update(msTimeStep:Int):Void
	{
		if (this.loading)
		{
			this.delayRemainingMs -= msTimeStep;
			if (this.delayRemainingMs < 0)
			{
				this.delayRemainingMs = 0;
				this.loading = false;
				super._onload(null);
			}
		}
	}
}
