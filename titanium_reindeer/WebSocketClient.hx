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

	public var onOpen(null, bindOnOpen):Void -> Void;
	public var onMessage(null, bindOnMessage):String -> Void;
	public var onError(null, bindOnError):Void -> Void;
	public var onClose(null, bindOnClose):Void -> Void;

	public function new(host:String)
	{
		untyped
		{
			__js__("this.socket = new WebSocket(host);");
			this.socket.onopen = this.onOpenHandle;
			this.socket.onmessage = this.onMessageHandle;
			this.socket.onerror = this.onErrorHandle;
			this.socket.onclose = this.onCloseHandle;
		}
	}

	private function onOpenHandle(event:Dynamic):Void
	{
		var msg = event;
	}

	private function onMessageHandle(event:Dynamic):Void
	{
		var msg = event;
	}

	private function onErrorHandle(event:Dynamic):Void
	{
		var msg = event;
	}

	private function onCloseHandle(event:Dynamic):Void
	{
		var msg = event;
	}

	// Bindings for handler functions
	public function bindOnOpen(func:Void -> Void):Void -> Void
	{
		return null;
	}

	public function bindOnMessage(func:String -> Void):String -> Void
	{
		return null;
	}

	public function bindOnError(func:Void -> Void):Void -> Void
	{
		return null;
	}

	public function bindOnClose(func:Void -> Void):Void -> Void
	{
		return null;
	}

	public function unbindOnOpen(func:Void -> Void):Void
	{
		return null;
	}

	public function unbindOnMessage(func:String -> Void):Void
	{
		return null;
	}

	public function unbindOnError(func:Void -> Void):Void
	{
		return null;
	}

	public function unbindOnClose(func:Void -> Void):Void
	{
		return null;
	}
}
