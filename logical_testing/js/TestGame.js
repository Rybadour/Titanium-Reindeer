$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof titanium_reindeer=='undefined') titanium_reindeer = {}
if(!titanium_reindeer.components) titanium_reindeer.components = {}
titanium_reindeer.components.CanvasRenderState = function(renderFunc) { if( renderFunc === $_ ) return; {
	this.renderFunc = renderFunc;
	this.setAlpha(1);
	this.setRotation(0);
	this.position = new titanium_reindeer.core.Watcher(new titanium_reindeer.Vector2(0,0));
}}
titanium_reindeer.components.CanvasRenderState.__name__ = ["titanium_reindeer","components","CanvasRenderState"];
titanium_reindeer.components.CanvasRenderState.prototype.renderFunc = null;
titanium_reindeer.components.CanvasRenderState.prototype.alpha = null;
titanium_reindeer.components.CanvasRenderState.prototype.setAlpha = function(value) {
	if(value < 0) value = 0;
	else if(value > 1) value = 1;
	if(value != this.alpha) {
		this.alpha = value;
	}
	return this.alpha;
}
titanium_reindeer.components.CanvasRenderState.prototype.shadow = null;
titanium_reindeer.components.CanvasRenderState.prototype.setShadow = function(value) {
	if(value != null) {
		if(this.shadow == null || !value.equal(this.shadow)) {
			this.shadow = value;
		}
	}
	return this.shadow;
}
titanium_reindeer.components.CanvasRenderState.prototype.rotation = null;
titanium_reindeer.components.CanvasRenderState.prototype.setRotation = function(value) {
	value %= Math.PI * 2;
	if(value != this.rotation) {
		this.rotation = value;
	}
	return this.rotation;
}
titanium_reindeer.components.CanvasRenderState.prototype.position = null;
titanium_reindeer.components.CanvasRenderState.prototype.localPosition = null;
titanium_reindeer.components.CanvasRenderState.prototype.getLocalPosition = function() {
	return this.position.value;
}
titanium_reindeer.components.CanvasRenderState.prototype.setLocalPosition = function(value) {
	this.position.setValue(value);
	return this.position.value;
}
titanium_reindeer.components.CanvasRenderState.prototype.preRender = function(canvas) {
	canvas.ctx.save();
	canvas.ctx.globalAlpha = this.alpha;
	if(this.shadow != null) {
		canvas.ctx.shadowColor = this.shadow.color.getRgba();
		canvas.ctx.shadowOffsetX = this.shadow.offset.getX();
		canvas.ctx.shadowOffsetY = this.shadow.offset.getY();
		canvas.ctx.shadowBlur = this.shadow.blur;
	}
}
titanium_reindeer.components.CanvasRenderState.prototype.render = function(canvas) {
	this.preRender(canvas);
	this.renderFunc(canvas);
	this.postRender(canvas);
}
titanium_reindeer.components.CanvasRenderState.prototype.postRender = function(canvas) {
	canvas.ctx.restore();
}
titanium_reindeer.components.CanvasRenderState.prototype.__class__ = titanium_reindeer.components.CanvasRenderState;
titanium_reindeer.components.CanvasStrokeFillState = function(renderFunc) { if( renderFunc === $_ ) return; {
	titanium_reindeer.components.CanvasRenderState.call(this,renderFunc);
	this.isFillUnstyled = false;
	this.isStrokeUnstyled = false;
}}
titanium_reindeer.components.CanvasStrokeFillState.__name__ = ["titanium_reindeer","components","CanvasStrokeFillState"];
titanium_reindeer.components.CanvasStrokeFillState.__super__ = titanium_reindeer.components.CanvasRenderState;
for(var k in titanium_reindeer.components.CanvasRenderState.prototype ) titanium_reindeer.components.CanvasStrokeFillState.prototype[k] = titanium_reindeer.components.CanvasRenderState.prototype[k];
titanium_reindeer.components.CanvasStrokeFillState.prototype.lastRenderedCanvas = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.fillStyle = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.currentFill = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.isFillUnstyled = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.fillColor = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setFill = function(value) {
	if(value != null) {
		this.currentFill = titanium_reindeer.FillTypes.ColorFill;
		if(this.fillStyle != value.getRgba()) {
			this.fillColor = value;
			this.fillStyle = value.getRgba();
		}
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.fillGradient = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setFillGradient = function(value) {
	if(value != null) {
		this.fillGradient = value;
		this.currentFill = titanium_reindeer.FillTypes.Gradient;
		if(this.lastRenderedCanvas != null) {
			var style = value.getStyle(this.lastRenderedCanvas);
			if(this.fillStyle != style) {
				this.fillStyle = style;
			}
		}
		else this.isFillUnstyled = true;
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.fillPattern = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setFillPattern = function(value) {
	if(value != null) {
		this.fillPattern = value;
		this.currentFill = titanium_reindeer.FillTypes.Pattern;
		if(value.imageSource.isLoaded) {
			if(this.lastRenderedCanvas != null) {
				var style = value.getStyle(this.lastRenderedCanvas);
				if(this.fillStyle != style) {
					this.fillStyle = style;
				}
			}
			else this.isFillUnstyled = true;
		}
		else {
			value.imageSource.registerLoadEvent($closure(this,"fillPatternImageLoaded"));
		}
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.strokeStyle = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.currentStroke = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.isStrokeUnstyled = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.strokeColor = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setStrokeColor = function(value) {
	if(value != null) {
		this.strokeColor = value;
		this.currentStroke = titanium_reindeer.StrokeTypes.StrokeColor;
		if(this.strokeStyle != value.getRgba()) {
			this.strokeStyle = this.strokeColor.getRgba();
		}
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.strokeGradient = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setStrokeGradient = function(value) {
	if(value != null) {
		this.strokeGradient = value;
		this.currentStroke = titanium_reindeer.StrokeTypes.Gradient;
		if(this.lastRenderedCanvas != null) {
			var style = value.getStyle(this.lastRenderedCanvas);
			if(this.strokeStyle != style) {
				this.strokeStyle = style;
			}
		}
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.lineWidth = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setLineWidth = function(value) {
	if(value != this.lineWidth) {
		this.lineWidth = value;
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.lineCap = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setLineCap = function(value) {
	if(value != this.lineCap) {
		this.lineCap = value;
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.lineJoin = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setLineJoin = function(value) {
	if(value != this.lineJoin) {
		this.lineJoin = value;
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.miterLimit = null;
titanium_reindeer.components.CanvasStrokeFillState.prototype.setMiterLimit = function(value) {
	if(value != this.miterLimit) {
		this.miterLimit = value;
	}
	return value;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.fillPatternImageLoaded = function(event) {
	if(this.lastRenderedCanvas != null) {
		if(this.fillStyle != this.fillPattern.getStyle(this.lastRenderedCanvas)) {
			this.fillStyle = this.fillPattern.getStyle(this.lastRenderedCanvas);
		}
	}
	else this.isFillUnstyled = true;
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.preRender = function(canvas) {
	this.lastRenderedCanvas = canvas;
	if(this.isFillUnstyled) {
		if(this.currentFill == titanium_reindeer.FillTypes.Gradient) this.fillStyle = this.fillGradient.getStyle(this.lastRenderedCanvas);
		else if(this.currentFill == titanium_reindeer.FillTypes.Pattern) this.fillStyle = this.fillPattern.getStyle(this.lastRenderedCanvas);
		this.isFillUnstyled = false;
	}
	if(this.isStrokeUnstyled) {
		if(this.currentStroke == titanium_reindeer.StrokeTypes.Gradient) this.strokeStyle = this.strokeGradient.getStyle(this.lastRenderedCanvas);
		this.isStrokeUnstyled = false;
	}
}
titanium_reindeer.components.CanvasStrokeFillState.prototype.__class__ = titanium_reindeer.components.CanvasStrokeFillState;
if(!titanium_reindeer.core) titanium_reindeer.core = {}
titanium_reindeer.core.IHasIdProvider = function() { }
titanium_reindeer.core.IHasIdProvider.__name__ = ["titanium_reindeer","core","IHasIdProvider"];
titanium_reindeer.core.IHasIdProvider.prototype.idProvider = null;
titanium_reindeer.core.IHasIdProvider.prototype.__class__ = titanium_reindeer.core.IHasIdProvider;
Provider = function(p) { if( p === $_ ) return; {
	this.idProvider = new titanium_reindeer.core.IdProvider();
}}
Provider.__name__ = ["Provider"];
Provider.prototype.idProvider = null;
Provider.prototype.__class__ = Provider;
Provider.__interfaces__ = [titanium_reindeer.core.IHasIdProvider];
titanium_reindeer.core.IShape = function() { }
titanium_reindeer.core.IShape.__name__ = ["titanium_reindeer","core","IShape"];
titanium_reindeer.core.IShape.prototype.getBoundingRect = null;
titanium_reindeer.core.IShape.prototype.isPointInside = null;
titanium_reindeer.core.IShape.prototype.getArea = null;
titanium_reindeer.core.IShape.prototype.__class__ = titanium_reindeer.core.IShape;
titanium_reindeer.core.IRegion = function() { }
titanium_reindeer.core.IRegion.__name__ = ["titanium_reindeer","core","IRegion"];
titanium_reindeer.core.IRegion.prototype.getBoundingRegion = null;
titanium_reindeer.core.IRegion.prototype.center = null;
titanium_reindeer.core.IRegion.prototype.__class__ = titanium_reindeer.core.IRegion;
titanium_reindeer.core.IRegion.__interfaces__ = [titanium_reindeer.core.IShape];
titanium_reindeer.core.IWatchable = function() { }
titanium_reindeer.core.IWatchable.__name__ = ["titanium_reindeer","core","IWatchable"];
titanium_reindeer.core.IWatchable.prototype.value = null;
titanium_reindeer.core.IWatchable.prototype.onChange = null;
titanium_reindeer.core.IWatchable.prototype.bindOnChange = null;
titanium_reindeer.core.IWatchable.prototype.__class__ = titanium_reindeer.core.IWatchable;
titanium_reindeer.MouseButton = { __ename__ : ["titanium_reindeer","MouseButton"], __constructs__ : ["Left","Right","Middle","None"] }
titanium_reindeer.MouseButton.Left = ["Left",0];
titanium_reindeer.MouseButton.Left.toString = $estr;
titanium_reindeer.MouseButton.Left.__enum__ = titanium_reindeer.MouseButton;
titanium_reindeer.MouseButton.Right = ["Right",1];
titanium_reindeer.MouseButton.Right.toString = $estr;
titanium_reindeer.MouseButton.Right.__enum__ = titanium_reindeer.MouseButton;
titanium_reindeer.MouseButton.Middle = ["Middle",2];
titanium_reindeer.MouseButton.Middle.toString = $estr;
titanium_reindeer.MouseButton.Middle.__enum__ = titanium_reindeer.MouseButton;
titanium_reindeer.MouseButton.None = ["None",3];
titanium_reindeer.MouseButton.None.toString = $estr;
titanium_reindeer.MouseButton.None.__enum__ = titanium_reindeer.MouseButton;
titanium_reindeer.MouseButtonState = { __ename__ : ["titanium_reindeer","MouseButtonState"], __constructs__ : ["Down","Held","Up"] }
titanium_reindeer.MouseButtonState.Down = ["Down",0];
titanium_reindeer.MouseButtonState.Down.toString = $estr;
titanium_reindeer.MouseButtonState.Down.__enum__ = titanium_reindeer.MouseButtonState;
titanium_reindeer.MouseButtonState.Held = ["Held",1];
titanium_reindeer.MouseButtonState.Held.toString = $estr;
titanium_reindeer.MouseButtonState.Held.__enum__ = titanium_reindeer.MouseButtonState;
titanium_reindeer.MouseButtonState.Up = ["Up",2];
titanium_reindeer.MouseButtonState.Up.toString = $estr;
titanium_reindeer.MouseButtonState.Up.__enum__ = titanium_reindeer.MouseButtonState;
titanium_reindeer.Key = { __ename__ : ["titanium_reindeer","Key"], __constructs__ : ["Esc","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","Tilde","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Zero","Dash","Equals","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","SemiColon","Quote","Comma","Period","BackSlash","Slash","LeftBracket","RightBracket","Tab","CapsLock","Ctrl","Alt","Shift","Space","Enter","BackSpace","UpArrow","RightArrow","DownArrow","LeftArrow","Insert","Delete","Home","End","PageUp","PageDown","NumLock","NumSlash","NumAsterick","NumDash","NumPlus","NumOne","NumTwo","NumThree","NumFour","NumFive","NumSix","NumSeven","NumEight","NumNine","NumZero","None"] }
titanium_reindeer.Key.Esc = ["Esc",0];
titanium_reindeer.Key.Esc.toString = $estr;
titanium_reindeer.Key.Esc.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F1 = ["F1",1];
titanium_reindeer.Key.F1.toString = $estr;
titanium_reindeer.Key.F1.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F2 = ["F2",2];
titanium_reindeer.Key.F2.toString = $estr;
titanium_reindeer.Key.F2.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F3 = ["F3",3];
titanium_reindeer.Key.F3.toString = $estr;
titanium_reindeer.Key.F3.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F4 = ["F4",4];
titanium_reindeer.Key.F4.toString = $estr;
titanium_reindeer.Key.F4.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F5 = ["F5",5];
titanium_reindeer.Key.F5.toString = $estr;
titanium_reindeer.Key.F5.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F6 = ["F6",6];
titanium_reindeer.Key.F6.toString = $estr;
titanium_reindeer.Key.F6.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F7 = ["F7",7];
titanium_reindeer.Key.F7.toString = $estr;
titanium_reindeer.Key.F7.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F8 = ["F8",8];
titanium_reindeer.Key.F8.toString = $estr;
titanium_reindeer.Key.F8.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F9 = ["F9",9];
titanium_reindeer.Key.F9.toString = $estr;
titanium_reindeer.Key.F9.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F10 = ["F10",10];
titanium_reindeer.Key.F10.toString = $estr;
titanium_reindeer.Key.F10.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F11 = ["F11",11];
titanium_reindeer.Key.F11.toString = $estr;
titanium_reindeer.Key.F11.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F12 = ["F12",12];
titanium_reindeer.Key.F12.toString = $estr;
titanium_reindeer.Key.F12.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Tilde = ["Tilde",13];
titanium_reindeer.Key.Tilde.toString = $estr;
titanium_reindeer.Key.Tilde.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.One = ["One",14];
titanium_reindeer.Key.One.toString = $estr;
titanium_reindeer.Key.One.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Two = ["Two",15];
titanium_reindeer.Key.Two.toString = $estr;
titanium_reindeer.Key.Two.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Three = ["Three",16];
titanium_reindeer.Key.Three.toString = $estr;
titanium_reindeer.Key.Three.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Four = ["Four",17];
titanium_reindeer.Key.Four.toString = $estr;
titanium_reindeer.Key.Four.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Five = ["Five",18];
titanium_reindeer.Key.Five.toString = $estr;
titanium_reindeer.Key.Five.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Six = ["Six",19];
titanium_reindeer.Key.Six.toString = $estr;
titanium_reindeer.Key.Six.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Seven = ["Seven",20];
titanium_reindeer.Key.Seven.toString = $estr;
titanium_reindeer.Key.Seven.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Eight = ["Eight",21];
titanium_reindeer.Key.Eight.toString = $estr;
titanium_reindeer.Key.Eight.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Nine = ["Nine",22];
titanium_reindeer.Key.Nine.toString = $estr;
titanium_reindeer.Key.Nine.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Zero = ["Zero",23];
titanium_reindeer.Key.Zero.toString = $estr;
titanium_reindeer.Key.Zero.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Dash = ["Dash",24];
titanium_reindeer.Key.Dash.toString = $estr;
titanium_reindeer.Key.Dash.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Equals = ["Equals",25];
titanium_reindeer.Key.Equals.toString = $estr;
titanium_reindeer.Key.Equals.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.A = ["A",26];
titanium_reindeer.Key.A.toString = $estr;
titanium_reindeer.Key.A.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.B = ["B",27];
titanium_reindeer.Key.B.toString = $estr;
titanium_reindeer.Key.B.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.C = ["C",28];
titanium_reindeer.Key.C.toString = $estr;
titanium_reindeer.Key.C.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.D = ["D",29];
titanium_reindeer.Key.D.toString = $estr;
titanium_reindeer.Key.D.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.E = ["E",30];
titanium_reindeer.Key.E.toString = $estr;
titanium_reindeer.Key.E.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.F = ["F",31];
titanium_reindeer.Key.F.toString = $estr;
titanium_reindeer.Key.F.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.G = ["G",32];
titanium_reindeer.Key.G.toString = $estr;
titanium_reindeer.Key.G.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.H = ["H",33];
titanium_reindeer.Key.H.toString = $estr;
titanium_reindeer.Key.H.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.I = ["I",34];
titanium_reindeer.Key.I.toString = $estr;
titanium_reindeer.Key.I.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.J = ["J",35];
titanium_reindeer.Key.J.toString = $estr;
titanium_reindeer.Key.J.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.K = ["K",36];
titanium_reindeer.Key.K.toString = $estr;
titanium_reindeer.Key.K.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.L = ["L",37];
titanium_reindeer.Key.L.toString = $estr;
titanium_reindeer.Key.L.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.M = ["M",38];
titanium_reindeer.Key.M.toString = $estr;
titanium_reindeer.Key.M.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.N = ["N",39];
titanium_reindeer.Key.N.toString = $estr;
titanium_reindeer.Key.N.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.O = ["O",40];
titanium_reindeer.Key.O.toString = $estr;
titanium_reindeer.Key.O.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.P = ["P",41];
titanium_reindeer.Key.P.toString = $estr;
titanium_reindeer.Key.P.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Q = ["Q",42];
titanium_reindeer.Key.Q.toString = $estr;
titanium_reindeer.Key.Q.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.R = ["R",43];
titanium_reindeer.Key.R.toString = $estr;
titanium_reindeer.Key.R.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.S = ["S",44];
titanium_reindeer.Key.S.toString = $estr;
titanium_reindeer.Key.S.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.T = ["T",45];
titanium_reindeer.Key.T.toString = $estr;
titanium_reindeer.Key.T.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.U = ["U",46];
titanium_reindeer.Key.U.toString = $estr;
titanium_reindeer.Key.U.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.V = ["V",47];
titanium_reindeer.Key.V.toString = $estr;
titanium_reindeer.Key.V.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.W = ["W",48];
titanium_reindeer.Key.W.toString = $estr;
titanium_reindeer.Key.W.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.X = ["X",49];
titanium_reindeer.Key.X.toString = $estr;
titanium_reindeer.Key.X.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Y = ["Y",50];
titanium_reindeer.Key.Y.toString = $estr;
titanium_reindeer.Key.Y.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Z = ["Z",51];
titanium_reindeer.Key.Z.toString = $estr;
titanium_reindeer.Key.Z.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.SemiColon = ["SemiColon",52];
titanium_reindeer.Key.SemiColon.toString = $estr;
titanium_reindeer.Key.SemiColon.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Quote = ["Quote",53];
titanium_reindeer.Key.Quote.toString = $estr;
titanium_reindeer.Key.Quote.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Comma = ["Comma",54];
titanium_reindeer.Key.Comma.toString = $estr;
titanium_reindeer.Key.Comma.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Period = ["Period",55];
titanium_reindeer.Key.Period.toString = $estr;
titanium_reindeer.Key.Period.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.BackSlash = ["BackSlash",56];
titanium_reindeer.Key.BackSlash.toString = $estr;
titanium_reindeer.Key.BackSlash.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Slash = ["Slash",57];
titanium_reindeer.Key.Slash.toString = $estr;
titanium_reindeer.Key.Slash.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.LeftBracket = ["LeftBracket",58];
titanium_reindeer.Key.LeftBracket.toString = $estr;
titanium_reindeer.Key.LeftBracket.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.RightBracket = ["RightBracket",59];
titanium_reindeer.Key.RightBracket.toString = $estr;
titanium_reindeer.Key.RightBracket.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Tab = ["Tab",60];
titanium_reindeer.Key.Tab.toString = $estr;
titanium_reindeer.Key.Tab.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.CapsLock = ["CapsLock",61];
titanium_reindeer.Key.CapsLock.toString = $estr;
titanium_reindeer.Key.CapsLock.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Ctrl = ["Ctrl",62];
titanium_reindeer.Key.Ctrl.toString = $estr;
titanium_reindeer.Key.Ctrl.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Alt = ["Alt",63];
titanium_reindeer.Key.Alt.toString = $estr;
titanium_reindeer.Key.Alt.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Shift = ["Shift",64];
titanium_reindeer.Key.Shift.toString = $estr;
titanium_reindeer.Key.Shift.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Space = ["Space",65];
titanium_reindeer.Key.Space.toString = $estr;
titanium_reindeer.Key.Space.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Enter = ["Enter",66];
titanium_reindeer.Key.Enter.toString = $estr;
titanium_reindeer.Key.Enter.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.BackSpace = ["BackSpace",67];
titanium_reindeer.Key.BackSpace.toString = $estr;
titanium_reindeer.Key.BackSpace.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.UpArrow = ["UpArrow",68];
titanium_reindeer.Key.UpArrow.toString = $estr;
titanium_reindeer.Key.UpArrow.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.RightArrow = ["RightArrow",69];
titanium_reindeer.Key.RightArrow.toString = $estr;
titanium_reindeer.Key.RightArrow.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.DownArrow = ["DownArrow",70];
titanium_reindeer.Key.DownArrow.toString = $estr;
titanium_reindeer.Key.DownArrow.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.LeftArrow = ["LeftArrow",71];
titanium_reindeer.Key.LeftArrow.toString = $estr;
titanium_reindeer.Key.LeftArrow.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Insert = ["Insert",72];
titanium_reindeer.Key.Insert.toString = $estr;
titanium_reindeer.Key.Insert.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Delete = ["Delete",73];
titanium_reindeer.Key.Delete.toString = $estr;
titanium_reindeer.Key.Delete.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.Home = ["Home",74];
titanium_reindeer.Key.Home.toString = $estr;
titanium_reindeer.Key.Home.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.End = ["End",75];
titanium_reindeer.Key.End.toString = $estr;
titanium_reindeer.Key.End.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.PageUp = ["PageUp",76];
titanium_reindeer.Key.PageUp.toString = $estr;
titanium_reindeer.Key.PageUp.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.PageDown = ["PageDown",77];
titanium_reindeer.Key.PageDown.toString = $estr;
titanium_reindeer.Key.PageDown.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumLock = ["NumLock",78];
titanium_reindeer.Key.NumLock.toString = $estr;
titanium_reindeer.Key.NumLock.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumSlash = ["NumSlash",79];
titanium_reindeer.Key.NumSlash.toString = $estr;
titanium_reindeer.Key.NumSlash.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumAsterick = ["NumAsterick",80];
titanium_reindeer.Key.NumAsterick.toString = $estr;
titanium_reindeer.Key.NumAsterick.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumDash = ["NumDash",81];
titanium_reindeer.Key.NumDash.toString = $estr;
titanium_reindeer.Key.NumDash.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumPlus = ["NumPlus",82];
titanium_reindeer.Key.NumPlus.toString = $estr;
titanium_reindeer.Key.NumPlus.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumOne = ["NumOne",83];
titanium_reindeer.Key.NumOne.toString = $estr;
titanium_reindeer.Key.NumOne.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumTwo = ["NumTwo",84];
titanium_reindeer.Key.NumTwo.toString = $estr;
titanium_reindeer.Key.NumTwo.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumThree = ["NumThree",85];
titanium_reindeer.Key.NumThree.toString = $estr;
titanium_reindeer.Key.NumThree.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumFour = ["NumFour",86];
titanium_reindeer.Key.NumFour.toString = $estr;
titanium_reindeer.Key.NumFour.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumFive = ["NumFive",87];
titanium_reindeer.Key.NumFive.toString = $estr;
titanium_reindeer.Key.NumFive.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumSix = ["NumSix",88];
titanium_reindeer.Key.NumSix.toString = $estr;
titanium_reindeer.Key.NumSix.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumSeven = ["NumSeven",89];
titanium_reindeer.Key.NumSeven.toString = $estr;
titanium_reindeer.Key.NumSeven.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumEight = ["NumEight",90];
titanium_reindeer.Key.NumEight.toString = $estr;
titanium_reindeer.Key.NumEight.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumNine = ["NumNine",91];
titanium_reindeer.Key.NumNine.toString = $estr;
titanium_reindeer.Key.NumNine.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.NumZero = ["NumZero",92];
titanium_reindeer.Key.NumZero.toString = $estr;
titanium_reindeer.Key.NumZero.__enum__ = titanium_reindeer.Key;
titanium_reindeer.Key.None = ["None",93];
titanium_reindeer.Key.None.toString = $estr;
titanium_reindeer.Key.None.__enum__ = titanium_reindeer.Key;
titanium_reindeer.KeyState = { __ename__ : ["titanium_reindeer","KeyState"], __constructs__ : ["Down","Held","Up"] }
titanium_reindeer.KeyState.Down = ["Down",0];
titanium_reindeer.KeyState.Down.toString = $estr;
titanium_reindeer.KeyState.Down.__enum__ = titanium_reindeer.KeyState;
titanium_reindeer.KeyState.Held = ["Held",1];
titanium_reindeer.KeyState.Held.toString = $estr;
titanium_reindeer.KeyState.Held.__enum__ = titanium_reindeer.KeyState;
titanium_reindeer.KeyState.Up = ["Up",2];
titanium_reindeer.KeyState.Up.toString = $estr;
titanium_reindeer.KeyState.Up.__enum__ = titanium_reindeer.KeyState;
titanium_reindeer.InputEvent = { __ename__ : ["titanium_reindeer","InputEvent"], __constructs__ : ["MouseDown","MouseUp","MouseMove","MouseWheel","KeyUp","KeyDown","MouseHeldEvent","KeyHeldEvent","MouseAnyEvent","KeyAnyEvent"] }
titanium_reindeer.InputEvent.MouseDown = ["MouseDown",0];
titanium_reindeer.InputEvent.MouseDown.toString = $estr;
titanium_reindeer.InputEvent.MouseDown.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.MouseUp = ["MouseUp",1];
titanium_reindeer.InputEvent.MouseUp.toString = $estr;
titanium_reindeer.InputEvent.MouseUp.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.MouseMove = ["MouseMove",2];
titanium_reindeer.InputEvent.MouseMove.toString = $estr;
titanium_reindeer.InputEvent.MouseMove.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.MouseWheel = ["MouseWheel",3];
titanium_reindeer.InputEvent.MouseWheel.toString = $estr;
titanium_reindeer.InputEvent.MouseWheel.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.KeyUp = ["KeyUp",4];
titanium_reindeer.InputEvent.KeyUp.toString = $estr;
titanium_reindeer.InputEvent.KeyUp.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.KeyDown = ["KeyDown",5];
titanium_reindeer.InputEvent.KeyDown.toString = $estr;
titanium_reindeer.InputEvent.KeyDown.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.MouseHeldEvent = ["MouseHeldEvent",6];
titanium_reindeer.InputEvent.MouseHeldEvent.toString = $estr;
titanium_reindeer.InputEvent.MouseHeldEvent.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.KeyHeldEvent = ["KeyHeldEvent",7];
titanium_reindeer.InputEvent.KeyHeldEvent.toString = $estr;
titanium_reindeer.InputEvent.KeyHeldEvent.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.MouseAnyEvent = ["MouseAnyEvent",8];
titanium_reindeer.InputEvent.MouseAnyEvent.toString = $estr;
titanium_reindeer.InputEvent.MouseAnyEvent.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.InputEvent.KeyAnyEvent = ["KeyAnyEvent",9];
titanium_reindeer.InputEvent.KeyAnyEvent.toString = $estr;
titanium_reindeer.InputEvent.KeyAnyEvent.__enum__ = titanium_reindeer.InputEvent;
titanium_reindeer.Composition = { __ename__ : ["titanium_reindeer","Composition"], __constructs__ : ["SourceAtop","SourceIn","SourceOut","SourceOver","DestinationAtop","DestinationIn","DestinationOut","DestinationOver","Lighter","Copy","Xor"] }
titanium_reindeer.Composition.SourceAtop = ["SourceAtop",0];
titanium_reindeer.Composition.SourceAtop.toString = $estr;
titanium_reindeer.Composition.SourceAtop.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.SourceIn = ["SourceIn",1];
titanium_reindeer.Composition.SourceIn.toString = $estr;
titanium_reindeer.Composition.SourceIn.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.SourceOut = ["SourceOut",2];
titanium_reindeer.Composition.SourceOut.toString = $estr;
titanium_reindeer.Composition.SourceOut.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.SourceOver = ["SourceOver",3];
titanium_reindeer.Composition.SourceOver.toString = $estr;
titanium_reindeer.Composition.SourceOver.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.DestinationAtop = ["DestinationAtop",4];
titanium_reindeer.Composition.DestinationAtop.toString = $estr;
titanium_reindeer.Composition.DestinationAtop.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.DestinationIn = ["DestinationIn",5];
titanium_reindeer.Composition.DestinationIn.toString = $estr;
titanium_reindeer.Composition.DestinationIn.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.DestinationOut = ["DestinationOut",6];
titanium_reindeer.Composition.DestinationOut.toString = $estr;
titanium_reindeer.Composition.DestinationOut.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.DestinationOver = ["DestinationOver",7];
titanium_reindeer.Composition.DestinationOver.toString = $estr;
titanium_reindeer.Composition.DestinationOver.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.Lighter = ["Lighter",8];
titanium_reindeer.Composition.Lighter.toString = $estr;
titanium_reindeer.Composition.Lighter.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.Copy = ["Copy",9];
titanium_reindeer.Composition.Copy.toString = $estr;
titanium_reindeer.Composition.Copy.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.Composition.Xor = ["Xor",10];
titanium_reindeer.Composition.Xor.toString = $estr;
titanium_reindeer.Composition.Xor.__enum__ = titanium_reindeer.Composition;
titanium_reindeer.LineCapType = { __ename__ : ["titanium_reindeer","LineCapType"], __constructs__ : ["Butt","Round","Square"] }
titanium_reindeer.LineCapType.Butt = ["Butt",0];
titanium_reindeer.LineCapType.Butt.toString = $estr;
titanium_reindeer.LineCapType.Butt.__enum__ = titanium_reindeer.LineCapType;
titanium_reindeer.LineCapType.Round = ["Round",1];
titanium_reindeer.LineCapType.Round.toString = $estr;
titanium_reindeer.LineCapType.Round.__enum__ = titanium_reindeer.LineCapType;
titanium_reindeer.LineCapType.Square = ["Square",2];
titanium_reindeer.LineCapType.Square.toString = $estr;
titanium_reindeer.LineCapType.Square.__enum__ = titanium_reindeer.LineCapType;
titanium_reindeer.LineJoinType = { __ename__ : ["titanium_reindeer","LineJoinType"], __constructs__ : ["Round","Bevel","Miter"] }
titanium_reindeer.LineJoinType.Round = ["Round",0];
titanium_reindeer.LineJoinType.Round.toString = $estr;
titanium_reindeer.LineJoinType.Round.__enum__ = titanium_reindeer.LineJoinType;
titanium_reindeer.LineJoinType.Bevel = ["Bevel",1];
titanium_reindeer.LineJoinType.Bevel.toString = $estr;
titanium_reindeer.LineJoinType.Bevel.__enum__ = titanium_reindeer.LineJoinType;
titanium_reindeer.LineJoinType.Miter = ["Miter",2];
titanium_reindeer.LineJoinType.Miter.toString = $estr;
titanium_reindeer.LineJoinType.Miter.__enum__ = titanium_reindeer.LineJoinType;
titanium_reindeer.FillTypes = { __ename__ : ["titanium_reindeer","FillTypes"], __constructs__ : ["Gradient","Pattern","ColorFill"] }
titanium_reindeer.FillTypes.Gradient = ["Gradient",0];
titanium_reindeer.FillTypes.Gradient.toString = $estr;
titanium_reindeer.FillTypes.Gradient.__enum__ = titanium_reindeer.FillTypes;
titanium_reindeer.FillTypes.Pattern = ["Pattern",1];
titanium_reindeer.FillTypes.Pattern.toString = $estr;
titanium_reindeer.FillTypes.Pattern.__enum__ = titanium_reindeer.FillTypes;
titanium_reindeer.FillTypes.ColorFill = ["ColorFill",2];
titanium_reindeer.FillTypes.ColorFill.toString = $estr;
titanium_reindeer.FillTypes.ColorFill.__enum__ = titanium_reindeer.FillTypes;
titanium_reindeer.StrokeTypes = { __ename__ : ["titanium_reindeer","StrokeTypes"], __constructs__ : ["Gradient","StrokeColor"] }
titanium_reindeer.StrokeTypes.Gradient = ["Gradient",0];
titanium_reindeer.StrokeTypes.Gradient.toString = $estr;
titanium_reindeer.StrokeTypes.Gradient.__enum__ = titanium_reindeer.StrokeTypes;
titanium_reindeer.StrokeTypes.StrokeColor = ["StrokeColor",1];
titanium_reindeer.StrokeTypes.StrokeColor.toString = $estr;
titanium_reindeer.StrokeTypes.StrokeColor.__enum__ = titanium_reindeer.StrokeTypes;
titanium_reindeer.Rect = function(width,height) { if( width === $_ ) return; {
	this.width = width;
	this.height = height;
}}
titanium_reindeer.Rect.__name__ = ["titanium_reindeer","Rect"];
titanium_reindeer.Rect.copy = function(r) {
	return new titanium_reindeer.Rect(r.width,r.height);
}
titanium_reindeer.Rect.prototype.width = null;
titanium_reindeer.Rect.prototype.height = null;
titanium_reindeer.Rect.prototype.getBoundingRect = function() {
	return titanium_reindeer.Rect.copy(this);
}
titanium_reindeer.Rect.prototype.isPointInside = function(p) {
	var halfWidth = this.width / 2;
	var halfHeight = this.height / 2;
	return p.getX() >= -halfWidth && p.getX() < halfWidth && p.getY() >= -halfHeight && p.getY() < halfHeight;
}
titanium_reindeer.Rect.prototype.getArea = function() {
	return this.width * this.height;
}
titanium_reindeer.Rect.prototype.__class__ = titanium_reindeer.Rect;
titanium_reindeer.Rect.__interfaces__ = [titanium_reindeer.core.IShape];
titanium_reindeer.core.RectRegion = function(width,height,center) { if( width === $_ ) return; {
	titanium_reindeer.Rect.call(this,width,height);
	if(center == null) this.setCenter(new titanium_reindeer.Vector2(0,0));
	else this.setCenter(center.getCopy());
}}
titanium_reindeer.core.RectRegion.__name__ = ["titanium_reindeer","core","RectRegion"];
titanium_reindeer.core.RectRegion.__super__ = titanium_reindeer.Rect;
for(var k in titanium_reindeer.Rect.prototype ) titanium_reindeer.core.RectRegion.prototype[k] = titanium_reindeer.Rect.prototype[k];
titanium_reindeer.core.RectRegion.copy = function(rr) {
	return new titanium_reindeer.core.RectRegion(rr.width,rr.height,rr.getCenter().getCopy());
}
titanium_reindeer.core.RectRegion.prototype.center = null;
titanium_reindeer.core.RectRegion.prototype.getCenter = function() {
	return this.center;
}
titanium_reindeer.core.RectRegion.prototype.setCenter = function(value) {
	this.center = value;
	return this.getCenter();
}
titanium_reindeer.core.RectRegion.prototype.top = null;
titanium_reindeer.core.RectRegion.prototype.getTop = function() {
	return this.getCenter().getY() - this.height / 2;
}
titanium_reindeer.core.RectRegion.prototype.bottom = null;
titanium_reindeer.core.RectRegion.prototype.getBottom = function() {
	return this.getCenter().getY() + this.height / 2;
}
titanium_reindeer.core.RectRegion.prototype.left = null;
titanium_reindeer.core.RectRegion.prototype.getLeft = function() {
	return this.getCenter().getX() - this.width / 2;
}
titanium_reindeer.core.RectRegion.prototype.right = null;
titanium_reindeer.core.RectRegion.prototype.getRight = function() {
	return this.getCenter().getX() + this.width / 2;
}
titanium_reindeer.core.RectRegion.prototype.getBoundingRegion = function() {
	return titanium_reindeer.core.RectRegion.copy(this);
}
titanium_reindeer.core.RectRegion.prototype.isPointInside = function(p) {
	return titanium_reindeer.Rect.prototype.isPointInside.call(this,p.subtract(this.getCenter()));
}
titanium_reindeer.core.RectRegion.prototype.__class__ = titanium_reindeer.core.RectRegion;
titanium_reindeer.core.RectRegion.__interfaces__ = [titanium_reindeer.core.IRegion];
titanium_reindeer.core.IHasId = function() { }
titanium_reindeer.core.IHasId.__name__ = ["titanium_reindeer","core","IHasId"];
titanium_reindeer.core.IHasId.prototype.id = null;
titanium_reindeer.core.IHasId.prototype.__class__ = titanium_reindeer.core.IHasId;
Reflect = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	if(o.hasOwnProperty != null) return o.hasOwnProperty(field);
	var arr = Reflect.fields(o);
	{ var $it0 = arr.iterator();
	while( $it0.hasNext() ) { var t = $it0.next();
	if(t == field) return true;
	}}
	return false;
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	}
	catch( $e0 ) {
		{
			var e = $e0;
			null;
		}
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	if(o == null) return new Array();
	var a = new Array();
	if(o.hasOwnProperty) {
		
				for(var i in o)
					if( o.hasOwnProperty(i) )
						a.push(i);
			;
	}
	else {
		var t;
		try {
			t = o.__proto__;
		}
		catch( $e0 ) {
			{
				var e = $e0;
				{
					t = null;
				}
			}
		}
		if(t != null) o.__proto__ = null;
		
				for(var i in o)
					if( i != "__proto__" )
						a.push(i);
			;
		if(t != null) o.__proto__ = t;
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && f.__name__ == null;
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && v.__name__ != null;
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	{
		var _g = 0, _g1 = Reflect.fields(o);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			o2[f] = Reflect.field(o,f);
		}
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = new Array();
		{
			var _g1 = 0, _g = arguments.length;
			while(_g1 < _g) {
				var i = _g1++;
				a.push(arguments[i]);
			}
		}
		return f(a);
	}
}
Reflect.prototype.__class__ = Reflect;
titanium_reindeer.core.IRenderer = function() { }
titanium_reindeer.core.IRenderer.__name__ = ["titanium_reindeer","core","IRenderer"];
titanium_reindeer.core.IRenderer.prototype.boundingShape = null;
titanium_reindeer.core.IRenderer.prototype.getBoundingShape = null;
titanium_reindeer.core.IRenderer.prototype.__class__ = titanium_reindeer.core.IRenderer;
titanium_reindeer.components.ICanvasRenderer = function() { }
titanium_reindeer.components.ICanvasRenderer.__name__ = ["titanium_reindeer","components","ICanvasRenderer"];
titanium_reindeer.components.ICanvasRenderer.prototype.state = null;
titanium_reindeer.components.ICanvasRenderer.prototype.__class__ = titanium_reindeer.components.ICanvasRenderer;
titanium_reindeer.components.ICanvasRenderer.__interfaces__ = [titanium_reindeer.core.IRenderer];
titanium_reindeer.ImageSource = function(path) { if( path === $_ ) return; {
	this.image = new Image();;
	this.image.onload = $closure(this,"imageLoaded");
	this.image.src = path;
}}
titanium_reindeer.ImageSource.__name__ = ["titanium_reindeer","ImageSource"];
titanium_reindeer.ImageSource.prototype.image = null;
titanium_reindeer.ImageSource.prototype.width = null;
titanium_reindeer.ImageSource.prototype.height = null;
titanium_reindeer.ImageSource.prototype.isLoaded = null;
titanium_reindeer.ImageSource.prototype.loadedFunctions = null;
titanium_reindeer.ImageSource.prototype.imageLoaded = function(event) {
	if(this.image == null) return;
	this.isLoaded = true;
	this.width = this.image.width;
	this.height = this.image.height;
	if(this.loadedFunctions != null) {
		{ var $it0 = this.loadedFunctions.iterator();
		while( $it0.hasNext() ) { var func = $it0.next();
		func(event);
		}}
		this.loadedFunctions.clear();
		this.loadedFunctions = null;
	}
}
titanium_reindeer.ImageSource.prototype.registerLoadEvent = function(cb) {
	if(this.isLoaded) return;
	if(this.loadedFunctions == null) this.loadedFunctions = new List();
	this.loadedFunctions.push(cb);
}
titanium_reindeer.ImageSource.prototype.identify = function() {
	return "ImageSource(" + this.image.src + "," + this.width + "," + this.height + ");";
}
titanium_reindeer.ImageSource.prototype.destroy = function() {
	this.isLoaded = false;
	this.image = null;
	if(this.loadedFunctions != null) {
		this.loadedFunctions.clear();
		this.loadedFunctions = null;
	}
}
titanium_reindeer.ImageSource.prototype.__class__ = titanium_reindeer.ImageSource;
StringBuf = function(p) { if( p === $_ ) return; {
	this.b = new Array();
}}
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype.add = function(x) {
	this.b[this.b.length] = x;
}
StringBuf.prototype.addSub = function(s,pos,len) {
	this.b[this.b.length] = s.substr(pos,len);
}
StringBuf.prototype.addChar = function(c) {
	this.b[this.b.length] = String.fromCharCode(c);
}
StringBuf.prototype.toString = function() {
	return this.b.join("");
}
StringBuf.prototype.b = null;
StringBuf.prototype.__class__ = StringBuf;
titanium_reindeer.core.IHasUpdater = function() { }
titanium_reindeer.core.IHasUpdater.__name__ = ["titanium_reindeer","core","IHasUpdater"];
titanium_reindeer.core.IHasUpdater.prototype.updater = null;
titanium_reindeer.core.IHasUpdater.prototype.__class__ = titanium_reindeer.core.IHasUpdater;
TestGame = function(p) { if( p === $_ ) return; {
	var parentDom = js.Lib.document.getElementById("TestGame");
	this.provider = new Provider();
	this.scene = new RenderScene(this.provider,parentDom);
	this.a = new Thing(this.scene);
}}
TestGame.__name__ = ["TestGame"];
TestGame.main = function() {
	var game = new TestGame();
	game.play();
}
TestGame.prototype.provider = null;
TestGame.prototype.scene = null;
TestGame.prototype.a = null;
TestGame.prototype.play = function() {
	this.scene.updater.update(10);
}
TestGame.prototype.__class__ = TestGame;
titanium_reindeer.core.BaseRelation = function(p) { if( p === $_ ) return; {
	this.changeBinds = new Array();
}}
titanium_reindeer.core.BaseRelation.__name__ = ["titanium_reindeer","core","BaseRelation"];
titanium_reindeer.core.BaseRelation.prototype.value = null;
titanium_reindeer.core.BaseRelation.prototype.setValue = function(value) {
	this.value = value;
	{
		var _g = 0, _g1 = this.changeBinds;
		while(_g < _g1.length) {
			var func = _g1[_g];
			++_g;
			func();
		}
	}
}
titanium_reindeer.core.BaseRelation.prototype.changeBinds = null;
titanium_reindeer.core.BaseRelation.prototype.onChange = null;
titanium_reindeer.core.BaseRelation.prototype.bindOnChange = function(func) {
	this.changeBinds.push(func);
	return func;
}
titanium_reindeer.core.BaseRelation.prototype.__class__ = titanium_reindeer.core.BaseRelation;
titanium_reindeer.core.BaseRelation.__interfaces__ = [titanium_reindeer.core.IWatchable];
titanium_reindeer.core.Relation = function(a,transformFunc) { if( a === $_ ) return; {
	titanium_reindeer.core.BaseRelation.call(this);
	this.transformFunc = transformFunc;
	this.a = a;
	this.a.bindOnChange($closure(this,"dependentChanged"));
	this.dependentChanged();
}}
titanium_reindeer.core.Relation.__name__ = ["titanium_reindeer","core","Relation"];
titanium_reindeer.core.Relation.__super__ = titanium_reindeer.core.BaseRelation;
for(var k in titanium_reindeer.core.BaseRelation.prototype ) titanium_reindeer.core.Relation.prototype[k] = titanium_reindeer.core.BaseRelation.prototype[k];
titanium_reindeer.core.Relation.prototype.transformFunc = null;
titanium_reindeer.core.Relation.prototype.a = null;
titanium_reindeer.core.Relation.prototype.dependentChanged = function() {
	this.setValue(this.transformFunc(this.a.value));
}
titanium_reindeer.core.Relation.prototype.__class__ = titanium_reindeer.core.Relation;
titanium_reindeer.core.Relation2 = function(a,b,transformFunc) { if( a === $_ ) return; {
	titanium_reindeer.core.BaseRelation.call(this);
	this.changeBinds = new Array();
	this.transformFunc = transformFunc;
	this.a = a;
	this.a.bindOnChange($closure(this,"dependentChanged"));
	this.b = b;
	this.b.bindOnChange($closure(this,"dependentChanged"));
	this.dependentChanged();
}}
titanium_reindeer.core.Relation2.__name__ = ["titanium_reindeer","core","Relation2"];
titanium_reindeer.core.Relation2.__super__ = titanium_reindeer.core.BaseRelation;
for(var k in titanium_reindeer.core.BaseRelation.prototype ) titanium_reindeer.core.Relation2.prototype[k] = titanium_reindeer.core.BaseRelation.prototype[k];
titanium_reindeer.core.Relation2.prototype.transformFunc = null;
titanium_reindeer.core.Relation2.prototype.a = null;
titanium_reindeer.core.Relation2.prototype.b = null;
titanium_reindeer.core.Relation2.prototype.dependentChanged = function() {
	this.setValue(this.transformFunc(this.a.value,this.b.value));
}
titanium_reindeer.core.Relation2.prototype.__class__ = titanium_reindeer.core.Relation2;
titanium_reindeer.core.Relation3 = function(a,b,c,transformFunc) { if( a === $_ ) return; {
	titanium_reindeer.core.BaseRelation.call(this);
	this.changeBinds = new Array();
	this.transformFunc = transformFunc;
	this.a = a;
	this.a.bindOnChange($closure(this,"dependentChanged"));
	this.b = b;
	this.b.bindOnChange($closure(this,"dependentChanged"));
	this.c = c;
	this.c.bindOnChange($closure(this,"dependentChanged"));
	this.dependentChanged();
}}
titanium_reindeer.core.Relation3.__name__ = ["titanium_reindeer","core","Relation3"];
titanium_reindeer.core.Relation3.__super__ = titanium_reindeer.core.BaseRelation;
for(var k in titanium_reindeer.core.BaseRelation.prototype ) titanium_reindeer.core.Relation3.prototype[k] = titanium_reindeer.core.BaseRelation.prototype[k];
titanium_reindeer.core.Relation3.prototype.transformFunc = null;
titanium_reindeer.core.Relation3.prototype.a = null;
titanium_reindeer.core.Relation3.prototype.b = null;
titanium_reindeer.core.Relation3.prototype.c = null;
titanium_reindeer.core.Relation3.prototype.dependentChanged = function() {
	this.setValue(this.transformFunc(this.a.value,this.b.value,this.c.value));
}
titanium_reindeer.core.Relation3.prototype.__class__ = titanium_reindeer.core.Relation3;
titanium_reindeer.core.Relation4 = function(a,b,c,d,transformFunc) { if( a === $_ ) return; {
	titanium_reindeer.core.BaseRelation.call(this);
	this.changeBinds = new Array();
	this.transformFunc = transformFunc;
	this.a = a;
	this.a.bindOnChange($closure(this,"dependentChanged"));
	this.b = b;
	this.b.bindOnChange($closure(this,"dependentChanged"));
	this.c = c;
	this.c.bindOnChange($closure(this,"dependentChanged"));
	this.d = d;
	this.d.bindOnChange($closure(this,"dependentChanged"));
	this.dependentChanged();
}}
titanium_reindeer.core.Relation4.__name__ = ["titanium_reindeer","core","Relation4"];
titanium_reindeer.core.Relation4.__super__ = titanium_reindeer.core.BaseRelation;
for(var k in titanium_reindeer.core.BaseRelation.prototype ) titanium_reindeer.core.Relation4.prototype[k] = titanium_reindeer.core.BaseRelation.prototype[k];
titanium_reindeer.core.Relation4.prototype.transformFunc = null;
titanium_reindeer.core.Relation4.prototype.a = null;
titanium_reindeer.core.Relation4.prototype.b = null;
titanium_reindeer.core.Relation4.prototype.c = null;
titanium_reindeer.core.Relation4.prototype.d = null;
titanium_reindeer.core.Relation4.prototype.dependentChanged = function() {
	this.setValue(this.transformFunc(this.a.value,this.b.value,this.c.value,this.d.value));
}
titanium_reindeer.core.Relation4.prototype.__class__ = titanium_reindeer.core.Relation4;
titanium_reindeer.core.IGroup = function() { }
titanium_reindeer.core.IGroup.__name__ = ["titanium_reindeer","core","IGroup"];
titanium_reindeer.core.IGroup.prototype.idProvider = null;
titanium_reindeer.core.IGroup.prototype.name = null;
titanium_reindeer.core.IGroup.prototype.get = null;
titanium_reindeer.core.IGroup.prototype.add = null;
titanium_reindeer.core.IGroup.prototype.remove = null;
titanium_reindeer.core.IGroup.prototype.__class__ = titanium_reindeer.core.IGroup;
titanium_reindeer.core.IGroup.__interfaces__ = [titanium_reindeer.core.IHasIdProvider];
titanium_reindeer.core.Scene = function(provider,name) { if( provider === $_ ) return; {
	this.hasProvider = provider;
	this.id = this.hasProvider.idProvider.requestId();
	this.name = name;
	this.idProvider = new titanium_reindeer.core.IdProvider();
	this.updater = new titanium_reindeer.core.Updater($closure(this,"preUpdate"),$closure(this,"update"),$closure(this,"postUpdate"));
	this.objects = new IntHash();
}}
titanium_reindeer.core.Scene.__name__ = ["titanium_reindeer","core","Scene"];
titanium_reindeer.core.Scene.prototype.idProvider = null;
titanium_reindeer.core.Scene.prototype.updater = null;
titanium_reindeer.core.Scene.prototype.id = null;
titanium_reindeer.core.Scene.prototype.name = null;
titanium_reindeer.core.Scene.prototype.hasProvider = null;
titanium_reindeer.core.Scene.prototype.objects = null;
titanium_reindeer.core.Scene.prototype.get = function(id) {
	if(!this.objects.exists(id)) return null;
	return this.objects.get(id);
}
titanium_reindeer.core.Scene.prototype.add = function(id,object) {
	this.objects.set(id,object);
}
titanium_reindeer.core.Scene.prototype.remove = function(id) {
	if(!this.objects.exists(id)) return;
	this.objects.remove(id);
}
titanium_reindeer.core.Scene.prototype.preUpdate = function(msTimeStep) {
	{ var $it0 = this.objects.iterator();
	while( $it0.hasNext() ) { var obj = $it0.next();
	obj.updater.preUpdate(msTimeStep);
	}}
}
titanium_reindeer.core.Scene.prototype.update = function(msTimeStep) {
	{ var $it0 = this.objects.iterator();
	while( $it0.hasNext() ) { var obj = $it0.next();
	obj.updater.update(msTimeStep);
	}}
}
titanium_reindeer.core.Scene.prototype.postUpdate = function(msTimeStep) {
	{ var $it0 = this.objects.iterator();
	while( $it0.hasNext() ) { var obj = $it0.next();
	obj.updater.postUpdate(msTimeStep);
	}}
}
titanium_reindeer.core.Scene.prototype.__class__ = titanium_reindeer.core.Scene;
titanium_reindeer.core.Scene.__interfaces__ = [titanium_reindeer.core.IHasId,titanium_reindeer.core.IHasUpdater,titanium_reindeer.core.IHasIdProvider,titanium_reindeer.core.IGroup];
titanium_reindeer.LinearGradient = function(x0,y0,x1,y1,colorStops) { if( x0 === $_ ) return; {
	this.x0 = x0;
	this.y0 = y0;
	this.x1 = x1;
	this.y1 = y1;
	this.colorStops = new List();
	{
		var _g = 0;
		while(_g < colorStops.length) {
			var colorStop = colorStops[_g];
			++_g;
			this.colorStops.add(colorStop);
		}
	}
}}
titanium_reindeer.LinearGradient.__name__ = ["titanium_reindeer","LinearGradient"];
titanium_reindeer.LinearGradient.prototype.x0 = null;
titanium_reindeer.LinearGradient.prototype.x1 = null;
titanium_reindeer.LinearGradient.prototype.y0 = null;
titanium_reindeer.LinearGradient.prototype.y1 = null;
titanium_reindeer.LinearGradient.prototype.colorStops = null;
titanium_reindeer.LinearGradient.prototype.addColorStop = function(colorStop) {
	this.colorStops.add(colorStop);
}
titanium_reindeer.LinearGradient.prototype.applyColorStops = function(gradient) {
	{ var $it0 = this.colorStops.iterator();
	while( $it0.hasNext() ) { var colorStop = $it0.next();
	{
		gradient.addColorStop(colorStop.offset,colorStop.color.getRgba());
	}
	}}
}
titanium_reindeer.LinearGradient.prototype.getStyle = function(pen) {
	var gradient = pen.createLinearGradient(this.x0,this.y0,this.x1,this.y1);
	this.applyColorStops(gradient);
	return gradient;
}
titanium_reindeer.LinearGradient.prototype.identify = function() {
	var identity = "Gradient(" + this.x0 + "," + this.x1 + "," + this.y0 + "," + this.y1 + ",";
	{ var $it0 = this.colorStops.iterator();
	while( $it0.hasNext() ) { var colorStop = $it0.next();
	identity += colorStop.identify() + ",";
	}}
	return identity + ");";
}
titanium_reindeer.LinearGradient.prototype.destroy = function() {
	this.colorStops.clear();
	this.colorStops = null;
}
titanium_reindeer.LinearGradient.prototype.__class__ = titanium_reindeer.LinearGradient;
titanium_reindeer.components.Canvas2D = function(name,width,height) { if( name === $_ ) return; {
	this.canvas = js.Lib.document.createElement("canvas");
	this.canvas.id = name;
	this.setWidth(width);
	this.setHeight(height);
	this.ctx = this.canvas.getContext("2d");
}}
titanium_reindeer.components.Canvas2D.__name__ = ["titanium_reindeer","components","Canvas2D"];
titanium_reindeer.components.Canvas2D.prototype.canvas = null;
titanium_reindeer.components.Canvas2D.prototype.ctx = null;
titanium_reindeer.components.Canvas2D.prototype.width = null;
titanium_reindeer.components.Canvas2D.prototype.setWidth = function(value) {
	if(this.width != value) {
		this.width = value;
		this.canvas.setAttribute("width",this.width + "px");
	}
	return this.width;
}
titanium_reindeer.components.Canvas2D.prototype.height = null;
titanium_reindeer.components.Canvas2D.prototype.setHeight = function(value) {
	if(this.height != value) {
		this.height = value;
		this.canvas.setAttribute("height",this.height + "px");
	}
	return this.height;
}
titanium_reindeer.components.Canvas2D.prototype.appendToDom = function(element) {
	element.appendChild(this.canvas);
}
titanium_reindeer.components.Canvas2D.prototype.clear = function(rect) {
	if(rect == null) rect = new titanium_reindeer.core.RectRegion(this.width,this.height,new titanium_reindeer.Vector2(this.width / 2,this.height / 2));
	this.ctx.clearRect(rect.getLeft(),rect.getTop(),rect.width,rect.height);
}
titanium_reindeer.components.Canvas2D.prototype.__class__ = titanium_reindeer.components.Canvas2D;
titanium_reindeer.core.Updater = function(preFunc,func,postFunc) { if( preFunc === $_ ) return; {
	this.isPaused = false;
	this.preFunc = preFunc;
	this.func = func;
	this.postFunc = postFunc;
}}
titanium_reindeer.core.Updater.__name__ = ["titanium_reindeer","core","Updater"];
titanium_reindeer.core.Updater.prototype.isPaused = null;
titanium_reindeer.core.Updater.prototype.preFunc = null;
titanium_reindeer.core.Updater.prototype.func = null;
titanium_reindeer.core.Updater.prototype.postFunc = null;
titanium_reindeer.core.Updater.prototype.pause = function() {
	this.isPaused = true;
}
titanium_reindeer.core.Updater.prototype.unpause = function() {
	this.isPaused = false;
}
titanium_reindeer.core.Updater.prototype.preUpdate = function(msTimeStep) {
	if(!this.isPaused && this.preFunc != null) this.preFunc(msTimeStep);
}
titanium_reindeer.core.Updater.prototype.update = function(msTimeStep) {
	if(!this.isPaused && this.func != null) this.func(msTimeStep);
}
titanium_reindeer.core.Updater.prototype.postUpdate = function(msTimeStep) {
	if(!this.isPaused && this.postFunc != null) this.postFunc(msTimeStep);
}
titanium_reindeer.core.Updater.prototype.__class__ = titanium_reindeer.core.Updater;
IntIter = function(min,max) { if( min === $_ ) return; {
	this.min = min;
	this.max = max;
}}
IntIter.__name__ = ["IntIter"];
IntIter.prototype.min = null;
IntIter.prototype.max = null;
IntIter.prototype.hasNext = function() {
	return this.min < this.max;
}
IntIter.prototype.next = function() {
	return this.min++;
}
IntIter.prototype.__class__ = IntIter;
titanium_reindeer.Vector2 = function(x,y) { if( x === $_ ) return; {
	this.mX = x;
	this.mY = y;
}}
titanium_reindeer.Vector2.__name__ = ["titanium_reindeer","Vector2"];
titanium_reindeer.Vector2.getDistance = function(a,b) {
	return Math.sqrt((b.getX() - a.getX()) * (b.getX() - a.getX()) + (b.getY() - a.getY()) * (b.getY() - a.getY()));
}
titanium_reindeer.Vector2.getReflected = function(surfaceNormal,incoming) {
	var outgoing = new titanium_reindeer.Vector2(1,0);
	var surfaceRadians = surfaceNormal.getRadians();
	var incomingRadians = incoming.getReverse().getRadians();
	var rad = (surfaceRadians * 2 - incomingRadians) % (Math.PI * 2);
	outgoing.rotate(rad);
	return outgoing;
}
titanium_reindeer.Vector2.prototype.mX = null;
titanium_reindeer.Vector2.prototype.x = null;
titanium_reindeer.Vector2.prototype.getX = function() {
	return this.mX;
}
titanium_reindeer.Vector2.prototype.setX = function(value) {
	this.mX = value;
	return this.mX;
}
titanium_reindeer.Vector2.prototype.mY = null;
titanium_reindeer.Vector2.prototype.y = null;
titanium_reindeer.Vector2.prototype.getY = function() {
	return this.mY;
}
titanium_reindeer.Vector2.prototype.setY = function(value) {
	this.mY = value;
	return this.mY;
}
titanium_reindeer.Vector2.prototype.getCopy = function() {
	return new titanium_reindeer.Vector2(this.getX(),this.getY());
}
titanium_reindeer.Vector2.prototype.getMagnitude = function() {
	return Math.sqrt(this.getX() * this.getX() + this.getY() * this.getY());
}
titanium_reindeer.Vector2.prototype.getExtend = function(n) {
	return new titanium_reindeer.Vector2(this.getX() * n,this.getY() * n);
}
titanium_reindeer.Vector2.prototype.extend = function(n) {
	{
		var _g = this;
		_g.setX(_g.getX() * n);
	}
	{
		var _g = this;
		_g.setY(_g.getY() * n);
	}
}
titanium_reindeer.Vector2.prototype.getNormalized = function() {
	var mag = this.getMagnitude();
	if(mag == 0) return new titanium_reindeer.Vector2(0,0);
	return new titanium_reindeer.Vector2(this.getX() / mag,this.getY() / mag);
}
titanium_reindeer.Vector2.prototype.normalize = function() {
	var mag = this.getMagnitude();
	if(mag != 0) {
		{
			var _g = this;
			_g.setX(_g.getX() / mag);
		}
		{
			var _g = this;
			_g.setY(_g.getY() / mag);
		}
	}
}
titanium_reindeer.Vector2.prototype.getReverse = function() {
	return new titanium_reindeer.Vector2(-this.getX(),-this.getY());
}
titanium_reindeer.Vector2.prototype.reverse = function() {
	this.setX(-this.getX());
	this.setY(-this.getY());
}
titanium_reindeer.Vector2.prototype.getRotate = function(r) {
	var sin = Math.sin(r);
	var cos = Math.cos(r);
	return new titanium_reindeer.Vector2(this.getX() * cos - this.getY() * sin,this.getX() * sin + this.getY() * cos);
}
titanium_reindeer.Vector2.prototype.rotate = function(r) {
	var sin = Math.sin(r);
	var cos = Math.cos(r);
	var x = this.getX();
	this.setX(this.getX() * cos - this.getY() * sin);
	this.setY(x * sin + this.getY() * cos);
}
titanium_reindeer.Vector2.prototype.getRadians = function() {
	if(this.getX() == 0) return Math.PI / 2 + (this.getY() < 0?Math.PI:0);
	var rads = Math.atan(this.getY() / this.getX());
	if(this.getX() < 0) rads += Math.PI;
	else if(this.getY() < 0) rads += Math.PI * 2;
	return rads;
}
titanium_reindeer.Vector2.prototype.add = function(b) {
	if(b == null) return this.getCopy();
	return new titanium_reindeer.Vector2(this.getX() + b.getX(),this.getY() + b.getY());
}
titanium_reindeer.Vector2.prototype.addTo = function(b) {
	{
		var _g = this;
		_g.setX(_g.getX() + b.getX());
	}
	{
		var _g = this;
		_g.setY(_g.getY() + b.getY());
	}
	return this;
}
titanium_reindeer.Vector2.prototype.subtract = function(b) {
	return new titanium_reindeer.Vector2(this.getX() - b.getX(),this.getY() - b.getY());
}
titanium_reindeer.Vector2.prototype.subtractFrom = function(b) {
	{
		var _g = this;
		_g.setX(_g.getX() - b.getX());
	}
	{
		var _g = this;
		_g.setY(_g.getY() - b.getY());
	}
	return this;
}
titanium_reindeer.Vector2.prototype.equal = function(b) {
	if(b == null) return false;
	return this.getX() == b.getX() && this.getY() == b.getY();
}
titanium_reindeer.Vector2.prototype.identify = function() {
	return "Vector2(" + this.getX() + "," + this.getY() + ")";
}
titanium_reindeer.Vector2.prototype.__class__ = titanium_reindeer.Vector2;
Thing = function(scene) { if( scene === $_ ) return; {
	this.scene = scene;
	this.body = new titanium_reindeer.components.RectCanvasRenderer(scene,40,100);
	this.body.strokeFillState.setFill(titanium_reindeer.Color.getRedConst());
	this.scene.addRenderer(this.body.id,this.body,"things");
}}
Thing.__name__ = ["Thing"];
Thing.prototype.scene = null;
Thing.prototype.body = null;
Thing.prototype.__class__ = Thing;
Std = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	if(x < 0) return Math.ceil(x);
	return Math.floor(x);
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && x.charCodeAt(1) == 120) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype.__class__ = Std;
titanium_reindeer.core.Watcher = function(value) { if( value === $_ ) return; {
	this.changeBinds = new Array();
	this.setValue(value);
}}
titanium_reindeer.core.Watcher.__name__ = ["titanium_reindeer","core","Watcher"];
titanium_reindeer.core.Watcher.prototype.value = null;
titanium_reindeer.core.Watcher.prototype.setValue = function(value) {
	this.value = value;
	{
		var _g = 0, _g1 = this.changeBinds;
		while(_g < _g1.length) {
			var func = _g1[_g];
			++_g;
			func();
		}
	}
	return this.value;
}
titanium_reindeer.core.Watcher.prototype.changeBinds = null;
titanium_reindeer.core.Watcher.prototype.onChange = null;
titanium_reindeer.core.Watcher.prototype.bindOnChange = function(func) {
	this.changeBinds.push(func);
	return func;
}
titanium_reindeer.core.Watcher.prototype.__class__ = titanium_reindeer.core.Watcher;
titanium_reindeer.core.Watcher.__interfaces__ = [titanium_reindeer.core.IWatchable];
titanium_reindeer.Shadow = function(color,offset,blur) { if( color === $_ ) return; {
	this.color = color;
	this.offset = offset;
	this.blur = blur;
}}
titanium_reindeer.Shadow.__name__ = ["titanium_reindeer","Shadow"];
titanium_reindeer.Shadow.prototype.color = null;
titanium_reindeer.Shadow.prototype.offset = null;
titanium_reindeer.Shadow.prototype.blur = null;
titanium_reindeer.Shadow.prototype.equal = function(other) {
	return this.color.equal(other.color) && this.offset.equal(other.offset) && this.blur == other.blur;
}
titanium_reindeer.Shadow.prototype.identify = function() {
	return "Shadow(" + this.color.identify() + "," + this.offset.identify() + "," + this.blur + ");";
}
titanium_reindeer.Shadow.prototype.__class__ = titanium_reindeer.Shadow;
List = function(p) { if( p === $_ ) return; {
	this.length = 0;
}}
List.__name__ = ["List"];
List.prototype.h = null;
List.prototype.q = null;
List.prototype.length = null;
List.prototype.add = function(item) {
	var x = [item];
	if(this.h == null) this.h = x;
	else this.q[1] = x;
	this.q = x;
	this.length++;
}
List.prototype.push = function(item) {
	var x = [item,this.h];
	this.h = x;
	if(this.q == null) this.q = x;
	this.length++;
}
List.prototype.first = function() {
	return this.h == null?null:this.h[0];
}
List.prototype.last = function() {
	return this.q == null?null:this.q[0];
}
List.prototype.pop = function() {
	if(this.h == null) return null;
	var x = this.h[0];
	this.h = this.h[1];
	if(this.h == null) this.q = null;
	this.length--;
	return x;
}
List.prototype.isEmpty = function() {
	return this.h == null;
}
List.prototype.clear = function() {
	this.h = null;
	this.q = null;
	this.length = 0;
}
List.prototype.remove = function(v) {
	var prev = null;
	var l = this.h;
	while(l != null) {
		if(l[0] == v) {
			if(prev == null) this.h = l[1];
			else prev[1] = l[1];
			if(this.q == l) this.q = prev;
			this.length--;
			return true;
		}
		prev = l;
		l = l[1];
	}
	return false;
}
List.prototype.iterator = function() {
	return { h : this.h, hasNext : function() {
		return this.h != null;
	}, next : function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		return x;
	}};
}
List.prototype.toString = function() {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	s.b[s.b.length] = "{";
	while(l != null) {
		if(first) first = false;
		else s.b[s.b.length] = ", ";
		s.b[s.b.length] = Std.string(l[0]);
		l = l[1];
	}
	s.b[s.b.length] = "}";
	return s.b.join("");
}
List.prototype.join = function(sep) {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	while(l != null) {
		if(first) first = false;
		else s.b[s.b.length] = sep;
		s.b[s.b.length] = l[0];
		l = l[1];
	}
	return s.b.join("");
}
List.prototype.filter = function(f) {
	var l2 = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		if(f(v)) l2.add(v);
	}
	return l2;
}
List.prototype.map = function(f) {
	var b = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		b.add(f(v));
	}
	return b;
}
List.prototype.__class__ = List;
ValueType = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
Type = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if(o.__enum__ != null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl;
	try {
		cl = eval(name);
	}
	catch( $e0 ) {
		{
			var e = $e0;
			{
				cl = null;
			}
		}
	}
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e;
	try {
		e = eval(name);
	}
	catch( $e0 ) {
		{
			var err = $e0;
			{
				e = null;
			}
		}
	}
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	if(args.length <= 3) return new cl(args[0],args[1],args[2]);
	if(args.length > 8) throw "Too many arguments";
	return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
}
Type.createEmptyInstance = function(cl) {
	return new cl($_);
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = Type.getEnumConstructs(e)[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = Reflect.fields(c.prototype);
	a.remove("__class__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__super__");
	a.remove("prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	return e.__constructs__;
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":{
		return ValueType.TBool;
	}break;
	case "string":{
		return ValueType.TClass(String);
	}break;
	case "number":{
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	}break;
	case "object":{
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	}break;
	case "function":{
		if(v.__name__ != null) return ValueType.TObject;
		return ValueType.TFunction;
	}break;
	case "undefined":{
		return ValueType.TNull;
	}break;
	default:{
		return ValueType.TUnknown;
	}break;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		{
			var _g1 = 2, _g = a.length;
			while(_g1 < _g) {
				var i = _g1++;
				if(!Type.enumEq(a[i],b[i])) return false;
			}
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	}
	catch( $e0 ) {
		{
			var e = $e0;
			{
				return false;
			}
		}
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.prototype.__class__ = Type;
if(typeof js=='undefined') js = {}
js.Lib = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype.__class__ = js.Lib;
js.Boot = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__unhtml(js.Boot.__string_rec(v,"")) + "<br/>";
	var d = document.getElementById("haxe:trace");
	if(d == null) alert("No haxe:trace element defined\n" + msg);
	else d.innerHTML += msg;
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
	else null;
}
js.Boot.__closure = function(o,f) {
	var m = o[f];
	if(m == null) return null;
	var f1 = function() {
		return m.apply(o,arguments);
	}
	f1.scope = o;
	f1.method = m;
	return f1;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":{
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				{
					var _g1 = 2, _g = o.length;
					while(_g1 < _g) {
						var i = _g1++;
						if(i != 2) str += "," + js.Boot.__string_rec(o[i],s);
						else str += js.Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			{
				var _g = 0;
				while(_g < l) {
					var i1 = _g++;
					str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
				}
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		}
		catch( $e0 ) {
			{
				var e = $e0;
				{
					return "???";
				}
			}
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) continue;
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__") continue;
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	}break;
	case "function":{
		return "<function>";
	}break;
	case "string":{
		return o;
	}break;
	default:{
		return String(o);
	}break;
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	}
	catch( $e0 ) {
		{
			var e = $e0;
			{
				if(cl == null) return false;
			}
		}
	}
	switch(cl) {
	case Int:{
		return Math.ceil(o%2147483648.0) === o;
	}break;
	case Float:{
		return typeof(o) == "number";
	}break;
	case Bool:{
		return o === true || o === false;
	}break;
	case String:{
		return typeof(o) == "string";
	}break;
	case Dynamic:{
		return true;
	}break;
	default:{
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}break;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	}
	Array.prototype.remove = Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	}
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	}
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return null;
		return x;
	}
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		}
		else if(len < 0) {
			len = this.length + len - pos;
		}
		return oldsub.apply(this,[pos,len]);
	}
	$closure = js.Boot.__closure;
}
js.Boot.prototype.__class__ = js.Boot;
titanium_reindeer.components.CanvasRendererGroup = function(provider,name) { if( provider === $_ ) return; {
	this.hasProvider = provider;
	this.id = this.hasProvider.idProvider.requestId();
	this.idProvider = new titanium_reindeer.core.IdProvider();
	this.name = name;
	this.minBounds = new titanium_reindeer.Rect(0,0);
	this.state = new titanium_reindeer.components.CanvasRenderState($closure(this,"render"));
	this.canvas = new titanium_reindeer.components.Canvas2D(name + "_canvas",0,0);
	this.renderers = new IntHash();
}}
titanium_reindeer.components.CanvasRendererGroup.__name__ = ["titanium_reindeer","components","CanvasRendererGroup"];
titanium_reindeer.components.CanvasRendererGroup.prototype.hasProvider = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.id = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.idProvider = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.name = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.state = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.getState = function() {
	return this.state;
}
titanium_reindeer.components.CanvasRendererGroup.prototype.minBounds = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.boundingShape = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.getBoundingShape = function() {
	return titanium_reindeer.Rect.copy(this.minBounds);
}
titanium_reindeer.components.CanvasRendererGroup.prototype.watchedCenter = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.worldCenter = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.getWorldCenter = function() {
	return this.watchedCenter.value;
}
titanium_reindeer.components.CanvasRendererGroup.prototype.setWorldCenter = function(value) {
	this.watchedCenter.setValue(value);
	return this.getWorldCenter();
}
titanium_reindeer.components.CanvasRendererGroup.prototype.canvas = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.renderers = null;
titanium_reindeer.components.CanvasRendererGroup.prototype.expandBounds = function(newShape) {
	var newBounds = newShape.getBoundingRect();
	if(this.minBounds.width == 0 && this.minBounds.height == 0) this.minBounds = newBounds;
	else {
		this.minBounds.width = Math.max(this.minBounds.width,newBounds.width);
		this.minBounds.height = Math.max(this.minBounds.height,newBounds.height);
	}
	this.canvas.setWidth(this.minBounds.width);
	this.canvas.setHeight(this.minBounds.height);
}
titanium_reindeer.components.CanvasRendererGroup.prototype.get = function(id) {
	if(!this.renderers.exists(id)) return null;
	return this.renderers.get(id);
}
titanium_reindeer.components.CanvasRendererGroup.prototype.add = function(id,renderer) {
	if(renderer == null) return;
	this.renderers.set(id,renderer);
	this.expandBounds(renderer.getBoundingShape());
}
titanium_reindeer.components.CanvasRendererGroup.prototype.remove = function(id) {
	if(!this.renderers.exists(id)) return;
	this.renderers.remove(id);
}
titanium_reindeer.components.CanvasRendererGroup.prototype.render = function(canvas) {
	this.canvas.clear();
	{ var $it0 = this.renderers.iterator();
	while( $it0.hasNext() ) { var renderer = $it0.next();
	renderer.getState().render(this.canvas);
	}}
	canvas.ctx.drawImage(this.canvas.canvas,0,0);
}
titanium_reindeer.components.CanvasRendererGroup.prototype.__class__ = titanium_reindeer.components.CanvasRendererGroup;
titanium_reindeer.components.CanvasRendererGroup.__interfaces__ = [titanium_reindeer.components.ICanvasRenderer,titanium_reindeer.core.IGroup];
RenderScene = function(provider,parentDom) { if( provider === $_ ) return; {
	titanium_reindeer.core.Scene.call(this,provider,"RenderScene");
	this.things = new titanium_reindeer.components.CanvasRendererGroup(this,"things");
	this.pageCanvas = new titanium_reindeer.components.Canvas2D("testCanvas",1000,1000);
	this.pageCanvas.appendToDom(parentDom);
}}
RenderScene.__name__ = ["RenderScene"];
RenderScene.__super__ = titanium_reindeer.core.Scene;
for(var k in titanium_reindeer.core.Scene.prototype ) RenderScene.prototype[k] = titanium_reindeer.core.Scene.prototype[k];
RenderScene.prototype.things = null;
RenderScene.prototype.pageCanvas = null;
RenderScene.prototype.update = function(msTimeStep) {
	titanium_reindeer.core.Scene.prototype.update.call(this,msTimeStep);
	this.things.getState().render(this.pageCanvas);
}
RenderScene.prototype.addRenderer = function(id,renderer,layerName) {
	if(this.things.name == layerName) this.things.add(id,renderer);
}
RenderScene.prototype.__class__ = RenderScene;
titanium_reindeer.Color = function(red,green,blue,alpha) { if( red === $_ ) return; {
	if(alpha == null) alpha = 1;
	this.red = (function($this) {
		var $r;
		var $t = Math.max(0,Math.min(red,255));
		if(Std["is"]($t,Int)) $t;
		else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	this.green = (function($this) {
		var $r;
		var $t = Math.max(0,Math.min(green,255));
		if(Std["is"]($t,Int)) $t;
		else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	this.blue = (function($this) {
		var $r;
		var $t = Math.max(0,Math.min(blue,255));
		if(Std["is"]($t,Int)) $t;
		else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	this.alpha = Math.max(0,Math.min(alpha,1));
}}
titanium_reindeer.Color.__name__ = ["titanium_reindeer","Color"];
titanium_reindeer.Color.Red = null;
titanium_reindeer.Color.getRedConst = function() {
	return new titanium_reindeer.Color(255,0,0);
}
titanium_reindeer.Color.Orange = null;
titanium_reindeer.Color.getOrangeConst = function() {
	return new titanium_reindeer.Color(255,127,0);
}
titanium_reindeer.Color.Yellow = null;
titanium_reindeer.Color.getYellowConst = function() {
	return new titanium_reindeer.Color(255,205,0);
}
titanium_reindeer.Color.Green = null;
titanium_reindeer.Color.getGreenConst = function() {
	return new titanium_reindeer.Color(0,255,0);
}
titanium_reindeer.Color.Blue = null;
titanium_reindeer.Color.getBlueConst = function() {
	return new titanium_reindeer.Color(0,0,255);
}
titanium_reindeer.Color.Purple = null;
titanium_reindeer.Color.getPurpleConst = function() {
	return new titanium_reindeer.Color(128,0,128);
}
titanium_reindeer.Color.White = null;
titanium_reindeer.Color.getWhiteConst = function() {
	return new titanium_reindeer.Color(255,255,255);
}
titanium_reindeer.Color.Black = null;
titanium_reindeer.Color.getBlackConst = function() {
	return new titanium_reindeer.Color(0,0,0);
}
titanium_reindeer.Color.Grey = null;
titanium_reindeer.Color.getGreyConst = function() {
	return new titanium_reindeer.Color(128,128,128);
}
titanium_reindeer.Color.Clear = null;
titanium_reindeer.Color.getClearConst = function() {
	return new titanium_reindeer.Color(0,0,0,0);
}
titanium_reindeer.Color.prototype.red = null;
titanium_reindeer.Color.prototype.green = null;
titanium_reindeer.Color.prototype.blue = null;
titanium_reindeer.Color.prototype.alpha = null;
titanium_reindeer.Color.prototype.rgba = null;
titanium_reindeer.Color.prototype.getRgba = function() {
	return "rgba(" + this.red + "," + this.green + "," + this.blue + "," + this.alpha + ")";
}
titanium_reindeer.Color.prototype.equal = function(other) {
	return this.red == other.red && this.green == other.green && this.blue == other.blue && this.alpha == other.alpha;
}
titanium_reindeer.Color.prototype.getCopy = function() {
	return new titanium_reindeer.Color(this.red,this.green,this.blue,this.alpha);
}
titanium_reindeer.Color.prototype.identify = function() {
	return "Color(" + this.red + "," + this.green + "," + this.blue + "," + this.alpha + ");";
}
titanium_reindeer.Color.prototype.getMultiplied = function(n) {
	return new titanium_reindeer.Color(Std["int"](this.red * n),Std["int"](this.green * n),Std["int"](this.blue * n));
}
titanium_reindeer.Color.prototype.multiply = function(n) {
	this.red = Std["int"](this.red * n);
	this.green = Std["int"](this.green * n);
	this.blue = Std["int"](this.blue * n);
}
titanium_reindeer.Color.prototype.__class__ = titanium_reindeer.Color;
IntHash = function(p) { if( p === $_ ) return; {
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
	else null;
}}
IntHash.__name__ = ["IntHash"];
IntHash.prototype.h = null;
IntHash.prototype.set = function(key,value) {
	this.h[key] = value;
}
IntHash.prototype.get = function(key) {
	return this.h[key];
}
IntHash.prototype.exists = function(key) {
	return this.h[key] != null;
}
IntHash.prototype.remove = function(key) {
	if(this.h[key] == null) return false;
	delete(this.h[key]);
	return true;
}
IntHash.prototype.keys = function() {
	var a = new Array();
	
			for( x in this.h )
				a.push(x);
		;
	return a.iterator();
}
IntHash.prototype.iterator = function() {
	return { ref : this.h, it : this.keys(), hasNext : function() {
		return this.it.hasNext();
	}, next : function() {
		var i = this.it.next();
		return this.ref[i];
	}};
}
IntHash.prototype.toString = function() {
	var s = new StringBuf();
	s.b[s.b.length] = "{";
	var it = this.keys();
	{ var $it0 = it;
	while( $it0.hasNext() ) { var i = $it0.next();
	{
		s.b[s.b.length] = i;
		s.b[s.b.length] = " => ";
		s.b[s.b.length] = Std.string(this.get(i));
		if(it.hasNext()) s.b[s.b.length] = ", ";
	}
	}}
	s.b[s.b.length] = "}";
	return s.b.join("");
}
IntHash.prototype.__class__ = IntHash;
titanium_reindeer.PatternOption = { __ename__ : ["titanium_reindeer","PatternOption"], __constructs__ : ["Repeat","RepeatX","RepeatY","NoRepeat"] }
titanium_reindeer.PatternOption.Repeat = ["Repeat",0];
titanium_reindeer.PatternOption.Repeat.toString = $estr;
titanium_reindeer.PatternOption.Repeat.__enum__ = titanium_reindeer.PatternOption;
titanium_reindeer.PatternOption.RepeatX = ["RepeatX",1];
titanium_reindeer.PatternOption.RepeatX.toString = $estr;
titanium_reindeer.PatternOption.RepeatX.__enum__ = titanium_reindeer.PatternOption;
titanium_reindeer.PatternOption.RepeatY = ["RepeatY",2];
titanium_reindeer.PatternOption.RepeatY.toString = $estr;
titanium_reindeer.PatternOption.RepeatY.__enum__ = titanium_reindeer.PatternOption;
titanium_reindeer.PatternOption.NoRepeat = ["NoRepeat",3];
titanium_reindeer.PatternOption.NoRepeat.toString = $estr;
titanium_reindeer.PatternOption.NoRepeat.__enum__ = titanium_reindeer.PatternOption;
titanium_reindeer.Pattern = function(imageSource,option) { if( imageSource === $_ ) return; {
	this.imageSource = imageSource;
	this.option = option;
}}
titanium_reindeer.Pattern.__name__ = ["titanium_reindeer","Pattern"];
titanium_reindeer.Pattern.prototype.imageSource = null;
titanium_reindeer.Pattern.prototype.option = null;
titanium_reindeer.Pattern.prototype.getStyle = function(pen) {
	var option;
	var $e = this.option;
	switch( $e[1] ) {
	case 0:
	{
		option = "repeat";
	}break;
	case 1:
	{
		option = "repeat-x";
	}break;
	case 2:
	{
		option = "repeat-y";
	}break;
	case 3:
	{
		option = "no-repeat";
	}break;
	}
	return pen.createPattern(this.imageSource.image,option);
}
titanium_reindeer.Pattern.prototype.identify = function() {
	return "Pattern(" + this.imageSource.identify() + "," + this.option[0] + ");";
}
titanium_reindeer.Pattern.prototype.__class__ = titanium_reindeer.Pattern;
titanium_reindeer.core.IdProvider = function(p) { if( p === $_ ) return; {
	this.lastId = 0;
	this.oldAvailableIds = new Array();
}}
titanium_reindeer.core.IdProvider.__name__ = ["titanium_reindeer","core","IdProvider"];
titanium_reindeer.core.IdProvider.prototype.lastId = null;
titanium_reindeer.core.IdProvider.prototype.oldAvailableIds = null;
titanium_reindeer.core.IdProvider.prototype.requestId = function() {
	if(this.oldAvailableIds.length > 0) return this.oldAvailableIds.pop();
	return this.lastId++;
}
titanium_reindeer.core.IdProvider.prototype.freeUpId = function(object) {
	if(this.lastId == object.id + 1) this.lastId--;
	else this.oldAvailableIds.push(object.id);
}
titanium_reindeer.core.IdProvider.prototype.__class__ = titanium_reindeer.core.IdProvider;
titanium_reindeer.components.RectCanvasRenderer = function(provider,width,height) { if( provider === $_ ) return; {
	this.id = provider.idProvider.requestId();
	this.strokeFillState = new titanium_reindeer.components.CanvasStrokeFillState($closure(this,"render"));
	this.width = new titanium_reindeer.core.Watcher(width);
	this.height = new titanium_reindeer.core.Watcher(height);
	this.relatedRect = new titanium_reindeer.core.Relation2(this.width,this.height,$closure(this,"getBounds"));
}}
titanium_reindeer.components.RectCanvasRenderer.__name__ = ["titanium_reindeer","components","RectCanvasRenderer"];
titanium_reindeer.components.RectCanvasRenderer.prototype.id = null;
titanium_reindeer.components.RectCanvasRenderer.prototype.state = null;
titanium_reindeer.components.RectCanvasRenderer.prototype.getState = function() {
	return this.strokeFillState;
}
titanium_reindeer.components.RectCanvasRenderer.prototype.strokeFillState = null;
titanium_reindeer.components.RectCanvasRenderer.prototype.boundingShape = null;
titanium_reindeer.components.RectCanvasRenderer.prototype.getBoundingShape = function() {
	return this.relatedRect.value;
}
titanium_reindeer.components.RectCanvasRenderer.prototype.relatedRect = null;
titanium_reindeer.components.RectCanvasRenderer.prototype.width = null;
titanium_reindeer.components.RectCanvasRenderer.prototype.height = null;
titanium_reindeer.components.RectCanvasRenderer.prototype.getBounds = function(width,height) {
	return new titanium_reindeer.Rect(width,height);
}
titanium_reindeer.components.RectCanvasRenderer.prototype.render = function(canvas) {
	var x = -this.width.value / 2;
	var y = -this.height.value / 2;
	canvas.ctx.fillRect(x,y,this.width.value,this.height.value);
	var lineWidth = this.strokeFillState.lineWidth;
	if(lineWidth > 0) {
		canvas.ctx.strokeRect(x + lineWidth / 2,y + lineWidth / 2,this.width.value - lineWidth,this.height.value - lineWidth);
	}
}
titanium_reindeer.components.RectCanvasRenderer.prototype.__class__ = titanium_reindeer.components.RectCanvasRenderer;
titanium_reindeer.components.RectCanvasRenderer.__interfaces__ = [titanium_reindeer.components.ICanvasRenderer];
titanium_reindeer.ColorStop = function(color,offset) { if( color === $_ ) return; {
	this.color = color;
	this.offset = offset;
}}
titanium_reindeer.ColorStop.__name__ = ["titanium_reindeer","ColorStop"];
titanium_reindeer.ColorStop.prototype.color = null;
titanium_reindeer.ColorStop.prototype.offset = null;
titanium_reindeer.ColorStop.prototype.identify = function() {
	return "ColorStop(" + this.color.identify() + "," + this.offset + ");";
}
titanium_reindeer.ColorStop.prototype.__class__ = titanium_reindeer.ColorStop;
$_ = {}
js.Boot.__res = {}
js.Boot.__init();
{
	String.prototype.__class__ = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = Array;
	Array.__name__ = ["Array"];
	Int = { __name__ : ["Int"]};
	Dynamic = { __name__ : ["Dynamic"]};
	Float = Number;
	Float.__name__ = ["Float"];
	Bool = { __ename__ : ["Bool"]};
	Class = { __name__ : ["Class"]};
	Enum = { };
	Void = { __ename__ : ["Void"]};
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	Math.isFinite = function(i) {
		return isFinite(i);
	}
	Math.isNaN = function(i) {
		return isNaN(i);
	}
}
{
	js.Lib.document = document;
	js.Lib.window = window;
	onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if( f == null )
			return false;
		return f(msg,[url+":"+line]);
	}
}
js.Lib.onerror = null;
TestGame.main()