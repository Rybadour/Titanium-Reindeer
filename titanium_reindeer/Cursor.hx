package titanium_reindeer;

import js.Dom;

enum CursorType
{
	AllScroll;
	ColResize;
	CrossHair;
	Custom;
	Default;
	EResize;
	Help;
	Move;
	NEResize;
	NoDrop;
	None;
	NotAllowed;
	NResize;
	NWResize;
	Pointer;
	Progress;
	RowResize;
	SEResize;
	SResize;
	SWResize;
	Text;
	VerticalText;
	Wait;
	WResize;
}

class Cursor
{
	public var cursorType(default, setCursorType):CursorType;
	private function setCursorType(value:CursorType):CursorType
	{
		if (value != this.cursorType)
		{
			this.cursorType = value;

			// Reset the custom url if the type is set to something non-custom
			if (this.cursorType != CursorType.Custom)
				this.customUrl = "";

			this.targetElement.style.cursor = this.getCursorTypeValue(this.cursorType);
		}

		return this.cursorType;
	}

	public var customUrl(default, setCustomUrl):String;
	private function setCustomUrl(value:String):String
	{
		if (value != this.customUrl)
		{
			this.customUrl = value;
			
			if (this.customUrl != "")
			{
				// Set the cursor type to custom
				this.cursorType = CursorType.Custom;
			}
		}

		return this.customUrl;
	}

	private var targetElement:HtmlDom;

	public function new(targetElement:HtmlDom)
	{
		this.targetElement = targetElement;
		this.cursorType = CursorType.Default;
	}

	public function getCursorTypeValue(cursorType:CursorType):String
	{
		var value:String = "";

		switch (cursorType)
		{
			case AllScroll: value = "all-scroll";
			case ColResize: value = "col-resize";
			case CrossHair: value = "crosshair";
			case Default: value = "default";
			case EResize: value = "E-resize";
			case Help: value = "help";
			case Move: value = "move";
			case NEResize: value = "NE-resize";
			case NoDrop: value = "no-drop";
			case None: value = "none";
			case NotAllowed: value = "not-allowed";
			case NResize: value = "N-resize";
			case NWResize: value = "NW-resize";
			case Pointer: value = "pointer";
			case Progress: value = "progress";
			case RowResize: value = "row-resize";
			case SEResize: value = "SE-resize";
			case SResize: value = "S-resize";
			case SWResize: value = "sw-resize";
			case Text: value = "text";
			case VerticalText: value = "vertical-text";
			case Wait: value = "wait";
			case WResize: value = "W-resize";

			case Custom: 
				var curReplaceReg = ~/\..*$/;
				var customCur:String = curReplaceReg.replace(this.customUrl, ".cur");
				value = "url("+this.customUrl+"), url("+customCur+"), auto";
		}

		return value;
	}
}
