package titanium_reindeer;

import haxe.Timer;
import js.Dom;

class Game
{
	public static inline var DEFAULT_UPDATES_TIME_MS:Int 	= Math.round(1000/60); // 60 fps


	public var targetElement(default, null):HtmlDom;
	public var width:Int;
	public var height:Int;

	public var backgroundColor:Color;

	public var debugMode:Bool;
	public var maxAllowedUpdateLengthMs(default, setMaxAllowedUpdateLengthMs):Int;
	private function setMaxAllowedUpdateLengthMs(value:Int):Int
	{
		if (value != this.maxAllowedUpdateLengthMs)
		{
			this.maxAllowedUpdateLengthMs = Std.int(Math.max(1, Math.min(value, Math.POSITIVE_INFINITY)));
		}

		return this.maxAllowedUpdateLengthMs;
	}

	private var exitGame:Bool;
	private var msLastTimeStep:Int;

	// Managers
	public var sceneManager(default, null):SceneManager;
	public var inputManager(default, null):GameInputManager;
	public var soundManager(default, null):SoundManager;
	public var cursor(default, null):Cursor;

	public function new(targetHtmlId:String, ?width:Int, ?height:Int, ?debugMode:Bool)
	{
		this.targetElement = js.Lib.document.getElementById(targetHtmlId);
		this.targetElement.style.position = "relative";

		this.width = width == null ? 400 : width;
		this.height = height == null ? 300 : height;

		this.debugMode = debugMode == null ? false : debugMode;
		this.maxAllowedUpdateLengthMs = 1000; // 1 fps

		this.exitGame = false;

		this.sceneManager = new SceneManager(this);
		this.inputManager = new GameInputManager(this, this.targetElement);
		this.soundManager = new SoundManager();
		this.cursor = new Cursor(this.targetElement);

		if (debugMode)
		{
			js.Lib.setErrorHandler(function (msg:String, stack:Array<String>)
			{
				js.Lib.alert("ERROR[ "+msg+" ]");
				trace(stack);
				return true;
			});
		}
	}

	public function play():Void
	{
		// Start the game loop
		requestAnimFrame();
	}

	private function gameLoop(now:Int):Void
	{
		if (exitGame)
		{
			this.destroy();
		}
		else
		{
			if (this.msLastTimeStep == null)
				this.msLastTimeStep = now;

			var msTimeStep:Int;
			if (now == null)
				msTimeStep = Game.DEFAULT_UPDATES_TIME_MS;
			else
				msTimeStep = Std.int(Math.min(now - this.msLastTimeStep, this.maxAllowedUpdateLengthMs));
			this.msLastTimeStep = now;

			// Game Logic
			inputManager.preUpdate(msTimeStep);

			this.update(msTimeStep);
			sceneManager.update(msTimeStep);
			inputManager.update(msTimeStep);

			inputManager.postUpdate(msTimeStep);

			// Request a game loop tick from the browser
			requestAnimFrame();
		}
	}

	// Setup the request animation frame wrapper for browser compatibility
	private function requestAnimFrame()
	{
		// This terrible code seems to be the only way I could get Haxe to allow me to call browser specific functions
		// Assigning the functions to a variable was causing the javascript code to crash
		untyped
		{
			if (js.Lib.window.requestAnimationFrame)
				js.Lib.window.requestAnimationFrame(gameLoop, this.targetElement);
			
			else if (js.Lib.window.webkitRequestAnimationFrame)
				js.Lib.window.webkitRequestAnimationFrame(gameLoop, this.targetElement);

			else if (js.Lib.window.mozRequestAnimationFrame)
				js.Lib.window.mozRequestAnimationFrame(gameLoop, this.targetElement);

			else if (js.Lib.window.oRequestAnimationFrame)
				js.Lib.window.oRequestAnimationFrame(gameLoop, this.targetElement);

			else if (js.Lib.window.msRequestAnimationFrame)
				js.Lib.window.msRequestAnimationFrame(gameLoop, this.targetElement);

			else
				js.Lib.window.setTimeout(gameLoop, Game.DEFAULT_UPDATES_TIME_MS);
		}
	}

	public function update(msTimeStep:Int):Void { }

	public function destroy():Void
	{
		this.targetElement = null;
		this.backgroundColor = null;

		this.sceneManager.destroy();
		this.inputManager.destroy();
	}

	public function stopGame():Void
	{
		this.exitGame = true;
	}
}
