package titanium_reindeer.util;

class UrlParser
{
    public var url:String;
	public var parts:Map<String, String>;

    public var source : String;
    public var protocol : String;
    public var authority : String;
    public var userInfo : String;
    public var user : String;
    public var password : String;
    public var host : String;
    public var port : String;
    public var relative : String;
    public var path : String;
    public var directory : String;
    public var file : String;
    public var query : String;
    public var anchor : String;
 
    inline static private var PART_NAMES:String = "source,protocol,authority,userInfo,user,password,host,port,relative,path,directory,file,query,anchor";
 
    public function new(url:String)
    {
        this.url = url;
 
        // The almighty regexp (courtesy of http://blog.stevenlevithan.com/archives/parseuri)
        var r : EReg = ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;
 
        // Match the regexp to the url
        r.match(url);
 
        // Use reflection to set each part
		var i = 0;
		for (partName in PART_NAMES.split(','))
        {
            this.parts.set(partName,  r.matched(i));
			++i;
        }
    }
 
    public function getFull():String
    {
		var parts:Array<String> = [
			this.parts.get('protocol'),
			'://',
			this.parts.get('authority'),
			this.parts.get('path'),
			'?',
			this.parts.get('query')
		];
		return parts.join('');
    }

	public function getUntilDirectory():String
	{
		var parts:Array<String> = [
			this.parts.get('protocol'),
			'://',
			this.parts.get('authority'),
			this.parts.get('directory')
		];
		return parts.join('');
	}
 
    public static function parse(url:String):UrlParser
    {
        return new UrlParser(url);
    }
}
