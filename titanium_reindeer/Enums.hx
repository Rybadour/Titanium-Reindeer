package titanium_reindeer;

// This file contains publicly usable enum types

enum MouseButton
{
	Left;
	Right;
	Middle;

	None;
}

enum MouseButtonState
{
	Down;
	Held;
	Up;
}

enum Key
{
	Esc; F1; F2; F3; F4; F5; F6; F7; F8; F9; F10; F11; F12;
	Tilde; One; Two; Three; Four; Five; Six; Seven; Eight; Nine; Zero; Dash; Equals;

	A; B; C; D; E; F; G; H; I; J; K; L; M; N; O; P; Q; R; S; T; U; V; W; X; Y; Z;
	SemiColon; Quote; Comma; Period; BackSlash; Slash; LeftBracket; RightBracket;
	Tab; CapsLock; Ctrl; Alt; Shift; Space; Enter; BackSpace;
	UpArrow; RightArrow; DownArrow; LeftArrow;

 	Insert; Delete; Home; End; PageUp; PageDown; NumLock;
	NumSlash; NumAsterick; NumDash; NumPlus;
 	NumOne; NumTwo; NumThree; NumFour; NumFive; NumSix; NumSeven; NumEight; NumNine; NumZero;

	None;
}

enum KeyState
{
	Down;
	Held;
	Up;
}

enum InputEvent
{
	MouseDown;
	MouseUp;
	MouseMove;
	MouseWheel;
	KeyUp;
	KeyDown;

	MouseHeldEvent;
	KeyHeldEvent;
	MouseAnyEvent;
	KeyAnyEvent;
}

enum Composition
{
	SourceAtop; SourceIn; SourceOut; SourceOver;
	DestinationAtop; DestinationIn; DestinationOut; DestinationOver;
	Lighter; Copy; Xor;
}

enum LineCapType
{
	Butt; Round; Square;
}

enum LineJoinType
{
	Round; Bevel; Miter;
}

enum FillTypes
{
	Gradient; Pattern; FillColor;
}

enum StrokeTypes
{
	Gradient; StrokeColor;
}
