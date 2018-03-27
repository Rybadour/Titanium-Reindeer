package titanium_reindeer.util;

import titanium_reindeer.Enums;

/**
 * A collection of static functions for a variety of simple operations not already specified in the
 * Haxe standard library.
 */
class Utility
{
	/**
	 * Detects the availability of web workers in the browser.
	 * Returns true if the feature is available to use.
	 */
	public static function browserHasWebWorkers():Bool
	{
		var r:Bool = false;
		untyped
		{
			__js__('r = !!Window.Worker');
		}
		return r;
	}

	public static function randomBool():Bool
	{
		return Std.random(2) == 1;
	}

	public static function keyToString(key:Key):String
	{
		var label:String = '[UNKNOWN KEY]';
		switch (key)
		{
			case Key.BackSpace:    label = 'Backspace';
			case Key.Tab:          label = 'Tab';
			case Key.Enter:        label = 'Enter';
			case Key.Shift:        label = 'Shift';
			case Key.Ctrl:         label = 'Ctrl';
			case Key.Alt:          label = 'Alt';
			case Key.CapsLock:     label = 'Caps Lock';
			case Key.Esc:          label = 'Esc';
			case Key.Space:        label = 'Space';

			case Key.PageUp:       label = 'Page Up';
			case Key.PageDown:     label = 'Page Down';
			case Key.End:          label = 'End';
			case Key.Home:         label = 'Home';
			case Key.Insert:       label = 'Insert';
			case Key.Delete:       label = 'Delete';
			
			case Key.LeftArrow:    label = 'Left';
			case Key.UpArrow:      label = 'Up';
			case Key.RightArrow:   label = 'Right';
			case Key.DownArrow:    label = 'Down';

			case Key.Zero:         label = '0';
			case Key.One:          label = '1';
			case Key.Two:          label = '2';
			case Key.Three:        label = '3';
			case Key.Four:         label = '4';
			case Key.Five:         label = '5';
			case Key.Six:          label = '6';
			case Key.Seven:        label = '7';
			case Key.Eight:        label = '8';
			case Key.Nine:         label = '9';

			case Key.A:            label = 'A';
			case Key.B:            label = 'B';
			case Key.C:            label = 'C';
			case Key.D:            label = 'D';
			case Key.E:            label = 'E';
			case Key.F:            label = 'F';
			case Key.G:            label = 'G';
			case Key.H:            label = 'H';
			case Key.I:            label = 'I';
			case Key.J:            label = 'J';
			case Key.K:            label = 'K';
			case Key.L:            label = 'L';
			case Key.M:            label = 'M';
			case Key.N:            label = 'N';
			case Key.O:            label = 'O';
			case Key.P:            label = 'P';
			case Key.Q:            label = 'Q';
			case Key.R:            label = 'R';
			case Key.S:            label = 'S';
			case Key.T:            label = 'T';
			case Key.U:            label = 'U';
			case Key.V:            label = 'V';
			case Key.W:            label = 'W';
			case Key.X:            label = 'X';
			case Key.Y:            label = 'Y';
			case Key.Z:            label = 'Z';

			case Key.NumOne:       label = 'NumPad 1';
			case Key.NumTwo:       label = 'NumPad 2';
			case Key.NumThree:     label = 'NumPad 3';
			case Key.NumFour:      label = 'NumPad 4';
			case Key.NumFive:      label = 'NumPad 5';
			case Key.NumSix:       label = 'NumPad 6';
			case Key.NumSeven:     label = 'NumPad 7';
			case Key.NumEight:     label = 'NumPad 8';
			case Key.NumNine:      label = 'NumPad 9';
			case Key.NumAsterick:  label = 'NumPad *';
			case Key.NumPlus:      label = 'NumPad +';
			case Key.NumDash:      label = 'NumPad -';
			case Key.NumSlash:     label = 'NumPad /';

			case Key.F1:           label = 'F1';
			case Key.F2:           label = 'F2';
			case Key.F3:           label = 'F3';
			case Key.F4:           label = 'F4';
			case Key.F5:           label = 'F5';
			case Key.F6:           label = 'F6';
			case Key.F7:           label = 'F7';
			case Key.F8:           label = 'F8';
			case Key.F9:           label = 'F9';
			case Key.F10:          label = 'F10';
			case Key.F11:          label = 'F11';
			case Key.F12:          label = 'F12';

			case Key.NumLock:      label = 'Numlock';
			case Key.SemiColon:    label = ';';
			case Key.Equals:       label = '=';
			case Key.Comma:        label = ',';
			case Key.Dash:         label = '-';
			case Key.Period:       label = '.';
			case Key.Slash:        label = '/';
			case Key.Tilde:        label = '~';
			case Key.LeftBracket:  label = '[';
			case Key.BackSlash:    label = '\\';
			case Key.RightBracket: label = ']';
			case Key.Quote:        label = '\'';

			default: key = Key.None;
		}
		return label;
	}

	/**
	 * Returns an array of arrays for each matcher function passed. Matchers are ran in order and the
	 * first true result assigns that item to that bucket. All non-matching items are discarded.
	 */
	public static function splitArray<T>(arr:Array<T>, matchers:Array<T -> Bool>):Array<Array<T>>
	{
		var results:Array<Array<T>> = [];
		for (i in 0...matchers.length)
			results.push([]);

		for (item in arr)
		{
			for (i in 0...matchers.length)
			{
				if (matchers[i](item))
				{
					results[i].push(item);
					break;
				}
			}
		}

		return results;
	}

	public static function randomEnum<T>(e:Enum<T>):T
	{
		var enums = Type.allEnums(e);
		return enums[Std.random(enums.length)];
	}
}
