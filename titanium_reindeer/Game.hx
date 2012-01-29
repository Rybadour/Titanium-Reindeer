package titanium_reindeer;

import haxe.Timer;
import js.Dom;

class Game
{
	public static inline var DEFAULT_UPDATES_TIME_MS:Int 	= Math.round(1000/60); // 60 fps


	public var targetElement(default, null):HtmlDom;
	public var width:Int;
	public var height:Int;

	public var layerCount:Int;
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
	public var gameObjectManager(default, null):GameObjectManager;
	public var inputManager(default, null):InputManager;
	public var soundManager(default, null):SoundManager;
	public var cursor(default, null):Cursor;
	// TODO: Screen manager

	public function new(?targetHtmlId:String, ?width:Int, ?height:Int, ?layerCount:Int, ?debugMode:Bool, ?backgroundColor:Color)
	{
		if (targetHtmlId == null || targetHtmlId == "")
			this.targetElement = js.Lib.document.createElement("div");
		else
			this.targetElement = js.Lib.document.getElementById(targetHtmlId);

		this.width = width == null ? 400 : width;
		this.height = height == null ? 300 : height;

		this.layerCount = layerCount == null ? 1 : layerCount;
		this.backgroundColor = backgroundColor == null ? new Color(255, 255, 255) : backgroundColor;

		this.debugMode = debugMode == null ? false : debugMode;
		this.maxAllowedUpdateLengthMs = 1000; // 1 fps

		this.exitGame = false;

		this.gameObjectManager = new GameObjectManager(this);
		this.inputManager = new InputManager(this.targetElement);
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
			{
				msTimeStep = Game.DEFAULT_UPDATES_TIME_MS;
			}
			else
			{
				msTimeStep = Std.int(Math.min(now - this.msLastTimeStep, this.maxAllowedUpdateLengthMs));
			}
			this.msLastTimeStep = now;

			this.update(msTimeStep);

			// Game Logic
			gameObjectManager.update(msTimeStep);
			inputManager.update(msTimeStep);

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
		targetElement = null;
		backgroundColor = null;

		gameObjectManager.destroy();
		inputManager.destroy();
	}

	public function stopGame():Void
	{
		exitGame = true;
	}
}
