package titanium_reindeer;

enum ReadyState
{
	Connecting;
	Open;
	Closing;
	Closed;
	None;
}

class WebSocketClient
{
	public var socket(default, null):Dynamic;

	public var readyState(getReadyState, null):ReadyState;
	public function getReadyState():ReadyState
	{
		switch (this.socket.readyState)
		{
			case 0:
				return ReadyState.Connecting;
			case 1:
				return ReadyState.Open;
			case 2:
				return ReadyState.Closing;
			case 3:
				return ReadyState.Closed;
		}
		return ReadyState.None;
	}

	private var eventBinder:EventBinder;
	public var onOpen(null, bindOpen):Void -> Void;
	public var onMessage(null, bindMessage):String -> Void;
	public var onError(null, bindError):Void -> Void;
	public var onClose(null, bindClose):Void -> Void;

	public function new(host:String)
	{
		this.socket = untyped __js__("new WebSocket(host)");
		this.socket.onopen = this.onOpenHandle;
		this.socket.onmessage = this.onMessageHandle;
		this.socket.onerror = this.onErrorHandle;
		this.socket.onclose = this.onCloseHandle;

		this.eventBinder = new EventBinder(["open", "message", "error", "close"]);
	}

	public function send(message:String):Void
	{
		this.socket.send(message);
	}

	private function onOpenHandle(event:Dynamic):Void
	{
		this.eventBinder.callBindsVoid("open");
	}

	private function onMessageHandle(event:Dynamic):Void
	{
		this.eventBinder.callBinds1Arg("message", event.data);
	}

	private function onErrorHandle(event:Dynamic):Void
	{
		this.eventBinder.callBindsVoid("error");
	}

	private function onCloseHandle(event:Dynamic):Void
	{
		this.eventBinder.callBindsVoid("close");
	}

	// Bindings for handler functions
	public function bindOpen(func:Void -> Void):Void -> Void
	{
		this.eventBinder.bindFunc("open", func);
		return func;
	}

	public function bindMessage(func:String -> Void):String -> Void
	{
		this.eventBinder.bindFunc("message", func);
		return func;
	}

	public function bindError(func:Void -> Void):Void -> Void
	{
		this.eventBinder.bindFunc("error", func);
		return func;
	}

	public function bindClose(func:Void -> Void):Void -> Void
	{
		this.eventBinder.bindFunc("close", func);
		return func;
	}

	public function unbindOpen(func:Void -> Void):Void
	{
		this.eventBinder.unbindFunc("open", func);
	}

	public function unbindMessage(func:String -> Void):Void
	{
		this.eventBinder.unbindFunc("message", func);
	}

	public function unbindError(func:Void -> Void):Void
	{
		this.eventBinder.unbindFunc("error", func);
	}

	public function unbindClose(func:Void -> Void):Void
	{
		this.eventBinder.unbindFunc("close", func);
	}
}
