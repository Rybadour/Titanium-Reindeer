var $_, $hxClasses = $hxClasses || {}, $estr = function() { return js.Boot.__string_rec(this,''); }
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var titanium_reindeer = titanium_reindeer || {}
titanium_reindeer.ManagedObject = $hxClasses["titanium_reindeer.ManagedObject"] = function() {
	this.registeredManagerSetEvents = new Array();
};
titanium_reindeer.ManagedObject.__name__ = ["titanium_reindeer","ManagedObject"];
titanium_reindeer.ManagedObject.prototype = {
	id: null
	,manager: null
	,setManager: function(manager) {
		if(this.manager == null) {
			this.manager = manager;
			this.id = manager.getNextId();
			var _g = 0, _g1 = this.registeredManagerSetEvents;
			while(_g < _g1.length) {
				var func = _g1[_g];
				++_g;
				func();
			}
		}
	}
	,toBeDestroyed: null
	,registeredManagerSetEvents: null
	,registerManagerSetFunc: function(func) {
		if(func != null) this.registeredManagerSetEvents.push(func);
	}
	,unregisterManagerSetFunc: function(func) {
		if(func == null) return;
		var _g1 = 0, _g = this.registeredManagerSetEvents.length;
		while(_g1 < _g) {
			var i = _g1++;
			while(i < this.registeredManagerSetEvents.length) if(Reflect.compareMethods(this.registeredManagerSetEvents[i],func)) this.registeredManagerSetEvents.splice(i,1); else break;
		}
	}
	,destroy: function() {
		this.toBeDestroyed = true;
	}
	,finalDestroy: function() {
		this.manager = null;
		var _g1 = 0, _g = this.registeredManagerSetEvents.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.registeredManagerSetEvents.splice(0,1);
		}
		this.registeredManagerSetEvents = null;
	}
	,__class__: titanium_reindeer.ManagedObject
}
titanium_reindeer.GameObject = $hxClasses["titanium_reindeer.GameObject"] = function(scene) {
	titanium_reindeer.ManagedObject.call(this);
	this.watchedPosition = new titanium_reindeer.WatchedVector2(0,0,this.positionChanged.$bind(this));
	this.components = new Hash();
	if(scene != null) {
		scene.addGameObject(this);
		this.setManager(scene);
	}
};
titanium_reindeer.GameObject.__name__ = ["titanium_reindeer","GameObject"];
titanium_reindeer.GameObject.__super__ = titanium_reindeer.ManagedObject;
titanium_reindeer.GameObject.prototype = $extend(titanium_reindeer.ManagedObject.prototype,{
	scene: null
	,getManager: function() {
		if(this.manager == null) return null; else return (function($this) {
			var $r;
			var $t = $this.manager;
			if(Std["is"]($t,titanium_reindeer.Scene)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
	}
	,components: null
	,componentsToRemove: null
	,watchedPosition: null
	,position: null
	,getPosition: function() {
		return this.watchedPosition;
	}
	,setPosition: function(value) {
		if(value != null) {
			if(this.watchedPosition != value && !this.watchedPosition.equal(value)) this.watchedPosition.setVector2(value);
		}
		return this.getPosition();
	}
	,update: function(msTimeStep) {
	}
	,addComponent: function(name,component) {
		if(this.components.exists(name)) {
			throw "GameObject: Attempting to add a component while the name '" + name + "' is already in use!";
			return;
		}
		this.components.set(name,component);
		component.setOwner(this);
		if(this.getManager() != null) this.getManager().delegateComponent(component);
	}
	,removeComponent: function(name) {
		if(this.components.exists(name)) {
			if(this.componentsToRemove == null) this.componentsToRemove = new Array();
			this.componentsToRemove.push(name);
			this.components.get(name).remove();
		}
	}
	,getComponent: function(name) {
		if(this.components.exists(name)) return this.components.get(name);
		return null;
	}
	,positionHasChanged: function() {
	}
	,positionChanged: function() {
		this.positionHasChanged();
		this.notifyPositionChanged();
	}
	,notifyPositionChanged: function() {
		if(this.components != null) {
			var $it0 = this.components.iterator();
			while( $it0.hasNext() ) {
				var component = $it0.next();
				component.notifyPositionChange();
			}
		}
	}
	,setManager: function(manager) {
		if(this.manager == manager) return;
		titanium_reindeer.ManagedObject.prototype.setManager.call(this,manager);
		var $it0 = this.components.iterator();
		while( $it0.hasNext() ) {
			var component = $it0.next();
			this.getManager().delegateComponent(component);
		}
	}
	,remove: function() {
		if(this.componentsToRemove == null) this.componentsToRemove = new Array();
		var $it0 = this.components.keys();
		while( $it0.hasNext() ) {
			var compName = $it0.next();
			this.componentsToRemove.push(compName);
			this.components.get(compName).remove();
		}
	}
	,removeComponents: function() {
		if(this.componentsToRemove != null) {
			var _g = 0, _g1 = this.componentsToRemove;
			while(_g < _g1.length) {
				var compName = _g1[_g];
				++_g;
				this.components.remove(compName);
			}
		}
	}
	,flushAndDestroyComponents: function() {
		if(this.components != null) {
			var $it0 = this.components.iterator();
			while( $it0.hasNext() ) {
				var component = $it0.next();
				component.destroy();
			}
			var $it1 = this.components.keys();
			while( $it1.hasNext() ) {
				var i = $it1.next();
				this.components.remove(i);
			}
		}
	}
	,finalDestroy: function() {
		if(this.getManager() != null) {
			this.getManager().removeGameObject(this);
			this.scene = null;
		}
		titanium_reindeer.ManagedObject.prototype.finalDestroy.call(this);
		if(this.componentsToRemove != null) {
			while(this.componentsToRemove.length != 0) this.componentsToRemove.pop();
			this.componentsToRemove = null;
		}
		if(this.components != null) {
			var $it0 = this.components.keys();
			while( $it0.hasNext() ) {
				var i = $it0.next();
				this.components.remove(i);
			}
			this.components = null;
		}
		this.watchedPosition.destroy();
		this.watchedPosition = null;
	}
	,__class__: titanium_reindeer.GameObject
	,__properties__: {set_position:"setPosition",get_position:"getPosition",get_scene:"getManager"}
});
var Ball = $hxClasses["Ball"] = function(scene,color) {
	titanium_reindeer.GameObject.call(this,scene);
	this.color = color;
	this.body = new titanium_reindeer.CircleRenderer(10,0);
	this.body.setFill(color);
	this.addComponent("body",this.body);
	this.collision = new titanium_reindeer.CollisionCircle(10,"main","balls");
	this.addComponent("collision",this.collision);
	this.clickRegion = ((function($this) {
		var $r;
		var $t = $this.getManager().getManager(titanium_reindeer.CollisionComponentManager);
		if(Std["is"]($t,titanium_reindeer.CollisionComponentManager)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this))).mouseRegionManager.getHandler(this.collision);
	this.clickRegion.registerMouseMoveEvent(titanium_reindeer.MouseRegionMoveEvent.Enter,this.mouseEnter.$bind(this));
	this.clickRegion.registerMouseMoveEvent(titanium_reindeer.MouseRegionMoveEvent.Exit,this.mouseExit.$bind(this));
	this.clickRegion.registerMouseButtonEvent(titanium_reindeer.MouseRegionButtonEvent.Click,this.mouseClick.$bind(this));
};
Ball.__name__ = ["Ball"];
Ball.__super__ = titanium_reindeer.GameObject;
Ball.prototype = $extend(titanium_reindeer.GameObject.prototype,{
	body: null
	,collision: null
	,clickRegion: null
	,color: null
	,mouseEnter: function(pos) {
		this.body.setFill(titanium_reindeer.Color.getWhiteConst());
	}
	,mouseExit: function(pos) {
		this.body.setFill(this.color);
	}
	,mouseClick: function(pos,button) {
		this.body.setFill(titanium_reindeer.Color.getBlackConst());
	}
	,__class__: Ball
});
var EReg = $hxClasses["EReg"] = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	r: null
	,match: function(s) {
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,customReplace: function(s,f) {
		var buf = new StringBuf();
		while(true) {
			if(!this.match(s)) break;
			buf.add(this.matchedLeft());
			buf.add(f(this));
			s = this.matchedRight();
		}
		buf.b[buf.b.length] = s == null?"null":s;
		return buf.b.join("");
	}
	,__class__: EReg
}
var Hash = $hxClasses["Hash"] = function() {
	this.h = { };
};
Hash.__name__ = ["Hash"];
Hash.prototype = {
	h: null
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.b[s.b.length] = "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b[s.b.length] = i == null?"null":i;
			s.b[s.b.length] = " => ";
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.b[s.b.length] = ", ";
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,__class__: Hash
}
var IntHash = $hxClasses["IntHash"] = function() {
	this.h = { };
};
IntHash.__name__ = ["IntHash"];
IntHash.prototype = {
	h: null
	,set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.b[s.b.length] = "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b[s.b.length] = i == null?"null":i;
			s.b[s.b.length] = " => ";
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.b[s.b.length] = ", ";
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,__class__: IntHash
}
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	min: null
	,max: null
	,hasNext: function() {
		return this.min < this.max;
	}
	,next: function() {
		return this.min++;
	}
	,__class__: IntIter
}
var Lambda = $hxClasses["Lambda"] = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !it.iterator().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = a.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = b.iterator();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
Lambda.prototype = {
	__class__: Lambda
}
var Layers = $hxClasses["Layers"] = function() { }
Layers.__name__ = ["Layers"];
Layers.prototype = {
	__class__: Layers
}
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b[s.b.length] = "{";
		while(l != null) {
			if(first) first = false; else s.b[s.b.length] = ", ";
			s.add(Std.string(l[0]));
			l = l[1];
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.b[s.b.length] = sep == null?"null":sep;
			s.add(l[0]);
			l = l[1];
		}
		return s.b.join("");
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,__class__: List
}
var Reflect = $hxClasses["Reflect"] = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
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
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
Reflect.prototype = {
	__class__: Reflect
}
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
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
Std.prototype = {
	__class__: Std
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = new Array();
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b[this.b.length] = x == null?"null":x;
	}
	,addSub: function(s,pos,len) {
		this.b[this.b.length] = s.substr(pos,len);
	}
	,addChar: function(c) {
		this.b[this.b.length] = String.fromCharCode(c);
	}
	,toString: function() {
		return this.b.join("");
	}
	,b: null
	,__class__: StringBuf
}
titanium_reindeer.Game = $hxClasses["titanium_reindeer.Game"] = function(targetHtmlId,width,height,debugMode) {
	this.targetElement = js.Lib.document.getElementById(targetHtmlId);
	this.targetElement.style.position = "relative";
	this.width = width == null?400:width;
	this.height = height == null?300:height;
	this.debugMode = debugMode == null?false:debugMode;
	this.setMaxAllowedUpdateLengthMs(1000);
	this.exitGame = false;
	this.sceneManager = new titanium_reindeer.SceneManager(this);
	this.inputManager = new titanium_reindeer.GameInputManager(this,this.targetElement);
	this.soundManager = new titanium_reindeer.GameSoundManager(this);
	this.bitmapCache = new titanium_reindeer.BitmapCache();
	this.cursor = new titanium_reindeer.Cursor(this.targetElement);
	if(debugMode) js.Lib.onerror = function(msg,stack) {
		js.Lib.alert("ERROR[ " + msg + " ]");
		haxe.Log.trace(stack,{ fileName : "Game.hx", lineNumber : 63, className : "titanium_reindeer.Game", methodName : "new"});
		return true;
	};
};
titanium_reindeer.Game.__name__ = ["titanium_reindeer","Game"];
titanium_reindeer.Game.prototype = {
	targetElement: null
	,width: null
	,height: null
	,backgroundColor: null
	,debugMode: null
	,maxAllowedUpdateLengthMs: null
	,setMaxAllowedUpdateLengthMs: function(value) {
		if(value != this.maxAllowedUpdateLengthMs) this.maxAllowedUpdateLengthMs = Math.max(1,Math.min(value,Math.POSITIVE_INFINITY)) | 0;
		return this.maxAllowedUpdateLengthMs;
	}
	,exitGame: null
	,msLastTimeStep: null
	,sceneManager: null
	,inputManager: null
	,soundManager: null
	,bitmapCache: null
	,cursor: null
	,play: function() {
		this.requestAnimFrame();
	}
	,gameLoop: function(now) {
		if(this.exitGame) this.destroy(); else {
			if(this.msLastTimeStep == null) this.msLastTimeStep = now;
			var msTimeStep;
			if(now == null) msTimeStep = Math.round(1000 / 60); else msTimeStep = Math.min(now - this.msLastTimeStep,this.maxAllowedUpdateLengthMs) | 0;
			this.msLastTimeStep = now;
			this.preUpdate(msTimeStep);
			this.update(msTimeStep);
			this.postUpdate(msTimeStep);
			this.requestAnimFrame();
		}
	}
	,requestAnimFrame: function() {
		if(js.Lib.window.requestAnimationFrame) js.Lib.window.requestAnimationFrame(this.gameLoop.$bind(this),this.targetElement); else if(js.Lib.window.webkitRequestAnimationFrame) js.Lib.window.webkitRequestAnimationFrame(this.gameLoop.$bind(this),this.targetElement); else if(js.Lib.window.mozRequestAnimationFrame) js.Lib.window.mozRequestAnimationFrame(this.gameLoop.$bind(this),this.targetElement); else if(js.Lib.window.oRequestAnimationFrame) js.Lib.window.oRequestAnimationFrame(this.gameLoop.$bind(this),this.targetElement); else if(js.Lib.window.msRequestAnimationFrame) js.Lib.window.msRequestAnimationFrame(this.gameLoop.$bind(this),this.targetElement); else js.Lib.window.setTimeout(this.gameLoop.$bind(this),Math.round(1000 / 60));
	}
	,preUpdate: function(msTimeStep) {
		this.inputManager.preUpdate(msTimeStep);
		this.sceneManager.preUpdate(msTimeStep);
	}
	,update: function(msTimeStep) {
		this.sceneManager.update(msTimeStep);
		this.inputManager.update(msTimeStep);
	}
	,postUpdate: function(msTimeStep) {
		this.sceneManager.postUpdate(msTimeStep);
		this.inputManager.postUpdate(msTimeStep);
	}
	,destroy: function() {
		this.targetElement = null;
		this.backgroundColor = null;
		this.sceneManager.destroy();
		this.inputManager.destroy();
	}
	,stopGame: function() {
		this.exitGame = true;
	}
	,__class__: titanium_reindeer.Game
	,__properties__: {set_maxAllowedUpdateLengthMs:"setMaxAllowedUpdateLengthMs"}
}
var TestGame = $hxClasses["TestGame"] = function() {
	titanium_reindeer.Game.call(this,"TestGame",2000,2000,true);
	this.testScene = new TestScene(this);
};
TestGame.__name__ = ["TestGame"];
TestGame.main = function() {
	var game = new TestGame();
	game.play();
}
TestGame.__super__ = titanium_reindeer.Game;
TestGame.prototype = $extend(titanium_reindeer.Game.prototype,{
	testScene: null
	,__class__: TestGame
});
titanium_reindeer.ObjectManager = $hxClasses["titanium_reindeer.ObjectManager"] = function() {
	this.nextId = 0;
	this.objects = new IntHash();
	this.objectsToRemove = new IntHash();
};
titanium_reindeer.ObjectManager.__name__ = ["titanium_reindeer","ObjectManager"];
titanium_reindeer.ObjectManager.prototype = {
	nextId: null
	,objects: null
	,objectsToRemove: null
	,getNextId: function() {
		return this.nextId++;
	}
	,getObject: function(id) {
		if(this.objects.exists(id)) return this.objects.get(id); else return null;
	}
	,objectIdExists: function(id) {
		return this.objects.exists(id);
	}
	,addObject: function(object) {
		object.setManager(this);
		this.objects.set(object.id,object);
	}
	,removeObject: function(obj) {
		if(this.objects.exists(obj.id) && !this.objectsToRemove.exists(obj.id)) this.objectsToRemove.set(obj.id,obj.id);
	}
	,removeObjects: function() {
		if(Lambda.count(this.objectsToRemove) > 0) {
			var $it0 = this.objectsToRemove.iterator();
			while( $it0.hasNext() ) {
				var objId = $it0.next();
				var obj = this.objects.get(objId);
				if(obj.toBeDestroyed) {
					obj.finalDestroy();
					this.objects.remove(objId);
					this.objectsToRemove.remove(objId);
				}
			}
		}
	}
	,finalDestroy: function() {
		var $it0 = this.objects.keys();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			this.objects.get(i).destroy();
			this.objects.remove(i);
		}
		this.objects = null;
		var $it1 = this.objectsToRemove.keys();
		while( $it1.hasNext() ) {
			var i = $it1.next();
			this.objectsToRemove.remove(i);
		}
		this.objectsToRemove = null;
	}
	,__class__: titanium_reindeer.ObjectManager
}
titanium_reindeer.Scene = $hxClasses["titanium_reindeer.Scene"] = function(game,name,renderDepth,layerCount,backgroundColor) {
	titanium_reindeer.ObjectManager.call(this);
	this.name = name;
	this.inputManager = new titanium_reindeer.SceneInputManager(this);
	this.soundManager = new titanium_reindeer.SceneSoundManager(this);
	this.renderDepth = renderDepth;
	this.layerCount = layerCount;
	this.backgroundColor = backgroundColor == null?new titanium_reindeer.Color(255,255,255):backgroundColor;
	this.isPaused = false;
	this.sceneManager = game.sceneManager;
	this.sceneManager.addScene(this);
	this.componentManagers = new Hash();
};
titanium_reindeer.Scene.__name__ = ["titanium_reindeer","Scene"];
titanium_reindeer.Scene.__super__ = titanium_reindeer.ObjectManager;
titanium_reindeer.Scene.prototype = $extend(titanium_reindeer.ObjectManager.prototype,{
	sceneManager: null
	,game: null
	,getGame: function() {
		return this.sceneManager.game;
	}
	,toBeDestroyed: null
	,name: null
	,renderDepth: null
	,layerCount: null
	,backgroundColor: null
	,isPaused: null
	,inputManager: null
	,soundManager: null
	,bitmapCache: null
	,getBitmapCache: function() {
		return this.getGame().bitmapCache;
	}
	,componentManagers: null
	,addGameObject: function(gameObject) {
		this.addObject(gameObject);
	}
	,addGameObjects: function(objs) {
		var _g = 0;
		while(_g < objs.length) {
			var obj = objs[_g];
			++_g;
			titanium_reindeer.ObjectManager.prototype.addObject.call(this,obj);
		}
	}
	,removeGameObject: function(obj) {
		if(titanium_reindeer.ObjectManager.prototype.objectIdExists.call(this,obj.id)) obj.remove();
		titanium_reindeer.ObjectManager.prototype.removeObject.call(this,obj);
	}
	,getGameObject: function(id) {
		return (function($this) {
			var $r;
			var $t = titanium_reindeer.ObjectManager.prototype.getObject.call($this,id);
			if(Std["is"]($t,titanium_reindeer.GameObject)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
	}
	,getImage: function(filePath) {
		var pathIdentifier = "filePath:" + filePath;
		if(this.getBitmapCache().exists(pathIdentifier)) return this.getBitmapCache().get(pathIdentifier);
		var imageSource = new titanium_reindeer.ImageSource(filePath);
		this.getBitmapCache().set(pathIdentifier,imageSource);
		return imageSource;
	}
	,getSound: function(filePath) {
		return this.soundManager.getSound(filePath);
	}
	,getManager: function(managerType) {
		var className = Type.getClassName(managerType);
		var manager;
		if(this.componentManagers.exists(className)) manager = this.componentManagers.get(className); else {
			manager = Type.createInstance(managerType,[this]);
			this.componentManagers.set(className,manager);
		}
		return manager;
	}
	,pause: function() {
		if(!this.isPaused) {
			this.isPaused = true;
			this.soundManager.pause(true);
		}
	}
	,unpause: function() {
		if(this.isPaused) {
			this.isPaused = false;
			this.soundManager.unpause();
		}
	}
	,delegateComponent: function(component) {
		var manager = this.getManager(component.getManagerType());
		manager.addComponent(component);
		component.initialize();
	}
	,preUpdate: function(msTimeStep) {
		var $it0 = this.componentManagers.iterator();
		while( $it0.hasNext() ) {
			var manager = $it0.next();
			manager.preUpdate(msTimeStep);
		}
		this.inputManager.preUpdate(msTimeStep);
	}
	,update: function(msTimeStep) {
		if(this.isPaused) return;
		var $it0 = this.objects.iterator();
		while( $it0.hasNext() ) {
			var obj = $it0.next();
			((function($this) {
				var $r;
				var $t = obj;
				if(Std["is"]($t,titanium_reindeer.GameObject)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this))).update(msTimeStep);
		}
		var $it1 = this.componentManagers.iterator();
		while( $it1.hasNext() ) {
			var manager = $it1.next();
			manager.update(msTimeStep);
		}
		this.inputManager.update(msTimeStep);
	}
	,postUpdate: function(msTimeStep) {
		var $it0 = this.componentManagers.iterator();
		while( $it0.hasNext() ) {
			var manager = $it0.next();
			manager.postUpdate(msTimeStep);
		}
		this.inputManager.postUpdate(msTimeStep);
		titanium_reindeer.ObjectManager.prototype.removeObjects.call(this);
		var $it1 = this.objects.iterator();
		while( $it1.hasNext() ) {
			var obj = $it1.next();
			((function($this) {
				var $r;
				var $t = obj;
				if(Std["is"]($t,titanium_reindeer.GameObject)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this))).removeComponents();
		}
		var $it2 = this.componentManagers.iterator();
		while( $it2.hasNext() ) {
			var manager = $it2.next();
			manager.removeComponents();
		}
		if(this.toBeDestroyed) this.finalDestroy();
	}
	,destroy: function() {
		this.toBeDestroyed = true;
	}
	,finalDestroy: function() {
		titanium_reindeer.ObjectManager.prototype.finalDestroy.call(this);
		var $it0 = this.componentManagers.keys();
		while( $it0.hasNext() ) {
			var managerName = $it0.next();
			this.componentManagers.get(managerName).finalDestroy();
			this.componentManagers.remove(managerName);
		}
		this.componentManagers = null;
		this.sceneManager.removeScene(this);
		this.sceneManager = null;
	}
	,__class__: titanium_reindeer.Scene
	,__properties__: {get_bitmapCache:"getBitmapCache",get_game:"getGame"}
});
var TestScene = $hxClasses["TestScene"] = function(game) {
	titanium_reindeer.Scene.call(this,game,"testScene",0,1,titanium_reindeer.Color.getWhiteConst());
	this.testGame = game;
	this.balls = new Array();
	var colors = [titanium_reindeer.Color.getRedConst(),titanium_reindeer.Color.getOrangeConst(),titanium_reindeer.Color.getYellowConst(),titanium_reindeer.Color.getGreenConst(),titanium_reindeer.Color.getBlueConst(),titanium_reindeer.Color.getPurpleConst()];
	var spacing = 22;
	var _g = 1;
	while(_g < 20) {
		var x = _g++;
		var _g1 = 1;
		while(_g1 < 20) {
			var y = _g1++;
			var ball = new Ball(this,colors[Std.random(colors.length)]);
			ball.setPosition(new titanium_reindeer.Vector2(x * spacing,y * spacing));
			this.balls.push(ball);
		}
	}
};
TestScene.__name__ = ["TestScene"];
TestScene.__super__ = titanium_reindeer.Scene;
TestScene.prototype = $extend(titanium_reindeer.Scene.prototype,{
	testGame: null
	,balls: null
	,__class__: TestScene
});
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
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
var Type = $hxClasses["Type"] = function() { }
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
	var cl = $hxClasses[name];
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
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
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	a.remove("__class__");
	a.remove("__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__properties__");
	a.remove("__super__");
	a.remove("prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.copy();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ != null) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
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
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
Type.prototype = {
	__class__: Type
}
var haxe = haxe || {}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype = {
	__class__: haxe.Log
}
haxe.Timer = $hxClasses["haxe.Timer"] = function(time_ms) {
	var me = this;
	this.id = window.setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.measure = function(f,pos) {
	var t0 = haxe.Timer.stamp();
	var r = f();
	haxe.Log.trace(haxe.Timer.stamp() - t0 + "s",pos);
	return r;
}
haxe.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
haxe.Timer.prototype = {
	id: null
	,stop: function() {
		if(this.id == null) return;
		window.clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
}
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
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
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
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
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	};
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
	};
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	};
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return undefined;
		return x;
	};
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		} else if(len < 0) len = this.length + len - pos;
		return oldsub.apply(this,[pos,len]);
	};
	Function.prototype["$bind"] = function(o) {
		var f = function() {
			return f.method.apply(f.scope,arguments);
		};
		f.scope = o;
		f.method = this;
		return f;
	};
}
js.Boot.prototype = {
	__class__: js.Boot
}
js.Lib = $hxClasses["js.Lib"] = function() { }
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
js.Lib.prototype = {
	__class__: js.Lib
}
titanium_reindeer.BinCoord = $hxClasses["titanium_reindeer.BinCoord"] = function(x,y) {
	this.x = x;
	this.y = y;
};
titanium_reindeer.BinCoord.__name__ = ["titanium_reindeer","BinCoord"];
titanium_reindeer.BinCoord.prototype = {
	x: null
	,y: null
	,__class__: titanium_reindeer.BinCoord
}
titanium_reindeer.Bin = $hxClasses["titanium_reindeer.Bin"] = function() {
	this.items = new IntHash();
};
titanium_reindeer.Bin.__name__ = ["titanium_reindeer","Bin"];
titanium_reindeer.Bin.prototype = {
	items: null
	,addItem: function(item) {
		this.items.set(item.value,item);
	}
	,removeItem: function(value) {
		this.items.remove(value);
	}
	,__class__: titanium_reindeer.Bin
}
titanium_reindeer.Item = $hxClasses["titanium_reindeer.Item"] = function(bins,bounds,value) {
	this.bins = bins;
	this.bounds = bounds;
	this.value = value;
};
titanium_reindeer.Item.__name__ = ["titanium_reindeer","Item"];
titanium_reindeer.Item.prototype = {
	bins: null
	,bounds: null
	,value: null
	,__class__: titanium_reindeer.Item
}
titanium_reindeer.SpacePartition = $hxClasses["titanium_reindeer.SpacePartition"] = function() { }
titanium_reindeer.SpacePartition.__name__ = ["titanium_reindeer","SpacePartition"];
titanium_reindeer.SpacePartition.prototype = {
	debugCanvas: null
	,debugOffset: null
	,debugSteps: null
	,insert: null
	,update: null
	,remove: null
	,getRectIntersectingValues: null
	,getPointIntersectingValues: null
	,drawDebug: null
	,__class__: titanium_reindeer.SpacePartition
}
titanium_reindeer.BinPartition = $hxClasses["titanium_reindeer.BinPartition"] = function(binSize,originOffset,width,height) {
	this.binSize = binSize;
	this.originOffset = originOffset == null?new titanium_reindeer.Vector2(0,0):originOffset;
	this.width = width;
	this.height = height;
	this.bins = new Array();
	this.valueMap = new IntHash();
};
titanium_reindeer.BinPartition.__name__ = ["titanium_reindeer","BinPartition"];
titanium_reindeer.BinPartition.__interfaces__ = [titanium_reindeer.SpacePartition];
titanium_reindeer.BinPartition.prototype = {
	binSize: null
	,originOffset: null
	,width: null
	,height: null
	,bins: null
	,valueMap: null
	,debugCanvas: null
	,debugOffset: null
	,debugSteps: null
	,getBinsIntersectingRect: function(rect) {
		var collidingBins = new IntHash();
		if(rect.width < this.binSize && rect.height < this.binSize) {
			collidingBins.set(this.getBinIndex(new titanium_reindeer.Vector2(rect.getLeft(),rect.getTop())),1);
			collidingBins.set(this.getBinIndex(new titanium_reindeer.Vector2(rect.getRight(),rect.getTop())),1);
			collidingBins.set(this.getBinIndex(new titanium_reindeer.Vector2(rect.getLeft(),rect.getBottom())),1);
			collidingBins.set(this.getBinIndex(new titanium_reindeer.Vector2(rect.getRight(),rect.getBottom())),1);
		} else {
			var topLeft = this.getBinCoord(new titanium_reindeer.Vector2(rect.getLeft(),rect.getTop()));
			var topRight = this.getBinCoord(new titanium_reindeer.Vector2(rect.getRight(),rect.getTop()));
			var bottomLeft = this.getBinCoord(new titanium_reindeer.Vector2(rect.getLeft(),rect.getBottom()));
			var _g1 = topLeft.x, _g = topRight.x;
			while(_g1 < _g) {
				var x = _g1++;
				var _g3 = topLeft.y, _g2 = bottomLeft.y;
				while(_g3 < _g2) {
					var y = _g3++;
					collidingBins.set(this.indexFromCoord(x,y),1);
				}
			}
		}
		var bins = new Array();
		var binCoord;
		var $it0 = collidingBins.keys();
		while( $it0.hasNext() ) {
			var index = $it0.next();
			bins.push(this.getBin(this.coordFromIndex(index)));
		}
		return bins;
	}
	,getBinCoord: function(p) {
		p.subtractFrom(this.originOffset);
		return new titanium_reindeer.BinCoord(Math.floor(p.getX() / this.binSize),Math.floor(p.getY() / this.binSize));
	}
	,getBinIndex: function(p) {
		var binCoord = this.getBinCoord(p);
		return binCoord.x + binCoord.y * this.binSize;
	}
	,coordFromIndex: function(index) {
		return new titanium_reindeer.BinCoord(index % this.binSize,Math.floor(index / this.binSize));
	}
	,indexFromCoord: function(x,y) {
		return x + y * this.binSize;
	}
	,getBin: function(binCoord) {
		if(binCoord.x < 0 || binCoord.y < 0) return null;
		if(binCoord.x > this.width || binCoord.y > this.height) return null;
		if(this.bins[binCoord.y] == null) {
			this.bins[binCoord.y] = new Array();
			this.bins[binCoord.y][binCoord.x] = new titanium_reindeer.Bin();
		} else if(this.bins[binCoord.y][binCoord.x] == null) this.bins[binCoord.y][binCoord.x] = new titanium_reindeer.Bin();
		return this.bins[binCoord.y][binCoord.x];
	}
	,insert: function(rect,value) {
		if(rect == null) return;
		var bins = this.getBinsIntersectingRect(rect);
		var item = new titanium_reindeer.Item(bins,rect,value);
		var _g = 0;
		while(_g < bins.length) {
			var bin = bins[_g];
			++_g;
			bin.addItem(item);
		}
		this.valueMap.set(value,item);
	}
	,update: function(newBounds,value) {
		if(newBounds == null || !this.valueMap.exists(value)) return;
		this.remove(value);
		this.insert(newBounds,value);
	}
	,remove: function(value) {
		if(!this.valueMap.exists(value)) return;
		var _g = 0, _g1 = this.valueMap.get(value).bins;
		while(_g < _g1.length) {
			var bin = _g1[_g];
			++_g;
			bin.removeItem(value);
		}
		this.valueMap.remove(value);
	}
	,getRectIntersectingValues: function(rect) {
		if(rect == null) return new Array();
		var results = new Array();
		var _g = 0, _g1 = this.getBinsIntersectingRect(rect);
		while(_g < _g1.length) {
			var bin = _g1[_g];
			++_g;
			var $it0 = bin.items.iterator();
			while( $it0.hasNext() ) {
				var item = $it0.next();
				if(titanium_reindeer.Rect.isIntersecting(item.bounds,rect)) results.push(item.value);
			}
		}
		return results;
	}
	,getPointIntersectingValues: function(point) {
		if(point == null) return new Array();
		var results = new Array();
		var binCoord = this.getBinCoord(point);
		var $it0 = this.getBin(binCoord).items.iterator();
		while( $it0.hasNext() ) {
			var item = $it0.next();
			if(item.bounds.isPointInside(point)) results.push(item.value);
		}
		return results;
	}
	,drawDebug: function() {
	}
	,__class__: titanium_reindeer.BinPartition
}
titanium_reindeer.BitmapCache = $hxClasses["titanium_reindeer.BitmapCache"] = function() {
	this.cachedBitmaps = new Hash();
};
titanium_reindeer.BitmapCache.__name__ = ["titanium_reindeer","BitmapCache"];
titanium_reindeer.BitmapCache.prototype = {
	cachedBitmaps: null
	,exists: function(identifier) {
		return this.cachedBitmaps.exists(identifier);
	}
	,set: function(identifier,bitmap) {
		if(!this.cachedBitmaps.exists(identifier)) {
			this.cachedBitmaps.set(identifier,bitmap);
			return true;
		}
		return false;
	}
	,get: function(identifier) {
		return this.cachedBitmaps.get(identifier);
	}
	,remove: function(identifier) {
		return this.cachedBitmaps.remove(identifier);
	}
	,destroy: function() {
		var $it0 = this.cachedBitmaps.iterator();
		while( $it0.hasNext() ) {
			var image = $it0.next();
			image.destroy();
		}
		this.cachedBitmaps = null;
	}
	,__class__: titanium_reindeer.BitmapCache
}
titanium_reindeer.BitmapData = $hxClasses["titanium_reindeer.BitmapData"] = function(pen,sourceRect) {
	if(pen != null && sourceRect != null) this.rawData = pen.getImageData(sourceRect.x,sourceRect.y,sourceRect.width,sourceRect.height);
};
titanium_reindeer.BitmapData.__name__ = ["titanium_reindeer","BitmapData"];
titanium_reindeer.BitmapData.prototype = {
	rawData: null
	,data: null
	,getData: function() {
		return this.rawData.data;
	}
	,width: null
	,getWidth: function() {
		return this.rawData.width;
	}
	,height: null
	,getHeight: function() {
		return this.rawData.height;
	}
	,getCopy: function() {
		var newData = new titanium_reindeer.BitmapData();
		newData.rawData = this.rawData;
		return newData;
	}
	,destroy: function() {
		this.rawData = null;
	}
	,__class__: titanium_reindeer.BitmapData
	,__properties__: {get_height:"getHeight",get_width:"getWidth",get_data:"getData"}
}
titanium_reindeer.BitmapEffect = $hxClasses["titanium_reindeer.BitmapEffect"] = function() {
};
titanium_reindeer.BitmapEffect.__name__ = ["titanium_reindeer","BitmapEffect"];
titanium_reindeer.BitmapEffect.prototype = {
	apply: function(bitmapData) {
	}
	,identify: function() {
		return "";
	}
	,destroy: function() {
	}
	,__class__: titanium_reindeer.BitmapEffect
}
titanium_reindeer.Shape = $hxClasses["titanium_reindeer.Shape"] = function() { }
titanium_reindeer.Shape.__name__ = ["titanium_reindeer","Shape"];
titanium_reindeer.Shape.prototype = {
	getMinBoundingRect: function() {
		throw "Error: This function should not be called, inheriting classes should override and not call!";
		return null;
	}
	,isPointInside: function(p) {
		return false;
	}
	,__class__: titanium_reindeer.Shape
}
titanium_reindeer.Circle = $hxClasses["titanium_reindeer.Circle"] = function(radius,center) {
	this.radius = radius;
	this.setCenter(new titanium_reindeer.Vector2(0,0));
	this.setCenter(center);
};
titanium_reindeer.Circle.__name__ = ["titanium_reindeer","Circle"];
titanium_reindeer.Circle.isIntersecting = function(a,b) {
	return a.radius + b.radius > titanium_reindeer.Vector2.getDistance(a.center,b.center);
}
titanium_reindeer.Circle.__super__ = titanium_reindeer.Shape;
titanium_reindeer.Circle.prototype = $extend(titanium_reindeer.Shape.prototype,{
	radius: null
	,center: null
	,setCenter: function(value) {
		if(value != null) this.center = value;
		return this.center;
	}
	,getMinBoundingRect: function() {
		return new titanium_reindeer.Rect(this.center.getX() - this.radius,this.center.getY() - this.radius,this.radius * 2,this.radius * 2);
	}
	,isPointInside: function(p) {
		return this.radius >= titanium_reindeer.Vector2.getDistance(p,this.center);
	}
	,__class__: titanium_reindeer.Circle
	,__properties__: {set_center:"setCenter"}
});
titanium_reindeer.Component = $hxClasses["titanium_reindeer.Component"] = function() {
	titanium_reindeer.ManagedObject.call(this);
	this.setEnabled(true);
};
titanium_reindeer.Component.__name__ = ["titanium_reindeer","Component"];
titanium_reindeer.Component.__super__ = titanium_reindeer.ManagedObject;
titanium_reindeer.Component.prototype = $extend(titanium_reindeer.ManagedObject.prototype,{
	owner: null
	,componentManager: null
	,getManager: function() {
		if(this.manager == null) return null; else return (function($this) {
			var $r;
			var $t = $this.manager;
			if(Std["is"]($t,titanium_reindeer.ComponentManager)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
	}
	,enabled: null
	,setEnabled: function(value) {
		this.enabled = value;
		return this.enabled;
	}
	,setOwner: function(gameObject) {
		if(this.owner == null) this.owner = gameObject;
	}
	,initialize: function() {
	}
	,getManagerType: function() {
		return titanium_reindeer.ComponentManager;
	}
	,notifyPositionChange: function() {
	}
	,remove: function() {
		if(this.getManager() != null) this.getManager().removeComponent(this);
	}
	,destroy: function() {
		this.remove();
		this.setEnabled(false);
		titanium_reindeer.ManagedObject.prototype.destroy.call(this);
	}
	,finalDestroy: function() {
		titanium_reindeer.ManagedObject.prototype.finalDestroy.call(this);
		this.owner = null;
		this.componentManager = null;
		this.setEnabled(false);
	}
	,__class__: titanium_reindeer.Component
	,__properties__: {set_enabled:"setEnabled",get_componentManager:"getManager"}
});
titanium_reindeer.RendererComponent = $hxClasses["titanium_reindeer.RendererComponent"] = function(width,height,layer) {
	titanium_reindeer.Component.call(this);
	this.setInitialWidth(width);
	this.setInitialHeight(height);
	this.layerNum = layer;
	this.setAlpha(1);
	this.setShadow(new titanium_reindeer.Shadow(new titanium_reindeer.Color(0,0,0,0),new titanium_reindeer.Vector2(0,0),0));
	this.setRotation(0);
	this.watchedOffset = new titanium_reindeer.WatchedVector2(0,0,this.offsetChanged.$bind(this));
	this.effects = new Hash();
	this.lastIdentifier = "";
	this.lastRenderedPosition = new titanium_reindeer.Vector2(0,0);
	this.useFakes = false;
};
titanium_reindeer.RendererComponent.__name__ = ["titanium_reindeer","RendererComponent"];
titanium_reindeer.RendererComponent.CompositionToString = function(comp) {
	return (function($this) {
		var $r;
		switch( (comp)[1] ) {
		case 0:
			$r = "source-atop";
			break;
		case 1:
			$r = "source-in";
			break;
		case 2:
			$r = "source-out";
			break;
		case 3:
			$r = "source-over";
			break;
		case 4:
			$r = "destination-atop";
			break;
		case 5:
			$r = "destination-in";
			break;
		case 6:
			$r = "destination-out";
			break;
		case 7:
			$r = "destination-over";
			break;
		case 8:
			$r = "lighter";
			break;
		case 9:
			$r = "copy";
			break;
		case 10:
			$r = "xor";
			break;
		}
		return $r;
	}(this));
}
titanium_reindeer.RendererComponent.__super__ = titanium_reindeer.Component;
titanium_reindeer.RendererComponent.prototype = $extend(titanium_reindeer.Component.prototype,{
	rendererManager: null
	,getRendererManager: function() {
		if(this.manager == null) return null; else return (function($this) {
			var $r;
			var $t = $this.manager;
			if(Std["is"]($t,titanium_reindeer.RendererComponentManager)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
	}
	,layerNum: null
	,layer: null
	,setLayer: function(layerId) {
		if(this.layer != null) {
			if(this.layer.id == layerId) return;
			this.layer.removeRenderer(this);
		}
		var layerManager = this.getRendererManager().renderLayerManager;
		if(layerManager.layerExists(layerId)) {
			this.layer = layerManager.getLayer(layerId);
			this.layer.addRenderer(this);
		} else throw "RendererComponent: Attempting to add renderer to a non-existant layer (" + layerId + ")!";
	}
	,pen: null
	,getPen: function() {
		if(this.useFakes) return this.fakePen;
		if(this.layer == null) return null; else return this.layer.pen;
	}
	,watchedOffset: null
	,offset: null
	,getOffset: function() {
		return this.watchedOffset;
	}
	,setOffset: function(value) {
		if(value != null) {
			if(this.watchedOffset != value && !this.watchedOffset.equal(value)) {
				this.watchedOffset.setVector2(value);
				this.setRedraw(true);
			}
		}
		return this.getOffset();
	}
	,drawnWidth: null
	,initialDrawnWidth: null
	,setInitialWidth: function(value) {
		if(value < 0) value = 0;
		if(this.initialDrawnWidth != value) {
			this.initialDrawnWidth = value;
			this.recalculateDrawnWidthAndHeight();
			this.setRedraw(true);
		}
		return this.initialDrawnWidth;
	}
	,drawnHeight: null
	,initialDrawnHeight: null
	,setInitialHeight: function(value) {
		if(value < 0) value = 0;
		if(this.initialDrawnHeight != value) {
			this.initialDrawnHeight = value;
			this.recalculateDrawnWidthAndHeight();
			this.setRedraw(true);
		}
		return this.initialDrawnHeight;
	}
	,recalculateDrawnWidthAndHeight: function() {
		var width = this.initialDrawnWidth;
		var height = this.initialDrawnHeight;
		if(this.shadow != null && this.shadow.color.alpha > 0) {
			width += Math.abs(this.shadow.offset.getX()) * 2 + this.shadow.blur;
			height += Math.abs(this.shadow.offset.getY()) * 2 + this.shadow.blur;
		}
		if(this.rotation != 0) {
			var hypot = Math.sqrt(width * width + height * height);
			width = hypot;
			height = hypot;
		}
		this.drawnWidth = width;
		this.drawnHeight = height;
	}
	,shadow: null
	,setShadow: function(value) {
		if(value != null) {
			if(this.shadow == null || !value.equal(this.shadow)) {
				this.shadow = value;
				this.recalculateDrawnWidthAndHeight();
				this.setRedraw(true);
			}
		}
		return this.shadow;
	}
	,rotation: null
	,setRotation: function(value) {
		value %= Math.PI * 2;
		if(value != this.rotation) {
			this.rotation = value;
			this.recalculateDrawnWidthAndHeight();
			this.setRedraw(true);
		}
		return this.rotation;
	}
	,alpha: null
	,setAlpha: function(value) {
		if(value < 0) value = 0; else if(value > 1) value = 1;
		if(value != this.alpha) {
			this.alpha = value;
			this.setRedraw(true);
		}
		return this.alpha;
	}
	,renderComposition: null
	,getRenderComposition: function() {
		if(this.layer == null) return titanium_reindeer.Composition.SourceOver; else return this.layer.renderComposition;
	}
	,screenPos: null
	,getScreenPos: function() {
		if(this.useFakes) return this.fakePosition;
		if(this.layer == null) return new titanium_reindeer.Vector2(0,0);
		if(this.owner == null) return this.layer.getVectorToScreen(new titanium_reindeer.Vector2(0,0)).add(this.getOffset()); else return this.layer.getVectorToScreen(this.owner.getPosition()).add(this.getOffset());
	}
	,timeForRedraw: null
	,setRedraw: function(value) {
		if(value) this.recreateBitmapData();
		if(value && !this.timeForRedraw) {
			if(this.layer != null) this.layer.redrawRenderer(this);
			this.timeForRedraw = true;
		} else if(!value && this.timeForRedraw) {
			if(this.layer != null) this.layer.stopRedrawRenderer(this);
			this.timeForRedraw = false;
		}
		return this.timeForRedraw;
	}
	,lastRenderedPosition: null
	,lastRenderedWidth: null
	,lastRenderedHeight: null
	,visible: null
	,getVisible: function() {
		return this.enabled;
	}
	,setVisible: function(value) {
		this.setEnabled(value);
		return this.enabled;
	}
	,setEnabled: function(value) {
		this.setRedraw(true);
		return titanium_reindeer.Component.prototype.setEnabled.call(this,value);
	}
	,effects: null
	,lastIdentifier: null
	,sharedBitmap: null
	,usingSharedBitmap: null
	,effectWorker: null
	,useFakes: null
	,fakePen: null
	,fakePosition: null
	,getManagerType: function() {
		return titanium_reindeer.RendererComponentManager;
	}
	,initialize: function() {
		this.setLayer(this.layerNum);
		this.setRedraw(true);
	}
	,notifyPositionChange: function() {
		this.setRedraw(true);
	}
	,offsetChanged: function() {
		this.setRedraw(true);
	}
	,fixRotationOnPoint: function(p) {
		if(this.rotation != 0) {
			var rotatedPoint = p.getRotate(this.rotation - 2 * Math.PI);
			this.getPen().translate(p.getX() - rotatedPoint.getX(),p.getY() - rotatedPoint.getY());
		}
	}
	,update: function(msTimeStep) {
	}
	,preRender: function() {
		this.getPen().save();
		this.getPen().globalCompositeOperation = titanium_reindeer.RendererComponent.CompositionToString(this.getRenderComposition());
		this.getPen().translate(this.getScreenPos().getX(),this.getScreenPos().getY());
		if(this.rotation != 0) this.getPen().rotate(this.rotation);
		this.getPen().globalAlpha = this.alpha;
		this.getPen().shadowColor = this.shadow.color.getRgba();
		this.getPen().shadowOffsetX = this.shadow.offset.getX();
		this.getPen().shadowOffsetY = this.shadow.offset.getY();
		this.getPen().shadowBlur = this.shadow.blur;
	}
	,render: function() {
	}
	,postRender: function() {
		this.setRedraw(false);
		this.getPen().restore();
	}
	,renderSharedBitmap: function() {
		if(this.sharedBitmap != null) this.getPen().drawImage(this.sharedBitmap.image,this.getScreenPos().getX() - (this.drawnWidth / 2 + 1),this.getScreenPos().getY() - (this.drawnHeight / 2 + 1));
	}
	,setLastRendered: function() {
		this.lastRenderedPosition = this.getScreenPos().getCopy();
		this.lastRenderedWidth = this.drawnWidth;
		this.lastRenderedHeight = this.drawnHeight;
	}
	,identify: function() {
		var identifier = "";
		var $it0 = this.effects.iterator();
		while( $it0.hasNext() ) {
			var effect = $it0.next();
			if(identifier != "") identifier += ",";
			identifier += effect.identify();
		}
		return "Renderer(" + Math.round(this.drawnWidth) + "," + Math.round(this.drawnHeight) + "," + this.alpha + "," + this.shadow.identify() + "," + this.rotation + ",Effects(" + identifier + "));";
	}
	,addEffect: function(name,effect) {
		this.effects.set(name,effect);
		this.setRedraw(true);
	}
	,removeEffect: function(name) {
		this.effects.remove(name);
		this.setRedraw(true);
	}
	,useAlternateCanvas: function(pen,newPosition) {
		this.fakePen = pen;
		if(newPosition == null) this.fakePosition = new titanium_reindeer.Vector2(this.drawnWidth / 2 + 1,this.drawnHeight / 2 + 1); else this.fakePosition = newPosition;
		this.useFakes = true;
	}
	,disableAlternateCanvas: function() {
		this.fakePen = null;
		this.fakePosition = null;
		this.useFakes = false;
	}
	,recreateBitmapData: function() {
		if(this.getRendererManager() != null && Lambda.count(this.effects) != 0) {
			var identifier = this.identify();
			if(this.lastIdentifier == identifier) return;
			this.lastIdentifier = identifier;
			this.usingSharedBitmap = true;
			if(this.getRendererManager().getBitmapCache().exists(identifier)) this.sharedBitmap = this.getRendererManager().getBitmapCache().get(identifier); else {
				var canvas = js.Lib.document.createElement("canvas");
				canvas.setAttribute("width",this.drawnWidth + 2 + "px");
				canvas.setAttribute("height",this.drawnHeight + 2 + "px");
				this.useAlternateCanvas(canvas.getContext("2d"),new titanium_reindeer.Vector2(this.drawnWidth / 2 + 1,this.drawnHeight / 2 + 1));
				this.preRender();
				this.render();
				this.postRender();
				var bitmapData = new titanium_reindeer.BitmapData(this.fakePen,new titanium_reindeer.Rect(0,0,this.drawnWidth + 2,this.drawnHeight + 2));
				var $it0 = this.effects.iterator();
				while( $it0.hasNext() ) {
					var effect = $it0.next();
					effect.apply(bitmapData);
				}
				this.fakePen.clearRect(0,0,this.drawnWidth + 2,this.drawnHeight + 2);
				this.fakePen.putImageData(bitmapData.rawData,0,0);
				var bitmap = new titanium_reindeer.ImageSource(canvas.toDataURL("image/png"));
				if(bitmap.isLoaded) this.cachedBitmapLoaded(null); else bitmap.registerLoadEvent(this.cachedBitmapLoaded.$bind(this));
				this.sharedBitmap = bitmap;
				this.getRendererManager().getBitmapCache().set(identifier,bitmap);
				this.disableAlternateCanvas();
			}
		} else {
			this.usingSharedBitmap = false;
			this.lastIdentifier = "";
		}
	}
	,cachedBitmapLoaded: function(event) {
		this.setRedraw(true);
	}
	,getRectBounds: function(extraEdgeSize) {
		var width = this.drawnWidth + extraEdgeSize;
		var height = this.drawnHeight + extraEdgeSize;
		return new titanium_reindeer.Rect(this.getScreenPos().getX() - width / 2,this.getScreenPos().getY() - height / 2,width,height);
	}
	,getLastRectBounds: function(extraEdgeSize) {
		var width = this.lastRenderedWidth + extraEdgeSize;
		var height = this.lastRenderedHeight + extraEdgeSize;
		return new titanium_reindeer.Rect(this.lastRenderedPosition.getX() - width / 2,this.lastRenderedPosition.getY() - height / 2,width,height);
	}
	,finalDestroy: function() {
		titanium_reindeer.Component.prototype.finalDestroy.call(this);
		this.layer.removeRenderer(this);
		this.layer.stopRedrawRenderer(this);
		this.layer = null;
		this.fakePen = null;
		this.fakePosition = null;
		this.watchedOffset.destroy();
		this.watchedOffset = null;
		this.lastRenderedPosition = null;
		this.setRedraw(false);
		this.setShadow(null);
		var $it0 = this.effects.keys();
		while( $it0.hasNext() ) {
			var name = $it0.next();
			this.effects.get(name).destroy();
			this.effects.remove(name);
		}
		this.effects = null;
		this.sharedBitmap = null;
	}
	,__class__: titanium_reindeer.RendererComponent
	,__properties__: $extend(titanium_reindeer.Component.prototype.__properties__,{set_visible:"setVisible",get_visible:"getVisible",set_timeForRedraw:"setRedraw",get_screenPos:"getScreenPos",get_renderComposition:"getRenderComposition",set_alpha:"setAlpha",set_rotation:"setRotation",set_shadow:"setShadow",set_initialDrawnHeight:"setInitialHeight",set_initialDrawnWidth:"setInitialWidth",set_offset:"setOffset",get_offset:"getOffset",get_pen:"getPen",get_rendererManager:"getRendererManager"})
});
titanium_reindeer.StrokeFillRenderer = $hxClasses["titanium_reindeer.StrokeFillRenderer"] = function(width,height,layer) {
	titanium_reindeer.RendererComponent.call(this,width,height,layer);
	this.setFill(titanium_reindeer.Color.getWhiteConst());
	this.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.setLineWidth(0);
	this.setLineCap(titanium_reindeer.LineCapType.Butt);
	this.setLineJoin(titanium_reindeer.LineJoinType.Miter);
	this.setMiterLimit(10.0);
};
titanium_reindeer.StrokeFillRenderer.__name__ = ["titanium_reindeer","StrokeFillRenderer"];
titanium_reindeer.StrokeFillRenderer.__super__ = titanium_reindeer.RendererComponent;
titanium_reindeer.StrokeFillRenderer.prototype = $extend(titanium_reindeer.RendererComponent.prototype,{
	fillStyle: null
	,currentFill: null
	,fillColor: null
	,setFill: function(value) {
		if(value != null) {
			this.currentFill = titanium_reindeer.FillTypes.ColorFill;
			if(this.fillStyle != value.getRgba()) {
				this.fillColor = value;
				this.fillStyle = value.getRgba();
				this.setRedraw(true);
			}
		}
		return value;
	}
	,fillGradient: null
	,setFillGradient: function(value) {
		if(value != null) {
			this.fillGradient = value;
			this.currentFill = titanium_reindeer.FillTypes.Gradient;
			if(this.getPen() != null && this.fillStyle != value.getStyle(this.getPen())) {
				this.fillStyle = value.getStyle(this.getPen());
				this.setRedraw(true);
			}
		}
		return value;
	}
	,fillPattern: null
	,setFillPattern: function(value) {
		if(value != null) {
			this.fillPattern = value;
			if(value.imageSource.isLoaded) {
				this.currentFill = titanium_reindeer.FillTypes.Pattern;
				if(this.getPen() != null && this.fillStyle != value.getStyle(this.getPen())) {
					this.fillStyle = value.getStyle(this.getPen());
					this.setRedraw(true);
				}
			} else value.imageSource.registerLoadEvent(this.fillPatternImageLoaded.$bind(this));
		}
		return value;
	}
	,strokeStyle: null
	,currentStroke: null
	,strokeColor: null
	,setStrokeColor: function(value) {
		if(value != null) {
			this.strokeColor = value;
			this.currentStroke = titanium_reindeer.StrokeTypes.StrokeColor;
			if(this.strokeStyle != value.getRgba()) {
				this.strokeStyle = this.strokeColor.getRgba();
				this.setRedraw(true);
			}
		}
		return value;
	}
	,strokeGradient: null
	,setStrokeGradient: function(value) {
		if(value != null) {
			this.strokeGradient = value;
			this.currentStroke = titanium_reindeer.StrokeTypes.Gradient;
			if(this.getPen() != null && this.strokeStyle != value.getStyle(this.getPen())) {
				this.strokeStyle = value.getStyle(this.getPen());
				this.setRedraw(true);
			}
		}
		return value;
	}
	,lineWidth: null
	,setLineWidth: function(value) {
		if(value != this.lineWidth) {
			this.lineWidth = value;
			this.setRedraw(true);
		}
		return value;
	}
	,lineCap: null
	,setLineCap: function(value) {
		if(value != this.lineCap) {
			this.lineCap = value;
			this.setRedraw(true);
		}
		return value;
	}
	,lineJoin: null
	,setLineJoin: function(value) {
		if(value != this.lineJoin) {
			this.lineJoin = value;
			this.setRedraw(true);
		}
		return value;
	}
	,miterLimit: null
	,setMiterLimit: function(value) {
		if(value != this.miterLimit) {
			this.miterLimit = value;
			this.setRedraw(true);
		}
		return value;
	}
	,initialize: function() {
		titanium_reindeer.RendererComponent.prototype.initialize.call(this);
		switch( (this.currentFill)[1] ) {
		case 0:
			this.fillStyle = this.fillGradient.getStyle(this.getPen());
			this.setRedraw(true);
			break;
		case 1:
			if(this.fillStyle != this.fillPattern.getStyle(this.getPen())) {
				this.fillStyle = this.fillPattern.getStyle(this.getPen());
				this.setRedraw(true);
			}
			break;
		case 2:
			break;
		}
		switch( (this.currentStroke)[1] ) {
		case 0:
			this.strokeStyle = this.strokeGradient.getStyle(this.getPen());
			this.setRedraw(true);
			break;
		case 1:
			break;
		}
	}
	,fillPatternImageLoaded: function(event) {
		this.currentFill = titanium_reindeer.FillTypes.Pattern;
		if(this.getPen() != null && this.fillStyle != this.fillPattern.getStyle(this.getPen())) {
			this.fillStyle = this.fillPattern.getStyle(this.getPen());
			this.setRedraw(true);
		}
	}
	,preRender: function() {
		titanium_reindeer.RendererComponent.prototype.preRender.call(this);
		this.getPen().fillStyle = this.fillStyle;
		this.getPen().strokeStyle = this.strokeStyle;
		this.getPen().lineWidth = this.lineWidth;
		this.getPen().miterLimit = this.miterLimit;
		switch( (this.lineCap)[1] ) {
		case 0:
			this.getPen().lineCap = "butt";
			break;
		case 1:
			this.getPen().lineCap = "round";
			break;
		case 2:
			this.getPen().lineCap = "square";
			break;
		}
		switch( (this.lineJoin)[1] ) {
		case 0:
			this.getPen().lineJoin = "round";
			break;
		case 1:
			this.getPen().lineJoin = "bevel";
			break;
		case 2:
			this.getPen().lineJoin = "miter";
			break;
		}
	}
	,identify: function() {
		var identifier = "StrokeFill(";
		switch( (this.currentFill)[1] ) {
		case 0:
			identifier += this.fillGradient.identify() + ",";
			break;
		case 1:
			identifier += this.fillPattern.identify() + ",";
			break;
		case 2:
			identifier += this.fillColor.identify() + ",";
			break;
		}
		switch( (this.currentStroke)[1] ) {
		case 0:
			identifier += this.strokeGradient.identify() + ",";
			break;
		case 1:
			identifier += this.strokeColor.identify() + ",";
			break;
		}
		identifier += this.lineWidth + ",";
		identifier += this.lineCap[0] + ",";
		identifier += this.lineJoin[0] + ",";
		identifier += this.miterLimit + ",";
		identifier += ");";
		return titanium_reindeer.RendererComponent.prototype.identify.call(this) + identifier;
	}
	,destroy: function() {
		titanium_reindeer.RendererComponent.prototype.destroy.call(this);
		this.fillStyle = null;
		this.setFill(null);
		this.setFillGradient(null);
		this.setFillPattern(null);
		this.setStrokeColor(null);
		this.setStrokeGradient(null);
	}
	,__class__: titanium_reindeer.StrokeFillRenderer
	,__properties__: $extend(titanium_reindeer.RendererComponent.prototype.__properties__,{set_miterLimit:"setMiterLimit",set_lineJoin:"setLineJoin",set_lineCap:"setLineCap",set_lineWidth:"setLineWidth",set_strokeGradient:"setStrokeGradient",set_strokeColor:"setStrokeColor",set_fillPattern:"setFillPattern",set_fillGradient:"setFillGradient",set_fillColor:"setFill"})
});
titanium_reindeer.CircleRenderer = $hxClasses["titanium_reindeer.CircleRenderer"] = function(radius,layer) {
	titanium_reindeer.StrokeFillRenderer.call(this,radius * 2,radius * 2,layer);
	this.setRadius(radius);
};
titanium_reindeer.CircleRenderer.__name__ = ["titanium_reindeer","CircleRenderer"];
titanium_reindeer.CircleRenderer.__super__ = titanium_reindeer.StrokeFillRenderer;
titanium_reindeer.CircleRenderer.prototype = $extend(titanium_reindeer.StrokeFillRenderer.prototype,{
	radius: null
	,setRadius: function(value) {
		if(this.radius != value) {
			this.radius = value;
			this.setInitialWidth(value * 2);
			this.setInitialHeight(value * 2);
		}
		return this.radius;
	}
	,render: function() {
		titanium_reindeer.StrokeFillRenderer.prototype.render.call(this);
		this.getPen().beginPath();
		this.getPen().arc(0,0,this.radius,0,Math.PI * 2,false);
		this.getPen().fill();
		this.getPen().closePath();
		if(this.lineWidth > 0) {
			this.getPen().beginPath();
			this.getPen().arc(0,0,this.radius - this.lineWidth / 2,0,Math.PI * 2,false);
			this.getPen().stroke();
			this.getPen().closePath();
		}
	}
	,identify: function() {
		return titanium_reindeer.StrokeFillRenderer.prototype.identify.call(this) + "Circle(" + this.radius + ");";
	}
	,__class__: titanium_reindeer.CircleRenderer
	,__properties__: $extend(titanium_reindeer.StrokeFillRenderer.prototype.__properties__,{set_radius:"setRadius"})
});
titanium_reindeer.CollisionComponent = $hxClasses["titanium_reindeer.CollisionComponent"] = function(width,height,layer,group) {
	titanium_reindeer.Component.call(this);
	this.setWidth(width);
	this.setHeight(height);
	this.watchedOffset = new titanium_reindeer.WatchedVector2(0,0,this.offsetChanged.$bind(this));
	this.layerName = layer;
	this.groupName = group;
	this.allowUpdateBounds = true;
	this.registeredCallbacks = new Array();
};
titanium_reindeer.CollisionComponent.__name__ = ["titanium_reindeer","CollisionComponent"];
titanium_reindeer.CollisionComponent.__super__ = titanium_reindeer.Component;
titanium_reindeer.CollisionComponent.prototype = $extend(titanium_reindeer.Component.prototype,{
	collisionManager: null
	,getCollisionManager: function() {
		if(this.manager == null) return null; else return (function($this) {
			var $r;
			var $t = $this.manager;
			if(Std["is"]($t,titanium_reindeer.CollisionComponentManager)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
	}
	,minBoundingRect: null
	,getMinBoundingRect: function() {
		return this.minBoundingRect.getCopy();
	}
	,width: null
	,setWidth: function(value) {
		this.width = value;
		this.updateBounds();
		return this.width;
	}
	,height: null
	,setHeight: function(value) {
		this.height = value;
		this.updateBounds();
		return this.height;
	}
	,watchedOffset: null
	,offset: null
	,getOffset: function() {
		return this.watchedOffset;
	}
	,setOffset: function(value) {
		if(value != null) {
			if(this.watchedOffset != value && !this.watchedOffset.equal(value)) {
				this.watchedOffset.setVector2(value);
				this.updateBounds();
			}
		}
		return this.getOffset();
	}
	,allowUpdateBounds: null
	,getCenter: function() {
		return this.owner.getPosition().add(this.getOffset());
	}
	,layerName: null
	,groupName: null
	,registeredCallbacks: null
	,collide: function(otherCompId) {
		var otherComp = this.getCollisionManager().getComponent(otherCompId);
		if(otherComp == null) return;
		var _g = 0, _g1 = this.registeredCallbacks;
		while(_g < _g1.length) {
			var func = _g1[_g];
			++_g;
			func(otherComp);
		}
	}
	,registerCallback: function(func) {
		if(func != null) this.registeredCallbacks.push(func);
	}
	,unregisterCallback: function(func) {
		if(func == null) return;
		var _g1 = 0, _g = this.registeredCallbacks.length;
		while(_g1 < _g) {
			var i = _g1++;
			while(i < this.registeredCallbacks.length) if(Reflect.compareMethods(this.registeredCallbacks[i],func)) this.registeredCallbacks.splice(i,1); else break;
		}
	}
	,getShape: function() {
		return this.getMinBoundingRect();
	}
	,isPointIntersecting: function(point) {
		return this.getShape().isPointInside(point);
	}
	,setOwner: function(gameObject) {
		titanium_reindeer.Component.prototype.setOwner.call(this,gameObject);
		this.updateBounds();
	}
	,getManagerType: function() {
		return titanium_reindeer.CollisionComponentManager;
	}
	,initialize: function() {
		var layer = this.getCollisionManager().getLayer(this.layerName);
		layer.addComponent(this);
	}
	,notifyPositionChange: function() {
		this.updateBounds();
	}
	,offsetChanged: function() {
		this.updateBounds();
	}
	,updateBounds: function() {
		if(!this.allowUpdateBounds) return;
		if(this.owner != null) {
			var center = this.getCenter();
			this.minBoundingRect = new titanium_reindeer.Rect(center.getX() - this.width / 2,center.getY() - this.height / 2,this.width,this.height);
		}
		if(this.getCollisionManager() != null) {
			var layer = this.getCollisionManager().getLayer(this.layerName);
			layer.updateComponent(this);
		}
	}
	,destroy: function() {
		titanium_reindeer.Component.prototype.destroy.call(this);
	}
	,__class__: titanium_reindeer.CollisionComponent
	,__properties__: $extend(titanium_reindeer.Component.prototype.__properties__,{set_offset:"setOffset",get_offset:"getOffset",set_height:"setHeight",set_width:"setWidth",get_collisionManager:"getCollisionManager"})
});
titanium_reindeer.CollisionCircle = $hxClasses["titanium_reindeer.CollisionCircle"] = function(radius,layer,group) {
	titanium_reindeer.CollisionComponent.call(this,radius * 2,radius * 2,layer,group);
	this.setRadius(radius);
};
titanium_reindeer.CollisionCircle.__name__ = ["titanium_reindeer","CollisionCircle"];
titanium_reindeer.CollisionCircle.__super__ = titanium_reindeer.CollisionComponent;
titanium_reindeer.CollisionCircle.prototype = $extend(titanium_reindeer.CollisionComponent.prototype,{
	radius: null
	,setRadius: function(value) {
		if(this.radius != value) {
			this.radius = value;
			this.allowUpdateBounds = false;
			this.setWidth(value * 2);
			this.setHeight(value * 2);
			this.allowUpdateBounds = true;
			this.updateBounds();
		}
		return this.radius;
	}
	,collide: function(otherCompId) {
		var otherComp = this.getCollisionManager().getComponent(otherCompId);
		if(otherComp == null) return;
		if(Std["is"](otherComp,titanium_reindeer.CollisionCircle)) {
			var circleComp = (function($this) {
				var $r;
				var $t = otherComp;
				if(Std["is"]($t,titanium_reindeer.CollisionCircle)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this));
			if(titanium_reindeer.Circle.isIntersecting(new titanium_reindeer.Circle(this.radius,this.getCenter()),new titanium_reindeer.Circle(circleComp.radius,circleComp.getCenter()))) titanium_reindeer.CollisionComponent.prototype.collide.call(this,otherCompId);
		} else if(Std["is"](otherComp,titanium_reindeer.CollisionRect)) {
			var rectComp = (function($this) {
				var $r;
				var $t = otherComp;
				if(Std["is"]($t,titanium_reindeer.CollisionRect)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this));
			if(titanium_reindeer.Geometry.isCircleIntersectingRect(new titanium_reindeer.Circle(this.radius,this.getCenter()),rectComp.getMinBoundingRect())) titanium_reindeer.CollisionComponent.prototype.collide.call(this,otherCompId);
		}
	}
	,getShape: function() {
		return new titanium_reindeer.Circle(this.radius,this.getCenter());
	}
	,__class__: titanium_reindeer.CollisionCircle
	,__properties__: $extend(titanium_reindeer.CollisionComponent.prototype.__properties__,{set_radius:"setRadius"})
});
titanium_reindeer.ComponentManager = $hxClasses["titanium_reindeer.ComponentManager"] = function(scene) {
	titanium_reindeer.ObjectManager.call(this);
	this.scene = scene;
	this.componentsChanged = true;
};
titanium_reindeer.ComponentManager.__name__ = ["titanium_reindeer","ComponentManager"];
titanium_reindeer.ComponentManager.__super__ = titanium_reindeer.ObjectManager;
titanium_reindeer.ComponentManager.prototype = $extend(titanium_reindeer.ObjectManager.prototype,{
	scene: null
	,components: null
	,getComponents: function() {
		if(this.componentsChanged) {
			this.components = new Array();
			var $it0 = this.objects.iterator();
			while( $it0.hasNext() ) {
				var obj = $it0.next();
				this.components.push((function($this) {
					var $r;
					var $t = obj;
					if(Std["is"]($t,titanium_reindeer.Component)) $t; else throw "Class cast error";
					$r = $t;
					return $r;
				}(this)));
			}
			this.componentsChanged = false;
		}
		return this.components;
	}
	,componentsChanged: null
	,preUpdate: function(msTimeStep) {
	}
	,update: function(msTimeStep) {
	}
	,postUpdate: function(msTimeStep) {
	}
	,addComponent: function(component) {
		titanium_reindeer.ObjectManager.prototype.addObject.call(this,component);
		this.componentsChanged = true;
	}
	,removeComponent: function(component) {
		titanium_reindeer.ObjectManager.prototype.removeObject.call(this,component);
		this.componentsChanged = true;
	}
	,removeComponents: function() {
		titanium_reindeer.ObjectManager.prototype.removeObjects.call(this);
		this.componentsChanged = true;
	}
	,finalDestroy: function() {
		titanium_reindeer.ObjectManager.prototype.finalDestroy.call(this);
		this.components = null;
		this.scene = null;
	}
	,__class__: titanium_reindeer.ComponentManager
	,__properties__: {get_components:"getComponents"}
});
titanium_reindeer.CollisionComponentManager = $hxClasses["titanium_reindeer.CollisionComponentManager"] = function(scene) {
	titanium_reindeer.ComponentManager.call(this,scene);
	this.collisionLayers = new Hash();
	this.mouseRegionManager = new titanium_reindeer.MouseRegionManager(this);
};
titanium_reindeer.CollisionComponentManager.__name__ = ["titanium_reindeer","CollisionComponentManager"];
titanium_reindeer.CollisionComponentManager.__super__ = titanium_reindeer.ComponentManager;
titanium_reindeer.CollisionComponentManager.prototype = $extend(titanium_reindeer.ComponentManager.prototype,{
	collisionLayers: null
	,mouseRegionManager: null
	,getLayer: function(layerName) {
		if(this.collisionLayers.exists(layerName)) return this.collisionLayers.get(layerName); else {
			var layer = new titanium_reindeer.CollisionLayer(this,layerName);
			this.collisionLayers.set(layerName,layer);
			return layer;
		}
	}
	,getComponent: function(id) {
		return (function($this) {
			var $r;
			var $t = titanium_reindeer.ComponentManager.prototype.getObject.call($this,id);
			if(Std["is"]($t,titanium_reindeer.CollisionComponent)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
	}
	,removeComponent: function(component) {
		var collisionComp = (function($this) {
			var $r;
			var $t = component;
			if(Std["is"]($t,titanium_reindeer.CollisionComponent)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
		this.getLayer(collisionComp.layerName).removeComponent(collisionComp);
	}
	,update: function(msTimeStep) {
		var $it0 = this.collisionLayers.iterator();
		while( $it0.hasNext() ) {
			var layer = $it0.next();
			layer.update();
		}
	}
	,removeComponents: function() {
		this.mouseRegionManager.removeHandlers();
	}
	,finalDestroy: function() {
		this.mouseRegionManager.destroy();
		this.mouseRegionManager = null;
		var $it0 = this.collisionLayers.keys();
		while( $it0.hasNext() ) {
			var layerName = $it0.next();
			this.collisionLayers.get(layerName).destroy();
			this.collisionLayers.remove(layerName);
		}
		titanium_reindeer.ComponentManager.prototype.finalDestroy.call(this);
	}
	,__class__: titanium_reindeer.CollisionComponentManager
});
titanium_reindeer.CollisionGroup = $hxClasses["titanium_reindeer.CollisionGroup"] = function(name,layer) {
	this.name = name;
	this.layer = layer;
	this.members = new IntHash();
	this.mCollidingGroups = new Hash();
};
titanium_reindeer.CollisionGroup.__name__ = ["titanium_reindeer","CollisionGroup"];
titanium_reindeer.CollisionGroup.prototype = {
	name: null
	,layer: null
	,members: null
	,mCollidingGroups: null
	,collidingGroups: null
	,getCollidingGroups: function() {
		var groups = new Hash();
		var $it0 = this.mCollidingGroups.iterator();
		while( $it0.hasNext() ) {
			var group = $it0.next();
			groups.set(group.name,group);
		}
		return groups;
	}
	,addCollidingGroup: function(collidingGroupName) {
		var collidingGroup = this.layer.getGroup(collidingGroupName);
		this.mCollidingGroups.set(collidingGroupName,collidingGroup);
	}
	,removeCollidingGroup: function(collidingGroupName) {
		var collidingGroup = this.layer.getGroup(collidingGroupName);
		if(this.mCollidingGroups.exists(collidingGroupName)) this.mCollidingGroups.remove(collidingGroupName);
	}
	,addAllCollidingGroups: function() {
		var $it0 = this.layer.groups.iterator();
		while( $it0.hasNext() ) {
			var group = $it0.next();
			if(!this.mCollidingGroups.exists(group.name)) this.mCollidingGroups.set(group.name,group);
		}
	}
	,clearCollidingGroups: function() {
		this.mCollidingGroups = new Hash();
	}
	,destroy: function() {
		var $it0 = this.members.keys();
		while( $it0.hasNext() ) {
			var id = $it0.next();
			this.members.remove(id);
		}
		var $it1 = this.mCollidingGroups.keys();
		while( $it1.hasNext() ) {
			var groupName = $it1.next();
			this.mCollidingGroups.remove(groupName);
		}
	}
	,__class__: titanium_reindeer.CollisionGroup
	,__properties__: {get_collidingGroups:"getCollidingGroups"}
}
titanium_reindeer.CollisionLayer = $hxClasses["titanium_reindeer.CollisionLayer"] = function(manager,name) {
	this.manager = manager;
	this.name = name;
	this.componentsPartition = new titanium_reindeer.BinPartition(10,new titanium_reindeer.Vector2(-20,-20),100,100);
	this.groups = new Hash();
	this.debugView = false;
};
titanium_reindeer.CollisionLayer.__name__ = ["titanium_reindeer","CollisionLayer"];
titanium_reindeer.CollisionLayer.prototype = {
	manager: null
	,name: null
	,componentsPartition: null
	,groups: null
	,debugView: null
	,getGroup: function(groupName) {
		if(this.groups.exists(groupName)) return this.groups.get(groupName); else {
			var group = new titanium_reindeer.CollisionGroup(groupName,this);
			this.groups.set(groupName,group);
			return group;
		}
	}
	,getIdsIntersectingPoint: function(point) {
		var ids = this.componentsPartition.getPointIntersectingValues(point);
		var collidingIds = new Array();
		var _g = 0;
		while(_g < ids.length) {
			var id = ids[_g];
			++_g;
			var component = this.manager.getComponent(id);
			if(component != null && component.isPointIntersecting(point)) collidingIds.push(id);
		}
		return collidingIds;
	}
	,addComponent: function(component) {
		var group = this.getGroup(component.groupName);
		if(group.members.exists(component.id)) haxe.Log.trace("---ERROR---: component id " + component.id + " already exists in group " + component.groupName + "!",{ fileName : "CollisionLayer.hx", lineNumber : 83, className : "titanium_reindeer.CollisionLayer", methodName : "addComponent"}); else {
			group.members.set(component.id,component);
			this.componentsPartition.insert(component.getMinBoundingRect(),component.id);
		}
	}
	,updateComponent: function(component) {
		this.componentsPartition.update(component.getMinBoundingRect(),component.id);
	}
	,removeComponent: function(component) {
		var group = this.getGroup(component.groupName);
		group.members.remove(component.id);
		this.componentsPartition.remove(component.id);
	}
	,enableDebugView: function(debugCanvas,debugOffset) {
		this.debugView = true;
		this.componentsPartition.debugCanvas = debugCanvas;
		this.componentsPartition.debugOffset = debugOffset;
	}
	,update: function() {
		var $it0 = this.groups.iterator();
		while( $it0.hasNext() ) {
			var group = $it0.next();
			var $it1 = group.members.iterator();
			while( $it1.hasNext() ) {
				var component = $it1.next();
				var collidingIds = this.componentsPartition.getRectIntersectingValues(component.getMinBoundingRect());
				var _g = 0;
				while(_g < collidingIds.length) {
					var id = collidingIds[_g];
					++_g;
					if(id == component.id) continue;
					var found = false;
					var $it2 = group.getCollidingGroups().iterator();
					while( $it2.hasNext() ) {
						var collidingGroup = $it2.next();
						if(collidingGroup.members.exists(id)) {
							found = true;
							break;
						}
					}
					if(found) component.collide(id);
				}
			}
		}
		if(this.debugView) this.componentsPartition.drawDebug();
	}
	,destroy: function() {
		var $it0 = this.groups.keys();
		while( $it0.hasNext() ) {
			var groupName = $it0.next();
			this.groups.get(groupName).destroy();
			this.groups.remove(groupName);
		}
		this.groups = null;
		this.manager = null;
	}
	,__class__: titanium_reindeer.CollisionLayer
}
titanium_reindeer.CollisionRect = $hxClasses["titanium_reindeer.CollisionRect"] = function(width,height,layer,group) {
	titanium_reindeer.CollisionComponent.call(this,width,height,layer,group);
};
titanium_reindeer.CollisionRect.__name__ = ["titanium_reindeer","CollisionRect"];
titanium_reindeer.CollisionRect.__super__ = titanium_reindeer.CollisionComponent;
titanium_reindeer.CollisionRect.prototype = $extend(titanium_reindeer.CollisionComponent.prototype,{
	collide: function(otherCompId) {
		var otherComp = this.getCollisionManager().getComponent(otherCompId);
		if(otherComp == null) return;
		if(Std["is"](otherComp,titanium_reindeer.CollisionRect)) titanium_reindeer.CollisionComponent.prototype.collide.call(this,otherCompId); else if(Std["is"](otherComp,titanium_reindeer.CollisionCircle)) {
			var circleComp = (function($this) {
				var $r;
				var $t = otherComp;
				if(Std["is"]($t,titanium_reindeer.CollisionCircle)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this));
			if(titanium_reindeer.Geometry.isCircleIntersectingRect(new titanium_reindeer.Circle(circleComp.radius,circleComp.getCenter()),this.getMinBoundingRect())) titanium_reindeer.CollisionComponent.prototype.collide.call(this,otherCompId);
		}
	}
	,__class__: titanium_reindeer.CollisionRect
});
titanium_reindeer.Color = $hxClasses["titanium_reindeer.Color"] = function(red,green,blue,alpha) {
	if(alpha == null) alpha = 1;
	this.red = (function($this) {
		var $r;
		var $t = Math.max(0,Math.min(red,255));
		if(Std["is"]($t,Int)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	this.green = (function($this) {
		var $r;
		var $t = Math.max(0,Math.min(green,255));
		if(Std["is"]($t,Int)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	this.blue = (function($this) {
		var $r;
		var $t = Math.max(0,Math.min(blue,255));
		if(Std["is"]($t,Int)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	this.alpha = Math.max(0,Math.min(alpha,1));
};
titanium_reindeer.Color.__name__ = ["titanium_reindeer","Color"];
titanium_reindeer.Color.__properties__ = {get_Clear:"getClearConst",get_Grey:"getGreyConst",get_Black:"getBlackConst",get_White:"getWhiteConst",get_Purple:"getPurpleConst",get_Blue:"getBlueConst",get_Green:"getGreenConst",get_Yellow:"getYellowConst",get_Orange:"getOrangeConst",get_Red:"getRedConst"}
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
titanium_reindeer.Color.prototype = {
	red: null
	,green: null
	,blue: null
	,alpha: null
	,rgba: null
	,getRgba: function() {
		return "rgba(" + this.red + "," + this.green + "," + this.blue + "," + this.alpha + ")";
	}
	,equal: function(other) {
		return this.red == other.red && this.green == other.green && this.blue == other.blue && this.alpha == other.alpha;
	}
	,getCopy: function() {
		return new titanium_reindeer.Color(this.red,this.green,this.blue,this.alpha);
	}
	,identify: function() {
		return "Color(" + this.red + "," + this.green + "," + this.blue + "," + this.alpha + ");";
	}
	,getMultiplied: function(n) {
		return new titanium_reindeer.Color(this.red * n | 0,this.green * n | 0,this.blue * n | 0);
	}
	,multiply: function(n) {
		this.red = this.red * n | 0;
		this.green = this.green * n | 0;
		this.blue = this.blue * n | 0;
	}
	,__class__: titanium_reindeer.Color
	,__properties__: {get_rgba:"getRgba"}
}
titanium_reindeer.ColorStop = $hxClasses["titanium_reindeer.ColorStop"] = function(color,offset) {
	this.color = color;
	this.offset = offset;
};
titanium_reindeer.ColorStop.__name__ = ["titanium_reindeer","ColorStop"];
titanium_reindeer.ColorStop.prototype = {
	color: null
	,offset: null
	,identify: function() {
		return "ColorStop(" + this.color.identify() + "," + this.offset + ");";
	}
	,__class__: titanium_reindeer.ColorStop
}
titanium_reindeer.CursorType = $hxClasses["titanium_reindeer.CursorType"] = { __ename__ : ["titanium_reindeer","CursorType"], __constructs__ : ["AllScroll","ColResize","CrossHair","Custom","Default","EResize","Help","Move","NEResize","NoDrop","None","NotAllowed","NResize","NWResize","Pointer","Progress","RowResize","SEResize","SResize","SWResize","Text","VerticalText","Wait","WResize"] }
titanium_reindeer.CursorType.AllScroll = ["AllScroll",0];
titanium_reindeer.CursorType.AllScroll.toString = $estr;
titanium_reindeer.CursorType.AllScroll.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.ColResize = ["ColResize",1];
titanium_reindeer.CursorType.ColResize.toString = $estr;
titanium_reindeer.CursorType.ColResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.CrossHair = ["CrossHair",2];
titanium_reindeer.CursorType.CrossHair.toString = $estr;
titanium_reindeer.CursorType.CrossHair.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Custom = ["Custom",3];
titanium_reindeer.CursorType.Custom.toString = $estr;
titanium_reindeer.CursorType.Custom.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Default = ["Default",4];
titanium_reindeer.CursorType.Default.toString = $estr;
titanium_reindeer.CursorType.Default.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.EResize = ["EResize",5];
titanium_reindeer.CursorType.EResize.toString = $estr;
titanium_reindeer.CursorType.EResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Help = ["Help",6];
titanium_reindeer.CursorType.Help.toString = $estr;
titanium_reindeer.CursorType.Help.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Move = ["Move",7];
titanium_reindeer.CursorType.Move.toString = $estr;
titanium_reindeer.CursorType.Move.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.NEResize = ["NEResize",8];
titanium_reindeer.CursorType.NEResize.toString = $estr;
titanium_reindeer.CursorType.NEResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.NoDrop = ["NoDrop",9];
titanium_reindeer.CursorType.NoDrop.toString = $estr;
titanium_reindeer.CursorType.NoDrop.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.None = ["None",10];
titanium_reindeer.CursorType.None.toString = $estr;
titanium_reindeer.CursorType.None.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.NotAllowed = ["NotAllowed",11];
titanium_reindeer.CursorType.NotAllowed.toString = $estr;
titanium_reindeer.CursorType.NotAllowed.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.NResize = ["NResize",12];
titanium_reindeer.CursorType.NResize.toString = $estr;
titanium_reindeer.CursorType.NResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.NWResize = ["NWResize",13];
titanium_reindeer.CursorType.NWResize.toString = $estr;
titanium_reindeer.CursorType.NWResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Pointer = ["Pointer",14];
titanium_reindeer.CursorType.Pointer.toString = $estr;
titanium_reindeer.CursorType.Pointer.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Progress = ["Progress",15];
titanium_reindeer.CursorType.Progress.toString = $estr;
titanium_reindeer.CursorType.Progress.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.RowResize = ["RowResize",16];
titanium_reindeer.CursorType.RowResize.toString = $estr;
titanium_reindeer.CursorType.RowResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.SEResize = ["SEResize",17];
titanium_reindeer.CursorType.SEResize.toString = $estr;
titanium_reindeer.CursorType.SEResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.SResize = ["SResize",18];
titanium_reindeer.CursorType.SResize.toString = $estr;
titanium_reindeer.CursorType.SResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.SWResize = ["SWResize",19];
titanium_reindeer.CursorType.SWResize.toString = $estr;
titanium_reindeer.CursorType.SWResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Text = ["Text",20];
titanium_reindeer.CursorType.Text.toString = $estr;
titanium_reindeer.CursorType.Text.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.VerticalText = ["VerticalText",21];
titanium_reindeer.CursorType.VerticalText.toString = $estr;
titanium_reindeer.CursorType.VerticalText.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.Wait = ["Wait",22];
titanium_reindeer.CursorType.Wait.toString = $estr;
titanium_reindeer.CursorType.Wait.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.CursorType.WResize = ["WResize",23];
titanium_reindeer.CursorType.WResize.toString = $estr;
titanium_reindeer.CursorType.WResize.__enum__ = titanium_reindeer.CursorType;
titanium_reindeer.Cursor = $hxClasses["titanium_reindeer.Cursor"] = function(targetElement) {
	this.targetElement = targetElement;
	this.setCursorType(titanium_reindeer.CursorType.Default);
};
titanium_reindeer.Cursor.__name__ = ["titanium_reindeer","Cursor"];
titanium_reindeer.Cursor.prototype = {
	cursorType: null
	,setCursorType: function(value) {
		if(value != this.cursorType) {
			this.cursorType = value;
			if(this.cursorType != titanium_reindeer.CursorType.Custom) this.setCustomUrl("");
			this.targetElement.style.cursor = this.getCursorTypeValue(this.cursorType);
		}
		return this.cursorType;
	}
	,customUrl: null
	,setCustomUrl: function(value) {
		if(value != this.customUrl) {
			this.customUrl = value;
			if(this.customUrl != "") this.setCursorType(titanium_reindeer.CursorType.Custom);
		}
		return this.customUrl;
	}
	,targetElement: null
	,getCursorTypeValue: function(cursorType) {
		var value = "";
		switch( (cursorType)[1] ) {
		case 0:
			value = "all-scroll";
			break;
		case 1:
			value = "col-resize";
			break;
		case 2:
			value = "crosshair";
			break;
		case 4:
			value = "default";
			break;
		case 5:
			value = "E-resize";
			break;
		case 6:
			value = "help";
			break;
		case 7:
			value = "move";
			break;
		case 8:
			value = "NE-resize";
			break;
		case 9:
			value = "no-drop";
			break;
		case 10:
			value = "none";
			break;
		case 11:
			value = "not-allowed";
			break;
		case 12:
			value = "N-resize";
			break;
		case 13:
			value = "NW-resize";
			break;
		case 14:
			value = "pointer";
			break;
		case 15:
			value = "progress";
			break;
		case 16:
			value = "row-resize";
			break;
		case 17:
			value = "SE-resize";
			break;
		case 18:
			value = "S-resize";
			break;
		case 19:
			value = "sw-resize";
			break;
		case 20:
			value = "text";
			break;
		case 21:
			value = "vertical-text";
			break;
		case 22:
			value = "wait";
			break;
		case 23:
			value = "W-resize";
			break;
		case 3:
			var curReplaceReg = new EReg("\\..*$","");
			var customCur = curReplaceReg.replace(this.customUrl,".cur");
			value = "url(" + this.customUrl + "), url(" + customCur + "), auto";
			break;
		}
		return value;
	}
	,__class__: titanium_reindeer.Cursor
	,__properties__: {set_customUrl:"setCustomUrl",set_cursorType:"setCursorType"}
}
titanium_reindeer.MouseButton = $hxClasses["titanium_reindeer.MouseButton"] = { __ename__ : ["titanium_reindeer","MouseButton"], __constructs__ : ["Left","Right","Middle","None"] }
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
titanium_reindeer.MouseButtonState = $hxClasses["titanium_reindeer.MouseButtonState"] = { __ename__ : ["titanium_reindeer","MouseButtonState"], __constructs__ : ["Down","Held","Up"] }
titanium_reindeer.MouseButtonState.Down = ["Down",0];
titanium_reindeer.MouseButtonState.Down.toString = $estr;
titanium_reindeer.MouseButtonState.Down.__enum__ = titanium_reindeer.MouseButtonState;
titanium_reindeer.MouseButtonState.Held = ["Held",1];
titanium_reindeer.MouseButtonState.Held.toString = $estr;
titanium_reindeer.MouseButtonState.Held.__enum__ = titanium_reindeer.MouseButtonState;
titanium_reindeer.MouseButtonState.Up = ["Up",2];
titanium_reindeer.MouseButtonState.Up.toString = $estr;
titanium_reindeer.MouseButtonState.Up.__enum__ = titanium_reindeer.MouseButtonState;
titanium_reindeer.Key = $hxClasses["titanium_reindeer.Key"] = { __ename__ : ["titanium_reindeer","Key"], __constructs__ : ["Esc","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","Tilde","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Zero","Dash","Equals","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","SemiColon","Quote","Comma","Period","BackSlash","Slash","LeftBracket","RightBracket","Tab","CapsLock","Ctrl","Alt","Shift","Space","Enter","BackSpace","UpArrow","RightArrow","DownArrow","LeftArrow","Insert","Delete","Home","End","PageUp","PageDown","NumLock","NumSlash","NumAsterick","NumDash","NumPlus","NumOne","NumTwo","NumThree","NumFour","NumFive","NumSix","NumSeven","NumEight","NumNine","NumZero","None"] }
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
titanium_reindeer.KeyState = $hxClasses["titanium_reindeer.KeyState"] = { __ename__ : ["titanium_reindeer","KeyState"], __constructs__ : ["Down","Held","Up"] }
titanium_reindeer.KeyState.Down = ["Down",0];
titanium_reindeer.KeyState.Down.toString = $estr;
titanium_reindeer.KeyState.Down.__enum__ = titanium_reindeer.KeyState;
titanium_reindeer.KeyState.Held = ["Held",1];
titanium_reindeer.KeyState.Held.toString = $estr;
titanium_reindeer.KeyState.Held.__enum__ = titanium_reindeer.KeyState;
titanium_reindeer.KeyState.Up = ["Up",2];
titanium_reindeer.KeyState.Up.toString = $estr;
titanium_reindeer.KeyState.Up.__enum__ = titanium_reindeer.KeyState;
titanium_reindeer.InputEvent = $hxClasses["titanium_reindeer.InputEvent"] = { __ename__ : ["titanium_reindeer","InputEvent"], __constructs__ : ["MouseDown","MouseUp","MouseMove","MouseWheel","KeyUp","KeyDown","MouseHeldEvent","KeyHeldEvent","MouseAnyEvent","KeyAnyEvent"] }
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
titanium_reindeer.Composition = $hxClasses["titanium_reindeer.Composition"] = { __ename__ : ["titanium_reindeer","Composition"], __constructs__ : ["SourceAtop","SourceIn","SourceOut","SourceOver","DestinationAtop","DestinationIn","DestinationOut","DestinationOver","Lighter","Copy","Xor"] }
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
titanium_reindeer.InputManager = $hxClasses["titanium_reindeer.InputManager"] = function() {
	this.mouseButtonsRegistered = new IntHash();
	this.mouseButtonsRegistered.set(0,new IntHash());
	this.mouseButtonsRegistered.set(1,new IntHash());
	this.mouseButtonsRegistered.set(2,new IntHash());
	this.mouseButtonsAnyRegistered = new Array();
	this.mouseWheelsRegistered = new Array();
	this.mousePositionChangesRegistered = new Array();
	this.mouseButtonsHeld = new IntHash();
	this.lastMousePos = new titanium_reindeer.Vector2(0,0);
	this.keysRegistered = new IntHash();
	this.keysRegistered.set(0,new IntHash());
	this.keysRegistered.set(1,new IntHash());
	this.keysRegistered.set(2,new IntHash());
	this.keysAnyRegistered = new Array();
	this.heldKeys = new IntHash();
	this.recordedEvents = new Array();
	this.queuedMouseButtonRegisters = new Array();
	this.queuedMouseMoveRegisters = new Array();
	this.queuedMouseWheelRegisters = new Array();
	this.queuedMouseButtonAnyRegisters = new Array();
	this.queuedKeyRegisters = new Array();
	this.queuedKeyAnyRegisters = new Array();
	this.queuedMouseButtonUnregisters = new Array();
	this.queuedMouseMoveUnregisters = new Array();
	this.queuedMouseWheelUnregisters = new Array();
	this.queuedMouseButtonAnyUnregisters = new Array();
	this.queuedKeyUnregisters = new Array();
	this.queuedKeyAnyUnregisters = new Array();
	this.queueRegisters = false;
	this.targetDocumentOffset = new titanium_reindeer.Vector2(0,0);
};
titanium_reindeer.InputManager.__name__ = ["titanium_reindeer","InputManager"];
titanium_reindeer.InputManager.prototype = {
	mouseButtonsRegistered: null
	,downMouseButtonsRegistered: null
	,getDownMouseButtonsRegistered: function() {
		return this.mouseButtonsRegistered.get(0);
	}
	,heldMouseButtonsRegistered: null
	,getHeldMouseButtonsRegistered: function() {
		return this.mouseButtonsRegistered.get(1);
	}
	,upMouseButtonsRegistered: null
	,getUpMouseButtonsRegistered: function() {
		return this.mouseButtonsRegistered.get(2);
	}
	,mouseButtonsAnyRegistered: null
	,mouseWheelsRegistered: null
	,mousePositionChangesRegistered: null
	,mouseButtonsHeld: null
	,lastMousePos: null
	,mousePosition: null
	,getMousePos: function() {
		return this.lastMousePos.getCopy();
	}
	,keysRegistered: null
	,downKeysRegistered: null
	,getDownKeysRegistered: function() {
		return this.keysRegistered.get(0);
	}
	,heldKeysRegistered: null
	,getHeldKeysRegistered: function() {
		return this.keysRegistered.get(1);
	}
	,upKeysRegistered: null
	,getUpKeysRegistered: function() {
		return this.keysRegistered.get(2);
	}
	,keysAnyRegistered: null
	,heldKeys: null
	,recordedEvents: null
	,queuedMouseButtonRegisters: null
	,queuedMouseMoveRegisters: null
	,queuedMouseWheelRegisters: null
	,queuedMouseButtonAnyRegisters: null
	,queuedKeyRegisters: null
	,queuedKeyAnyRegisters: null
	,queuedMouseButtonUnregisters: null
	,queuedMouseMoveUnregisters: null
	,queuedMouseWheelUnregisters: null
	,queuedMouseButtonAnyUnregisters: null
	,queuedKeyUnregisters: null
	,queuedKeyAnyUnregisters: null
	,queueRegisters: null
	,targetDocumentOffset: null
	,receiveEvent: function(recordedEvent) {
		var func;
		switch( (recordedEvent.type)[1] ) {
		case 0:
			func = this.mouseDown.$bind(this);
			break;
		case 1:
			func = this.mouseUp.$bind(this);
			break;
		case 2:
			func = this.mouseMove.$bind(this);
			break;
		case 3:
			func = this.mouseWheel.$bind(this);
			break;
		case 5:
			func = this.keyDown.$bind(this);
			break;
		case 4:
			func = this.keyUp.$bind(this);
			break;
		default:
			func = null;
		}
		func(recordedEvent.event);
	}
	,mouseDown: function(event) {
		var mousePos = this.getMousePositionFromEvent(event);
		var mouseButton = this.getMouseButtonFromButton(event.button);
		this.mouseButtonsHeld.set(mouseButton[1],mouseButton);
		var _g = 0, _g1 = this.mouseButtonsAnyRegistered;
		while(_g < _g1.length) {
			var cb = _g1[_g];
			++_g;
			if(cb != null) cb(mouseButton,titanium_reindeer.MouseButtonState.Down,mousePos.getCopy());
		}
		if(this.getDownMouseButtonsRegistered().exists(mouseButton[1])) {
			var functions = this.getDownMouseButtonsRegistered().get(mouseButton[1]);
			var _g = 0;
			while(_g < functions.length) {
				var cb = functions[_g];
				++_g;
				if(cb != null) cb(mousePos.getCopy());
			}
		}
	}
	,mouseUp: function(event) {
		var mousePos = this.getMousePositionFromEvent(event);
		var mouseButton = this.getMouseButtonFromButton(event.button);
		this.mouseButtonsHeld.remove(mouseButton[1]);
		var _g = 0, _g1 = this.mouseButtonsAnyRegistered;
		while(_g < _g1.length) {
			var cb = _g1[_g];
			++_g;
			if(cb != null) cb(mouseButton,titanium_reindeer.MouseButtonState.Up,mousePos.getCopy());
		}
		if(this.getUpMouseButtonsRegistered().exists(mouseButton[1])) {
			var functions = this.getUpMouseButtonsRegistered().get(mouseButton[1]);
			var _g = 0;
			while(_g < functions.length) {
				var cb = functions[_g];
				++_g;
				if(cb != null) cb(mousePos.getCopy());
			}
		}
	}
	,mouseMove: function(event) {
		var mousePos = this.getMousePositionFromEvent(event);
		var _g = 0, _g1 = this.mousePositionChangesRegistered;
		while(_g < _g1.length) {
			var cb = _g1[_g];
			++_g;
			if(cb != null) cb(mousePos.getCopy());
		}
		this.lastMousePos = mousePos;
	}
	,mouseWheel: function(event) {
		var ticks = 0;
		var firefoxReg = new EReg("Firefox","i");
		if(firefoxReg.match(js.Lib.window.navigator.userAgent)) ticks = event.detail; else ticks = Math.round(event.wheelDelta / 120);
		var _g = 0, _g1 = this.mouseWheelsRegistered;
		while(_g < _g1.length) {
			var cb = _g1[_g];
			++_g;
			if(cb != null) cb(ticks);
		}
	}
	,keyDown: function(event) {
		var keyCode = event.keyCode;
		var key = this.getKeyFromCode(keyCode);
		this.heldKeys.set(key[1],key);
		if(this.getDownKeysRegistered().exists(key[1])) {
			var functions = this.getDownKeysRegistered().get(key[1]);
			var _g = 0;
			while(_g < functions.length) {
				var cb = functions[_g];
				++_g;
				if(cb != null) cb();
			}
		}
	}
	,keyUp: function(event) {
		var keyCode = event.keyCode;
		var key = this.getKeyFromCode(keyCode);
		this.heldKeys.remove(key[1]);
		if(this.getUpKeysRegistered().exists(key[1])) {
			var functions = this.getUpKeysRegistered().get(key[1]);
			var _g = 0;
			while(_g < functions.length) {
				var cb = functions[_g];
				++_g;
				if(cb != null) cb();
			}
		}
	}
	,preUpdate: function(msTimeStep) {
		this.queueRegisters = true;
	}
	,update: function(msTimeStep) {
		var $it0 = this.heldKeys.iterator();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			if(this.getHeldKeysRegistered().exists(key[1])) {
				var functions = this.getHeldKeysRegistered().get(key[1]);
				var _g = 0;
				while(_g < functions.length) {
					var cb = functions[_g];
					++_g;
					if(cb != null) cb();
				}
			}
		}
		var $it1 = this.mouseButtonsHeld.iterator();
		while( $it1.hasNext() ) {
			var mouseButton = $it1.next();
			if(this.getHeldMouseButtonsRegistered().exists(mouseButton[1])) {
				var _g = 0, _g1 = this.getHeldMouseButtonsRegistered().get(mouseButton[1]);
				while(_g < _g1.length) {
					var cb = _g1[_g];
					++_g;
					if(cb != null) cb(this.lastMousePos);
				}
			}
		}
	}
	,postUpdate: function(msTimeStep) {
		this.queueRegisters = false;
		this.flushQueues();
	}
	,destroy: function() {
		var $it0 = this.mouseButtonsRegistered.keys();
		while( $it0.hasNext() ) {
			var mouseButtonState = $it0.next();
			var $it1 = this.mouseButtonsRegistered.get(mouseButtonState).keys();
			while( $it1.hasNext() ) {
				var mouseButton = $it1.next();
				var functions = this.mouseButtonsRegistered.get(mouseButtonState).get(mouseButton);
				functions.splice(0,functions.length);
				this.mouseButtonsRegistered.get(mouseButtonState).remove(mouseButton);
			}
			this.mouseButtonsRegistered.remove(mouseButtonState);
		}
		this.mouseButtonsRegistered = null;
		this.mouseButtonsAnyRegistered.splice(0,this.mouseButtonsAnyRegistered.length);
		this.mouseButtonsAnyRegistered = null;
		this.mouseWheelsRegistered.splice(0,this.mouseWheelsRegistered.length);
		this.mouseWheelsRegistered = null;
		this.mousePositionChangesRegistered.splice(0,this.mousePositionChangesRegistered.length);
		this.mousePositionChangesRegistered = null;
		var $it2 = this.mouseButtonsHeld.keys();
		while( $it2.hasNext() ) {
			var mouseButton = $it2.next();
			this.mouseButtonsHeld.remove(mouseButton);
		}
		this.mouseButtonsHeld = null;
		this.lastMousePos = null;
		var $it3 = this.keysRegistered.keys();
		while( $it3.hasNext() ) {
			var mouseButtonState = $it3.next();
			var $it4 = this.keysRegistered.get(mouseButtonState).keys();
			while( $it4.hasNext() ) {
				var mouseButton = $it4.next();
				var functions = this.keysRegistered.get(mouseButtonState).get(mouseButton);
				functions.splice(0,functions.length);
				this.keysRegistered.get(mouseButtonState).remove(mouseButton);
			}
			this.keysRegistered.remove(mouseButtonState);
		}
		this.keysRegistered = null;
		var $it5 = this.heldKeys.keys();
		while( $it5.hasNext() ) {
			var key = $it5.next();
			this.heldKeys.remove(key);
		}
		this.heldKeys = null;
	}
	,registerMouseButtonEvent: function(button,buttonState,cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseButtonRegisters.push(new titanium_reindeer.MouseButtonData(button,buttonState,cb));
			return;
		}
		var buttons = this.mouseButtonsRegistered.get(buttonState[1]);
		if(!buttons.exists(button[1])) buttons.set(button[1],new Array());
		buttons.get(button[1]).push(cb);
	}
	,registerMouseButtonAnyEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseButtonAnyRegisters.push(new titanium_reindeer.MouseButtonAnyData(cb));
			return;
		}
		this.mouseButtonsAnyRegistered.push(cb);
	}
	,registerMouseMoveEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseMoveRegisters.push(new titanium_reindeer.MouseMoveData(cb));
			return;
		}
		this.mousePositionChangesRegistered.push(cb);
	}
	,registerMouseWheelEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseWheelRegisters.push(new titanium_reindeer.MouseWheelData(cb));
			return;
		}
		this.mouseWheelsRegistered.push(cb);
	}
	,registerKeyEvent: function(key,keyState,cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedKeyRegisters.push(new titanium_reindeer.KeyData(key,keyState,cb));
			return;
		}
		var arr = this.keysRegistered.get(keyState[1]);
		if(!arr.exists(key[1])) arr.set(key[1],new Array());
		arr.get(key[1]).push(cb);
	}
	,registerKeyAnyEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedKeyAnyRegisters.push(new titanium_reindeer.KeyAnyData(cb));
			return;
		}
		this.keysAnyRegistered.push(cb);
	}
	,unregisterMouseButtonEvent: function(mouseButton,mouseButtonState,cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseButtonUnregisters.push(new titanium_reindeer.MouseButtonData(mouseButton,mouseButtonState,cb));
			return;
		}
		var mouseButtons = this.mouseButtonsRegistered.get(mouseButtonState[1]);
		if(mouseButtons.exists(mouseButton[1])) {
			var functions = mouseButtons.get(mouseButton[1]);
			var _g1 = 0, _g = functions.length;
			while(_g1 < _g) {
				var i = _g1++;
				if(Reflect.compareMethods(functions[i],cb)) {
					functions.splice(i,1);
					break;
				}
			}
		}
	}
	,unregisterMouseButtonAnyEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseButtonAnyUnregisters.push(new titanium_reindeer.MouseButtonAnyData(cb));
			return;
		}
		var _g1 = 0, _g = this.mouseButtonsAnyRegistered.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this.mouseButtonsAnyRegistered[i],cb)) {
				this.mouseButtonsAnyRegistered.splice(i,1);
				break;
			}
		}
	}
	,unregisterMouseMoveEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseMoveUnregisters.push(new titanium_reindeer.MouseMoveData(cb));
			return;
		}
		var _g1 = 0, _g = this.mousePositionChangesRegistered.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this.mousePositionChangesRegistered[i],cb)) {
				this.mousePositionChangesRegistered.splice(i,1);
				break;
			}
		}
	}
	,unregisterMouseWheelEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedMouseWheelUnregisters.push(new titanium_reindeer.MouseWheelData(cb));
			return;
		}
		var _g1 = 0, _g = this.mouseWheelsRegistered.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this.mouseWheelsRegistered[i],cb)) {
				this.mouseWheelsRegistered.splice(i,1);
				break;
			}
		}
	}
	,unregisterKeyEvent: function(key,keyState,cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedKeyUnregisters.push(new titanium_reindeer.KeyData(key,keyState,cb));
			return;
		}
		var keys = this.keysRegistered.get(keyState[1]);
		if(keys.exists(key[1])) {
			var functions = keys.get(key[1]);
			var _g1 = 0, _g = functions.length;
			while(_g1 < _g) {
				var i = _g1++;
				if(Reflect.compareMethods(functions[i],cb)) {
					functions.splice(i,1);
					break;
				}
			}
		}
	}
	,unregisterKeyAnyEvent: function(cb) {
		if(cb == null) return;
		if(this.queueRegisters) {
			this.queuedKeyAnyUnregisters.push(new titanium_reindeer.KeyAnyData(cb));
			return;
		}
		var _g1 = 0, _g = this.keysAnyRegistered.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this.keysAnyRegistered[i],cb)) {
				this.keysAnyRegistered.splice(i,1);
				break;
			}
		}
	}
	,flushQueues: function() {
		var _g = 0, _g1 = this.queuedMouseButtonRegisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.registerMouseButtonEvent(data.button,data.buttonState,data.cb);
		}
		this.queuedMouseButtonRegisters = new Array();
		var _g = 0, _g1 = this.queuedMouseMoveRegisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.registerMouseMoveEvent(data.cb);
		}
		this.queuedMouseMoveRegisters = new Array();
		var _g = 0, _g1 = this.queuedMouseWheelRegisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.registerMouseWheelEvent(data.cb);
		}
		this.queuedMouseWheelRegisters = new Array();
		var _g = 0, _g1 = this.queuedMouseButtonAnyRegisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.registerMouseButtonAnyEvent(data.cb);
		}
		this.queuedMouseButtonAnyRegisters = new Array();
		var _g = 0, _g1 = this.queuedKeyRegisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.registerKeyEvent(data.key,data.keyState,data.cb);
		}
		this.queuedKeyRegisters = new Array();
		var _g = 0, _g1 = this.queuedKeyAnyRegisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.registerKeyAnyEvent(data.cb);
		}
		this.queuedKeyAnyRegisters = new Array();
		var _g = 0, _g1 = this.queuedMouseButtonUnregisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.unregisterMouseButtonEvent(data.button,data.buttonState,data.cb);
		}
		this.queuedMouseButtonUnregisters = new Array();
		var _g = 0, _g1 = this.queuedMouseMoveUnregisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.unregisterMouseMoveEvent(data.cb);
		}
		this.queuedMouseMoveUnregisters = new Array();
		var _g = 0, _g1 = this.queuedMouseWheelUnregisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.unregisterMouseWheelEvent(data.cb);
		}
		this.queuedMouseWheelUnregisters = new Array();
		var _g = 0, _g1 = this.queuedMouseButtonAnyUnregisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.unregisterMouseButtonAnyEvent(data.cb);
		}
		this.queuedMouseButtonAnyUnregisters = new Array();
		var _g = 0, _g1 = this.queuedKeyUnregisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.unregisterKeyEvent(data.key,data.keyState,data.cb);
		}
		this.queuedKeyUnregisters = new Array();
		var _g = 0, _g1 = this.queuedKeyAnyUnregisters;
		while(_g < _g1.length) {
			var data = _g1[_g];
			++_g;
			this.unregisterKeyAnyEvent(data.cb);
		}
		this.queuedKeyAnyUnregisters = new Array();
	}
	,isMouseButtonDown: function(mouseButton) {
		return this.mouseButtonsHeld.exists(mouseButton[1]);
	}
	,isKeyDown: function(key) {
		return this.heldKeys.exists(key[1]);
	}
	,setDocumentOffset: function(value) {
		this.targetDocumentOffset = value;
	}
	,getMousePositionFromEvent: function(event) {
		if(event == null) return new titanium_reindeer.Vector2(0,0);
		var mousePos;
		if(event.pageX || event.pageY) mousePos = new titanium_reindeer.Vector2(event.pageX,event.pageY); else if(event.clientX || event.clientY) mousePos = new titanium_reindeer.Vector2(event.clientX + js.Lib.document.body.scrollLeft + js.Lib.document.documentElement.scrollLeft,event.clientY + js.Lib.document.body.scrollTop + js.Lib.document.documentElement.scrollTop); else return new titanium_reindeer.Vector2(0,0);
		return mousePos.subtract(this.targetDocumentOffset);
	}
	,getMouseButtonFromButton: function(which) {
		var mouseButton;
		switch(which) {
		case 0:
			mouseButton = titanium_reindeer.MouseButton.Left;
			break;
		case 1:
			mouseButton = titanium_reindeer.MouseButton.Middle;
			break;
		case 2:
			mouseButton = titanium_reindeer.MouseButton.Right;
			break;
		default:
			mouseButton = titanium_reindeer.MouseButton.Left;
		}
		return mouseButton;
	}
	,getKeyFromCode: function(keyCode) {
		var key;
		switch(keyCode) {
		case 8:
			key = titanium_reindeer.Key.BackSpace;
			break;
		case 9:
			key = titanium_reindeer.Key.Tab;
			break;
		case 13:
			key = titanium_reindeer.Key.Enter;
			break;
		case 16:
			key = titanium_reindeer.Key.Shift;
			break;
		case 17:
			key = titanium_reindeer.Key.Ctrl;
			break;
		case 18:
			key = titanium_reindeer.Key.Alt;
			break;
		case 20:
			key = titanium_reindeer.Key.CapsLock;
			break;
		case 27:
			key = titanium_reindeer.Key.Esc;
			break;
		case 32:
			key = titanium_reindeer.Key.Space;
			break;
		case 33:
			key = titanium_reindeer.Key.PageUp;
			break;
		case 34:
			key = titanium_reindeer.Key.PageDown;
			break;
		case 35:
			key = titanium_reindeer.Key.End;
			break;
		case 36:
			key = titanium_reindeer.Key.Home;
			break;
		case 37:
			key = titanium_reindeer.Key.LeftArrow;
			break;
		case 38:
			key = titanium_reindeer.Key.UpArrow;
			break;
		case 39:
			key = titanium_reindeer.Key.RightArrow;
			break;
		case 40:
			key = titanium_reindeer.Key.DownArrow;
			break;
		case 45:
			key = titanium_reindeer.Key.Insert;
			break;
		case 46:
			key = titanium_reindeer.Key.Delete;
			break;
		case 48:
			key = titanium_reindeer.Key.Zero;
			break;
		case 49:
			key = titanium_reindeer.Key.One;
			break;
		case 50:
			key = titanium_reindeer.Key.Two;
			break;
		case 51:
			key = titanium_reindeer.Key.Three;
			break;
		case 52:
			key = titanium_reindeer.Key.Four;
			break;
		case 53:
			key = titanium_reindeer.Key.Five;
			break;
		case 54:
			key = titanium_reindeer.Key.Six;
			break;
		case 55:
			key = titanium_reindeer.Key.Seven;
			break;
		case 56:
			key = titanium_reindeer.Key.Eight;
			break;
		case 57:
			key = titanium_reindeer.Key.Nine;
			break;
		case 65:
			key = titanium_reindeer.Key.A;
			break;
		case 66:
			key = titanium_reindeer.Key.B;
			break;
		case 67:
			key = titanium_reindeer.Key.C;
			break;
		case 68:
			key = titanium_reindeer.Key.D;
			break;
		case 69:
			key = titanium_reindeer.Key.E;
			break;
		case 70:
			key = titanium_reindeer.Key.F;
			break;
		case 71:
			key = titanium_reindeer.Key.G;
			break;
		case 72:
			key = titanium_reindeer.Key.H;
			break;
		case 73:
			key = titanium_reindeer.Key.I;
			break;
		case 74:
			key = titanium_reindeer.Key.J;
			break;
		case 75:
			key = titanium_reindeer.Key.K;
			break;
		case 76:
			key = titanium_reindeer.Key.L;
			break;
		case 77:
			key = titanium_reindeer.Key.M;
			break;
		case 78:
			key = titanium_reindeer.Key.N;
			break;
		case 79:
			key = titanium_reindeer.Key.O;
			break;
		case 80:
			key = titanium_reindeer.Key.P;
			break;
		case 81:
			key = titanium_reindeer.Key.Q;
			break;
		case 82:
			key = titanium_reindeer.Key.R;
			break;
		case 83:
			key = titanium_reindeer.Key.S;
			break;
		case 84:
			key = titanium_reindeer.Key.T;
			break;
		case 85:
			key = titanium_reindeer.Key.U;
			break;
		case 86:
			key = titanium_reindeer.Key.V;
			break;
		case 87:
			key = titanium_reindeer.Key.W;
			break;
		case 88:
			key = titanium_reindeer.Key.X;
			break;
		case 89:
			key = titanium_reindeer.Key.Y;
			break;
		case 90:
			key = titanium_reindeer.Key.Z;
			break;
		case 97:
			key = titanium_reindeer.Key.NumOne;
			break;
		case 98:
			key = titanium_reindeer.Key.NumTwo;
			break;
		case 99:
			key = titanium_reindeer.Key.NumThree;
			break;
		case 100:
			key = titanium_reindeer.Key.NumFour;
			break;
		case 101:
			key = titanium_reindeer.Key.NumFive;
			break;
		case 102:
			key = titanium_reindeer.Key.NumSix;
			break;
		case 103:
			key = titanium_reindeer.Key.NumSeven;
			break;
		case 104:
			key = titanium_reindeer.Key.NumEight;
			break;
		case 105:
			key = titanium_reindeer.Key.NumNine;
			break;
		case 106:
			key = titanium_reindeer.Key.NumAsterick;
			break;
		case 107:
			key = titanium_reindeer.Key.NumPlus;
			break;
		case 109:
			key = titanium_reindeer.Key.NumDash;
			break;
		case 111:
			key = titanium_reindeer.Key.NumSlash;
			break;
		case 112:
			key = titanium_reindeer.Key.F1;
			break;
		case 113:
			key = titanium_reindeer.Key.F2;
			break;
		case 114:
			key = titanium_reindeer.Key.F3;
			break;
		case 115:
			key = titanium_reindeer.Key.F4;
			break;
		case 116:
			key = titanium_reindeer.Key.F5;
			break;
		case 117:
			key = titanium_reindeer.Key.F6;
			break;
		case 118:
			key = titanium_reindeer.Key.F7;
			break;
		case 119:
			key = titanium_reindeer.Key.F8;
			break;
		case 120:
			key = titanium_reindeer.Key.F9;
			break;
		case 121:
			key = titanium_reindeer.Key.F10;
			break;
		case 122:
			key = titanium_reindeer.Key.F11;
			break;
		case 123:
			key = titanium_reindeer.Key.F12;
			break;
		case 144:
			key = titanium_reindeer.Key.NumLock;
			break;
		case 186:
			key = titanium_reindeer.Key.SemiColon;
			break;
		case 187:
			key = titanium_reindeer.Key.Equals;
			break;
		case 188:
			key = titanium_reindeer.Key.Comma;
			break;
		case 189:
			key = titanium_reindeer.Key.Dash;
			break;
		case 190:
			key = titanium_reindeer.Key.Period;
			break;
		case 191:
			key = titanium_reindeer.Key.Slash;
			break;
		case 192:
			key = titanium_reindeer.Key.Tilde;
			break;
		case 219:
			key = titanium_reindeer.Key.LeftBracket;
			break;
		case 220:
			key = titanium_reindeer.Key.BackSlash;
			break;
		case 221:
			key = titanium_reindeer.Key.LeftBracket;
			break;
		case 222:
			key = titanium_reindeer.Key.Quote;
			break;
		default:
			key = titanium_reindeer.Key.None;
		}
		return key;
	}
	,__class__: titanium_reindeer.InputManager
	,__properties__: {get_upKeysRegistered:"getUpKeysRegistered",get_heldKeysRegistered:"getHeldKeysRegistered",get_downKeysRegistered:"getDownKeysRegistered",get_mousePosition:"getMousePos",get_upMouseButtonsRegistered:"getUpMouseButtonsRegistered",get_heldMouseButtonsRegistered:"getHeldMouseButtonsRegistered",get_downMouseButtonsRegistered:"getDownMouseButtonsRegistered"}
}
titanium_reindeer.GameInputManager = $hxClasses["titanium_reindeer.GameInputManager"] = function(game,targetElement) {
	titanium_reindeer.InputManager.call(this);
	this.game = game;
	this.targetElement = targetElement;
	this.recalculateCanvasOffset();
	this.keyDowns = new IntHash();
	this.timeLeftToRecalculateOffsetMs = 1000;
	var me = this;
	targetElement.onmousedown = function(event) {
		me.recordEvent(titanium_reindeer.InputEvent.MouseDown,event);
	};
	targetElement.onmouseup = function(event) {
		me.recordEvent(titanium_reindeer.InputEvent.MouseUp,event);
	};
	targetElement.onmousemove = function(event) {
		me.recordEvent(titanium_reindeer.InputEvent.MouseMove,event);
	};
	targetElement.oncontextmenu = this.contextMenu.$bind(this);
	var firefoxReg = new EReg("Firefox","i");
	var wheelFunc = function(event) {
		me.recordEvent(titanium_reindeer.InputEvent.MouseWheel,event);
	};
	if(firefoxReg.match(js.Lib.window.navigator.userAgent)) js.Lib.document.addEventListener("DOMMouseScroll",wheelFunc,true); else js.Lib.document.onmousewheel = wheelFunc;
	js.Lib.document.onkeydown = function(event) {
		me.recordEvent(titanium_reindeer.InputEvent.KeyDown,event);
	};
	js.Lib.document.onkeyup = function(event) {
		me.recordEvent(titanium_reindeer.InputEvent.KeyUp,event);
	};
};
titanium_reindeer.GameInputManager.__name__ = ["titanium_reindeer","GameInputManager"];
titanium_reindeer.GameInputManager.__super__ = titanium_reindeer.InputManager;
titanium_reindeer.GameInputManager.prototype = $extend(titanium_reindeer.InputManager.prototype,{
	game: null
	,targetElement: null
	,timeLeftToRecalculateOffsetMs: null
	,keyDowns: null
	,contextMenu: function(event) {
		var found = false;
		if(this.getUpMouseButtonsRegistered().exists(1)) found = this.getUpMouseButtonsRegistered().get(1).length != 0;
		return !(found || this.mouseButtonsAnyRegistered.length != 0);
	}
	,recordEvent: function(type,event) {
		if(type == titanium_reindeer.InputEvent.KeyDown) {
			var key = event.keyCode;
			if(this.keyDowns.exists(key) && this.keyDowns.get(key)) return;
			this.keyDowns.set(key,true);
		} else if(type == titanium_reindeer.InputEvent.KeyUp) {
			var key = event.keyCode;
			this.keyDowns.set(key,false);
		}
		this.recordedEvents.push(new titanium_reindeer.RecordedEvent(type,event));
	}
	,update: function(msTimeStep) {
		titanium_reindeer.InputManager.prototype.update.call(this,msTimeStep);
		var tempEvents = new Array();
		var _g = 0, _g1 = this.recordedEvents;
		while(_g < _g1.length) {
			var recordedEvent = _g1[_g];
			++_g;
			tempEvents.push(recordedEvent);
		}
		this.recordedEvents = new Array();
		var scenes = this.game.sceneManager.getAllScenes();
		var _g = 0;
		while(_g < tempEvents.length) {
			var recordedEvent = tempEvents[_g];
			++_g;
			this.receiveEvent(recordedEvent);
			while( scenes.hasNext() ) {
				var scene = scenes.next();
				scene.inputManager.receiveEvent(recordedEvent);
			}
		}
	}
	,postUpdate: function(msTimeStep) {
		titanium_reindeer.InputManager.prototype.postUpdate.call(this,msTimeStep);
		this.timeLeftToRecalculateOffsetMs -= msTimeStep;
		if(this.timeLeftToRecalculateOffsetMs <= 0) {
			this.timeLeftToRecalculateOffsetMs = 1000;
			this.recalculateCanvasOffset();
		}
	}
	,destroy: function() {
		titanium_reindeer.InputManager.prototype.destroy.call(this);
		this.targetElement.onmousedown = null;
		this.targetElement.onmouseup = null;
		this.targetElement.onmousemove = null;
		this.targetElement.oncontextmenu = null;
		js.Lib.document.onmousewheel = null;
		js.Lib.document.onkeydown = null;
		js.Lib.document.onkeyup = null;
		var firefoxReg = new EReg("Firefox","i");
		if(firefoxReg.match(js.Lib.window.navigator.userAgent)) js.Lib.document.removeEventListener("DOMMouseScroll",this.mouseWheel.$bind(this),true); else js.Lib.document.onmousewheel = null;
		this.targetElement = null;
	}
	,recalculateCanvasOffset: function() {
		var offset = new titanium_reindeer.Vector2(0,0);
		if(this.targetElement != null && this.targetElement.offsetParent != null) {
			var ele = this.targetElement;
			do {
				var _g = offset;
				_g.setX(_g.getX() + ele.offsetLeft);
				var _g = offset;
				_g.setY(_g.getY() + ele.offsetTop);
				ele = ele.offsetParent;
			} while(ele != null);
		}
		this.targetDocumentOffset = offset;
		var $it0 = this.game.sceneManager.getAllScenes();
		while( $it0.hasNext() ) {
			var scene = $it0.next();
			scene.inputManager.setDocumentOffset(offset);
		}
	}
	,__class__: titanium_reindeer.GameInputManager
});
titanium_reindeer.SoundBase = $hxClasses["titanium_reindeer.SoundBase"] = function() {
	this.setVolumeModifier(1.0);
	this.setVolume(1.0);
	this.setMutedState(false);
	this.setPausedState(false);
	this.lockingMute = false;
	this.lockingPause = false;
	this.muteLocked = false;
	this.pauseLocked = false;
};
titanium_reindeer.SoundBase.__name__ = ["titanium_reindeer","SoundBase"];
titanium_reindeer.SoundBase.prototype = {
	volume: null
	,setVolume: function(value) {
		if(this.volume != value) {
			if(value > 1.0) value = 1.0; else if(value < 0.0) value = 0.0;
			this.volume = value;
			this.updateTrueVolume();
		}
		return this.volume;
	}
	,volumeModifier: null
	,setVolumeModifier: function(value) {
		if(this.volumeModifier != value) {
			if(value > 1.0) value = 1.0; else if(value < 0.0) value = 0.0;
			this.volumeModifier = value;
			this.updateTrueVolume();
		}
		return this.volumeModifier;
	}
	,trueVolume: null
	,setTrueVolume: function(value) {
		if(this.trueVolume != value) {
			if(value > 1.0) value = 1.0; else if(value < 0.0) value = 0.0;
			this.trueVolume = value;
		}
		return this.trueVolume;
	}
	,isMuted: null
	,getIsMuted: function() {
		return this.lockingMute || !this.muteLocked && this.mutedState;
	}
	,isTrulyMuted: null
	,getIsTrulyMuted: function() {
		return this.mutedState;
	}
	,mutedState: null
	,setMutedState: function(value) {
		this.mutedState = value;
		return value;
	}
	,isPaused: null
	,getIsPaused: function() {
		return this.lockingPause || !this.pauseLocked && this.pausedState;
	}
	,isTrulyPaused: null
	,getIsTrulyPaused: function() {
		return this.pausedState;
	}
	,pausedState: null
	,setPausedState: function(value) {
		this.pausedState = value;
		return value;
	}
	,lockingMute: null
	,lockingPause: null
	,muteLocked: null
	,pauseLocked: null
	,mute: function(lock) {
		if(lock == null) lock = true;
		if(this.mutedState && !lock || this.lockingMute) return;
		this.setMutedState(true);
		this.lockingMute = lock;
		if(lock) this.propagateCall("lockedMute",[]); else this.propagateCall("mute",[false]);
	}
	,unmute: function() {
		if(!this.mutedState) return;
		if(this.muteLocked) {
			this.lockingMute = false;
			return;
		}
		this.setMutedState(false);
		if(this.lockingMute) {
			this.propagateCall("lockedUnmute",[]);
			this.lockingMute = false;
		} else this.propagateCall("unmute",[]);
	}
	,pause: function(lock) {
		if(lock == null) lock = true;
		if(this.pausedState && !lock || this.lockingPause) return;
		this.setPausedState(true);
		this.lockingPause = lock;
		if(lock) this.propagateCall("lockedPause",[]); else this.propagateCall("pause",[false]);
	}
	,unpause: function() {
		if(!this.pausedState) return;
		if(this.pauseLocked) {
			this.lockingPause = false;
			return;
		}
		this.setPausedState(false);
		if(this.lockingPause) {
			this.propagateCall("lockedUnpause",[]);
			this.lockingPause = false;
		} else this.propagateCall("unpause",[]);
	}
	,lockedMute: function() {
		this.muteLocked = true;
		if(!this.lockingMute) {
			this.setMutedState(true);
			this.propagateCall("lockedMute",[]);
		}
	}
	,lockedUnmute: function() {
		this.muteLocked = false;
		if(!this.lockingMute) {
			this.setMutedState(false);
			this.propagateCall("lockedUnmute",[]);
		}
	}
	,lockedPause: function() {
		this.pauseLocked = true;
		if(!this.lockingPause) {
			this.setPausedState(true);
			this.propagateCall("lockedPause",[]);
		}
	}
	,lockedUnpause: function() {
		this.pauseLocked = false;
		if(!this.lockingPause) {
			this.setPausedState(false);
			this.propagateCall("lockedUnpause",[]);
		}
	}
	,updateTrueVolume: function() {
		this.setTrueVolume(this.volume * this.volumeModifier);
		this.propagateCall("setVolumeModifier",[this.trueVolume]);
	}
	,propagateCall: function(methodName,params) {
	}
	,__class__: titanium_reindeer.SoundBase
	,__properties__: {set_pausedState:"setPausedState",get_isTrulyPaused:"getIsTrulyPaused",get_isPaused:"getIsPaused",set_mutedState:"setMutedState",get_isTrulyMuted:"getIsTrulyMuted",get_isMuted:"getIsMuted",set_volumeModifier:"setVolumeModifier",set_volume:"setVolume"}
}
titanium_reindeer.SoundManager = $hxClasses["titanium_reindeer.SoundManager"] = function() {
	this.sounds = new Hash();
	this.soundGroups = new Array();
	titanium_reindeer.SoundBase.call(this);
};
titanium_reindeer.SoundManager.__name__ = ["titanium_reindeer","SoundManager"];
titanium_reindeer.SoundManager.__super__ = titanium_reindeer.SoundBase;
titanium_reindeer.SoundManager.prototype = $extend(titanium_reindeer.SoundBase.prototype,{
	sounds: null
	,soundGroups: null
	,getSound: function(filePath) {
		if(this.sounds.exists(filePath)) return this.sounds.get(filePath);
		var newSound = new titanium_reindeer.Sound(this,this.getSoundSource(filePath));
		this.sounds.set(filePath,newSound);
		return newSound;
	}
	,getSoundSource: function(filePath) {
		return null;
	}
	,addGroup: function(soundGroup) {
		if(soundGroup == null || soundGroup.soundManager != this || this.containsGroup(soundGroup)) return;
		this.soundGroups.push(soundGroup);
	}
	,containsGroup: function(soundGroup) {
		var _g = 0, _g1 = this.soundGroups;
		while(_g < _g1.length) {
			var mySoundGroup = _g1[_g];
			++_g;
			if(soundGroup == mySoundGroup) return true;
		}
		return false;
	}
	,removeGroup: function(soundGroup) {
		this.soundGroups.remove(soundGroup);
	}
	,propagateCall: function(methodName,params) {
		var $it0 = this.sounds.iterator();
		while( $it0.hasNext() ) {
			var sound = $it0.next();
			Reflect.field(sound,methodName).apply(sound,params);
		}
		var _g = 0, _g1 = this.soundGroups;
		while(_g < _g1.length) {
			var soundGroup = _g1[_g];
			++_g;
			Reflect.field(soundGroup,methodName).apply(soundGroup,params);
		}
	}
	,__class__: titanium_reindeer.SoundManager
});
titanium_reindeer.GameSoundManager = $hxClasses["titanium_reindeer.GameSoundManager"] = function(game) {
	this.game = game;
	this.cachedSounds = new Hash();
	titanium_reindeer.SoundManager.call(this);
};
titanium_reindeer.GameSoundManager.__name__ = ["titanium_reindeer","GameSoundManager"];
titanium_reindeer.GameSoundManager.__super__ = titanium_reindeer.SoundManager;
titanium_reindeer.GameSoundManager.prototype = $extend(titanium_reindeer.SoundManager.prototype,{
	game: null
	,cachedSounds: null
	,getSoundSource: function(filePath) {
		if(this.cachedSounds.exists(filePath)) return this.cachedSounds.get(filePath); else {
			var newSound = new titanium_reindeer.SoundSource(filePath);
			this.cachedSounds.set(filePath,newSound);
			return newSound;
		}
	}
	,propagateCall: function(methodName,params) {
		titanium_reindeer.SoundManager.prototype.propagateCall.call(this,methodName,params);
		var $it0 = this.game.sceneManager.getAllScenes();
		while( $it0.hasNext() ) {
			var scene = $it0.next();
			Reflect.field(scene.soundManager,methodName).apply(scene.soundManager,params);
		}
	}
	,__class__: titanium_reindeer.GameSoundManager
});
titanium_reindeer.Geometry = $hxClasses["titanium_reindeer.Geometry"] = function() { }
titanium_reindeer.Geometry.__name__ = ["titanium_reindeer","Geometry"];
titanium_reindeer.Geometry.isCircleIntersectingRect = function(c,r) {
	var rWidthHalf = r.width / 2;
	var rHeightHalf = r.height / 2;
	var circleDistX = Math.abs(c.center.getX() - r.x - rWidthHalf);
	var circleDistY = Math.abs(c.center.getY() - r.y - rHeightHalf);
	if(circleDistX > rWidthHalf + c.radius || circleDistY > rHeightHalf + c.radius) return false;
	if(circleDistX <= rWidthHalf || circleDistY <= rHeightHalf) return true;
	var cornerDistance = (circleDistX - rWidthHalf) * (circleDistX - rWidthHalf) + (circleDistY - rHeightHalf) * (circleDistY - rHeightHalf);
	return cornerDistance <= c.radius * c.radius;
}
titanium_reindeer.Geometry.getMidPoint = function(a,b) {
	return b.add(a.subtract(b).getExtend(0.5));
}
titanium_reindeer.Geometry.isAngleWithin = function(start,target,bounds) {
	if(bounds >= Math.PI) return true;
	var diff = (target - start) % (Math.PI * 2);
	if(start > target) diff += Math.PI * 2;
	if(diff >= Math.PI) diff = -(diff - Math.PI * 2);
	return bounds >= diff;
}
titanium_reindeer.Geometry.closestAngle = function(rad,comparisons) {
	if(comparisons == null || comparisons.length == 0) return rad;
	if(comparisons.length == 1) return comparisons.pop();
	var closestComparison = rad;
	var closestDiff = Math.POSITIVE_INFINITY;
	var diff;
	var _g = 0;
	while(_g < comparisons.length) {
		var comparison = comparisons[_g];
		++_g;
		diff = (comparison - rad) % (Math.PI * 2);
		if(rad > comparison) diff += Math.PI * 2;
		if(diff >= Math.PI) diff = -(diff - Math.PI * 2);
		if(closestDiff > diff) {
			closestComparison = comparison % (Math.PI * 2);
			closestDiff = diff;
		}
	}
	return closestComparison;
}
titanium_reindeer.Geometry.prototype = {
	__class__: titanium_reindeer.Geometry
}
titanium_reindeer.ImageRenderer = $hxClasses["titanium_reindeer.ImageRenderer"] = function(image,layer,sourceRect,width,height) {
	if(height == null) height = 0;
	if(width == null) width = 0;
	titanium_reindeer.RendererComponent.call(this,0,0,layer);
	this.sourceRect = sourceRect;
	this.destWidth = width;
	this.destHeight = height;
	this.setImage(image);
};
titanium_reindeer.ImageRenderer.__name__ = ["titanium_reindeer","ImageRenderer"];
titanium_reindeer.ImageRenderer.__super__ = titanium_reindeer.RendererComponent;
titanium_reindeer.ImageRenderer.prototype = $extend(titanium_reindeer.RendererComponent.prototype,{
	image: null
	,setImage: function(value) {
		if(value != null && value != this.image) {
			this.image = value;
			if(this.image.isLoaded) this.imageLoaded(null); else this.image.registerLoadEvent(this.imageLoaded.$bind(this));
		}
		return this.image;
	}
	,sourceRect: null
	,destWidth: null
	,destHeight: null
	,render: function() {
		titanium_reindeer.RendererComponent.prototype.render.call(this);
		if(this.image.isLoaded) {
			var x = 2;
			this.getPen().drawImage(this.image.image,this.sourceRect.x,this.sourceRect.y,this.sourceRect.width,this.sourceRect.height,-this.destWidth / 2,-this.destHeight / 2,this.destWidth,this.destHeight);
		} else this.setRedraw(true);
	}
	,imageLoaded: function(event) {
		if(this.destWidth == 0) {
			if(this.sourceRect == null) this.destWidth = this.image.width; else this.destWidth = this.sourceRect.width;
		}
		this.setInitialWidth(this.destWidth);
		if(this.destHeight == 0) {
			if(this.sourceRect != null) this.destHeight = this.sourceRect.height; else this.destHeight = this.image.height;
		}
		this.setInitialHeight(this.destHeight);
		if(this.sourceRect == null) this.sourceRect = new titanium_reindeer.Rect(0,0,this.destWidth,this.destHeight);
		this.setRedraw(true);
	}
	,identify: function() {
		return titanium_reindeer.RendererComponent.prototype.identify.call(this) + "Image(" + this.image.identify() + ");";
	}
	,destroy: function() {
		titanium_reindeer.RendererComponent.prototype.destroy.call(this);
		this.setImage(null);
	}
	,__class__: titanium_reindeer.ImageRenderer
	,__properties__: $extend(titanium_reindeer.RendererComponent.prototype.__properties__,{set_image:"setImage"})
});
titanium_reindeer.ImageSource = $hxClasses["titanium_reindeer.ImageSource"] = function(path) {
	this.image = new Image();;
	this.image.onload = this.imageLoaded.$bind(this);
	this.image.src = path;
};
titanium_reindeer.ImageSource.__name__ = ["titanium_reindeer","ImageSource"];
titanium_reindeer.ImageSource.prototype = {
	image: null
	,width: null
	,height: null
	,isLoaded: null
	,loadedFunctions: null
	,imageLoaded: function(event) {
		if(this.image == null) return;
		this.isLoaded = true;
		this.width = this.image.width;
		this.height = this.image.height;
		if(this.loadedFunctions != null) {
			var $it0 = this.loadedFunctions.iterator();
			while( $it0.hasNext() ) {
				var func = $it0.next();
				func(event);
			}
			this.loadedFunctions.clear();
			this.loadedFunctions = null;
		}
	}
	,registerLoadEvent: function(cb) {
		if(this.isLoaded) return;
		if(this.loadedFunctions == null) this.loadedFunctions = new List();
		this.loadedFunctions.push(cb);
	}
	,identify: function() {
		return "ImageSource(" + this.image.src + "," + this.width + "," + this.height + ");";
	}
	,destroy: function() {
		this.isLoaded = false;
		this.image = null;
		if(this.loadedFunctions != null) {
			this.loadedFunctions.clear();
			this.loadedFunctions = null;
		}
	}
	,__class__: titanium_reindeer.ImageSource
}
titanium_reindeer.RecordedEvent = $hxClasses["titanium_reindeer.RecordedEvent"] = function(type,event) {
	this.type = type;
	this.event = event;
};
titanium_reindeer.RecordedEvent.__name__ = ["titanium_reindeer","RecordedEvent"];
titanium_reindeer.RecordedEvent.prototype = {
	type: null
	,event: null
	,__class__: titanium_reindeer.RecordedEvent
}
titanium_reindeer.MouseButtonData = $hxClasses["titanium_reindeer.MouseButtonData"] = function(button,buttonState,cb) {
	this.button = button;
	this.buttonState = buttonState;
	this.cb = cb;
};
titanium_reindeer.MouseButtonData.__name__ = ["titanium_reindeer","MouseButtonData"];
titanium_reindeer.MouseButtonData.prototype = {
	button: null
	,buttonState: null
	,cb: null
	,__class__: titanium_reindeer.MouseButtonData
}
titanium_reindeer.MouseMoveData = $hxClasses["titanium_reindeer.MouseMoveData"] = function(cb) {
	this.cb = cb;
};
titanium_reindeer.MouseMoveData.__name__ = ["titanium_reindeer","MouseMoveData"];
titanium_reindeer.MouseMoveData.prototype = {
	cb: null
	,__class__: titanium_reindeer.MouseMoveData
}
titanium_reindeer.MouseWheelData = $hxClasses["titanium_reindeer.MouseWheelData"] = function(cb) {
	this.cb = cb;
};
titanium_reindeer.MouseWheelData.__name__ = ["titanium_reindeer","MouseWheelData"];
titanium_reindeer.MouseWheelData.prototype = {
	cb: null
	,__class__: titanium_reindeer.MouseWheelData
}
titanium_reindeer.MouseButtonAnyData = $hxClasses["titanium_reindeer.MouseButtonAnyData"] = function(cb) {
	this.cb = cb;
};
titanium_reindeer.MouseButtonAnyData.__name__ = ["titanium_reindeer","MouseButtonAnyData"];
titanium_reindeer.MouseButtonAnyData.prototype = {
	cb: null
	,__class__: titanium_reindeer.MouseButtonAnyData
}
titanium_reindeer.KeyData = $hxClasses["titanium_reindeer.KeyData"] = function(key,keyState,cb) {
	this.key = key;
	this.keyState = keyState;
	this.cb = cb;
};
titanium_reindeer.KeyData.__name__ = ["titanium_reindeer","KeyData"];
titanium_reindeer.KeyData.prototype = {
	key: null
	,keyState: null
	,cb: null
	,__class__: titanium_reindeer.KeyData
}
titanium_reindeer.KeyAnyData = $hxClasses["titanium_reindeer.KeyAnyData"] = function(cb) {
	this.cb = cb;
};
titanium_reindeer.KeyAnyData.__name__ = ["titanium_reindeer","KeyAnyData"];
titanium_reindeer.KeyAnyData.prototype = {
	cb: null
	,__class__: titanium_reindeer.KeyAnyData
}
titanium_reindeer.LinearGradient = $hxClasses["titanium_reindeer.LinearGradient"] = function(x0,y0,x1,y1,colorStops) {
	this.x0 = x0;
	this.y0 = y0;
	this.x1 = x1;
	this.y1 = y1;
	this.colorStops = new List();
	var _g = 0;
	while(_g < colorStops.length) {
		var colorStop = colorStops[_g];
		++_g;
		this.colorStops.add(colorStop);
	}
};
titanium_reindeer.LinearGradient.__name__ = ["titanium_reindeer","LinearGradient"];
titanium_reindeer.LinearGradient.prototype = {
	x0: null
	,x1: null
	,y0: null
	,y1: null
	,colorStops: null
	,addColorStop: function(colorStop) {
		this.colorStops.add(colorStop);
	}
	,applyColorStops: function(gradient) {
		var $it0 = this.colorStops.iterator();
		while( $it0.hasNext() ) {
			var colorStop = $it0.next();
			gradient.addColorStop(colorStop.offset,colorStop.color.getRgba());
		}
	}
	,getStyle: function(pen) {
		var gradient = pen.createLinearGradient(this.x0,this.y0,this.x1,this.y1);
		this.applyColorStops(gradient);
		return gradient;
	}
	,identify: function() {
		var identity = "Gradient(" + this.x0 + "," + this.x1 + "," + this.y0 + "," + this.y1 + ",";
		var $it0 = this.colorStops.iterator();
		while( $it0.hasNext() ) {
			var colorStop = $it0.next();
			identity += colorStop.identify() + ",";
		}
		return identity + ");";
	}
	,destroy: function() {
		this.colorStops.clear();
		this.colorStops = null;
	}
	,__class__: titanium_reindeer.LinearGradient
}
titanium_reindeer.MouseExclusionRegion = $hxClasses["titanium_reindeer.MouseExclusionRegion"] = function(manager,id,depth,shape) {
	this.manager = manager;
	this.id = id;
	this.depth = depth;
	if(shape == null) throw "Error: MouseExclusionRegion must take a non-null shape!";
	this.dontUpdateManager = true;
	this.setShape(shape);
	this.dontUpdateManager = false;
};
titanium_reindeer.MouseExclusionRegion.__name__ = ["titanium_reindeer","MouseExclusionRegion"];
titanium_reindeer.MouseExclusionRegion.prototype = {
	manager: null
	,id: null
	,dontUpdateManager: null
	,depth: null
	,shape: null
	,setShape: function(value) {
		if(value != this.shape && value != null) {
			this.shape = value;
			if(!this.dontUpdateManager) this.manager.updateExclusionRegionShape(this);
		}
		return this.shape;
	}
	,destroy: function() {
		if(this.manager != null) {
			this.manager.removeExclusionRegion(this);
			this.manager = null;
		}
	}
	,__class__: titanium_reindeer.MouseExclusionRegion
	,__properties__: {set_shape:"setShape"}
}
titanium_reindeer.MouseRegionMoveEvent = $hxClasses["titanium_reindeer.MouseRegionMoveEvent"] = { __ename__ : ["titanium_reindeer","MouseRegionMoveEvent"], __constructs__ : ["Move","Enter","Exit"] }
titanium_reindeer.MouseRegionMoveEvent.Move = ["Move",0];
titanium_reindeer.MouseRegionMoveEvent.Move.toString = $estr;
titanium_reindeer.MouseRegionMoveEvent.Move.__enum__ = titanium_reindeer.MouseRegionMoveEvent;
titanium_reindeer.MouseRegionMoveEvent.Enter = ["Enter",1];
titanium_reindeer.MouseRegionMoveEvent.Enter.toString = $estr;
titanium_reindeer.MouseRegionMoveEvent.Enter.__enum__ = titanium_reindeer.MouseRegionMoveEvent;
titanium_reindeer.MouseRegionMoveEvent.Exit = ["Exit",2];
titanium_reindeer.MouseRegionMoveEvent.Exit.toString = $estr;
titanium_reindeer.MouseRegionMoveEvent.Exit.__enum__ = titanium_reindeer.MouseRegionMoveEvent;
titanium_reindeer.MouseRegionButtonEvent = $hxClasses["titanium_reindeer.MouseRegionButtonEvent"] = { __ename__ : ["titanium_reindeer","MouseRegionButtonEvent"], __constructs__ : ["Down","Up","Click"] }
titanium_reindeer.MouseRegionButtonEvent.Down = ["Down",0];
titanium_reindeer.MouseRegionButtonEvent.Down.toString = $estr;
titanium_reindeer.MouseRegionButtonEvent.Down.__enum__ = titanium_reindeer.MouseRegionButtonEvent;
titanium_reindeer.MouseRegionButtonEvent.Up = ["Up",1];
titanium_reindeer.MouseRegionButtonEvent.Up.toString = $estr;
titanium_reindeer.MouseRegionButtonEvent.Up.__enum__ = titanium_reindeer.MouseRegionButtonEvent;
titanium_reindeer.MouseRegionButtonEvent.Click = ["Click",2];
titanium_reindeer.MouseRegionButtonEvent.Click.toString = $estr;
titanium_reindeer.MouseRegionButtonEvent.Click.__enum__ = titanium_reindeer.MouseRegionButtonEvent;
titanium_reindeer.MouseRegionHandler = $hxClasses["titanium_reindeer.MouseRegionHandler"] = function(manager,collisionComponent) {
	this.manager = manager;
	this.collisionRegion = collisionComponent;
	this.isMouseInside = false;
	this.isMouseButtonsDownInside = new IntHash();
	this.registeredMouseMoveEvents = new Array();
	this.registeredMouseEnterEvents = new Array();
	this.registeredMouseExitEvents = new Array();
	this.registeredMouseDownEvents = new Array();
	this.registeredMouseUpEvents = new Array();
	this.registeredMouseClickEvents = new Array();
	this.depth = 0;
};
titanium_reindeer.MouseRegionHandler.__name__ = ["titanium_reindeer","MouseRegionHandler"];
titanium_reindeer.MouseRegionHandler.prototype = {
	manager: null
	,collisionRegion: null
	,registeredMouseMoveEvents: null
	,registeredMouseEnterEvents: null
	,registeredMouseExitEvents: null
	,registeredMouseDownEvents: null
	,registeredMouseUpEvents: null
	,registeredMouseClickEvents: null
	,isMouseInside: null
	,isMouseButtonsDownInside: null
	,getIsMouseDownInside: function(mouseButton) {
		return this.isMouseButtonsDownInside.get(mouseButton[1]);
	}
	,depth: null
	,isBlockingBelow: null
	,setIsBlockingBelow: function(value) {
		if(value != this.isBlockingBelow) {
			this.isBlockingBelow = value;
			if(value) this.exclusionRegion = this.manager.createExclusionRegion(this.depth,this.collisionRegion.getShape()); else if(this.exclusionRegion != null) {
				this.exclusionRegion.destroy();
				this.exclusionRegion = null;
			}
		}
		return this.isBlockingBelow;
	}
	,exclusionRegion: null
	,mouseMove: function(mousePos,colliding) {
		if(colliding) {
			var _g = 0, _g1 = this.registeredMouseMoveEvents;
			while(_g < _g1.length) {
				var func = _g1[_g];
				++_g;
				func(mousePos);
			}
		}
		if(this.isMouseInside && !colliding) {
			var _g = 0, _g1 = this.registeredMouseExitEvents;
			while(_g < _g1.length) {
				var func = _g1[_g];
				++_g;
				func(mousePos);
			}
		} else if(!this.isMouseInside && colliding) {
			var _g = 0, _g1 = this.registeredMouseEnterEvents;
			while(_g < _g1.length) {
				var func = _g1[_g];
				++_g;
				func(mousePos);
			}
		}
		this.isMouseInside = colliding;
	}
	,mouseDown: function(mousePos,button,colliding) {
		if(colliding) {
			var _g = 0, _g1 = this.registeredMouseDownEvents;
			while(_g < _g1.length) {
				var func = _g1[_g];
				++_g;
				func(mousePos,button);
			}
		}
		this.isMouseButtonsDownInside.set(button[1],colliding);
	}
	,mouseUp: function(mousePos,button,colliding) {
		if(colliding) {
			var _g = 0, _g1 = this.registeredMouseUpEvents;
			while(_g < _g1.length) {
				var func = _g1[_g];
				++_g;
				func(mousePos,button);
			}
		}
		if(colliding && this.isMouseButtonsDownInside.get(button[1])) {
			var _g = 0, _g1 = this.registeredMouseClickEvents;
			while(_g < _g1.length) {
				var func = _g1[_g];
				++_g;
				func(mousePos,button);
			}
		}
		this.isMouseButtonsDownInside.set(button[1],false);
	}
	,registerMouseMoveEvent: function(mouseEvent,func) {
		if(func == null) return;
		switch( (mouseEvent)[1] ) {
		case 0:
			this.registeredMouseMoveEvents.push(func);
			break;
		case 1:
			this.registeredMouseEnterEvents.push(func);
			break;
		case 2:
			this.registeredMouseExitEvents.push(func);
			break;
		}
	}
	,registerMouseButtonEvent: function(mouseEvent,func) {
		if(func == null) return;
		switch( (mouseEvent)[1] ) {
		case 0:
			this.registeredMouseDownEvents.push(func);
			break;
		case 1:
			this.registeredMouseUpEvents.push(func);
			break;
		case 2:
			this.registeredMouseClickEvents.push(func);
			break;
		}
	}
	,unregisterMouseMoveEvent: function(mouseEvent,func) {
		if(func == null) return;
		var events;
		switch( (mouseEvent)[1] ) {
		case 0:
			events = this.registeredMouseMoveEvents;
			break;
		case 1:
			events = this.registeredMouseEnterEvents;
			break;
		case 2:
			events = this.registeredMouseExitEvents;
			break;
		}
		var _g1 = 0, _g = events.length;
		while(_g1 < _g) {
			var i = _g1++;
			while(i < events.length) if(Reflect.compareMethods(events[i],func)) events.splice(i,1); else break;
		}
	}
	,unregisterMouseButtonEvent: function(mouseEvent,func) {
		if(func == null) return;
		var events;
		switch( (mouseEvent)[1] ) {
		case 0:
			events = this.registeredMouseDownEvents;
			break;
		case 1:
			events = this.registeredMouseUpEvents;
			break;
		case 2:
			events = this.registeredMouseClickEvents;
			break;
		}
		var _g1 = 0, _g = events.length;
		while(_g1 < _g) {
			var i = _g1++;
			while(i < events.length) if(Reflect.compareMethods(events[i],func)) events.splice(i,1); else break;
		}
	}
	,destroy: function() {
		this.manager.removeHandler(this);
	}
	,finalDestroy: function() {
		this.collisionRegion = null;
		this.registeredMouseMoveEvents.splice(0,this.registeredMouseMoveEvents.length);
		this.registeredMouseMoveEvents = null;
		this.registeredMouseEnterEvents.splice(0,this.registeredMouseEnterEvents.length);
		this.registeredMouseEnterEvents = null;
		this.registeredMouseExitEvents.splice(0,this.registeredMouseExitEvents.length);
		this.registeredMouseExitEvents = null;
		this.registeredMouseDownEvents.splice(0,this.registeredMouseDownEvents.length);
		this.registeredMouseDownEvents = null;
		this.registeredMouseUpEvents.splice(0,this.registeredMouseUpEvents.length);
		this.registeredMouseUpEvents = null;
		this.registeredMouseClickEvents.splice(0,this.registeredMouseClickEvents.length);
		this.registeredMouseClickEvents = null;
	}
	,__class__: titanium_reindeer.MouseRegionHandler
	,__properties__: {set_isBlockingBelow:"setIsBlockingBelow"}
}
titanium_reindeer.MouseAction = $hxClasses["titanium_reindeer.MouseAction"] = { __ename__ : ["titanium_reindeer","MouseAction"], __constructs__ : ["Move","Down","Up"] }
titanium_reindeer.MouseAction.Move = ["Move",0];
titanium_reindeer.MouseAction.Move.toString = $estr;
titanium_reindeer.MouseAction.Move.__enum__ = titanium_reindeer.MouseAction;
titanium_reindeer.MouseAction.Down = ["Down",1];
titanium_reindeer.MouseAction.Down.toString = $estr;
titanium_reindeer.MouseAction.Down.__enum__ = titanium_reindeer.MouseAction;
titanium_reindeer.MouseAction.Up = ["Up",2];
titanium_reindeer.MouseAction.Up.toString = $estr;
titanium_reindeer.MouseAction.Up.__enum__ = titanium_reindeer.MouseAction;
titanium_reindeer.ExclusionsMaxDepthPair = $hxClasses["titanium_reindeer.ExclusionsMaxDepthPair"] = function(exclusions,maxDepth) {
	this.exclusions = exclusions;
	this.maxDepth = maxDepth;
};
titanium_reindeer.ExclusionsMaxDepthPair.__name__ = ["titanium_reindeer","ExclusionsMaxDepthPair"];
titanium_reindeer.ExclusionsMaxDepthPair.prototype = {
	exclusions: null
	,maxDepth: null
	,__class__: titanium_reindeer.ExclusionsMaxDepthPair
}
titanium_reindeer.ComponentHandlerPair = $hxClasses["titanium_reindeer.ComponentHandlerPair"] = function(component,handler) {
	this.component = component;
	this.handler = handler;
};
titanium_reindeer.ComponentHandlerPair.__name__ = ["titanium_reindeer","ComponentHandlerPair"];
titanium_reindeer.ComponentHandlerPair.prototype = {
	component: null
	,handler: null
	,__class__: titanium_reindeer.ComponentHandlerPair
}
titanium_reindeer.MouseRegionManager = $hxClasses["titanium_reindeer.MouseRegionManager"] = function(manager) {
	this.collisionManager = manager;
	this.collisionManager.scene.inputManager.registerMouseMoveEvent(this.mouseMoveHandle.$bind(this));
	this.collisionManager.scene.inputManager.registerMouseButtonAnyEvent(this.mouseButtonHandle.$bind(this));
	this.layerToPairsMap = new Hash();
	this.handlersToBeRemoved = new Array();
	this.exclusionRegions = new IntHash();
	this.exclusionRTree = new titanium_reindeer.RTreeFastInt();
	this.nextExclusionId = 0;
};
titanium_reindeer.MouseRegionManager.__name__ = ["titanium_reindeer","MouseRegionManager"];
titanium_reindeer.MouseRegionManager.prototype = {
	collisionManager: null
	,layerToPairsMap: null
	,handlersToBeRemoved: null
	,exclusionRegions: null
	,exclusionRTree: null
	,nextExclusionId: null
	,getHandler: function(component) {
		if(component == null) return null;
		if(component.id == null) return null;
		var handler;
		var pairs;
		if(this.layerToPairsMap.exists(component.layerName)) pairs = this.layerToPairsMap.get(component.layerName); else {
			pairs = new IntHash();
			this.layerToPairsMap.set(component.layerName,pairs);
		}
		if(pairs.exists(component.id)) handler = pairs.get(component.id).handler; else {
			handler = new titanium_reindeer.MouseRegionHandler(this,component);
			pairs.set(component.id,new titanium_reindeer.ComponentHandlerPair(component,handler));
		}
		return handler;
	}
	,removeHandler: function(handler) {
		if(handler == null || handler.collisionRegion == null) return;
		var pairs;
		if(this.layerToPairsMap.exists(handler.collisionRegion.layerName)) pairs = this.layerToPairsMap.get(handler.collisionRegion.layerName); else return;
		if(pairs.exists(handler.collisionRegion.id)) this.handlersToBeRemoved.push(handler);
	}
	,removeHandlers: function() {
		if(this.handlersToBeRemoved.length > 0) {
			var _g = 0, _g1 = this.handlersToBeRemoved;
			while(_g < _g1.length) {
				var handler = _g1[_g];
				++_g;
				var pairs;
				if(this.layerToPairsMap.exists(handler.collisionRegion.layerName)) pairs = this.layerToPairsMap.get(handler.collisionRegion.layerName); else return;
				pairs.remove(handler.collisionRegion.id);
				handler.finalDestroy();
			}
			this.handlersToBeRemoved = new Array();
		}
	}
	,createExclusionRegion: function(depth,shape) {
		if(shape == null) return null;
		var newExclusionRegion = new titanium_reindeer.MouseExclusionRegion(this,this.nextExclusionId,depth,shape);
		this.exclusionRegions.set(this.nextExclusionId,newExclusionRegion);
		this.exclusionRTree.insert(shape.getMinBoundingRect(),this.nextExclusionId);
		this.nextExclusionId += 1;
		return newExclusionRegion;
	}
	,updateExclusionRegionShape: function(exclusionRegion) {
		if(exclusionRegion == null || !this.exclusionRegions.exists(exclusionRegion.id)) return;
		this.exclusionRTree.update(exclusionRegion.shape.getMinBoundingRect(),exclusionRegion.id);
	}
	,removeExclusionRegion: function(exclusionRegion) {
		if(exclusionRegion == null || !this.exclusionRegions.exists(exclusionRegion.id)) return;
		this.exclusionRegions.remove(exclusionRegion.id);
		this.exclusionRTree.remove(exclusionRegion.id);
	}
	,mouseMoveHandle: function(mousePos) {
		this.handleAction(titanium_reindeer.MouseAction.Move,mousePos,titanium_reindeer.MouseButton.None);
	}
	,mouseButtonHandle: function(button,buttonState,mousePos) {
		var action;
		if(buttonState == titanium_reindeer.MouseButtonState.Down) action = titanium_reindeer.MouseAction.Down; else if(buttonState == titanium_reindeer.MouseButtonState.Up) action = titanium_reindeer.MouseAction.Up; else return;
		this.handleAction(action,mousePos,button);
	}
	,handleAction: function(action,mousePos,button) {
		if(Lambda.count(this.layerToPairsMap) <= 0) return;
		var $it0 = this.layerToPairsMap.keys();
		while( $it0.hasNext() ) {
			var layerName = $it0.next();
			var pairs = this.layerToPairsMap.get(layerName);
			var foundPairs = new IntHash();
			var collidingIds = this.collisionManager.getLayer(layerName).getIdsIntersectingPoint(mousePos);
			var _g = 0;
			while(_g < collidingIds.length) {
				var id = collidingIds[_g];
				++_g;
				if(pairs.exists(id)) foundPairs.set(id,true);
			}
			var exclusionResults = null;
			var $it1 = pairs.keys();
			while( $it1.hasNext() ) {
				var id = $it1.next();
				var colliding = foundPairs.exists(id);
				var handler = pairs.get(id).handler;
				if(colliding) {
					if(exclusionResults == null) exclusionResults = this.organizeIntersectingExclusions(mousePos);
					var handlersExclusion = -1;
					if(handler.isBlockingBelow) handlersExclusion = handler.exclusionRegion.id;
					var _g1 = handler.depth, _g = exclusionResults.maxDepth + 1;
					while(_g1 < _g) {
						var d = _g1++;
						if(exclusionResults.exclusions.exists(d)) {
							var _g2 = 0, _g3 = exclusionResults.exclusions.get(d);
							while(_g2 < _g3.length) {
								var exclusion = _g3[_g2];
								++_g2;
								if(exclusion.id != handlersExclusion) {
									colliding = false;
									break;
								}
							}
							if(!colliding) break;
						}
					}
				}
				switch( (action)[1] ) {
				case 0:
					handler.mouseMove(mousePos,colliding);
					break;
				case 1:
					handler.mouseDown(mousePos,button,colliding);
					break;
				case 2:
					handler.mouseUp(mousePos,button,colliding);
					break;
				}
			}
		}
	}
	,organizeIntersectingExclusions: function(mousePos) {
		var exclusionIds = this.exclusionRTree.getPointIntersectingValues(mousePos);
		var exclusionRegions = new IntHash();
		var regions;
		var maxDepth = 0;
		var _g = 0;
		while(_g < exclusionIds.length) {
			var id = exclusionIds[_g];
			++_g;
			var exclusionRegion = this.exclusionRegions.get(id);
			if(exclusionRegions.exists(exclusionRegion.depth)) regions = exclusionRegions.get(exclusionRegion.depth); else {
				regions = new Array();
				exclusionRegions.set(exclusionRegion.depth,regions);
			}
			regions.push(exclusionRegion);
			if(exclusionRegion.depth > maxDepth) maxDepth = exclusionRegion.depth;
		}
		return new titanium_reindeer.ExclusionsMaxDepthPair(exclusionRegions,maxDepth);
	}
	,destroy: function() {
		this.collisionManager.scene.inputManager.unregisterMouseMoveEvent(this.mouseMoveHandle.$bind(this));
		this.collisionManager.scene.inputManager.unregisterMouseButtonAnyEvent(this.mouseButtonHandle.$bind(this));
		this.removeHandlers();
		this.handlersToBeRemoved = null;
		this.collisionManager = null;
		var $it0 = this.layerToPairsMap.keys();
		while( $it0.hasNext() ) {
			var layerName = $it0.next();
			var pairs = this.layerToPairsMap.get(layerName);
			var $it1 = pairs.keys();
			while( $it1.hasNext() ) {
				var id = $it1.next();
				pairs.get(id).handler.finalDestroy();
				pairs.get(id).handler = null;
				pairs.get(id).component = null;
				pairs.remove(id);
			}
			this.layerToPairsMap.remove(layerName);
		}
		this.layerToPairsMap = null;
	}
	,__class__: titanium_reindeer.MouseRegionManager
}
titanium_reindeer.MovementComponent = $hxClasses["titanium_reindeer.MovementComponent"] = function(velocity) {
	titanium_reindeer.Component.call(this);
	this.setVelocity(velocity == null?new titanium_reindeer.Vector2(0,0):velocity);
};
titanium_reindeer.MovementComponent.__name__ = ["titanium_reindeer","MovementComponent"];
titanium_reindeer.MovementComponent.__super__ = titanium_reindeer.Component;
titanium_reindeer.MovementComponent.prototype = $extend(titanium_reindeer.Component.prototype,{
	velocity: null
	,setVelocity: function(value) {
		if(value != null && !value.equal(this.velocity)) this.velocity = value.getCopy();
		return this.velocity;
	}
	,move: function(msTimeStep) {
		this.owner.getPosition().addTo(this.velocity.getExtend(msTimeStep / 1000));
	}
	,getManagerType: function() {
		return titanium_reindeer.MovementComponentManager;
	}
	,destroy: function() {
		titanium_reindeer.Component.prototype.destroy.call(this);
		this.setVelocity(null);
	}
	,__class__: titanium_reindeer.MovementComponent
	,__properties__: $extend(titanium_reindeer.Component.prototype.__properties__,{set_velocity:"setVelocity"})
});
titanium_reindeer.MovementComponentManager = $hxClasses["titanium_reindeer.MovementComponentManager"] = function(scene) {
	titanium_reindeer.ComponentManager.call(this,scene);
};
titanium_reindeer.MovementComponentManager.__name__ = ["titanium_reindeer","MovementComponentManager"];
titanium_reindeer.MovementComponentManager.__super__ = titanium_reindeer.ComponentManager;
titanium_reindeer.MovementComponentManager.prototype = $extend(titanium_reindeer.ComponentManager.prototype,{
	update: function(msTimeStep) {
		var _g = 0, _g1 = this.getComponents();
		while(_g < _g1.length) {
			var component = _g1[_g];
			++_g;
			if((function($this) {
				var $r;
				var $t = component;
				if(Std["is"]($t,titanium_reindeer.MovementComponent)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this)) != null && component.enabled) ((function($this) {
				var $r;
				var $t = component;
				if(Std["is"]($t,titanium_reindeer.MovementComponent)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this))).move(msTimeStep);
		}
	}
	,__class__: titanium_reindeer.MovementComponentManager
});
titanium_reindeer.PatternOption = $hxClasses["titanium_reindeer.PatternOption"] = { __ename__ : ["titanium_reindeer","PatternOption"], __constructs__ : ["Repeat","RepeatX","RepeatY","NoRepeat"] }
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
titanium_reindeer.Pattern = $hxClasses["titanium_reindeer.Pattern"] = function(imageSource,option) {
	this.imageSource = imageSource;
	this.option = option;
};
titanium_reindeer.Pattern.__name__ = ["titanium_reindeer","Pattern"];
titanium_reindeer.Pattern.prototype = {
	imageSource: null
	,option: null
	,getStyle: function(pen) {
		var option;
		switch( (this.option)[1] ) {
		case 0:
			option = "repeat";
			break;
		case 1:
			option = "repeat-x";
			break;
		case 2:
			option = "repeat-y";
			break;
		case 3:
			option = "no-repeat";
			break;
		}
		return pen.createPattern(this.imageSource.image,option);
	}
	,identify: function() {
		return "Pattern(" + this.imageSource.identify() + "," + this.option[0] + ");";
	}
	,__class__: titanium_reindeer.Pattern
}
titanium_reindeer.PixelatedEffect = $hxClasses["titanium_reindeer.PixelatedEffect"] = function(amount) {
	titanium_reindeer.BitmapEffect.call(this);
	this.amount = amount;
};
titanium_reindeer.PixelatedEffect.__name__ = ["titanium_reindeer","PixelatedEffect"];
titanium_reindeer.PixelatedEffect.__super__ = titanium_reindeer.BitmapEffect;
titanium_reindeer.PixelatedEffect.prototype = $extend(titanium_reindeer.BitmapEffect.prototype,{
	amount: null
	,apply: function(bitmapData) {
		if(bitmapData == null) return;
		var rows = Math.ceil(bitmapData.getHeight() / this.amount);
		var cols = Math.ceil(bitmapData.getWidth() / this.amount);
		var _g = 0;
		while(_g < rows) {
			var r = _g++;
			var _g1 = 0;
			while(_g1 < cols) {
				var c = _g1++;
				var currentSize = 0;
				var averageRed = 0;
				var averageGreen = 0;
				var averageBlue = 0;
				var _g3 = 0, _g2 = this.amount;
				while(_g3 < _g2) {
					var i = _g3++;
					var horizontal = c * this.amount + i;
					if(horizontal > bitmapData.getWidth()) continue;
					var _g5 = 0, _g4 = this.amount;
					while(_g5 < _g4) {
						var j = _g5++;
						var vertical = r * this.amount + j;
						if(vertical > bitmapData.getHeight()) continue;
						var index = (horizontal + vertical * bitmapData.getWidth()) * 4;
						if(bitmapData.getData()[index + 3] > 0) {
							averageRed += bitmapData.getData()[index];
							averageGreen += bitmapData.getData()[index + 1];
							averageBlue += bitmapData.getData()[index + 2];
							++currentSize;
						}
					}
				}
				var _g3 = 0, _g2 = this.amount;
				while(_g3 < _g2) {
					var i = _g3++;
					var horizontal = c * this.amount + i;
					if(horizontal > bitmapData.getWidth()) continue;
					var _g5 = 0, _g4 = this.amount;
					while(_g5 < _g4) {
						var j = _g5++;
						var vertical = r * this.amount + j;
						if(vertical > bitmapData.getHeight()) continue;
						var index = (horizontal + vertical * bitmapData.getWidth()) * 4;
						if(bitmapData.getData()[index + 3] > 0) {
							bitmapData.getData()[index] = titanium_reindeer.Utility.clampFloat(averageRed / currentSize,0,255);
							bitmapData.getData()[index + 1] = titanium_reindeer.Utility.clampFloat(averageGreen / currentSize,0,255);
							bitmapData.getData()[index + 2] = titanium_reindeer.Utility.clampFloat(averageBlue / currentSize,0,255);
						}
					}
				}
			}
		}
	}
	,identify: function() {
		return "Pixelate(" + this.amount + ");";
	}
	,__class__: titanium_reindeer.PixelatedEffect
});
titanium_reindeer.RTreeFastNode = $hxClasses["titanium_reindeer.RTreeFastNode"] = function(bounds) {
	this.bounds = bounds;
};
titanium_reindeer.RTreeFastNode.__name__ = ["titanium_reindeer","RTreeFastNode"];
titanium_reindeer.RTreeFastNode.prototype = {
	bounds: null
	,parent: null
	,__class__: titanium_reindeer.RTreeFastNode
}
titanium_reindeer.RTreeFastLeaf = $hxClasses["titanium_reindeer.RTreeFastLeaf"] = function(bounds,value) {
	titanium_reindeer.RTreeFastNode.call(this,bounds);
	this.value = value;
};
titanium_reindeer.RTreeFastLeaf.__name__ = ["titanium_reindeer","RTreeFastLeaf"];
titanium_reindeer.RTreeFastLeaf.__super__ = titanium_reindeer.RTreeFastNode;
titanium_reindeer.RTreeFastLeaf.prototype = $extend(titanium_reindeer.RTreeFastNode.prototype,{
	value: null
	,__class__: titanium_reindeer.RTreeFastLeaf
});
titanium_reindeer.RTreeFastBranch = $hxClasses["titanium_reindeer.RTreeFastBranch"] = function(bounds) {
	titanium_reindeer.RTreeFastNode.call(this,bounds);
	this.children = new Array();
	this.isLeaf = false;
};
titanium_reindeer.RTreeFastBranch.__name__ = ["titanium_reindeer","RTreeFastBranch"];
titanium_reindeer.RTreeFastBranch.__super__ = titanium_reindeer.RTreeFastNode;
titanium_reindeer.RTreeFastBranch.prototype = $extend(titanium_reindeer.RTreeFastNode.prototype,{
	children: null
	,isLeaf: null
	,addChild: function(node) {
		this.children.push(node);
		node.parent = this;
	}
	,recalculateBounds: function() {
		if(this.children.length > 0) {
			var newBounds = this.children[0].bounds;
			var _g1 = 1, _g = this.children.length;
			while(_g1 < _g) {
				var i = _g1++;
				newBounds = titanium_reindeer.Rect.expandToCover(newBounds,this.children[i].bounds);
			}
			this.bounds = newBounds;
		}
	}
	,__class__: titanium_reindeer.RTreeFastBranch
});
titanium_reindeer.RTreeFastInt = $hxClasses["titanium_reindeer.RTreeFastInt"] = function() {
	this.setMaxChildren(3);
	this.intMap = new IntHash();
};
titanium_reindeer.RTreeFastInt.__name__ = ["titanium_reindeer","RTreeFastInt"];
titanium_reindeer.RTreeFastInt.__interfaces__ = [titanium_reindeer.SpacePartition];
titanium_reindeer.RTreeFastInt.prototype = {
	maxChildren: null
	,setMaxChildren: function(value) {
		if(value > 1) this.maxChildren = value;
		return this.maxChildren;
	}
	,root: null
	,intMap: null
	,debugCanvas: null
	,debugOffset: null
	,debugSteps: null
	,insert: function(rect,value) {
		if(this.intMap.exists(value)) return;
		var leaf;
		if(this.root == null) {
			this.root = new titanium_reindeer.RTreeFastBranch(rect.getCopy());
			leaf = new titanium_reindeer.RTreeFastLeaf(rect.getCopy(),value);
			this.root.addChild(leaf);
			this.intMap.set(value,leaf);
			this.root.isLeaf = true;
			return;
		}
		var currentNode = this.root;
		var intersection;
		var continueSearching = true;
		while(continueSearching) if(currentNode.isLeaf) {
			leaf = new titanium_reindeer.RTreeFastLeaf(rect.getCopy(),value);
			this.addChildToNode(currentNode,leaf);
			this.intMap.set(value,leaf);
			continueSearching = false;
		} else {
			var leastExpansion = Math.POSITIVE_INFINITY;
			var leastBranch = null;
			var _g = 0, _g1 = currentNode.children;
			while(_g < _g1.length) {
				var node = _g1[_g];
				++_g;
				var branch = (function($this) {
					var $r;
					var $t = node;
					if(Std["is"]($t,titanium_reindeer.RTreeFastBranch)) $t; else throw "Class cast error";
					$r = $t;
					return $r;
				}(this));
				intersection = titanium_reindeer.Rect.getIntersection(branch.bounds,rect);
				if(intersection != null) {
					var leastArea = rect.getArea() - intersection.getArea();
					if(leastExpansion > leastArea) {
						leastExpansion = leastArea;
						leastBranch = branch;
					}
				}
			}
			if(leastBranch == null) {
				var newBranch = new titanium_reindeer.RTreeFastBranch(rect.getCopy());
				this.addChildToNode(currentNode,newBranch);
				leaf = new titanium_reindeer.RTreeFastLeaf(rect.getCopy(),value);
				this.addChildToNode(newBranch,leaf);
				this.intMap.set(value,leaf);
				continueSearching = false;
			} else {
				currentNode.bounds = titanium_reindeer.Rect.expandToCover(currentNode.bounds,rect);
				currentNode = leastBranch;
			}
		}
		if(this.debugSteps) this.drawDebug();
	}
	,addChildToNode: function(parent,child) {
		parent.addChild(child);
		parent.bounds = titanium_reindeer.Rect.expandToCover(parent.bounds,child.bounds);
		if(parent.children.length <= this.maxChildren) {
			if(parent.children.length == 1 && Std["is"](child,titanium_reindeer.RTreeFastLeaf)) parent.isLeaf = true;
		} else this.linearSplit(parent);
	}
	,linearSplit: function(parent) {
		var compareOnX = parent.bounds.width > parent.bounds.height;
		var seedA = null;
		var children = new Array();
		while(parent.children.length > 0) {
			var node = parent.children.pop();
			if(seedA == null) {
				if(compareOnX) {
					if(Math.abs(node.bounds.getLeft() - parent.bounds.getLeft()) < 1) {
						seedA = node;
						continue;
					}
				} else if(Math.abs(node.bounds.getTop() - parent.bounds.getTop()) < 1) {
					seedA = node;
					continue;
				}
			}
			children.push(node);
		}
		var leastDist = Math.POSITIVE_INFINITY;
		var leastIndex = -1;
		var _g1 = 0, _g = children.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(compareOnX) {
				if(parent.bounds.getRight() - children[i].bounds.getRight() < leastDist) {
					leastDist = parent.bounds.getRight() - children[i].bounds.getRight();
					leastIndex = i;
				}
			} else if(parent.bounds.getBottom() - children[i].bounds.getBottom() < leastDist) {
				leastDist = parent.bounds.getBottom() - children[i].bounds.getBottom();
				leastIndex = i;
			}
		}
		var seedB = children[leastIndex];
		children.splice(leastIndex,1);
		if(seedA == null) {
			var x = 2;
		}
		var branchA = new titanium_reindeer.RTreeFastBranch(seedA.bounds.getCopy());
		branchA.addChild(seedA);
		var branchB = new titanium_reindeer.RTreeFastBranch(seedB.bounds.getCopy());
		branchB.addChild(seedB);
		while(children.length > 0) {
			var node = children.pop();
			var branch;
			var aDist;
			var bDist;
			if(compareOnX) {
				aDist = node.bounds.getLeft() - seedA.bounds.getLeft();
				bDist = seedB.bounds.getRight() - node.bounds.getRight();
			} else {
				aDist = node.bounds.getTop() - seedA.bounds.getTop();
				bDist = seedB.bounds.getBottom() - node.bounds.getBottom();
			}
			if(aDist < bDist) branch = branchA; else if(bDist < aDist) branch = branchB; else if(branchA.children.length < branchB.children.length) branch = branchA; else branch = branchB;
			branch.bounds = titanium_reindeer.Rect.expandToCover(branch.bounds,node.bounds);
			branch.addChild(node);
		}
		branchA.isLeaf = parent.isLeaf;
		branchB.isLeaf = parent.isLeaf;
		parent.children = new Array();
		if(branchA.children.length == 1 && !branchA.isLeaf) parent.addChild(branchA.children.pop()); else parent.addChild(branchA);
		if(branchB.children.length == 1 && !branchB.isLeaf) parent.addChild(branchB.children.pop()); else parent.addChild(branchB);
		parent.isLeaf = false;
		if(this.debugSteps) this.drawDebug();
	}
	,update: function(newBounds,value) {
		if(!this.intMap.exists(value)) return;
		var leaf = this.intMap.get(value);
		leaf.bounds = newBounds;
		this.updateNodeHierarchy(leaf);
	}
	,remove: function(value) {
		if(!this.intMap.exists(value)) return;
		var leaf = this.intMap.get(value);
		this.intMap.remove(value);
		var parent = leaf.parent;
		leaf.parent = null;
		if(parent.children.length > 1) {
			var _g1 = 0, _g = parent.children.length;
			while(_g1 < _g) {
				var i = _g1++;
				if(parent.children[i] == leaf) {
					parent.children.splice(i,1);
					break;
				}
			}
		} else {
			parent.children.pop();
			var nextParent = parent.parent;
			var timeToStop = false;
			while(nextParent != null) {
				if(nextParent.children.length == 1) nextParent.children.pop(); else {
					var _g1 = 0, _g = nextParent.children.length;
					while(_g1 < _g) {
						var i = _g1++;
						if(nextParent.children[i] == parent) {
							nextParent.children.splice(i,1);
							break;
						}
					}
					timeToStop = true;
				}
				parent.parent = null;
				parent = nextParent;
				if(timeToStop) break;
				nextParent = nextParent.parent;
			}
			if(!timeToStop) {
				this.root = null;
				return;
			}
		}
		if(parent.children.length == 1 && parent.parent != null) {
			if(parent.parent.children.length == 1) {
				parent.parent.children.pop();
				var child = parent.children.pop();
				child.parent = parent.parent;
				parent.parent.isLeaf = parent.isLeaf;
				parent.parent.children.push(child);
				parent.parent = null;
				parent = child.parent;
			}
			if(!parent.isLeaf) {
				var child = (function($this) {
					var $r;
					var $t = parent.children[0];
					if(Std["is"]($t,titanium_reindeer.RTreeFastBranch)) $t; else throw "Class cast error";
					$r = $t;
					return $r;
				}(this));
				if(child.children.length == 1) {
					parent.children.pop();
					parent.isLeaf = child.isLeaf;
					parent.addChild(child.children.pop());
					child.parent = null;
				}
			}
		}
		parent.recalculateBounds();
		this.updateNodeHierarchy(parent);
		if(this.debugSteps) this.drawDebug();
	}
	,updateNodeHierarchy: function(node) {
		var updatedNode = node;
		var nextParent = node.parent;
		while(nextParent != null) {
			if(!titanium_reindeer.Rect.isIntersecting(nextParent.bounds,updatedNode.bounds) && nextParent.parent != null) {
				var closestParent = null;
				var closestDistance = Math.POSITIVE_INFINITY;
				var parent;
				var distance;
				var _g1 = 0, _g = nextParent.parent.children.length;
				while(_g1 < _g) {
					var i = _g1++;
					parent = (function($this) {
						var $r;
						var $t = nextParent.parent.children[i];
						if(Std["is"]($t,titanium_reindeer.RTreeFastBranch)) $t; else throw "Class cast error";
						$r = $t;
						return $r;
					}(this));
					if(parent.isLeaf != nextParent.isLeaf) continue;
					distance = Math.abs(parent.bounds.x - updatedNode.bounds.x) + Math.abs(parent.bounds.y - updatedNode.bounds.y);
					if(closestParent == null || distance < closestDistance) {
						closestDistance = distance;
						closestParent = parent;
					}
				}
				if(closestParent != nextParent) {
					var _g1 = 0, _g = nextParent.children.length;
					while(_g1 < _g) {
						var i = _g1++;
						if(nextParent.children[i] == updatedNode) {
							nextParent.children.splice(i,1);
							break;
						}
					}
					this.addChildToNode(closestParent,updatedNode);
					var currentBranch = closestParent.parent;
					while(currentBranch != null) {
						titanium_reindeer.Rect.expandToCover(currentBranch.bounds,updatedNode.bounds);
						currentBranch = currentBranch.parent;
					}
				}
			}
			if(nextParent.children.length <= 0) {
				if(nextParent.parent != null) {
					updatedNode = nextParent.parent;
					var _g1 = 0, _g = nextParent.parent.children.length;
					while(_g1 < _g) {
						var i = _g1++;
						if(nextParent.parent.children[i] == nextParent) {
							nextParent.parent.children.splice(i,1);
							nextParent.parent = null;
							break;
						}
					}
					nextParent = updatedNode.parent;
				} else nextParent = null;
			} else {
				nextParent.recalculateBounds();
				updatedNode = nextParent;
				nextParent = nextParent.parent;
			}
		}
	}
	,getRectIntersectingValues: function(rect) {
		if(this.root == null) return [];
		var results = new Array();
		var currentNodes = new Array();
		currentNodes.push(this.root);
		var searchNodes;
		var continueSearching = true;
		while(continueSearching) {
			searchNodes = new Array();
			while(currentNodes.length > 0) searchNodes.push(currentNodes.pop());
			var anyNonLeafs = false;
			var _g = 0;
			while(_g < searchNodes.length) {
				var node = searchNodes[_g];
				++_g;
				if(!node.isLeaf) anyNonLeafs = true;
				var _g1 = 0, _g2 = node.children;
				while(_g1 < _g2.length) {
					var child = _g2[_g1];
					++_g1;
					if(titanium_reindeer.Rect.isIntersecting(rect,child.bounds)) {
						if(Std["is"](child,titanium_reindeer.RTreeFastLeaf)) results.push(((function($this) {
							var $r;
							var $t = child;
							if(Std["is"]($t,titanium_reindeer.RTreeFastLeaf)) $t; else throw "Class cast error";
							$r = $t;
							return $r;
						}(this))).value); else currentNodes.push((function($this) {
							var $r;
							var $t = child;
							if(Std["is"]($t,titanium_reindeer.RTreeFastBranch)) $t; else throw "Class cast error";
							$r = $t;
							return $r;
						}(this)));
					}
				}
			}
			continueSearching = anyNonLeafs;
		}
		return results;
	}
	,getPointIntersectingValues: function(point) {
		if(this.root == null) return [];
		var results = new Array();
		var currentNodes = new Array();
		currentNodes.push(this.root);
		var searchNodes;
		var continueSearching = true;
		while(continueSearching) {
			searchNodes = new Array();
			while(currentNodes.length > 0) searchNodes.push(currentNodes.pop());
			var anyNonLeafs = false;
			var _g = 0;
			while(_g < searchNodes.length) {
				var node = searchNodes[_g];
				++_g;
				if(!node.isLeaf) anyNonLeafs = true;
				var _g1 = 0, _g2 = node.children;
				while(_g1 < _g2.length) {
					var child = _g2[_g1];
					++_g1;
					if(child.bounds.isPointInside(point)) {
						if(Std["is"](child,titanium_reindeer.RTreeFastLeaf)) results.push(((function($this) {
							var $r;
							var $t = child;
							if(Std["is"]($t,titanium_reindeer.RTreeFastLeaf)) $t; else throw "Class cast error";
							$r = $t;
							return $r;
						}(this))).value); else currentNodes.push((function($this) {
							var $r;
							var $t = child;
							if(Std["is"]($t,titanium_reindeer.RTreeFastBranch)) $t; else throw "Class cast error";
							$r = $t;
							return $r;
						}(this)));
					}
				}
			}
			continueSearching = anyNonLeafs;
		}
		return results;
	}
	,drawDebug: function() {
		if(this.root == null) return;
		var canvas = js.Lib.document.getElementById(this.debugCanvas);
		var pen = canvas.getContext("2d");
		pen.fillStyle = "#FFFFFF";
		pen.fillRect(0,0,1000,1000);
		pen.strokeStyle = "#000000";
		pen.textAlign = "center";
		pen.textBaseline = "middle";
		pen.font = "20pt Arial";
		var currentNodes = new Array();
		var nextNodes = new Array();
		nextNodes.push(this.root);
		var node;
		var level = 0;
		while(nextNodes.length > 0) {
			while(nextNodes.length > 0) currentNodes.push(nextNodes.pop());
			while(currentNodes.length > 0) {
				node = currentNodes.pop();
				pen.strokeRect(node.bounds.x + this.debugOffset.getX(),node.bounds.y + this.debugOffset.getY(),node.bounds.width,node.bounds.height);
				pen.strokeText(level + "",node.bounds.x + this.debugOffset.getX() + node.bounds.width / 2,node.bounds.y + this.debugOffset.getY() + node.bounds.height / 2);
				if(Std["is"](node,titanium_reindeer.RTreeFastBranch)) {
					var branch = (function($this) {
						var $r;
						var $t = node;
						if(Std["is"]($t,titanium_reindeer.RTreeFastBranch)) $t; else throw "Class cast error";
						$r = $t;
						return $r;
					}(this));
					var _g1 = 0, _g = branch.children.length;
					while(_g1 < _g) {
						var i = _g1++;
						nextNodes.push(branch.children[i]);
					}
				}
			}
			level++;
		}
	}
	,__class__: titanium_reindeer.RTreeFastInt
	,__properties__: {set_maxChildren:"setMaxChildren"}
}
titanium_reindeer.Rect = $hxClasses["titanium_reindeer.Rect"] = function(x,y,width,height) {
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
};
titanium_reindeer.Rect.__name__ = ["titanium_reindeer","Rect"];
titanium_reindeer.Rect.isIntersecting = function(a,b) {
	return a.x + a.width >= b.x && a.x <= b.x + b.width && a.y + a.height >= b.y && a.y <= b.y + b.height;
}
titanium_reindeer.Rect.getIntersection = function(a,b) {
	if(a.x + a.width >= b.x && a.x <= b.x + b.width && a.y + a.height >= b.y && a.y <= b.y + b.height) {
		var left = Math.max(a.x,b.x);
		var top = Math.max(a.y,b.y);
		return new titanium_reindeer.Rect(left,top,Math.min(a.x + a.width,b.x + b.width) - left,Math.min(a.y + a.height,b.y + b.height) - top);
	} else return null;
}
titanium_reindeer.Rect.isWithin = function(a,b) {
	return a.x <= b.x && a.x + a.width >= b.x + b.width && a.y <= b.y && a.y + a.height >= b.y + b.height;
}
titanium_reindeer.Rect.expandToCover = function(coverage,toFit) {
	if(coverage == null) {
		if(toFit == null) return null; else return toFit.getCopy();
	} else if(toFit == null) return coverage.getCopy();
	var x = Math.min(coverage.x,toFit.x);
	var y = Math.min(coverage.y,toFit.y);
	return new titanium_reindeer.Rect(x,y,Math.max(coverage.getRight(),toFit.getRight()) - x,Math.max(coverage.getBottom(),toFit.getBottom()) - y);
}
titanium_reindeer.Rect.__super__ = titanium_reindeer.Shape;
titanium_reindeer.Rect.prototype = $extend(titanium_reindeer.Shape.prototype,{
	x: null
	,y: null
	,width: null
	,height: null
	,top: null
	,getTop: function() {
		return this.y;
	}
	,bottom: null
	,getBottom: function() {
		return this.y + this.height;
	}
	,left: null
	,getLeft: function() {
		return this.x;
	}
	,right: null
	,getRight: function() {
		return this.x + this.width;
	}
	,getMinBoundingRect: function() {
		return this.getCopy();
	}
	,isPointInside: function(p) {
		return p.getX() >= this.getLeft() && p.getX() < this.getRight() && p.getY() >= this.getTop() && p.getY() < this.getBottom();
	}
	,getCopy: function() {
		return new titanium_reindeer.Rect(this.x,this.y,this.width,this.height);
	}
	,getArea: function() {
		return this.width * this.height;
	}
	,__class__: titanium_reindeer.Rect
	,__properties__: {get_right:"getRight",get_left:"getLeft",get_bottom:"getBottom",get_top:"getTop"}
});
titanium_reindeer.RectRenderer = $hxClasses["titanium_reindeer.RectRenderer"] = function(width,height,layer) {
	titanium_reindeer.StrokeFillRenderer.call(this,width,height,layer);
	this.setWidth(width);
	this.setHeight(height);
};
titanium_reindeer.RectRenderer.__name__ = ["titanium_reindeer","RectRenderer"];
titanium_reindeer.RectRenderer.__super__ = titanium_reindeer.StrokeFillRenderer;
titanium_reindeer.RectRenderer.prototype = $extend(titanium_reindeer.StrokeFillRenderer.prototype,{
	width: null
	,setWidth: function(value) {
		if(this.width != value) {
			this.setInitialWidth(value);
			this.width = value;
		}
		return this.width;
	}
	,height: null
	,setHeight: function(value) {
		if(this.height != value) {
			this.setInitialHeight(value);
			this.height = value;
		}
		return this.height;
	}
	,render: function() {
		titanium_reindeer.StrokeFillRenderer.prototype.render.call(this);
		var x = -this.width / 2;
		var y = -this.height / 2;
		this.getPen().fillRect(x,y,this.width,this.height);
		if(this.lineWidth > 0) this.getPen().strokeRect(x + this.lineWidth / 2,y + this.lineWidth / 2,this.width - this.lineWidth,this.height - this.lineWidth);
	}
	,identify: function() {
		return titanium_reindeer.StrokeFillRenderer.prototype.identify.call(this) + "Rect();";
	}
	,__class__: titanium_reindeer.RectRenderer
	,__properties__: $extend(titanium_reindeer.StrokeFillRenderer.prototype.__properties__,{set_height:"setHeight",set_width:"setWidth"})
});
titanium_reindeer.RenderLayer = $hxClasses["titanium_reindeer.RenderLayer"] = function(layerManager,id,targetElement,width,height,clearColor) {
	this.layerManager = layerManager;
	this.id = id;
	this.canvas = js.Lib.document.createElement("canvas");
	this.canvas.setAttribute("width",width + "px");
	this.canvas.setAttribute("height",height + "px");
	this.canvas.id = "layer" + this.id;
	this.pen = this.canvas.getContext("2d");
	this.width = width;
	this.height = height;
	this.setClearColor(clearColor);
	this.setRenderComposition(titanium_reindeer.Composition.SourceOver);
	this.setVisible(true);
	this.setAlpha(1);
	this.watchedOffset = new titanium_reindeer.WatchedVector2(0,0,this.offsetChanged.$bind(this));
	this.renderers = new IntHash();
	this.redrawBackground = true;
};
titanium_reindeer.RenderLayer.__name__ = ["titanium_reindeer","RenderLayer"];
titanium_reindeer.RenderLayer.prototype = {
	layerManager: null
	,id: null
	,pen: null
	,canvas: null
	,clearColor: null
	,setClearColor: function(color) {
		if(color != null) {
			if(this.clearColor == null || color.equal(this.clearColor)) {
				this.clearColor = color.getCopy();
				this.redrawBackground = true;
			}
		}
		return this.clearColor;
	}
	,renderComposition: null
	,setRenderComposition: function(comp) {
		if(comp != this.renderComposition) {
			this.renderComposition = comp;
			this.redrawBackground = true;
		}
		return this.renderComposition;
	}
	,visible: null
	,setVisible: function(value) {
		if(value != this.visible) {
			this.visible = value;
			if(this.visible) this.redrawBackground = true;
		}
		return this.visible;
	}
	,alpha: null
	,setAlpha: function(value) {
		if(value != this.alpha && value >= 0 && value <= 1) this.alpha = value;
		return this.alpha;
	}
	,width: null
	,height: null
	,watchedOffset: null
	,renderOffset: null
	,getOffset: function() {
		return this.watchedOffset;
	}
	,setOffset: function(value) {
		if(value != null) {
			if(this.watchedOffset != value && !this.watchedOffset.equal(value)) {
				this.watchedOffset.setVector2(value);
				this.offsetChanged();
				this.redrawBackground = true;
			}
		}
		return this.getOffset();
	}
	,redrawBackground: null
	,renderers: null
	,renderersYetToRedraw: null
	,renderersToRedraw: null
	,clearing: null
	,offsetChanged: function() {
		if(this.renderers != null) {
			var $it0 = this.renderers.iterator();
			while( $it0.hasNext() ) {
				var renderer = $it0.next();
				renderer.setRedraw(true);
			}
		}
	}
	,clear: function() {
		this.clearing = true;
		var renderersExcluded = new IntHash();
		if(this.redrawBackground) this.clearArea(0,0,this.width,this.height); else {
			if(this.renderersYetToRedraw != null) {
				var $it0 = this.renderers.iterator();
				while( $it0.hasNext() ) {
					var renderer = $it0.next();
					if(!renderer.enabled) {
						if(this.renderersYetToRedraw.exists(renderer.id)) {
							this.renderersYetToRedraw.remove(renderer.id);
							renderersExcluded.set(renderer.id,renderer.id);
						}
					}
					var screenRect = new titanium_reindeer.Rect(0,0,this.width,this.height);
					if(!titanium_reindeer.Rect.isIntersecting(screenRect,renderer.getLastRectBounds(4)) && !titanium_reindeer.Rect.isIntersecting(screenRect,renderer.getRectBounds(4))) {
						if(this.renderersYetToRedraw.exists(renderer.id)) this.renderersYetToRedraw.remove(renderer.id); else if(this.renderersToRedraw.exists(renderer.id)) this.renderersToRedraw.remove(renderer.id);
						renderersExcluded.set(renderer.id,renderer.id);
						renderer.setRedraw(false);
					}
				}
				if(Lambda.count(this.renderersYetToRedraw) != 0) this.finalizeRedrawList();
			}
			if(this.renderersToRedraw != null) {
				var renderer;
				var position;
				var width;
				var height;
				var $it1 = this.renderersToRedraw.iterator();
				while( $it1.hasNext() ) {
					var id = $it1.next();
					renderer = this.renderers.get(id);
					position = renderer.lastRenderedPosition;
					width = renderer.lastRenderedWidth + 2;
					height = renderer.lastRenderedHeight + 2;
					this.clearArea(position.getX() - width / 2,position.getY() - height / 2,width,height);
				}
			}
		}
		if(this.renderersYetToRedraw != null) {
			if(this.renderersToRedraw != null) {
				var $it2 = this.renderersToRedraw.iterator();
				while( $it2.hasNext() ) {
					var id = $it2.next();
					this.renderersYetToRedraw.set(id,id);
				}
				var $it3 = renderersExcluded.iterator();
				while( $it3.hasNext() ) {
					var id = $it3.next();
					this.renderersYetToRedraw.set(id,id);
				}
			}
		}
		this.renderersToRedraw = new IntHash();
		this.clearing = false;
	}
	,clearArea: function(x,y,width,height) {
		this.pen.clearRect(x,y,width,height);
		if(this.clearColor != null) {
			this.pen.fillStyle = this.clearColor.getRgba();
			this.pen.fillRect(x - 1,y - 1,width + 2,height + 2);
		}
	}
	,finalizeRedrawList: function() {
		var sortedRenderers = new Array();
		var $it0 = this.renderersYetToRedraw.iterator();
		while( $it0.hasNext() ) {
			var id = $it0.next();
			sortedRenderers.push({ posX : Math.round(this.renderers.get(id).getScreenPos().getX() - this.renderers.get(id).drawnWidth), id : id});
		}
		sortedRenderers.sort(function(a,b) {
			return a.posX == b.posX?0:a.posX < b.posX?-1:1;
		});
		var sortedIndex = 0;
		var sortedMin;
		var sortedMax;
		var newRenderers = Lambda.array(this.renderersToRedraw);
		var nextRenderers = new Array();
		var foundAny = true;
		var newRenderer;
		var newRendererRight;
		var renderer;
		while(foundAny) {
			foundAny = false;
			var _g = 0;
			while(_g < newRenderers.length) {
				var id = newRenderers[_g];
				++_g;
				newRenderer = this.renderers.get(id);
				newRendererRight = newRenderer.getScreenPos().getX() + newRenderer.drawnWidth / 2 + 1;
				sortedMin = 0;
				sortedMax = sortedRenderers.length;
				sortedIndex = 0;
				while((sortedMax - sortedMin) / 2 >= 1) {
					sortedIndex = sortedMin + Math.round((sortedMax - sortedMin) / 2);
					if(newRendererRight < sortedRenderers[sortedIndex].posX) sortedMax = sortedIndex; else sortedMin = sortedIndex;
				}
				if(newRendererRight < sortedRenderers[sortedIndex].posX) --sortedIndex;
				var i = sortedIndex;
				while(i >= 0) {
					renderer = this.renderers.get(sortedRenderers[i].id);
					if(titanium_reindeer.Rect.isIntersecting(newRenderer.getLastRectBounds(4),renderer.getRectBounds(4))) {
						nextRenderers.push(renderer.id);
						this.renderersToRedraw.set(renderer.id,renderer.id);
						renderer.setRedraw(true);
						sortedRenderers.splice(i,1);
						foundAny = true;
					}
					--i;
				}
				if(sortedRenderers.length == 0) break;
			}
			if(sortedRenderers.length == 0) break;
			if(foundAny) {
				newRenderers = Lambda.array(nextRenderers);
				nextRenderers = new Array();
			}
		}
	}
	,display: function(screenPen) {
		if(this.visible && this.alpha > 0) {
			screenPen.save();
			screenPen.globalAlpha = this.alpha;
			screenPen.drawImage(this.canvas,0,0);
			screenPen.restore();
		}
		this.redrawBackground = false;
	}
	,getVectorToScreen: function(vector) {
		if(vector == null) return this.getOffset().getCopy();
		return vector.add(this.getOffset());
	}
	,getVectorFromScreen: function(vector) {
		return vector.subtract(this.getOffset());
	}
	,addRenderer: function(renderer) {
		if(!this.renderers.exists(renderer.id)) {
			this.ensureYetToRedrawIsReady();
			this.renderersYetToRedraw.set(renderer.id,renderer.id);
			this.renderers.set(renderer.id,renderer);
		}
	}
	,removeRenderer: function(renderer) {
		if(this.renderers.exists(renderer.id)) this.renderers.remove(renderer.id);
		if(this.renderersToRedraw.exists(renderer.id)) this.renderersToRedraw.remove(renderer.id);
		if(this.renderersYetToRedraw.exists(renderer.id)) this.renderersYetToRedraw.remove(renderer.id);
	}
	,redrawRenderer: function(renderer) {
		if(this.clearing || !this.renderers.exists(renderer.id)) return;
		if(this.renderersToRedraw == null) this.renderersToRedraw = new IntHash();
		this.ensureYetToRedrawIsReady();
		if(this.renderersYetToRedraw.exists(renderer.id)) {
			this.renderersYetToRedraw.remove(renderer.id);
			this.renderersToRedraw.set(renderer.id,renderer.id);
		}
	}
	,stopRedrawRenderer: function(renderer) {
		if(this.clearing || !this.renderers.exists(renderer.id)) return;
		if(this.renderersToRedraw == null) this.renderersToRedraw = new IntHash();
		this.ensureYetToRedrawIsReady();
		if(this.renderersToRedraw.exists(renderer.id)) {
			this.renderersToRedraw.remove(renderer.id);
			this.renderersYetToRedraw.set(renderer.id,renderer.id);
		}
	}
	,ensureYetToRedrawIsReady: function() {
		if(this.renderersYetToRedraw == null) {
			this.renderersYetToRedraw = new IntHash();
			var $it0 = this.renderers.keys();
			while( $it0.hasNext() ) {
				var rendererId = $it0.next();
				this.renderersYetToRedraw.set(rendererId,rendererId);
			}
		}
	}
	,destroy: function() {
		this.layerManager = null;
		this.canvas = null;
		this.pen = null;
		this.setClearColor(null);
		this.setOffset(null);
		var $it0 = this.renderers.keys();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			this.renderers.remove(i);
		}
		this.renderers = null;
		if(this.renderersYetToRedraw != null) {
			var $it1 = this.renderersYetToRedraw.keys();
			while( $it1.hasNext() ) {
				var i = $it1.next();
				this.renderersYetToRedraw.remove(i);
			}
			this.renderersYetToRedraw = null;
		}
		if(this.renderersYetToRedraw != null) {
			var $it2 = this.renderersToRedraw.keys();
			while( $it2.hasNext() ) {
				var i = $it2.next();
				this.renderersToRedraw.remove(i);
			}
			this.renderersToRedraw = null;
		}
	}
	,__class__: titanium_reindeer.RenderLayer
	,__properties__: {set_renderOffset:"setOffset",get_renderOffset:"getOffset",set_alpha:"setAlpha",set_visible:"setVisible",set_renderComposition:"setRenderComposition",set_clearColor:"setClearColor"}
}
titanium_reindeer.RenderLayerManager = $hxClasses["titanium_reindeer.RenderLayerManager"] = function(scene,targetElement,gameWidth,gameHeight) {
	this.scene = scene;
	this.gameWidth = gameWidth;
	this.gameHeight = gameHeight;
	this.layers = new Array();
	var _g1 = 0, _g = scene.layerCount;
	while(_g1 < _g) {
		var i = _g1++;
		if(i == 0) this.layers.push(new titanium_reindeer.RenderLayer(this,i,targetElement,gameWidth,gameHeight,scene.backgroundColor)); else this.layers.push(new titanium_reindeer.RenderLayer(this,i,targetElement,gameWidth,gameHeight));
	}
	var canvas = js.Lib.document.createElement("canvas");
	canvas.id = "gameCanvas_" + scene.name;
	canvas.setAttribute("width",gameWidth + "px");
	canvas.setAttribute("height",gameHeight + "px");
	canvas.style.position = "absolute";
	canvas.style.zIndex = scene.renderDepth;
	targetElement.appendChild(canvas);
	this.visiblePen = canvas.getContext("2d");
	this.canvas = js.Lib.document.createElement("canvas");
	this.canvas.id = "gameCanvasBuffer_" + scene.name;
	this.canvas.setAttribute("width",gameWidth + "px");
	this.canvas.setAttribute("height",gameHeight + "px");
	this.pen = this.canvas.getContext("2d");
};
titanium_reindeer.RenderLayerManager.__name__ = ["titanium_reindeer","RenderLayerManager"];
titanium_reindeer.RenderLayerManager.prototype = {
	scene: null
	,layers: null
	,gameWidth: null
	,gameHeight: null
	,canvas: null
	,pen: null
	,visiblePen: null
	,layerExists: function(layerId) {
		return 0 <= layerId && layerId < this.layers.length;
	}
	,getLayer: function(layerId) {
		if(this.layerExists(layerId)) return this.layers[layerId]; else return null;
	}
	,clear: function() {
		var _g = 0, _g1 = this.layers;
		while(_g < _g1.length) {
			var layer = _g1[_g];
			++_g;
			layer.clear();
		}
		this.visiblePen.clearRect(0,0,this.gameWidth,this.gameHeight);
	}
	,display: function() {
		this.pen.clearRect(0,0,this.gameWidth,this.gameHeight);
		var _g = 0, _g1 = this.layers;
		while(_g < _g1.length) {
			var layer = _g1[_g];
			++_g;
			layer.display(this.pen);
		}
		this.visiblePen.drawImage(this.canvas,0,0);
	}
	,destroy: function() {
		while(this.layers.length != 0) {
			var layer = this.layers.pop();
			layer.destroy();
		}
		this.layers = null;
		this.pen = null;
		this.canvas = null;
		this.visiblePen = null;
		var element = js.Lib.document.getElementById("gameCanvas_" + this.scene.name);
		element.parentNode.removeChild(element);
	}
	,__class__: titanium_reindeer.RenderLayerManager
}
titanium_reindeer.RendererComponentManager = $hxClasses["titanium_reindeer.RendererComponentManager"] = function(scene) {
	titanium_reindeer.ComponentManager.call(this,scene);
	var game = this.scene.getGame();
	this.renderLayerManager = new titanium_reindeer.RenderLayerManager(scene,game.targetElement,game.width,game.height);
};
titanium_reindeer.RendererComponentManager.__name__ = ["titanium_reindeer","RendererComponentManager"];
titanium_reindeer.RendererComponentManager.__super__ = titanium_reindeer.ComponentManager;
titanium_reindeer.RendererComponentManager.prototype = $extend(titanium_reindeer.ComponentManager.prototype,{
	renderLayerManager: null
	,bitmapCache: null
	,getBitmapCache: function() {
		return this.scene.getBitmapCache();
	}
	,postUpdate: function(msTimeStep) {
		this.renderLayerManager.clear();
		var _g = 0, _g1 = this.getComponents();
		while(_g < _g1.length) {
			var component = _g1[_g];
			++_g;
			var renderer = (function($this) {
				var $r;
				var $t = component;
				if(Std["is"]($t,titanium_reindeer.RendererComponent)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this));
			renderer.update(msTimeStep);
			if(renderer.layer != null && renderer.getVisible() && (renderer.timeForRedraw || renderer.layer.redrawBackground)) {
				renderer.preRender();
				if(renderer.usingSharedBitmap) renderer.renderSharedBitmap(); else renderer.render();
				renderer.postRender();
			}
			renderer.setLastRendered();
		}
		this.renderLayerManager.display();
	}
	,finalDestroy: function() {
		titanium_reindeer.ComponentManager.prototype.finalDestroy.call(this);
		this.renderLayerManager.destroy();
		this.renderLayerManager = null;
	}
	,__class__: titanium_reindeer.RendererComponentManager
	,__properties__: $extend(titanium_reindeer.ComponentManager.prototype.__properties__,{get_bitmapCache:"getBitmapCache"})
});
titanium_reindeer.SceneInputManager = $hxClasses["titanium_reindeer.SceneInputManager"] = function(scene) {
	titanium_reindeer.InputManager.call(this);
	this.scene = scene;
};
titanium_reindeer.SceneInputManager.__name__ = ["titanium_reindeer","SceneInputManager"];
titanium_reindeer.SceneInputManager.__super__ = titanium_reindeer.InputManager;
titanium_reindeer.SceneInputManager.prototype = $extend(titanium_reindeer.InputManager.prototype,{
	scene: null
	,receiveEvent: function(recordedEvent) {
		if(!this.scene.isPaused) titanium_reindeer.InputManager.prototype.receiveEvent.call(this,recordedEvent);
	}
	,__class__: titanium_reindeer.SceneInputManager
});
titanium_reindeer.SceneManager = $hxClasses["titanium_reindeer.SceneManager"] = function(game) {
	this.game = game;
	this.scenes = new Hash();
};
titanium_reindeer.SceneManager.__name__ = ["titanium_reindeer","SceneManager"];
titanium_reindeer.SceneManager.prototype = {
	game: null
	,scenes: null
	,getAllScenes: function() {
		return this.scenes.iterator();
	}
	,getScene: function(sceneName) {
		if(!this.scenes.exists(sceneName)) return this.scenes.get(sceneName);
		return null;
	}
	,addScene: function(scene) {
		if(!this.scenes.exists(scene.name)) this.scenes.set(scene.name,scene);
	}
	,removeScene: function(scene) {
		if(this.scenes.exists(scene.name)) this.scenes.remove(scene.name);
	}
	,preUpdate: function(msTimeStep) {
		var $it0 = this.scenes.iterator();
		while( $it0.hasNext() ) {
			var scene = $it0.next();
			scene.preUpdate(msTimeStep);
		}
	}
	,update: function(msTimeStep) {
		var $it0 = this.scenes.iterator();
		while( $it0.hasNext() ) {
			var scene = $it0.next();
			scene.update(msTimeStep);
		}
	}
	,postUpdate: function(msTimeStep) {
		var $it0 = this.scenes.iterator();
		while( $it0.hasNext() ) {
			var scene = $it0.next();
			scene.postUpdate(msTimeStep);
		}
	}
	,destroy: function() {
		this.game = null;
		var $it0 = this.scenes.keys();
		while( $it0.hasNext() ) {
			var sceneName = $it0.next();
			this.scenes.get(sceneName).destroy();
			this.scenes.remove(sceneName);
		}
		this.scenes = null;
	}
	,__class__: titanium_reindeer.SceneManager
}
titanium_reindeer.SceneSoundManager = $hxClasses["titanium_reindeer.SceneSoundManager"] = function(scene) {
	titanium_reindeer.SoundManager.call(this);
	this.scene = scene;
};
titanium_reindeer.SceneSoundManager.__name__ = ["titanium_reindeer","SceneSoundManager"];
titanium_reindeer.SceneSoundManager.__super__ = titanium_reindeer.SoundManager;
titanium_reindeer.SceneSoundManager.prototype = $extend(titanium_reindeer.SoundManager.prototype,{
	scene: null
	,getSoundSource: function(filePath) {
		return this.scene.getGame().soundManager.getSoundSource(filePath);
	}
	,__class__: titanium_reindeer.SceneSoundManager
});
titanium_reindeer.Shadow = $hxClasses["titanium_reindeer.Shadow"] = function(color,offset,blur) {
	this.color = color;
	this.offset = offset;
	this.blur = blur;
};
titanium_reindeer.Shadow.__name__ = ["titanium_reindeer","Shadow"];
titanium_reindeer.Shadow.prototype = {
	color: null
	,offset: null
	,blur: null
	,equal: function(other) {
		return this.color.equal(other.color) && this.offset.equal(other.offset) && this.blur == other.blur;
	}
	,identify: function() {
		return "Shadow(" + this.color.identify() + "," + this.offset.identify() + "," + this.blur + ");";
	}
	,__class__: titanium_reindeer.Shadow
}
titanium_reindeer.Sound = $hxClasses["titanium_reindeer.Sound"] = function(soundManager,soundSource) {
	this.soundManager = soundManager;
	this.soundSource = soundSource;
	this.isLoaded = false;
	this.isPlaying = false;
	this.sound = new Audio();
	this.sound.src = this.soundSource.sound.src;
	this.sound.addEventListener("canplaythrough",this.soundLoaded.$bind(this),true);
	this.sound.load();
	this.sound.addEventListener("ended",this.soundEnded.$bind(this),true);
	titanium_reindeer.SoundBase.call(this);
};
titanium_reindeer.Sound.__name__ = ["titanium_reindeer","Sound"];
titanium_reindeer.Sound.__super__ = titanium_reindeer.SoundBase;
titanium_reindeer.Sound.prototype = $extend(titanium_reindeer.SoundBase.prototype,{
	soundManager: null
	,soundSource: null
	,sound: null
	,isLoaded: null
	,isPlaying: null
	,play: function() {
		if(!this.isLoaded) {
			this.isPlaying = true;
			return;
		}
		this.sound.pause();
		this.sound.currentTime = this.sound.startTime;
		if(!this.pausedState) {
			this.sound.play();
			this.isPlaying = true;
		}
		this.sound.volume = this.trueVolume;
		this.sound.muted = this.mutedState;
	}
	,soundLoaded: function() {
		this.isLoaded = true;
		if(this.isPlaying) this.play();
	}
	,soundEnded: function() {
		this.isPlaying = false;
	}
	,setMutedState: function(value) {
		value = titanium_reindeer.SoundBase.prototype.setMutedState.call(this,value);
		this.sound.muted = value;
		return value;
	}
	,setPausedState: function(value) {
		value = titanium_reindeer.SoundBase.prototype.setPausedState.call(this,value);
		if(value) this.sound.pause(); else if(this.isPlaying) this.sound.play();
		return value;
	}
	,setTrueVolume: function(value) {
		if(this.trueVolume != value) {
			value = titanium_reindeer.SoundBase.prototype.setTrueVolume.call(this,value);
			this.sound.volume = value;
		}
		return value;
	}
	,__class__: titanium_reindeer.Sound
});
titanium_reindeer.SoundGroup = $hxClasses["titanium_reindeer.SoundGroup"] = function(soundManager,numChannels) {
	if(numChannels == null) numChannels = 4;
	this.soundManager = soundManager;
	this.soundManager.addGroup(this);
	this.soundChannels = new Array();
	this.channelsPlaying = new Array();
	this.lastChannelUsed = -1;
	this.setNumChannels(numChannels);
	this.sounds = new Hash();
	titanium_reindeer.SoundBase.call(this);
};
titanium_reindeer.SoundGroup.__name__ = ["titanium_reindeer","SoundGroup"];
titanium_reindeer.SoundGroup.__super__ = titanium_reindeer.SoundBase;
titanium_reindeer.SoundGroup.prototype = $extend(titanium_reindeer.SoundBase.prototype,{
	numChannels: null
	,setNumChannels: function(value) {
		if(this.numChannels != value) {
			if(this.numChannels < value) {
				var _g = this.numChannels;
				while(_g < value) {
					var i = [_g++];
					this.soundChannels[i] = new Audio();;
					this.channelsPlaying[i[0]] = false;
					var me = [this];
					this.soundChannels[i[0]].addEventListener("ended",(function(me,i) {
						return function() {
							me[0].channelEnded(i[0]);
						};
					})(me,i),true);
					this.soundChannels[i[0]].volume = this.volume;
				}
			}
			this.numChannels = value;
		}
		return this.numChannels;
	}
	,soundChannels: null
	,channelsPlaying: null
	,lastChannelUsed: null
	,sounds: null
	,soundManager: null
	,switchManager: function(newSoundManager) {
		if(this.soundManager == newSoundManager) return;
		this.soundManager.removeGroup(this);
		this.soundManager = newSoundManager;
		this.soundManager.addGroup(this);
	}
	,addSound: function(name,sound) {
		if(name == null || name == "" || sound == null) return;
		this.sounds.set(name,sound.soundSource);
	}
	,addSoundSource: function(name,sound) {
		if(name == null || name == "" || sound == null) return;
		this.sounds.set(name,sound);
	}
	,playSound: function(soundName) {
		if(soundName == null || !this.sounds.exists(soundName)) return;
		var sound = this.sounds.get(soundName);
		if(!sound.isLoaded) return;
		this.lastChannelUsed = this.lastChannelUsed == this.numChannels - 1?0:this.lastChannelUsed + 1;
		var channel = this.soundChannels[this.lastChannelUsed];
		if(channel.src != sound.sound.src) {
			channel.src = sound.sound.src;
			channel.load();
			channel.play();
			this.channelsPlaying[this.lastChannelUsed] = true;
		} else {
			channel.pause();
			channel.currentTime = channel.startTime;
			if(!this.pausedState) {
				channel.play();
				this.channelsPlaying[this.lastChannelUsed] = true;
			}
		}
		channel.volume = this.trueVolume;
		channel.muted = this.mutedState;
	}
	,playRandomSound: function(soundNames) {
		if(soundNames == null || soundNames.length == 0) return -1;
		var r = Std.random(soundNames.length);
		if(soundNames[r] == null) return -1; else {
			this.playSound(soundNames[r]);
			return r;
		}
	}
	,channelEnded: function(index) {
		if(index < this.numChannels && index >= 0) this.channelsPlaying[index] = false;
	}
	,setMutedState: function(value) {
		value = titanium_reindeer.SoundBase.prototype.setMutedState.call(this,value);
		var _g = 0, _g1 = this.soundChannels;
		while(_g < _g1.length) {
			var channel = _g1[_g];
			++_g;
			channel.muted = value;
		}
		return value;
	}
	,setPausedState: function(value) {
		value = titanium_reindeer.SoundBase.prototype.setPausedState.call(this,value);
		var _g1 = 0, _g = this.numChannels;
		while(_g1 < _g) {
			var i = _g1++;
			if(value) this.soundChannels[i].pause(); else if(this.channelsPlaying[i]) this.soundChannels[i].play();
		}
		return value;
	}
	,setTrueVolume: function(value) {
		if(this.trueVolume != value) {
			value = titanium_reindeer.SoundBase.prototype.setTrueVolume.call(this,value);
			var _g = 0, _g1 = this.soundChannels;
			while(_g < _g1.length) {
				var channel = _g1[_g];
				++_g;
				channel.volume = value;
			}
		}
		return value;
	}
	,__class__: titanium_reindeer.SoundGroup
	,__properties__: $extend(titanium_reindeer.SoundBase.prototype.__properties__,{set_numChannels:"setNumChannels"})
});
titanium_reindeer.SoundSource = $hxClasses["titanium_reindeer.SoundSource"] = function(filePath) {
	this.isLoaded = false;
	this.sound = new Audio();
	this.sound.addEventListener("canplaythrough",this.soundLoaded.$bind(this),true);
	this.sound.src = filePath;
	this.sound.load();
};
titanium_reindeer.SoundSource.__name__ = ["titanium_reindeer","SoundSource"];
titanium_reindeer.SoundSource.prototype = {
	sound: null
	,isLoaded: null
	,loadedFunctions: null
	,registerLoadEvent: function(cb) {
		if(this.isLoaded) return;
		if(this.loadedFunctions == null) this.loadedFunctions = new List();
		this.loadedFunctions.push(cb);
	}
	,soundLoaded: function(event) {
		if(this.sound == null) return;
		this.isLoaded = true;
		if(this.loadedFunctions != null) {
			var $it0 = this.loadedFunctions.iterator();
			while( $it0.hasNext() ) {
				var func = $it0.next();
				func(event);
			}
			this.loadedFunctions.clear();
			this.loadedFunctions = null;
		}
	}
	,identify: function() {
		return "SoundSource(" + this.sound.src + ");";
	}
	,destroy: function() {
		this.isLoaded = false;
		this.sound = null;
		if(this.loadedFunctions != null) {
			this.loadedFunctions.clear();
			this.loadedFunctions = null;
		}
	}
	,__class__: titanium_reindeer.SoundSource
}
titanium_reindeer.LineCapType = $hxClasses["titanium_reindeer.LineCapType"] = { __ename__ : ["titanium_reindeer","LineCapType"], __constructs__ : ["Butt","Round","Square"] }
titanium_reindeer.LineCapType.Butt = ["Butt",0];
titanium_reindeer.LineCapType.Butt.toString = $estr;
titanium_reindeer.LineCapType.Butt.__enum__ = titanium_reindeer.LineCapType;
titanium_reindeer.LineCapType.Round = ["Round",1];
titanium_reindeer.LineCapType.Round.toString = $estr;
titanium_reindeer.LineCapType.Round.__enum__ = titanium_reindeer.LineCapType;
titanium_reindeer.LineCapType.Square = ["Square",2];
titanium_reindeer.LineCapType.Square.toString = $estr;
titanium_reindeer.LineCapType.Square.__enum__ = titanium_reindeer.LineCapType;
titanium_reindeer.LineJoinType = $hxClasses["titanium_reindeer.LineJoinType"] = { __ename__ : ["titanium_reindeer","LineJoinType"], __constructs__ : ["Round","Bevel","Miter"] }
titanium_reindeer.LineJoinType.Round = ["Round",0];
titanium_reindeer.LineJoinType.Round.toString = $estr;
titanium_reindeer.LineJoinType.Round.__enum__ = titanium_reindeer.LineJoinType;
titanium_reindeer.LineJoinType.Bevel = ["Bevel",1];
titanium_reindeer.LineJoinType.Bevel.toString = $estr;
titanium_reindeer.LineJoinType.Bevel.__enum__ = titanium_reindeer.LineJoinType;
titanium_reindeer.LineJoinType.Miter = ["Miter",2];
titanium_reindeer.LineJoinType.Miter.toString = $estr;
titanium_reindeer.LineJoinType.Miter.__enum__ = titanium_reindeer.LineJoinType;
titanium_reindeer.FillTypes = $hxClasses["titanium_reindeer.FillTypes"] = { __ename__ : ["titanium_reindeer","FillTypes"], __constructs__ : ["Gradient","Pattern","ColorFill"] }
titanium_reindeer.FillTypes.Gradient = ["Gradient",0];
titanium_reindeer.FillTypes.Gradient.toString = $estr;
titanium_reindeer.FillTypes.Gradient.__enum__ = titanium_reindeer.FillTypes;
titanium_reindeer.FillTypes.Pattern = ["Pattern",1];
titanium_reindeer.FillTypes.Pattern.toString = $estr;
titanium_reindeer.FillTypes.Pattern.__enum__ = titanium_reindeer.FillTypes;
titanium_reindeer.FillTypes.ColorFill = ["ColorFill",2];
titanium_reindeer.FillTypes.ColorFill.toString = $estr;
titanium_reindeer.FillTypes.ColorFill.__enum__ = titanium_reindeer.FillTypes;
titanium_reindeer.StrokeTypes = $hxClasses["titanium_reindeer.StrokeTypes"] = { __ename__ : ["titanium_reindeer","StrokeTypes"], __constructs__ : ["Gradient","StrokeColor"] }
titanium_reindeer.StrokeTypes.Gradient = ["Gradient",0];
titanium_reindeer.StrokeTypes.Gradient.toString = $estr;
titanium_reindeer.StrokeTypes.Gradient.__enum__ = titanium_reindeer.StrokeTypes;
titanium_reindeer.StrokeTypes.StrokeColor = ["StrokeColor",1];
titanium_reindeer.StrokeTypes.StrokeColor.toString = $estr;
titanium_reindeer.StrokeTypes.StrokeColor.__enum__ = titanium_reindeer.StrokeTypes;
titanium_reindeer.FontStyle = $hxClasses["titanium_reindeer.FontStyle"] = { __ename__ : ["titanium_reindeer","FontStyle"], __constructs__ : ["Normal","Italics","Oblique"] }
titanium_reindeer.FontStyle.Normal = ["Normal",0];
titanium_reindeer.FontStyle.Normal.toString = $estr;
titanium_reindeer.FontStyle.Normal.__enum__ = titanium_reindeer.FontStyle;
titanium_reindeer.FontStyle.Italics = ["Italics",1];
titanium_reindeer.FontStyle.Italics.toString = $estr;
titanium_reindeer.FontStyle.Italics.__enum__ = titanium_reindeer.FontStyle;
titanium_reindeer.FontStyle.Oblique = ["Oblique",2];
titanium_reindeer.FontStyle.Oblique.toString = $estr;
titanium_reindeer.FontStyle.Oblique.__enum__ = titanium_reindeer.FontStyle;
titanium_reindeer.FontVariant = $hxClasses["titanium_reindeer.FontVariant"] = { __ename__ : ["titanium_reindeer","FontVariant"], __constructs__ : ["Normal","SmallCaps"] }
titanium_reindeer.FontVariant.Normal = ["Normal",0];
titanium_reindeer.FontVariant.Normal.toString = $estr;
titanium_reindeer.FontVariant.Normal.__enum__ = titanium_reindeer.FontVariant;
titanium_reindeer.FontVariant.SmallCaps = ["SmallCaps",1];
titanium_reindeer.FontVariant.SmallCaps.toString = $estr;
titanium_reindeer.FontVariant.SmallCaps.__enum__ = titanium_reindeer.FontVariant;
titanium_reindeer.FontWeight = $hxClasses["titanium_reindeer.FontWeight"] = { __ename__ : ["titanium_reindeer","FontWeight"], __constructs__ : ["Normal","Bold","Size"] }
titanium_reindeer.FontWeight.Normal = ["Normal",0];
titanium_reindeer.FontWeight.Normal.toString = $estr;
titanium_reindeer.FontWeight.Normal.__enum__ = titanium_reindeer.FontWeight;
titanium_reindeer.FontWeight.Bold = ["Bold",1];
titanium_reindeer.FontWeight.Bold.toString = $estr;
titanium_reindeer.FontWeight.Bold.__enum__ = titanium_reindeer.FontWeight;
titanium_reindeer.FontWeight.Size = function(s) { var $x = ["Size",2,s]; $x.__enum__ = titanium_reindeer.FontWeight; $x.toString = $estr; return $x; }
titanium_reindeer.TextRenderer = $hxClasses["titanium_reindeer.TextRenderer"] = function(text,layer) {
	titanium_reindeer.StrokeFillRenderer.call(this,0,this.fontSize,layer);
	this.setText(text);
	this.setFontStyle(titanium_reindeer.FontStyle.Normal);
	this.setFontVariant(titanium_reindeer.FontVariant.Normal);
	this.setFontWeight(titanium_reindeer.FontWeight.Normal);
	this.setFontSize(10);
	this.setFontFamily("sans-serif");
};
titanium_reindeer.TextRenderer.__name__ = ["titanium_reindeer","TextRenderer"];
titanium_reindeer.TextRenderer.__super__ = titanium_reindeer.StrokeFillRenderer;
titanium_reindeer.TextRenderer.prototype = $extend(titanium_reindeer.StrokeFillRenderer.prototype,{
	text: null
	,setText: function(value) {
		if(this.text != value) {
			this.text = value;
			this.recalculateSize();
		}
		return this.text;
	}
	,fontStyle: null
	,setFontStyle: function(value) {
		if(this.fontStyle != value) {
			this.fontStyle = value;
			this.recalculateSize();
		}
		return this.fontStyle;
	}
	,fontVariant: null
	,setFontVariant: function(value) {
		if(this.fontVariant != value) {
			this.fontVariant = value;
			this.recalculateSize();
		}
		return this.fontVariant;
	}
	,fontWeight: null
	,setFontWeight: function(value) {
		if(this.fontWeight != value) {
			this.fontWeight = value;
			this.recalculateSize();
		}
		return this.fontWeight;
	}
	,fontSize: null
	,setFontSize: function(value) {
		if(this.fontSize != value) {
			this.fontSize = value;
			this.recalculateSize();
		}
		return this.fontSize;
	}
	,fontFamily: null
	,setFontFamily: function(value) {
		if(this.fontFamily != value) {
			this.fontFamily = value;
			this.recalculateSize();
		}
		return this.fontFamily;
	}
	,initialize: function() {
		titanium_reindeer.StrokeFillRenderer.prototype.initialize.call(this);
		this.recalculateSize();
	}
	,setFontAttributes: function() {
		var font = "";
		switch( (this.fontStyle)[1] ) {
		case 0:
			font += "normal";
			break;
		case 1:
			font += "italics";
			break;
		case 2:
			font += "oblique";
			break;
		}
		font += " ";
		switch( (this.fontVariant)[1] ) {
		case 0:
			font += "normal";
			break;
		case 1:
			font += "small-caps";
			break;
		}
		font += " ";
		var $e = (this.fontWeight);
		switch( $e[1] ) {
		case 0:
			font += "normal";
			break;
		case 1:
			font += "bold";
			break;
		case 2:
			var s = $e[2];
			font += Math.max(100,Math.min(s,900));
			break;
		}
		font += " ";
		this.getPen().font = font + this.fontSize + "px " + this.fontFamily;
		this.getPen().textAlign = "center";
		this.getPen().textBaseline = "middle";
	}
	,recalculateSize: function() {
		if(this.getPen() != null) {
			this.setFontAttributes();
			var measuredFont = this.getPen().measureText(this.text);
			this.setInitialWidth(measuredFont.width + (this.lineWidth > 0?this.lineWidth:0));
			this.setInitialHeight(this.fontSize + (this.lineWidth > 0?this.lineWidth:0));
			this.setRedraw(true);
		}
	}
	,render: function() {
		titanium_reindeer.StrokeFillRenderer.prototype.render.call(this);
		this.setFontAttributes();
		this.getPen().fillText(this.text,0,0);
		if(this.lineWidth > 0) this.getPen().strokeText(this.text,0,0);
	}
	,identify: function() {
		var identity = "Text(";
		switch( (this.fontStyle)[1] ) {
		case 0:
			identity += "normal";
			break;
		case 1:
			identity += "italics";
			break;
		case 2:
			identity += "oblique";
			break;
		}
		identity += ",";
		switch( (this.fontVariant)[1] ) {
		case 0:
			identity += "normal";
			break;
		case 1:
			identity += "small-caps";
			break;
		}
		identity += ",";
		var $e = (this.fontWeight);
		switch( $e[1] ) {
		case 0:
			identity += "normal";
			break;
		case 1:
			identity += "bold";
			break;
		case 2:
			var s = $e[2];
			identity += Math.max(100,Math.min(s,900));
			break;
		}
		return titanium_reindeer.StrokeFillRenderer.prototype.identify.call(this) + identity + "," + this.fontSize + "," + this.fontFamily + ");";
	}
	,__class__: titanium_reindeer.TextRenderer
	,__properties__: $extend(titanium_reindeer.StrokeFillRenderer.prototype.__properties__,{set_fontFamily:"setFontFamily",set_fontSize:"setFontSize",set_fontWeight:"setFontWeight",set_fontVariant:"setFontVariant",set_fontStyle:"setFontStyle",set_text:"setText"})
});
titanium_reindeer.UnsaturateEffect = $hxClasses["titanium_reindeer.UnsaturateEffect"] = function() {
	titanium_reindeer.BitmapEffect.call(this);
};
titanium_reindeer.UnsaturateEffect.__name__ = ["titanium_reindeer","UnsaturateEffect"];
titanium_reindeer.UnsaturateEffect.__super__ = titanium_reindeer.BitmapEffect;
titanium_reindeer.UnsaturateEffect.prototype = $extend(titanium_reindeer.BitmapEffect.prototype,{
	apply: function(bitmapData) {
		if(bitmapData == null) return;
		var _g1 = 0, _g = bitmapData.getHeight();
		while(_g1 < _g) {
			var r = _g1++;
			var _g3 = 0, _g2 = bitmapData.getWidth();
			while(_g3 < _g2) {
				var c = _g3++;
				var index = (r * bitmapData.getWidth() + c) * 4;
				var red = bitmapData.getData()[index];
				var green = bitmapData.getData()[index + 1];
				var blue = bitmapData.getData()[index + 2];
				var average = Math.round((red + green + blue) / 3);
				bitmapData.getData()[index] = average;
				bitmapData.getData()[index + 1] = average;
				bitmapData.getData()[index + 2] = average;
			}
		}
	}
	,identify: function() {
		return "Unsaturate();";
	}
	,__class__: titanium_reindeer.UnsaturateEffect
});
titanium_reindeer.Utility = $hxClasses["titanium_reindeer.Utility"] = function() { }
titanium_reindeer.Utility.__name__ = ["titanium_reindeer","Utility"];
titanium_reindeer.Utility.clampInt = function(n,a,b) {
	return Math.round(Math.max(a,Math.min(n,b)));
}
titanium_reindeer.Utility.clampFloat = function(n,a,b) {
	return Math.max(a,Math.min(n,b));
}
titanium_reindeer.Utility.browserHasWebWorkers = function() {
	var r = false;
	r = !!Window.Worker;
	return r;
}
titanium_reindeer.Utility.prototype = {
	__class__: titanium_reindeer.Utility
}
titanium_reindeer.Vector2 = $hxClasses["titanium_reindeer.Vector2"] = function(x,y) {
	this.mX = x;
	this.mY = y;
};
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
titanium_reindeer.Vector2.prototype = {
	mX: null
	,x: null
	,getX: function() {
		return this.mX;
	}
	,setX: function(value) {
		this.mX = value;
		return this.mX;
	}
	,mY: null
	,y: null
	,getY: function() {
		return this.mY;
	}
	,setY: function(value) {
		this.mY = value;
		return this.mY;
	}
	,getCopy: function() {
		return new titanium_reindeer.Vector2(this.getX(),this.getY());
	}
	,getMagnitude: function() {
		return Math.sqrt(this.getX() * this.getX() + this.getY() * this.getY());
	}
	,getExtend: function(n) {
		return new titanium_reindeer.Vector2(this.getX() * n,this.getY() * n);
	}
	,extend: function(n) {
		var _g = this;
		_g.setX(_g.getX() * n);
		var _g = this;
		_g.setY(_g.getY() * n);
	}
	,getNormalized: function() {
		var mag = this.getMagnitude();
		if(mag == 0) return new titanium_reindeer.Vector2(0,0);
		return new titanium_reindeer.Vector2(this.getX() / mag,this.getY() / mag);
	}
	,normalize: function() {
		var mag = this.getMagnitude();
		if(mag != 0) {
			var _g = this;
			_g.setX(_g.getX() / mag);
			var _g = this;
			_g.setY(_g.getY() / mag);
		}
	}
	,getReverse: function() {
		return new titanium_reindeer.Vector2(-this.getX(),-this.getY());
	}
	,reverse: function() {
		this.setX(-this.getX());
		this.setY(-this.getY());
	}
	,getRotate: function(r) {
		var sin = Math.sin(r);
		var cos = Math.cos(r);
		return new titanium_reindeer.Vector2(this.getX() * cos - this.getY() * sin,this.getX() * sin + this.getY() * cos);
	}
	,rotate: function(r) {
		var sin = Math.sin(r);
		var cos = Math.cos(r);
		var x = this.getX();
		this.setX(this.getX() * cos - this.getY() * sin);
		this.setY(x * sin + this.getY() * cos);
	}
	,getRadians: function() {
		if(this.getX() == 0) return Math.PI / 2 + (this.getY() < 0?Math.PI:0);
		var rads = Math.atan(this.getY() / this.getX());
		if(this.getX() < 0) rads += Math.PI; else if(this.getY() < 0) rads += Math.PI * 2;
		return rads;
	}
	,add: function(b) {
		if(b == null) return this.getCopy();
		return new titanium_reindeer.Vector2(this.getX() + b.getX(),this.getY() + b.getY());
	}
	,addTo: function(b) {
		var _g = this;
		_g.setX(_g.getX() + b.getX());
		var _g = this;
		_g.setY(_g.getY() + b.getY());
		return this;
	}
	,subtract: function(b) {
		return new titanium_reindeer.Vector2(this.getX() - b.getX(),this.getY() - b.getY());
	}
	,subtractFrom: function(b) {
		var _g = this;
		_g.setX(_g.getX() - b.getX());
		var _g = this;
		_g.setY(_g.getY() - b.getY());
		return this;
	}
	,equal: function(b) {
		if(b == null) return false;
		return this.getX() == b.getX() && this.getY() == b.getY();
	}
	,identify: function() {
		return "Vector2(" + this.getX() + "," + this.getY() + ")";
	}
	,__class__: titanium_reindeer.Vector2
	,__properties__: {set_y:"setY",get_y:"getY",set_x:"setX",get_x:"getX"}
}
titanium_reindeer.WatchedVector2 = $hxClasses["titanium_reindeer.WatchedVector2"] = function(x,y,changeCallback) {
	this.changeCallback = changeCallback;
	titanium_reindeer.Vector2.call(this,x,y);
};
titanium_reindeer.WatchedVector2.__name__ = ["titanium_reindeer","WatchedVector2"];
titanium_reindeer.WatchedVector2.__super__ = titanium_reindeer.Vector2;
titanium_reindeer.WatchedVector2.prototype = $extend(titanium_reindeer.Vector2.prototype,{
	setX: function(value) {
		if(value != this.mX && this.changeCallback != null) this.changeCallback();
		titanium_reindeer.Vector2.prototype.setX.call(this,value);
		return this.mX;
	}
	,setY: function(value) {
		if(value != this.mY && this.changeCallback != null) this.changeCallback();
		titanium_reindeer.Vector2.prototype.setY.call(this,value);
		return this.mY;
	}
	,setVector2: function(value) {
		if(value != null) {
			if(value.getX() != this.getX() || value.getY() != this.getY()) {
				this.mX = value.getX();
				this.mY = value.getY();
				this.changeCallback();
			}
		}
		return this;
	}
	,changeCallback: null
	,destroy: function() {
		this.changeCallback = null;
	}
	,__class__: titanium_reindeer.WatchedVector2
});
js.Boot.__res = {}
js.Boot.__init();
{
	var d = Date;
	d.now = function() {
		return new Date();
	};
	d.fromTime = function(t) {
		var d1 = new Date();
		d1["setTime"](t);
		return d1;
	};
	d.fromString = function(s) {
		switch(s.length) {
		case 8:
			var k = s.split(":");
			var d1 = new Date();
			d1["setTime"](0);
			d1["setUTCHours"](k[0]);
			d1["setUTCMinutes"](k[1]);
			d1["setUTCSeconds"](k[2]);
			return d1;
		case 10:
			var k = s.split("-");
			return new Date(k[0],k[1] - 1,k[2],0,0,0);
		case 19:
			var k = s.split(" ");
			var y = k[0].split("-");
			var t = k[1].split(":");
			return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
		default:
			throw "Invalid date format : " + s;
		}
	};
	d.prototype["toString"] = function() {
		var date = this;
		var m = date.getMonth() + 1;
		var d1 = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d1 < 10?"0" + d1:"" + d1) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
	};
	d.prototype.__class__ = $hxClasses["Date"] = d;
	d.__name__ = ["Date"];
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	$hxClasses["Math"] = Math;
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
{
	String.prototype.__class__ = $hxClasses["String"] = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = $hxClasses["Array"] = Array;
	Array.__name__ = ["Array"];
	var Int = $hxClasses["Int"] = { __name__ : ["Int"]};
	var Dynamic = $hxClasses["Dynamic"] = { __name__ : ["Dynamic"]};
	var Float = $hxClasses["Float"] = Number;
	Float.__name__ = ["Float"];
	var Bool = $hxClasses["Bool"] = Boolean;
	Bool.__ename__ = ["Bool"];
	var Class = $hxClasses["Class"] = { __name__ : ["Class"]};
	var Enum = { };
	var Void = $hxClasses["Void"] = { __ename__ : ["Void"]};
}
{
	if(typeof document != "undefined") js.Lib.document = document;
	if(typeof window != "undefined") {
		js.Lib.window = window;
		js.Lib.window.onerror = function(msg,url,line) {
			var f = js.Lib.onerror;
			if(f == null) return false;
			return f(msg,[url + ":" + line]);
		};
	}
}
Ball.RADIUS = 10;
Layers.Balls = 0;
Layers.NUM_LAYERS = 1;
titanium_reindeer.Game.DEFAULT_UPDATES_TIME_MS = Math.round(1000 / 60);
js.Lib.onerror = null;
titanium_reindeer.GameInputManager.DEFAULT_OFFSET_RECALC_DELAY_MS = 1000;
TestGame.main()