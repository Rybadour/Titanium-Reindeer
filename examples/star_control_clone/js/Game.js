$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof titanium_reindeer=='undefined') titanium_reindeer = {}
titanium_reindeer.ManagedObject = function(p) {
	if( p === $_ ) return;
	this.registeredManagerSetEvents = new Array();
}
titanium_reindeer.ManagedObject.__name__ = ["titanium_reindeer","ManagedObject"];
titanium_reindeer.ManagedObject.prototype.id = null;
titanium_reindeer.ManagedObject.prototype.manager = null;
titanium_reindeer.ManagedObject.prototype.setManager = function(manager) {
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
titanium_reindeer.ManagedObject.prototype.toBeDestroyed = null;
titanium_reindeer.ManagedObject.prototype.registeredManagerSetEvents = null;
titanium_reindeer.ManagedObject.prototype.registerManagerSetFunc = function(func) {
	if(func != null) this.registeredManagerSetEvents.push(func);
}
titanium_reindeer.ManagedObject.prototype.unregisterManagerSetFunc = function(func) {
	if(func == null) return;
	var _g1 = 0, _g = this.registeredManagerSetEvents.length;
	while(_g1 < _g) {
		var i = _g1++;
		while(i < this.registeredManagerSetEvents.length) if(Reflect.compareMethods(this.registeredManagerSetEvents[i],func)) this.registeredManagerSetEvents.splice(i,1); else break;
	}
}
titanium_reindeer.ManagedObject.prototype.destroy = function() {
	this.toBeDestroyed = true;
}
titanium_reindeer.ManagedObject.prototype.finalDestroy = function() {
	this.manager = null;
	var _g1 = 0, _g = this.registeredManagerSetEvents.length;
	while(_g1 < _g) {
		var i = _g1++;
		this.registeredManagerSetEvents.splice(0,1);
	}
	this.registeredManagerSetEvents = null;
}
titanium_reindeer.ManagedObject.prototype.__class__ = titanium_reindeer.ManagedObject;
titanium_reindeer.GameObject = function(p) {
	if( p === $_ ) return;
	titanium_reindeer.ManagedObject.call(this);
	this.watchedPosition = new titanium_reindeer.WatchedVector2(0,0,$closure(this,"positionChanged"));
	this.components = new Hash();
}
titanium_reindeer.GameObject.__name__ = ["titanium_reindeer","GameObject"];
titanium_reindeer.GameObject.__super__ = titanium_reindeer.ManagedObject;
for(var k in titanium_reindeer.ManagedObject.prototype ) titanium_reindeer.GameObject.prototype[k] = titanium_reindeer.ManagedObject.prototype[k];
titanium_reindeer.GameObject.prototype.objectManager = null;
titanium_reindeer.GameObject.prototype.getManager = function() {
	if(this.manager == null) return null; else return (function($this) {
		var $r;
		var $t = $this.manager;
		if(Std["is"]($t,titanium_reindeer.GameObjectManager)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
}
titanium_reindeer.GameObject.prototype.components = null;
titanium_reindeer.GameObject.prototype.componentsToRemove = null;
titanium_reindeer.GameObject.prototype.watchedPosition = null;
titanium_reindeer.GameObject.prototype.position = null;
titanium_reindeer.GameObject.prototype.getPosition = function() {
	return this.watchedPosition;
}
titanium_reindeer.GameObject.prototype.setPosition = function(value) {
	if(value != null) {
		if(this.watchedPosition != value && !this.watchedPosition.equal(value)) this.watchedPosition.setVector2(value);
	}
	return this.getPosition();
}
titanium_reindeer.GameObject.prototype.update = function(msTimeStep) {
}
titanium_reindeer.GameObject.prototype.addComponent = function(name,component) {
	if(this.components.exists(name)) {
		throw "GameObject: Attempting to add a component while the name '" + name + "' is already in use!";
		return;
	}
	this.components.set(name,component);
	component.setOwner(this);
	if(this.getManager() != null) this.getManager().delegateComponent(component);
}
titanium_reindeer.GameObject.prototype.removeComponent = function(name) {
	if(this.components.exists(name)) {
		if(this.componentsToRemove == null) this.componentsToRemove = new Array();
		this.componentsToRemove.push(name);
		this.components.get(name).remove();
	}
}
titanium_reindeer.GameObject.prototype.getComponent = function(name) {
	if(this.components.exists(name)) return this.components.get(name);
	return null;
}
titanium_reindeer.GameObject.prototype.positionHasChanged = function() {
}
titanium_reindeer.GameObject.prototype.positionChanged = function() {
	this.positionHasChanged();
	this.notifyPositionChanged();
}
titanium_reindeer.GameObject.prototype.notifyPositionChanged = function() {
	if(this.components != null) {
		var $it0 = this.components.iterator();
		while( $it0.hasNext() ) {
			var component = $it0.next();
			component.notifyPositionChange();
		}
	}
}
titanium_reindeer.GameObject.prototype.hasInitialized = function() {
}
titanium_reindeer.GameObject.prototype.setManager = function(manager) {
	titanium_reindeer.ManagedObject.prototype.setManager.call(this,manager);
	var $it0 = this.components.iterator();
	while( $it0.hasNext() ) {
		var component = $it0.next();
		this.getManager().delegateComponent(component);
	}
	this.hasInitialized();
}
titanium_reindeer.GameObject.prototype.remove = function() {
	if(this.componentsToRemove == null) this.componentsToRemove = new Array();
	var $it0 = this.components.keys();
	while( $it0.hasNext() ) {
		var compName = $it0.next();
		this.componentsToRemove.push(compName);
		this.components.get(compName).remove();
	}
}
titanium_reindeer.GameObject.prototype.removeComponents = function() {
	if(this.componentsToRemove != null) {
		var _g = 0, _g1 = this.componentsToRemove;
		while(_g < _g1.length) {
			var compName = _g1[_g];
			++_g;
			this.components.remove(compName);
		}
	}
}
titanium_reindeer.GameObject.prototype.flushAndDestroyComponents = function() {
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
titanium_reindeer.GameObject.prototype.finalDestroy = function() {
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
titanium_reindeer.GameObject.prototype.__class__ = titanium_reindeer.GameObject;
if(typeof star_control=='undefined') star_control = {}
star_control.Ship = function(isPlayer1,imagePath,shipUi,maxHealth,maxAmmo,rechargeRate,fireRate,primaryAmmoCost,turnRate,thrustAccel,maxThrust) {
	if( isPlayer1 === $_ ) return;
	titanium_reindeer.GameObject.call(this);
	this.isPlayer1 = isPlayer1;
	var highlight = this.isPlayer1?new titanium_reindeer.Color(0,162,232):new titanium_reindeer.Color(193,29,37);
	this.sprite = new titanium_reindeer.ImageRenderer(new titanium_reindeer.ImageSource("img/" + imagePath),2);
	this.sprite.setShadow(new titanium_reindeer.Shadow(highlight,new titanium_reindeer.Vector2(4,4),20));
	this.addComponent("sprite",this.sprite);
	this.playerHighlight = new titanium_reindeer.CircleRenderer(30,1);
	this.playerHighlight.setFill(new titanium_reindeer.Color(0,0,0,1));
	this.playerHighlight.setShadow(new titanium_reindeer.Shadow(highlight,new titanium_reindeer.Vector2(0,0),0.5));
	this.collision = new titanium_reindeer.CollisionCircle(20,"main","ships");
	this.collision.registerCallback($closure(this,"collide"));
	this.addComponent("collision",this.collision);
	this.velocity = new titanium_reindeer.MovementComponent();
	this.addComponent("velocity",this.velocity);
	this.shipUi = shipUi;
	this.maxHealth = maxHealth;
	this.maxAmmo = maxAmmo;
	this.rechargeRate = rechargeRate;
	this.fireRate = fireRate;
	this.primaryAmmoCost = primaryAmmoCost;
	this.turnRate = turnRate;
	this.thrustAccel = thrustAccel;
	this.maxThrust = maxThrust;
	if(this.shipUi != null) this.shipUi.initialize(this.maxHealth,this.maxAmmo);
	this.health = this.maxHealth;
	this.ammo = this.maxAmmo;
	this.ammoRemainder = 0;
	this.msNextShot = 0;
	this.projectiles = new IntHash();
}
star_control.Ship.__name__ = ["star_control","Ship"];
star_control.Ship.__super__ = titanium_reindeer.GameObject;
for(var k in titanium_reindeer.GameObject.prototype ) star_control.Ship.prototype[k] = titanium_reindeer.GameObject.prototype[k];
star_control.Ship.prototype.sprite = null;
star_control.Ship.prototype.playerHighlight = null;
star_control.Ship.prototype.collision = null;
star_control.Ship.prototype.velocity = null;
star_control.Ship.prototype.hitSound = null;
star_control.Ship.prototype.hitSound2 = null;
star_control.Ship.prototype.shipUi = null;
star_control.Ship.prototype.isPlayer1 = null;
star_control.Ship.prototype.maxHealth = null;
star_control.Ship.prototype.maxAmmo = null;
star_control.Ship.prototype.rechargeRate = null;
star_control.Ship.prototype.fireRate = null;
star_control.Ship.prototype.primaryAmmoCost = null;
star_control.Ship.prototype.turnRate = null;
star_control.Ship.prototype.thrustAccel = null;
star_control.Ship.prototype.maxThrust = null;
star_control.Ship.prototype.health = null;
star_control.Ship.prototype.ammo = null;
star_control.Ship.prototype.ammoRemainder = null;
star_control.Ship.prototype.msNextShot = null;
star_control.Ship.prototype.facing = null;
star_control.Ship.prototype.projectiles = null;
star_control.Ship.prototype.hasInitialized = function() {
	if(this.hitSound == null) this.hitSound = this.getManager().game.soundManager.getSound("sound/ship_hit.mp3");
	if(this.hitSound2 == null) this.hitSound2 = this.getManager().game.soundManager.getSound("sound/ship_hit.mp3");
}
star_control.Ship.prototype.reset = function(startPos) {
	this.setPosition(startPos);
	this.setHealth(this.maxHealth);
	this.velocity.setVelocity(new titanium_reindeer.Vector2(0,0));
	var tempProjectiles = new Array();
	var $it0 = this.projectiles.iterator();
	while( $it0.hasNext() ) {
		var projectile = $it0.next();
		tempProjectiles.push(projectile);
	}
	var _g = 0;
	while(_g < tempProjectiles.length) {
		var projectile = tempProjectiles[_g];
		++_g;
		projectile.destroy();
		this.getManager().removeGameObject(projectile);
		this.projectiles.remove(projectile.id);
	}
}
star_control.Ship.prototype.thrust = function(msTimeStep) {
	var thrust = new titanium_reindeer.Vector2(1,0);
	thrust.rotate(this.facing);
	thrust.extend(this.thrustAccel * (msTimeStep / 1000));
	this.velocity.velocity.addTo(thrust);
	if(this.velocity.velocity.getMagnitude() > this.maxThrust) {
		var velo = this.velocity.velocity;
		velo.normalize();
		velo.extend(this.maxThrust);
	}
}
star_control.Ship.prototype.turn = function(direction,msTimeStep) {
	this.facing += (direction == star_control.Direction.Right?this.turnRate:-this.turnRate) * (msTimeStep / 1000);
	this.sprite.setRotation(this.facing);
}
star_control.Ship.prototype.enoughAmmo = function() {
	return this.ammo - this.primaryAmmoCost > 0;
}
star_control.Ship.prototype.attemptShoot = function(msTimeStep) {
	if(this.msNextShot <= 0 && this.enoughAmmo()) {
		this.shoot(msTimeStep);
		this.setAmmo(this.ammo - this.primaryAmmoCost);
		this.msNextShot = this.fireRate;
	}
}
star_control.Ship.prototype.shoot = function(msTimeStep) {
}
star_control.Ship.prototype.startShooting = function() {
}
star_control.Ship.prototype.shooting = function(msTimeStep) {
}
star_control.Ship.prototype.endShooting = function() {
}
star_control.Ship.prototype.update = function(msTimeStep) {
	var fieldRect = star_control.StarControlGame.getFieldRect();
	if(this.getPosition().getX() < fieldRect.getLeft()) {
		var _g = this.getPosition();
		_g.setX(_g.getX() + (fieldRect.width - 10));
	} else if(this.getPosition().getX() > fieldRect.getRight()) {
		var _g = this.getPosition();
		_g.setX(_g.getX() - (fieldRect.width - 10));
	} else if(this.getPosition().getY() < fieldRect.getTop()) {
		var _g = this.getPosition();
		_g.setY(_g.getY() + (fieldRect.height - 10));
	} else if(this.getPosition().getY() > fieldRect.getBottom()) {
		var _g = this.getPosition();
		_g.setY(_g.getY() - (fieldRect.height - 10));
	}
	if(this.msNextShot > 0) this.msNextShot -= msTimeStep;
	if(this.ammo < this.maxAmmo) {
		this.ammoRemainder += this.rechargeRate * (msTimeStep / 60000);
		if(this.ammoRemainder >= 1) {
			this.setAmmo(this.ammo + Math.floor(this.ammoRemainder));
			this.ammoRemainder -= Math.floor(this.ammoRemainder);
		}
	}
	var speed = this.velocity.velocity.getMagnitude();
	if(speed > 0) {
		speed = Math.max(0,speed - 25 * (msTimeStep / 1000));
		this.velocity.velocity.normalize();
		this.velocity.velocity.extend(speed);
	}
}
star_control.Ship.prototype.collide = function(other) {
	if(Std["is"](other.owner,star_control.Projectile)) {
		var projectile = (function($this) {
			var $r;
			var $t = other.owner;
			if(Std["is"]($t,star_control.Projectile)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
		this.setHealth(this.health - projectile.damage);
		this.getManager().game.soundManager.playRandomSound([this.hitSound,this.hitSound2]);
	}
}
star_control.Ship.prototype.setHealth = function(value) {
	value = Math.floor(Math.max(0,Math.min(value,this.maxHealth)));
	this.health = value;
	this.shipUi.updateHealth(this.health);
}
star_control.Ship.prototype.setAmmo = function(value) {
	value = Math.floor(Math.max(0,Math.min(value,this.maxAmmo)));
	this.ammo = value;
	this.shipUi.updateAmmo(this.ammo);
}
star_control.Ship.prototype.addProjectile = function(projectile) {
	this.getManager().addGameObject(projectile);
	this.projectiles.set(projectile.id,projectile);
}
star_control.Ship.prototype.removeProjectile = function(projectile) {
	if(this.projectiles.exists(projectile.id)) {
		this.getManager().removeGameObject(projectile);
		this.projectiles.remove(projectile.id);
	}
}
star_control.Ship.prototype.destroy = function() {
	titanium_reindeer.GameObject.prototype.destroy.call(this);
	this.removeComponent("sprite");
	this.removeComponent("collision");
	this.removeComponent("velocity");
	this.sprite.destroy();
	this.collision.destroy();
	this.velocity.destroy();
}
star_control.Ship.prototype.finalDestroy = function() {
	titanium_reindeer.GameObject.prototype.finalDestroy.call(this);
	this.sprite = null;
	this.collision = null;
	this.velocity = null;
}
star_control.Ship.prototype.__class__ = star_control.Ship;
star_control.Artillery = function(isPlayer1,shipUi) {
	if( isPlayer1 === $_ ) return;
	star_control.Ship.call(this,isPlayer1,"artillery.png",shipUi,14,16,300,500,8,Math.PI / 2,100,150);
}
star_control.Artillery.__name__ = ["star_control","Artillery"];
star_control.Artillery.__super__ = star_control.Ship;
for(var k in star_control.Ship.prototype ) star_control.Artillery.prototype[k] = star_control.Ship.prototype[k];
star_control.Artillery.prototype.fireSound = null;
star_control.Artillery.prototype.hasInitialized = function() {
	star_control.Ship.prototype.hasInitialized.call(this);
	if(this.fireSound == null) this.fireSound = this.getManager().game.soundManager.getSound("sound/artillery_fire.mp3");
}
star_control.Artillery.prototype.shoot = function(msTimeStep) {
	var newProjectile = new star_control.ArtilleryShell(this);
	this.addProjectile(newProjectile);
	this.getManager().game.soundManager.playSound(this.fireSound);
}
star_control.Artillery.prototype.shooting = function(msTimeStep) {
	this.attemptShoot(msTimeStep);
}
star_control.Artillery.prototype.__class__ = star_control.Artillery;
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
titanium_reindeer.Pattern = function(imageSource,option) {
	if( imageSource === $_ ) return;
	this.imageSource = imageSource;
	this.option = option;
}
titanium_reindeer.Pattern.__name__ = ["titanium_reindeer","Pattern"];
titanium_reindeer.Pattern.prototype.imageSource = null;
titanium_reindeer.Pattern.prototype.option = null;
titanium_reindeer.Pattern.prototype.getStyle = function(pen) {
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
titanium_reindeer.Pattern.prototype.identify = function() {
	return "Pattern(" + this.imageSource.identify() + "," + this.option[0] + ");";
}
titanium_reindeer.Pattern.prototype.__class__ = titanium_reindeer.Pattern;
titanium_reindeer.FontStyle = { __ename__ : ["titanium_reindeer","FontStyle"], __constructs__ : ["Normal","Italics","Oblique"] }
titanium_reindeer.FontStyle.Normal = ["Normal",0];
titanium_reindeer.FontStyle.Normal.toString = $estr;
titanium_reindeer.FontStyle.Normal.__enum__ = titanium_reindeer.FontStyle;
titanium_reindeer.FontStyle.Italics = ["Italics",1];
titanium_reindeer.FontStyle.Italics.toString = $estr;
titanium_reindeer.FontStyle.Italics.__enum__ = titanium_reindeer.FontStyle;
titanium_reindeer.FontStyle.Oblique = ["Oblique",2];
titanium_reindeer.FontStyle.Oblique.toString = $estr;
titanium_reindeer.FontStyle.Oblique.__enum__ = titanium_reindeer.FontStyle;
titanium_reindeer.FontVariant = { __ename__ : ["titanium_reindeer","FontVariant"], __constructs__ : ["Normal","SmallCaps"] }
titanium_reindeer.FontVariant.Normal = ["Normal",0];
titanium_reindeer.FontVariant.Normal.toString = $estr;
titanium_reindeer.FontVariant.Normal.__enum__ = titanium_reindeer.FontVariant;
titanium_reindeer.FontVariant.SmallCaps = ["SmallCaps",1];
titanium_reindeer.FontVariant.SmallCaps.toString = $estr;
titanium_reindeer.FontVariant.SmallCaps.__enum__ = titanium_reindeer.FontVariant;
titanium_reindeer.FontWeight = { __ename__ : ["titanium_reindeer","FontWeight"], __constructs__ : ["Normal","Bold","Size"] }
titanium_reindeer.FontWeight.Normal = ["Normal",0];
titanium_reindeer.FontWeight.Normal.toString = $estr;
titanium_reindeer.FontWeight.Normal.__enum__ = titanium_reindeer.FontWeight;
titanium_reindeer.FontWeight.Bold = ["Bold",1];
titanium_reindeer.FontWeight.Bold.toString = $estr;
titanium_reindeer.FontWeight.Bold.__enum__ = titanium_reindeer.FontWeight;
titanium_reindeer.FontWeight.Size = function(s) { var $x = ["Size",2,s]; $x.__enum__ = titanium_reindeer.FontWeight; $x.toString = $estr; return $x; }
titanium_reindeer.Component = function(p) {
	if( p === $_ ) return;
	titanium_reindeer.ManagedObject.call(this);
	this.setEnabled(true);
}
titanium_reindeer.Component.__name__ = ["titanium_reindeer","Component"];
titanium_reindeer.Component.__super__ = titanium_reindeer.ManagedObject;
for(var k in titanium_reindeer.ManagedObject.prototype ) titanium_reindeer.Component.prototype[k] = titanium_reindeer.ManagedObject.prototype[k];
titanium_reindeer.Component.prototype.owner = null;
titanium_reindeer.Component.prototype.componentManager = null;
titanium_reindeer.Component.prototype.getManager = function() {
	if(this.manager == null) return null; else return (function($this) {
		var $r;
		var $t = $this.manager;
		if(Std["is"]($t,titanium_reindeer.ComponentManager)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
}
titanium_reindeer.Component.prototype.enabled = null;
titanium_reindeer.Component.prototype.setEnabled = function(value) {
	this.enabled = value;
	return this.enabled;
}
titanium_reindeer.Component.prototype.setOwner = function(gameObject) {
	if(this.owner == null) this.owner = gameObject;
}
titanium_reindeer.Component.prototype.initialize = function() {
}
titanium_reindeer.Component.prototype.getManagerType = function() {
	return titanium_reindeer.ComponentManager;
}
titanium_reindeer.Component.prototype.notifyPositionChange = function() {
}
titanium_reindeer.Component.prototype.remove = function() {
	if(this.getManager() != null) this.getManager().removeComponent(this);
}
titanium_reindeer.Component.prototype.destroy = function() {
	this.remove();
	this.setEnabled(false);
	titanium_reindeer.ManagedObject.prototype.destroy.call(this);
}
titanium_reindeer.Component.prototype.finalDestroy = function() {
	titanium_reindeer.ManagedObject.prototype.finalDestroy.call(this);
	this.owner = null;
	this.componentManager = null;
	this.setEnabled(false);
}
titanium_reindeer.Component.prototype.__class__ = titanium_reindeer.Component;
titanium_reindeer.RendererComponent = function(width,height,layer) {
	if( width === $_ ) return;
	titanium_reindeer.Component.call(this);
	this.setInitialWidth(width);
	this.setInitialHeight(height);
	this.layerNum = layer;
	this.setAlpha(1);
	this.setShadow(new titanium_reindeer.Shadow(new titanium_reindeer.Color(0,0,0,0),new titanium_reindeer.Vector2(0,0),0));
	this.setRotation(0);
	this.watchedOffset = new titanium_reindeer.WatchedVector2(0,0,$closure(this,"offsetChanged"));
	this.effects = new Hash();
	this.lastIdentifier = "";
	this.lastRenderedPosition = new titanium_reindeer.Vector2(0,0);
	this.useFakes = false;
}
titanium_reindeer.RendererComponent.__name__ = ["titanium_reindeer","RendererComponent"];
titanium_reindeer.RendererComponent.__super__ = titanium_reindeer.Component;
for(var k in titanium_reindeer.Component.prototype ) titanium_reindeer.RendererComponent.prototype[k] = titanium_reindeer.Component.prototype[k];
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
titanium_reindeer.RendererComponent.prototype.rendererManager = null;
titanium_reindeer.RendererComponent.prototype.getRendererManager = function() {
	if(this.manager == null) return null; else return (function($this) {
		var $r;
		var $t = $this.manager;
		if(Std["is"]($t,titanium_reindeer.RendererComponentManager)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
}
titanium_reindeer.RendererComponent.prototype.layerNum = null;
titanium_reindeer.RendererComponent.prototype.layer = null;
titanium_reindeer.RendererComponent.prototype.setLayer = function(layerId) {
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
titanium_reindeer.RendererComponent.prototype.pen = null;
titanium_reindeer.RendererComponent.prototype.getPen = function() {
	if(this.useFakes) return this.fakePen;
	if(this.layer == null) return null; else return this.layer.pen;
}
titanium_reindeer.RendererComponent.prototype.watchedOffset = null;
titanium_reindeer.RendererComponent.prototype.offset = null;
titanium_reindeer.RendererComponent.prototype.getOffset = function() {
	return this.watchedOffset;
}
titanium_reindeer.RendererComponent.prototype.setOffset = function(value) {
	if(value != null) {
		if(this.watchedOffset != value && !this.watchedOffset.equal(value)) {
			this.watchedOffset.setVector2(value);
			this.setRedraw(true);
		}
	}
	return this.getOffset();
}
titanium_reindeer.RendererComponent.prototype.drawnWidth = null;
titanium_reindeer.RendererComponent.prototype.initialDrawnWidth = null;
titanium_reindeer.RendererComponent.prototype.setInitialWidth = function(value) {
	if(value < 0) value = 0;
	if(this.initialDrawnWidth != value) {
		this.initialDrawnWidth = value;
		this.recalculateDrawnWidthAndHeight();
		this.setRedraw(true);
	}
	return this.initialDrawnWidth;
}
titanium_reindeer.RendererComponent.prototype.drawnHeight = null;
titanium_reindeer.RendererComponent.prototype.initialDrawnHeight = null;
titanium_reindeer.RendererComponent.prototype.setInitialHeight = function(value) {
	if(value < 0) value = 0;
	if(this.initialDrawnHeight != value) {
		this.initialDrawnHeight = value;
		this.recalculateDrawnWidthAndHeight();
		this.setRedraw(true);
	}
	return this.initialDrawnHeight;
}
titanium_reindeer.RendererComponent.prototype.recalculateDrawnWidthAndHeight = function() {
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
titanium_reindeer.RendererComponent.prototype.shadow = null;
titanium_reindeer.RendererComponent.prototype.setShadow = function(value) {
	if(value != null) {
		if(this.shadow == null || !value.equal(this.shadow)) {
			this.shadow = value;
			this.recalculateDrawnWidthAndHeight();
			this.setRedraw(true);
		}
	}
	return this.shadow;
}
titanium_reindeer.RendererComponent.prototype.rotation = null;
titanium_reindeer.RendererComponent.prototype.setRotation = function(value) {
	value %= Math.PI * 2;
	if(value != this.rotation) {
		this.rotation = value;
		this.recalculateDrawnWidthAndHeight();
		this.setRedraw(true);
	}
	return this.rotation;
}
titanium_reindeer.RendererComponent.prototype.alpha = null;
titanium_reindeer.RendererComponent.prototype.setAlpha = function(value) {
	if(value < 0) value = 0; else if(value > 1) value = 1;
	if(value != this.alpha) {
		this.alpha = value;
		this.setRedraw(true);
	}
	return this.alpha;
}
titanium_reindeer.RendererComponent.prototype.renderComposition = null;
titanium_reindeer.RendererComponent.prototype.getRenderComposition = function() {
	if(this.layer == null) return titanium_reindeer.Composition.SourceOver; else return this.layer.renderComposition;
}
titanium_reindeer.RendererComponent.prototype.screenPos = null;
titanium_reindeer.RendererComponent.prototype.getScreenPos = function() {
	if(this.useFakes) return this.fakePosition;
	if(this.layer == null) return new titanium_reindeer.Vector2(0,0);
	if(this.owner == null) return this.layer.getVectorToScreen(new titanium_reindeer.Vector2(0,0)).add(this.getOffset()); else return this.layer.getVectorToScreen(this.owner.getPosition()).add(this.getOffset());
}
titanium_reindeer.RendererComponent.prototype.timeForRedraw = null;
titanium_reindeer.RendererComponent.prototype.setRedraw = function(value) {
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
titanium_reindeer.RendererComponent.prototype.lastRenderedPosition = null;
titanium_reindeer.RendererComponent.prototype.lastRenderedWidth = null;
titanium_reindeer.RendererComponent.prototype.lastRenderedHeight = null;
titanium_reindeer.RendererComponent.prototype.visible = null;
titanium_reindeer.RendererComponent.prototype.getVisible = function() {
	return this.enabled;
}
titanium_reindeer.RendererComponent.prototype.setVisible = function(value) {
	this.setEnabled(value);
	return this.enabled;
}
titanium_reindeer.RendererComponent.prototype.setEnabled = function(value) {
	this.setRedraw(true);
	return titanium_reindeer.Component.prototype.setEnabled.call(this,value);
}
titanium_reindeer.RendererComponent.prototype.effects = null;
titanium_reindeer.RendererComponent.prototype.lastIdentifier = null;
titanium_reindeer.RendererComponent.prototype.sharedBitmap = null;
titanium_reindeer.RendererComponent.prototype.usingSharedBitmap = null;
titanium_reindeer.RendererComponent.prototype.effectWorker = null;
titanium_reindeer.RendererComponent.prototype.useFakes = null;
titanium_reindeer.RendererComponent.prototype.fakePen = null;
titanium_reindeer.RendererComponent.prototype.fakePosition = null;
titanium_reindeer.RendererComponent.prototype.getManagerType = function() {
	return titanium_reindeer.RendererComponentManager;
}
titanium_reindeer.RendererComponent.prototype.initialize = function() {
	this.setLayer(this.layerNum);
	this.setRedraw(true);
}
titanium_reindeer.RendererComponent.prototype.notifyPositionChange = function() {
	this.setRedraw(true);
}
titanium_reindeer.RendererComponent.prototype.offsetChanged = function() {
	this.setRedraw(true);
}
titanium_reindeer.RendererComponent.prototype.fixRotationOnPoint = function(p) {
	if(this.rotation != 0) {
		var rotatedPoint = p.getRotate(this.rotation - 2 * Math.PI);
		this.getPen().translate(p.getX() - rotatedPoint.getX(),p.getY() - rotatedPoint.getY());
	}
}
titanium_reindeer.RendererComponent.prototype.update = function(msTimeStep) {
}
titanium_reindeer.RendererComponent.prototype.preRender = function() {
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
titanium_reindeer.RendererComponent.prototype.render = function() {
}
titanium_reindeer.RendererComponent.prototype.postRender = function() {
	this.setRedraw(false);
	this.getPen().restore();
}
titanium_reindeer.RendererComponent.prototype.renderSharedBitmap = function() {
	if(this.sharedBitmap != null) this.getPen().drawImage(this.sharedBitmap.image,this.getScreenPos().getX() - (this.drawnWidth / 2 + 1),this.getScreenPos().getY() - (this.drawnHeight / 2 + 1));
}
titanium_reindeer.RendererComponent.prototype.setLastRendered = function() {
	this.lastRenderedPosition = this.getScreenPos().getCopy();
	this.lastRenderedWidth = this.drawnWidth;
	this.lastRenderedHeight = this.drawnHeight;
}
titanium_reindeer.RendererComponent.prototype.identify = function() {
	var identifier = "";
	var $it0 = this.effects.iterator();
	while( $it0.hasNext() ) {
		var effect = $it0.next();
		if(identifier != "") identifier += ",";
		identifier += effect.identify();
	}
	return "Renderer(" + Math.round(this.drawnWidth) + "," + Math.round(this.drawnHeight) + "," + this.alpha + "," + this.shadow.identify() + "," + this.rotation + ",Effects(" + identifier + "));";
}
titanium_reindeer.RendererComponent.prototype.addEffect = function(name,effect) {
	this.effects.set(name,effect);
	this.setRedraw(true);
}
titanium_reindeer.RendererComponent.prototype.removeEffect = function(name) {
	this.effects.remove(name);
	this.setRedraw(true);
}
titanium_reindeer.RendererComponent.prototype.useAlternateCanvas = function(pen,newPosition) {
	this.fakePen = pen;
	if(newPosition == null) this.fakePosition = new titanium_reindeer.Vector2(this.drawnWidth / 2 + 1,this.drawnHeight / 2 + 1); else this.fakePosition = newPosition;
	this.useFakes = true;
}
titanium_reindeer.RendererComponent.prototype.disableAlternateCanvas = function() {
	this.fakePen = null;
	this.fakePosition = null;
	this.useFakes = false;
}
titanium_reindeer.RendererComponent.prototype.recreateBitmapData = function() {
	if(this.getRendererManager() != null && Lambda.count(this.effects) != 0) {
		var identifier = this.identify();
		if(this.lastIdentifier == identifier) return;
		this.lastIdentifier = identifier;
		this.usingSharedBitmap = true;
		if(this.getRendererManager().cachedBitmaps.exists(identifier)) this.sharedBitmap = this.getRendererManager().cachedBitmaps.get(identifier); else {
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
			if(bitmap.isLoaded) this.cachedBitmapLoaded(null); else bitmap.registerLoadEvent($closure(this,"cachedBitmapLoaded"));
			this.sharedBitmap = bitmap;
			this.getRendererManager().cachedBitmaps.set(identifier,bitmap);
			this.disableAlternateCanvas();
		}
	} else {
		this.usingSharedBitmap = false;
		this.lastIdentifier = "";
	}
}
titanium_reindeer.RendererComponent.prototype.cachedBitmapLoaded = function(event) {
	this.setRedraw(true);
}
titanium_reindeer.RendererComponent.prototype.getRectBounds = function(extraEdgeSize) {
	var width = this.drawnWidth + extraEdgeSize;
	var height = this.drawnHeight + extraEdgeSize;
	return new titanium_reindeer.Rect(this.getScreenPos().getX() - width / 2,this.getScreenPos().getY() - height / 2,width,height);
}
titanium_reindeer.RendererComponent.prototype.getLastRectBounds = function(extraEdgeSize) {
	var width = this.lastRenderedWidth + extraEdgeSize;
	var height = this.lastRenderedHeight + extraEdgeSize;
	return new titanium_reindeer.Rect(this.lastRenderedPosition.getX() - width / 2,this.lastRenderedPosition.getY() - height / 2,width,height);
}
titanium_reindeer.RendererComponent.prototype.finalDestroy = function() {
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
titanium_reindeer.RendererComponent.prototype.__class__ = titanium_reindeer.RendererComponent;
titanium_reindeer.StrokeFillRenderer = function(width,height,layer) {
	if( width === $_ ) return;
	titanium_reindeer.RendererComponent.call(this,width,height,layer);
	this.setFill(titanium_reindeer.Color.getWhiteConst());
	this.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.setLineWidth(0);
	this.setLineCap(titanium_reindeer.LineCapType.Butt);
	this.setLineJoin(titanium_reindeer.LineJoinType.Miter);
	this.setMiterLimit(10.0);
}
titanium_reindeer.StrokeFillRenderer.__name__ = ["titanium_reindeer","StrokeFillRenderer"];
titanium_reindeer.StrokeFillRenderer.__super__ = titanium_reindeer.RendererComponent;
for(var k in titanium_reindeer.RendererComponent.prototype ) titanium_reindeer.StrokeFillRenderer.prototype[k] = titanium_reindeer.RendererComponent.prototype[k];
titanium_reindeer.StrokeFillRenderer.prototype.fillStyle = null;
titanium_reindeer.StrokeFillRenderer.prototype.currentFill = null;
titanium_reindeer.StrokeFillRenderer.prototype.fillColor = null;
titanium_reindeer.StrokeFillRenderer.prototype.setFill = function(value) {
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
titanium_reindeer.StrokeFillRenderer.prototype.fillGradient = null;
titanium_reindeer.StrokeFillRenderer.prototype.setFillGradient = function(value) {
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
titanium_reindeer.StrokeFillRenderer.prototype.fillPattern = null;
titanium_reindeer.StrokeFillRenderer.prototype.setFillPattern = function(value) {
	if(value != null) {
		this.fillPattern = value;
		if(value.imageSource.isLoaded) {
			this.currentFill = titanium_reindeer.FillTypes.Pattern;
			if(this.getPen() != null && this.fillStyle != value.getStyle(this.getPen())) {
				this.fillStyle = value.getStyle(this.getPen());
				this.setRedraw(true);
			}
		} else value.imageSource.registerLoadEvent($closure(this,"fillPatternImageLoaded"));
	}
	return value;
}
titanium_reindeer.StrokeFillRenderer.prototype.strokeStyle = null;
titanium_reindeer.StrokeFillRenderer.prototype.currentStroke = null;
titanium_reindeer.StrokeFillRenderer.prototype.strokeColor = null;
titanium_reindeer.StrokeFillRenderer.prototype.setStrokeColor = function(value) {
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
titanium_reindeer.StrokeFillRenderer.prototype.strokeGradient = null;
titanium_reindeer.StrokeFillRenderer.prototype.setStrokeGradient = function(value) {
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
titanium_reindeer.StrokeFillRenderer.prototype.lineWidth = null;
titanium_reindeer.StrokeFillRenderer.prototype.setLineWidth = function(value) {
	if(value != this.lineWidth) {
		this.lineWidth = value;
		this.setRedraw(true);
	}
	return value;
}
titanium_reindeer.StrokeFillRenderer.prototype.lineCap = null;
titanium_reindeer.StrokeFillRenderer.prototype.setLineCap = function(value) {
	if(value != this.lineCap) {
		this.lineCap = value;
		this.setRedraw(true);
	}
	return value;
}
titanium_reindeer.StrokeFillRenderer.prototype.lineJoin = null;
titanium_reindeer.StrokeFillRenderer.prototype.setLineJoin = function(value) {
	if(value != this.lineJoin) {
		this.lineJoin = value;
		this.setRedraw(true);
	}
	return value;
}
titanium_reindeer.StrokeFillRenderer.prototype.miterLimit = null;
titanium_reindeer.StrokeFillRenderer.prototype.setMiterLimit = function(value) {
	if(value != this.miterLimit) {
		this.miterLimit = value;
		this.setRedraw(true);
	}
	return value;
}
titanium_reindeer.StrokeFillRenderer.prototype.initialize = function() {
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
titanium_reindeer.StrokeFillRenderer.prototype.fillPatternImageLoaded = function(event) {
	this.currentFill = titanium_reindeer.FillTypes.Pattern;
	if(this.getPen() != null && this.fillStyle != this.fillPattern.getStyle(this.getPen())) {
		this.fillStyle = this.fillPattern.getStyle(this.getPen());
		this.setRedraw(true);
	}
}
titanium_reindeer.StrokeFillRenderer.prototype.preRender = function() {
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
titanium_reindeer.StrokeFillRenderer.prototype.identify = function() {
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
titanium_reindeer.StrokeFillRenderer.prototype.destroy = function() {
	titanium_reindeer.RendererComponent.prototype.destroy.call(this);
	this.fillStyle = null;
	this.setFill(null);
	this.setFillGradient(null);
	this.setFillPattern(null);
	this.setStrokeColor(null);
	this.setStrokeGradient(null);
}
titanium_reindeer.StrokeFillRenderer.prototype.__class__ = titanium_reindeer.StrokeFillRenderer;
titanium_reindeer.TextRenderer = function(text,layer) {
	if( text === $_ ) return;
	titanium_reindeer.StrokeFillRenderer.call(this,0,this.fontSize,layer);
	this.setText(text);
	this.setFontStyle(titanium_reindeer.FontStyle.Normal);
	this.setFontVariant(titanium_reindeer.FontVariant.Normal);
	this.setFontWeight(titanium_reindeer.FontWeight.Normal);
	this.setFontSize(10);
	this.setFontFamily("sans-serif");
}
titanium_reindeer.TextRenderer.__name__ = ["titanium_reindeer","TextRenderer"];
titanium_reindeer.TextRenderer.__super__ = titanium_reindeer.StrokeFillRenderer;
for(var k in titanium_reindeer.StrokeFillRenderer.prototype ) titanium_reindeer.TextRenderer.prototype[k] = titanium_reindeer.StrokeFillRenderer.prototype[k];
titanium_reindeer.TextRenderer.prototype.text = null;
titanium_reindeer.TextRenderer.prototype.setText = function(value) {
	if(this.text != value) {
		this.text = value;
		this.recalculateSize();
	}
	return this.text;
}
titanium_reindeer.TextRenderer.prototype.fontStyle = null;
titanium_reindeer.TextRenderer.prototype.setFontStyle = function(value) {
	if(this.fontStyle != value) {
		this.fontStyle = value;
		this.recalculateSize();
	}
	return this.fontStyle;
}
titanium_reindeer.TextRenderer.prototype.fontVariant = null;
titanium_reindeer.TextRenderer.prototype.setFontVariant = function(value) {
	if(this.fontVariant != value) {
		this.fontVariant = value;
		this.recalculateSize();
	}
	return this.fontVariant;
}
titanium_reindeer.TextRenderer.prototype.fontWeight = null;
titanium_reindeer.TextRenderer.prototype.setFontWeight = function(value) {
	if(this.fontWeight != value) {
		this.fontWeight = value;
		this.recalculateSize();
	}
	return this.fontWeight;
}
titanium_reindeer.TextRenderer.prototype.fontSize = null;
titanium_reindeer.TextRenderer.prototype.setFontSize = function(value) {
	if(this.fontSize != value) {
		this.fontSize = value;
		this.recalculateSize();
	}
	return this.fontSize;
}
titanium_reindeer.TextRenderer.prototype.fontFamily = null;
titanium_reindeer.TextRenderer.prototype.setFontFamily = function(value) {
	if(this.fontFamily != value) {
		this.fontFamily = value;
		this.recalculateSize();
	}
	return this.fontFamily;
}
titanium_reindeer.TextRenderer.prototype.initialize = function() {
	titanium_reindeer.StrokeFillRenderer.prototype.initialize.call(this);
	this.recalculateSize();
}
titanium_reindeer.TextRenderer.prototype.setFontAttributes = function() {
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
titanium_reindeer.TextRenderer.prototype.recalculateSize = function() {
	if(this.getPen() != null) {
		this.setFontAttributes();
		var measuredFont = this.getPen().measureText(this.text);
		this.setInitialWidth(measuredFont.width + (this.lineWidth > 0?this.lineWidth:0));
		this.setInitialHeight(this.fontSize + (this.lineWidth > 0?this.lineWidth:0));
		this.setRedraw(true);
	}
}
titanium_reindeer.TextRenderer.prototype.render = function() {
	titanium_reindeer.StrokeFillRenderer.prototype.render.call(this);
	this.setFontAttributes();
	this.getPen().fillText(this.text,0,0);
	if(this.lineWidth > 0) this.getPen().strokeText(this.text,0,0);
}
titanium_reindeer.TextRenderer.prototype.identify = function() {
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
titanium_reindeer.TextRenderer.prototype.__class__ = titanium_reindeer.TextRenderer;
titanium_reindeer.MouseAction = { __ename__ : ["titanium_reindeer","MouseAction"], __constructs__ : ["Move","Down","Up"] }
titanium_reindeer.MouseAction.Move = ["Move",0];
titanium_reindeer.MouseAction.Move.toString = $estr;
titanium_reindeer.MouseAction.Move.__enum__ = titanium_reindeer.MouseAction;
titanium_reindeer.MouseAction.Down = ["Down",1];
titanium_reindeer.MouseAction.Down.toString = $estr;
titanium_reindeer.MouseAction.Down.__enum__ = titanium_reindeer.MouseAction;
titanium_reindeer.MouseAction.Up = ["Up",2];
titanium_reindeer.MouseAction.Up.toString = $estr;
titanium_reindeer.MouseAction.Up.__enum__ = titanium_reindeer.MouseAction;
titanium_reindeer.ExclusionsMaxDepthPair = function(exclusions,maxDepth) {
	if( exclusions === $_ ) return;
	this.exclusions = exclusions;
	this.maxDepth = maxDepth;
}
titanium_reindeer.ExclusionsMaxDepthPair.__name__ = ["titanium_reindeer","ExclusionsMaxDepthPair"];
titanium_reindeer.ExclusionsMaxDepthPair.prototype.exclusions = null;
titanium_reindeer.ExclusionsMaxDepthPair.prototype.maxDepth = null;
titanium_reindeer.ExclusionsMaxDepthPair.prototype.__class__ = titanium_reindeer.ExclusionsMaxDepthPair;
titanium_reindeer.ComponentHandlerPair = function(component,handler) {
	if( component === $_ ) return;
	this.component = component;
	this.handler = handler;
}
titanium_reindeer.ComponentHandlerPair.__name__ = ["titanium_reindeer","ComponentHandlerPair"];
titanium_reindeer.ComponentHandlerPair.prototype.component = null;
titanium_reindeer.ComponentHandlerPair.prototype.handler = null;
titanium_reindeer.ComponentHandlerPair.prototype.__class__ = titanium_reindeer.ComponentHandlerPair;
titanium_reindeer.MouseRegionManager = function(manager) {
	if( manager === $_ ) return;
	this.collisionManager = manager;
	this.collisionManager.gameObjectManager.game.inputManager.registerMouseMoveEvent($closure(this,"mouseMoveHandle"));
	this.collisionManager.gameObjectManager.game.inputManager.registerMouseButtonAnyEvent($closure(this,"mouseButtonHandle"));
	this.layerToPairsMap = new Hash();
	this.exclusionRegions = new IntHash();
	this.exclusionRTree = new titanium_reindeer.RTreeFastInt();
	this.nextExclusionId = 0;
}
titanium_reindeer.MouseRegionManager.__name__ = ["titanium_reindeer","MouseRegionManager"];
titanium_reindeer.MouseRegionManager.prototype.collisionManager = null;
titanium_reindeer.MouseRegionManager.prototype.layerToPairsMap = null;
titanium_reindeer.MouseRegionManager.prototype.exclusionRegions = null;
titanium_reindeer.MouseRegionManager.prototype.exclusionRTree = null;
titanium_reindeer.MouseRegionManager.prototype.nextExclusionId = null;
titanium_reindeer.MouseRegionManager.prototype.getHandler = function(component) {
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
titanium_reindeer.MouseRegionManager.prototype.createExclusionRegion = function(depth,shape) {
	if(shape == null) return null;
	var newExclusionRegion = new titanium_reindeer.MouseExclusionRegion(this,this.nextExclusionId,depth,shape);
	this.exclusionRegions.set(this.nextExclusionId,newExclusionRegion);
	this.exclusionRTree.insert(shape.getMinBoundingRect(),this.nextExclusionId);
	this.nextExclusionId += 1;
	return newExclusionRegion;
}
titanium_reindeer.MouseRegionManager.prototype.updateExclusionRegionShape = function(exclusionRegion) {
	if(exclusionRegion == null || !this.exclusionRegions.exists(exclusionRegion.id)) return;
	this.exclusionRTree.update(exclusionRegion.shape.getMinBoundingRect(),exclusionRegion.id);
}
titanium_reindeer.MouseRegionManager.prototype.removeExclusionRegion = function(exclusionRegion) {
	if(exclusionRegion == null || !this.exclusionRegions.exists(exclusionRegion.id)) return;
	this.exclusionRegions.remove(exclusionRegion.id);
	this.exclusionRTree.remove(exclusionRegion.id);
}
titanium_reindeer.MouseRegionManager.prototype.mouseMoveHandle = function(mousePos) {
	this.handleAction(titanium_reindeer.MouseAction.Move,mousePos,titanium_reindeer.MouseButton.None);
}
titanium_reindeer.MouseRegionManager.prototype.mouseButtonHandle = function(button,buttonState,mousePos) {
	var action;
	if(buttonState == titanium_reindeer.MouseButtonState.Down) action = titanium_reindeer.MouseAction.Down; else if(buttonState == titanium_reindeer.MouseButtonState.Up) action = titanium_reindeer.MouseAction.Up; else return;
	this.handleAction(action,mousePos,button);
}
titanium_reindeer.MouseRegionManager.prototype.handleAction = function(action,mousePos,button) {
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
titanium_reindeer.MouseRegionManager.prototype.organizeIntersectingExclusions = function(mousePos) {
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
titanium_reindeer.MouseRegionManager.prototype.destroy = function() {
	this.collisionManager.gameObjectManager.game.inputManager.unregisterMouseMoveEvent($closure(this,"mouseMoveHandle"));
	this.collisionManager.gameObjectManager.game.inputManager.unregisterMouseButtonAnyEvent($closure(this,"mouseButtonHandle"));
	this.collisionManager = null;
	var $it0 = this.layerToPairsMap.keys();
	while( $it0.hasNext() ) {
		var layerName = $it0.next();
		var pairs = this.layerToPairsMap.get(layerName);
		var $it1 = pairs.keys();
		while( $it1.hasNext() ) {
			var id = $it1.next();
			pairs.get(id).handler.destroy();
			pairs.get(id).handler = null;
			pairs.get(id).component = null;
			pairs.remove(id);
		}
		pairs = null;
		this.layerToPairsMap.remove(layerName);
	}
	this.layerToPairsMap = null;
}
titanium_reindeer.MouseRegionManager.prototype.__class__ = titanium_reindeer.MouseRegionManager;
titanium_reindeer.ObjectManager = function(p) {
	if( p === $_ ) return;
	this.nextId = 0;
	this.objects = new IntHash();
	this.objectsToRemove = new IntHash();
}
titanium_reindeer.ObjectManager.__name__ = ["titanium_reindeer","ObjectManager"];
titanium_reindeer.ObjectManager.prototype.nextId = null;
titanium_reindeer.ObjectManager.prototype.objects = null;
titanium_reindeer.ObjectManager.prototype.objectsToRemove = null;
titanium_reindeer.ObjectManager.prototype.getNextId = function() {
	return this.nextId++;
}
titanium_reindeer.ObjectManager.prototype.getObject = function(id) {
	if(this.objects.exists(id)) return this.objects.get(id); else return null;
}
titanium_reindeer.ObjectManager.prototype.objectIdExists = function(id) {
	return this.objects.exists(id);
}
titanium_reindeer.ObjectManager.prototype.addObject = function(object) {
	object.setManager(this);
	this.objects.set(object.id,object);
}
titanium_reindeer.ObjectManager.prototype.removeObject = function(obj) {
	if(this.objects.exists(obj.id) && !this.objectsToRemove.exists(obj.id)) this.objectsToRemove.set(obj.id,obj.id);
}
titanium_reindeer.ObjectManager.prototype.removeObjects = function() {
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
titanium_reindeer.ObjectManager.prototype.destroy = function() {
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
titanium_reindeer.ObjectManager.prototype.__class__ = titanium_reindeer.ObjectManager;
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
titanium_reindeer.Color = function(red,green,blue,alpha) {
	if( red === $_ ) return;
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
}
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
List = function(p) {
	if( p === $_ ) return;
	this.length = 0;
}
List.__name__ = ["List"];
List.prototype.h = null;
List.prototype.q = null;
List.prototype.length = null;
List.prototype.add = function(item) {
	var x = [item];
	if(this.h == null) this.h = x; else this.q[1] = x;
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
	s.b[s.b.length] = "{" == null?"null":"{";
	while(l != null) {
		if(first) first = false; else s.b[s.b.length] = ", " == null?"null":", ";
		s.add(Std.string(l[0]));
		l = l[1];
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
List.prototype.join = function(sep) {
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
titanium_reindeer.RTreeFastNode = function(bounds) {
	if( bounds === $_ ) return;
	this.bounds = bounds;
}
titanium_reindeer.RTreeFastNode.__name__ = ["titanium_reindeer","RTreeFastNode"];
titanium_reindeer.RTreeFastNode.prototype.bounds = null;
titanium_reindeer.RTreeFastNode.prototype.parent = null;
titanium_reindeer.RTreeFastNode.prototype.__class__ = titanium_reindeer.RTreeFastNode;
titanium_reindeer.RTreeFastLeaf = function(bounds,value) {
	if( bounds === $_ ) return;
	titanium_reindeer.RTreeFastNode.call(this,bounds);
	this.value = value;
}
titanium_reindeer.RTreeFastLeaf.__name__ = ["titanium_reindeer","RTreeFastLeaf"];
titanium_reindeer.RTreeFastLeaf.__super__ = titanium_reindeer.RTreeFastNode;
for(var k in titanium_reindeer.RTreeFastNode.prototype ) titanium_reindeer.RTreeFastLeaf.prototype[k] = titanium_reindeer.RTreeFastNode.prototype[k];
titanium_reindeer.RTreeFastLeaf.prototype.value = null;
titanium_reindeer.RTreeFastLeaf.prototype.__class__ = titanium_reindeer.RTreeFastLeaf;
titanium_reindeer.RTreeFastBranch = function(bounds) {
	if( bounds === $_ ) return;
	titanium_reindeer.RTreeFastNode.call(this,bounds);
	this.children = new Array();
	this.isLeaf = false;
}
titanium_reindeer.RTreeFastBranch.__name__ = ["titanium_reindeer","RTreeFastBranch"];
titanium_reindeer.RTreeFastBranch.__super__ = titanium_reindeer.RTreeFastNode;
for(var k in titanium_reindeer.RTreeFastNode.prototype ) titanium_reindeer.RTreeFastBranch.prototype[k] = titanium_reindeer.RTreeFastNode.prototype[k];
titanium_reindeer.RTreeFastBranch.prototype.children = null;
titanium_reindeer.RTreeFastBranch.prototype.isLeaf = null;
titanium_reindeer.RTreeFastBranch.prototype.addChild = function(node) {
	this.children.push(node);
	node.parent = this;
}
titanium_reindeer.RTreeFastBranch.prototype.recalculateBounds = function() {
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
titanium_reindeer.RTreeFastBranch.prototype.__class__ = titanium_reindeer.RTreeFastBranch;
titanium_reindeer.RTreeFastInt = function(p) {
	if( p === $_ ) return;
	this.setMaxChildren(3);
	this.intMap = new IntHash();
}
titanium_reindeer.RTreeFastInt.__name__ = ["titanium_reindeer","RTreeFastInt"];
titanium_reindeer.RTreeFastInt.prototype.maxChildren = null;
titanium_reindeer.RTreeFastInt.prototype.setMaxChildren = function(value) {
	if(value > 1) this.maxChildren = value;
	return this.maxChildren;
}
titanium_reindeer.RTreeFastInt.prototype.root = null;
titanium_reindeer.RTreeFastInt.prototype.intMap = null;
titanium_reindeer.RTreeFastInt.prototype.debugCanvas = null;
titanium_reindeer.RTreeFastInt.prototype.debugOffset = null;
titanium_reindeer.RTreeFastInt.prototype.debugSteps = null;
titanium_reindeer.RTreeFastInt.prototype.insert = function(rect,value) {
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
titanium_reindeer.RTreeFastInt.prototype.addChildToNode = function(parent,child) {
	parent.addChild(child);
	parent.bounds = titanium_reindeer.Rect.expandToCover(parent.bounds,child.bounds);
	if(parent.children.length <= this.maxChildren) {
		if(parent.children.length == 1 && Std["is"](child,titanium_reindeer.RTreeFastLeaf)) parent.isLeaf = true;
	} else this.linearSplit(parent);
}
titanium_reindeer.RTreeFastInt.prototype.linearSplit = function(parent) {
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
titanium_reindeer.RTreeFastInt.prototype.update = function(newBounds,value) {
	if(!this.intMap.exists(value)) return;
	var leaf = this.intMap.get(value);
	leaf.bounds = newBounds;
	this.updateNodeHierarchy(leaf);
}
titanium_reindeer.RTreeFastInt.prototype.remove = function(value) {
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
titanium_reindeer.RTreeFastInt.prototype.updateNodeHierarchy = function(node) {
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
titanium_reindeer.RTreeFastInt.prototype.getRectIntersectingValues = function(rect) {
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
titanium_reindeer.RTreeFastInt.prototype.getPointIntersectingValues = function(point) {
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
titanium_reindeer.RTreeFastInt.prototype.drawDebug = function() {
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
titanium_reindeer.RTreeFastInt.prototype.__class__ = titanium_reindeer.RTreeFastInt;
titanium_reindeer.CircleRenderer = function(radius,layer) {
	if( radius === $_ ) return;
	titanium_reindeer.StrokeFillRenderer.call(this,radius * 2,radius * 2,layer);
	this.setRadius(radius);
}
titanium_reindeer.CircleRenderer.__name__ = ["titanium_reindeer","CircleRenderer"];
titanium_reindeer.CircleRenderer.__super__ = titanium_reindeer.StrokeFillRenderer;
for(var k in titanium_reindeer.StrokeFillRenderer.prototype ) titanium_reindeer.CircleRenderer.prototype[k] = titanium_reindeer.StrokeFillRenderer.prototype[k];
titanium_reindeer.CircleRenderer.prototype.radius = null;
titanium_reindeer.CircleRenderer.prototype.setRadius = function(value) {
	if(this.radius != value) {
		this.radius = value;
		this.setInitialWidth(value * 2);
		this.setInitialHeight(value * 2);
	}
	return this.radius;
}
titanium_reindeer.CircleRenderer.prototype.render = function() {
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
titanium_reindeer.CircleRenderer.prototype.identify = function() {
	return titanium_reindeer.StrokeFillRenderer.prototype.identify.call(this) + "Circle(" + this.radius + ");";
}
titanium_reindeer.CircleRenderer.prototype.__class__ = titanium_reindeer.CircleRenderer;
star_control.Projectile = function(owner,sprite,speed,damage,msLifeTime) {
	if( owner === $_ ) return;
	titanium_reindeer.GameObject.call(this);
	this.owner = owner;
	this.speed = speed;
	this.damage = damage;
	this.msLifeLeft = msLifeTime;
	this.sprite = sprite;
	this.addComponent("sprite",sprite);
	this.collision = new titanium_reindeer.CollisionCircle(5,"main","bullets");
	this.collision.registerCallback($closure(this,"collide"));
	this.addComponent("collision",this.collision);
	if(this.owner != null) {
		var offset = new titanium_reindeer.Vector2(1,0);
		offset.rotate(this.owner.facing);
		offset.extend(40);
		this.setPosition(this.owner.getPosition().add(offset));
		offset.normalize();
		offset.extend(this.speed);
		this.velocity = new titanium_reindeer.MovementComponent(offset);
		this.addComponent("velocity",this.velocity);
		this.sprite.setRotation(this.owner.facing);
	}
}
star_control.Projectile.__name__ = ["star_control","Projectile"];
star_control.Projectile.__super__ = titanium_reindeer.GameObject;
for(var k in titanium_reindeer.GameObject.prototype ) star_control.Projectile.prototype[k] = titanium_reindeer.GameObject.prototype[k];
star_control.Projectile.prototype.sprite = null;
star_control.Projectile.prototype.collision = null;
star_control.Projectile.prototype.velocity = null;
star_control.Projectile.prototype.owner = null;
star_control.Projectile.prototype.speed = null;
star_control.Projectile.prototype.damage = null;
star_control.Projectile.prototype.msLifeLeft = null;
star_control.Projectile.prototype.update = function(msTimeStep) {
	var fieldRect = star_control.StarControlGame.getFieldRect();
	if(this.getPosition().getX() < fieldRect.getLeft()) {
		var _g = this.getPosition();
		_g.setX(_g.getX() + (fieldRect.width - 10));
	} else if(this.getPosition().getX() > fieldRect.getRight()) {
		var _g = this.getPosition();
		_g.setX(_g.getX() - (fieldRect.width - 10));
	} else if(this.getPosition().getY() < fieldRect.getTop()) {
		var _g = this.getPosition();
		_g.setY(_g.getY() + (fieldRect.height - 10));
	} else if(this.getPosition().getY() > fieldRect.getBottom()) {
		var _g = this.getPosition();
		_g.setY(_g.getY() - (fieldRect.height - 10));
	}
	if(this.msLifeLeft != -1) {
		this.msLifeLeft -= msTimeStep;
		if(this.msLifeLeft <= 0) {
			this.owner.removeProjectile(this);
			this.destroy();
		}
	}
}
star_control.Projectile.prototype.collide = function(other) {
	this.destroy();
}
star_control.Projectile.prototype.destroy = function() {
	titanium_reindeer.GameObject.prototype.destroy.call(this);
	this.removeComponent("sprite");
	this.removeComponent("collision");
	this.removeComponent("velocity");
	this.sprite.destroy();
	this.collision.destroy();
	this.velocity.destroy();
}
star_control.Projectile.prototype.finalDestroy = function() {
	titanium_reindeer.GameObject.prototype.finalDestroy.call(this);
	this.owner = null;
	this.sprite = null;
	this.collision = null;
	this.velocity = null;
}
star_control.Projectile.prototype.__class__ = star_control.Projectile;
star_control.FighterBullet = function(owner) {
	if( owner === $_ ) return;
	var sprite = new titanium_reindeer.CircleRenderer(5,2);
	sprite.setFill(new titanium_reindeer.Color(0,0,0,0));
	sprite.setStrokeColor(titanium_reindeer.Color.getWhiteConst());
	sprite.setLineWidth(2);
	star_control.Projectile.call(this,owner,sprite,300,1,1500);
}
star_control.FighterBullet.__name__ = ["star_control","FighterBullet"];
star_control.FighterBullet.__super__ = star_control.Projectile;
for(var k in star_control.Projectile.prototype ) star_control.FighterBullet.prototype[k] = star_control.Projectile.prototype[k];
star_control.FighterBullet.prototype.__class__ = star_control.FighterBullet;
titanium_reindeer.RenderLayer = function(layerManager,id,targetElement,width,height,clearColor) {
	if( layerManager === $_ ) return;
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
	this.watchedOffset = new titanium_reindeer.WatchedVector2(0,0,$closure(this,"offsetChanged"));
	this.renderers = new IntHash();
	this.redrawBackground = true;
}
titanium_reindeer.RenderLayer.__name__ = ["titanium_reindeer","RenderLayer"];
titanium_reindeer.RenderLayer.prototype.layerManager = null;
titanium_reindeer.RenderLayer.prototype.id = null;
titanium_reindeer.RenderLayer.prototype.pen = null;
titanium_reindeer.RenderLayer.prototype.canvas = null;
titanium_reindeer.RenderLayer.prototype.clearColor = null;
titanium_reindeer.RenderLayer.prototype.setClearColor = function(color) {
	if(color != null) {
		if(this.clearColor == null || color.equal(this.clearColor)) {
			this.clearColor = color.getCopy();
			this.redrawBackground = true;
		}
	}
	return this.clearColor;
}
titanium_reindeer.RenderLayer.prototype.renderComposition = null;
titanium_reindeer.RenderLayer.prototype.setRenderComposition = function(comp) {
	if(comp != this.renderComposition) {
		this.renderComposition = comp;
		this.redrawBackground = true;
	}
	return this.renderComposition;
}
titanium_reindeer.RenderLayer.prototype.visible = null;
titanium_reindeer.RenderLayer.prototype.setVisible = function(value) {
	if(value != this.visible) {
		this.visible = value;
		if(this.visible) this.redrawBackground = true;
	}
	return this.visible;
}
titanium_reindeer.RenderLayer.prototype.alpha = null;
titanium_reindeer.RenderLayer.prototype.setAlpha = function(value) {
	if(value != this.alpha && value >= 0 && value <= 1) this.alpha = value;
	return this.alpha;
}
titanium_reindeer.RenderLayer.prototype.width = null;
titanium_reindeer.RenderLayer.prototype.height = null;
titanium_reindeer.RenderLayer.prototype.watchedOffset = null;
titanium_reindeer.RenderLayer.prototype.renderOffset = null;
titanium_reindeer.RenderLayer.prototype.getOffset = function() {
	return this.watchedOffset;
}
titanium_reindeer.RenderLayer.prototype.setOffset = function(value) {
	if(value != null) {
		if(this.watchedOffset != value && !this.watchedOffset.equal(value)) {
			this.watchedOffset.setVector2(value);
			this.offsetChanged();
			this.redrawBackground = true;
		}
	}
	return this.getOffset();
}
titanium_reindeer.RenderLayer.prototype.redrawBackground = null;
titanium_reindeer.RenderLayer.prototype.renderers = null;
titanium_reindeer.RenderLayer.prototype.renderersYetToRedraw = null;
titanium_reindeer.RenderLayer.prototype.renderersToRedraw = null;
titanium_reindeer.RenderLayer.prototype.clearing = null;
titanium_reindeer.RenderLayer.prototype.offsetChanged = function() {
	if(this.renderers != null) {
		var $it0 = this.renderers.iterator();
		while( $it0.hasNext() ) {
			var renderer = $it0.next();
			renderer.setRedraw(true);
		}
	}
}
titanium_reindeer.RenderLayer.prototype.clear = function() {
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
titanium_reindeer.RenderLayer.prototype.clearArea = function(x,y,width,height) {
	this.pen.clearRect(x,y,width,height);
	if(this.clearColor != null) {
		this.pen.fillStyle = this.clearColor.getRgba();
		this.pen.fillRect(x - 1,y - 1,width + 2,height + 2);
	}
}
titanium_reindeer.RenderLayer.prototype.finalizeRedrawList = function() {
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
titanium_reindeer.RenderLayer.prototype.display = function(screenPen) {
	if(this.visible && this.alpha > 0) {
		screenPen.save();
		screenPen.globalAlpha = this.alpha;
		screenPen.drawImage(this.canvas,0,0);
		screenPen.restore();
	}
	this.redrawBackground = false;
}
titanium_reindeer.RenderLayer.prototype.getVectorToScreen = function(vector) {
	if(vector == null) return this.getOffset().getCopy();
	return vector.add(this.getOffset());
}
titanium_reindeer.RenderLayer.prototype.getVectorFromScreen = function(vector) {
	return vector.subtract(this.getOffset());
}
titanium_reindeer.RenderLayer.prototype.addRenderer = function(renderer) {
	if(!this.renderers.exists(renderer.id)) {
		this.ensureYetToRedrawIsReady();
		this.renderersYetToRedraw.set(renderer.id,renderer.id);
		this.renderers.set(renderer.id,renderer);
	}
}
titanium_reindeer.RenderLayer.prototype.removeRenderer = function(renderer) {
	if(this.renderers.exists(renderer.id)) this.renderers.remove(renderer.id);
	if(this.renderersToRedraw.exists(renderer.id)) this.renderersToRedraw.remove(renderer.id);
	if(this.renderersYetToRedraw.exists(renderer.id)) this.renderersYetToRedraw.remove(renderer.id);
}
titanium_reindeer.RenderLayer.prototype.redrawRenderer = function(renderer) {
	if(this.clearing || !this.renderers.exists(renderer.id)) return;
	if(this.renderersToRedraw == null) this.renderersToRedraw = new IntHash();
	this.ensureYetToRedrawIsReady();
	if(this.renderersYetToRedraw.exists(renderer.id)) {
		this.renderersYetToRedraw.remove(renderer.id);
		this.renderersToRedraw.set(renderer.id,renderer.id);
	}
}
titanium_reindeer.RenderLayer.prototype.stopRedrawRenderer = function(renderer) {
	if(this.clearing || !this.renderers.exists(renderer.id)) return;
	if(this.renderersToRedraw == null) this.renderersToRedraw = new IntHash();
	this.ensureYetToRedrawIsReady();
	if(this.renderersToRedraw.exists(renderer.id)) {
		this.renderersToRedraw.remove(renderer.id);
		this.renderersYetToRedraw.set(renderer.id,renderer.id);
	}
}
titanium_reindeer.RenderLayer.prototype.ensureYetToRedrawIsReady = function() {
	if(this.renderersYetToRedraw == null) {
		this.renderersYetToRedraw = new IntHash();
		var $it0 = this.renderers.keys();
		while( $it0.hasNext() ) {
			var rendererId = $it0.next();
			this.renderersYetToRedraw.set(rendererId,rendererId);
		}
	}
}
titanium_reindeer.RenderLayer.prototype.destroy = function() {
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
titanium_reindeer.RenderLayer.prototype.__class__ = titanium_reindeer.RenderLayer;
titanium_reindeer.Shadow = function(color,offset,blur) {
	if( color === $_ ) return;
	this.color = color;
	this.offset = offset;
	this.blur = blur;
}
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
star_control.ShipUi = function(p) {
	if( p === $_ ) return;
	titanium_reindeer.GameObject.call(this);
	this.background = new titanium_reindeer.RectRenderer(72,86,4);
	this.background.setFill(titanium_reindeer.Color.getGreyConst());
	this.background.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.background.setLineWidth(2);
	this.addComponent("background",this.background);
	this.maxHealth = 0;
	this.maxAmmo = 0;
}
star_control.ShipUi.__name__ = ["star_control","ShipUi"];
star_control.ShipUi.__super__ = titanium_reindeer.GameObject;
for(var k in titanium_reindeer.GameObject.prototype ) star_control.ShipUi.prototype[k] = titanium_reindeer.GameObject.prototype[k];
star_control.ShipUi.prototype.background = null;
star_control.ShipUi.prototype.healthBars = null;
star_control.ShipUi.prototype.ammoBars = null;
star_control.ShipUi.prototype.maxHealth = null;
star_control.ShipUi.prototype.maxAmmo = null;
star_control.ShipUi.prototype.lastHealth = null;
star_control.ShipUi.prototype.lastAmmo = null;
star_control.ShipUi.prototype.initialize = function(maxHealth,maxAmmo) {
	this.maxHealth = Math.round(Math.max(0,Math.min(maxHealth,20)));
	this.maxAmmo = Math.round(Math.max(0,Math.min(maxAmmo,20)));
	this.healthBars = new Array();
	var _g1 = 0, _g = this.maxHealth;
	while(_g1 < _g) {
		var i = _g1++;
		var healthBar = new titanium_reindeer.RectRenderer(12,6,5);
		healthBar.setFill(new titanium_reindeer.Color(34,255,51));
		healthBar.setStrokeColor(titanium_reindeer.Color.getBlackConst());
		healthBar.setLineWidth(2);
		var x = 4;
		if(i > 9) x += 16;
		var y = 4 + i % 10 * 8;
		healthBar.setOffset(new titanium_reindeer.Vector2(-72 / 2 + 12 / 2 + x,-86 / 2 + 6 / 2 + y));
		this.healthBars[i] = healthBar;
		this.addComponent("healthBar_" + i,healthBar);
	}
	this.lastHealth = this.maxHealth;
	this.ammoBars = new Array();
	var _g1 = 0, _g = this.maxAmmo;
	while(_g1 < _g) {
		var i = _g1++;
		var ammoBar = new titanium_reindeer.RectRenderer(12,6,5);
		ammoBar.setFill(new titanium_reindeer.Color(255,0,17));
		ammoBar.setStrokeColor(titanium_reindeer.Color.getBlackConst());
		ammoBar.setLineWidth(2);
		var x = 4;
		if(i > 9) x += 16;
		var y = 4 + i % 10 * 8;
		ammoBar.setOffset(new titanium_reindeer.Vector2(-72 / 2 + 12 / 2 + x,-86 / 2 + 6 / 2 + y));
		var _g2 = ammoBar.getOffset();
		_g2.setX(_g2.getX() + 36);
		this.ammoBars[i] = ammoBar;
		this.addComponent("ammoBar_" + i,ammoBar);
	}
	this.lastAmmo = this.maxAmmo;
}
star_control.ShipUi.prototype.updateHealth = function(amount) {
	amount = Math.round(Math.max(0,Math.min(amount,this.maxHealth)));
	if(amount > this.lastHealth) {
		var _g = this.lastHealth;
		while(_g < amount) {
			var i = _g++;
			this.healthBars[i].setFill(new titanium_reindeer.Color(34,255,51));
		}
	} else if(amount < this.lastHealth) {
		var _g1 = amount, _g = this.lastHealth;
		while(_g1 < _g) {
			var i = _g1++;
			this.healthBars[i].setFill(new titanium_reindeer.Color(34,34,34));
		}
	}
	this.lastHealth = amount;
}
star_control.ShipUi.prototype.updateAmmo = function(amount) {
	amount = Math.round(Math.max(0,Math.min(amount,this.maxAmmo)));
	if(amount > this.lastAmmo) {
		var _g = this.lastAmmo;
		while(_g < amount) {
			var i = _g++;
			this.ammoBars[i].setFill(new titanium_reindeer.Color(255,0,17));
		}
	} else if(amount < this.lastAmmo) {
		var _g1 = amount, _g = this.lastAmmo;
		while(_g1 < _g) {
			var i = _g1++;
			this.ammoBars[i].setFill(new titanium_reindeer.Color(34,34,34));
		}
	}
	this.lastAmmo = amount;
}
star_control.ShipUi.prototype.__class__ = star_control.ShipUi;
titanium_reindeer.LinearGradient = function(x0,y0,x1,y1,colorStops) {
	if( x0 === $_ ) return;
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
}
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
	var $it0 = this.colorStops.iterator();
	while( $it0.hasNext() ) {
		var colorStop = $it0.next();
		gradient.addColorStop(colorStop.offset,colorStop.color.getRgba());
	}
}
titanium_reindeer.LinearGradient.prototype.getStyle = function(pen) {
	var gradient = pen.createLinearGradient(this.x0,this.y0,this.x1,this.y1);
	this.applyColorStops(gradient);
	return gradient;
}
titanium_reindeer.LinearGradient.prototype.identify = function() {
	var identity = "Gradient(" + this.x0 + "," + this.x1 + "," + this.y0 + "," + this.y1 + ",";
	var $it0 = this.colorStops.iterator();
	while( $it0.hasNext() ) {
		var colorStop = $it0.next();
		identity += colorStop.identify() + ",";
	}
	return identity + ");";
}
titanium_reindeer.LinearGradient.prototype.destroy = function() {
	this.colorStops.clear();
	this.colorStops = null;
}
titanium_reindeer.LinearGradient.prototype.__class__ = titanium_reindeer.LinearGradient;
star_control.Direction = { __ename__ : ["star_control","Direction"], __constructs__ : ["Right","Left"] }
star_control.Direction.Right = ["Right",0];
star_control.Direction.Right.toString = $estr;
star_control.Direction.Right.__enum__ = star_control.Direction;
star_control.Direction.Left = ["Left",1];
star_control.Direction.Left.toString = $estr;
star_control.Direction.Left.__enum__ = star_control.Direction;
titanium_reindeer.Geometry = function() { }
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
titanium_reindeer.Geometry.prototype.__class__ = titanium_reindeer.Geometry;
titanium_reindeer.Shape = function() { }
titanium_reindeer.Shape.__name__ = ["titanium_reindeer","Shape"];
titanium_reindeer.Shape.prototype.getMinBoundingRect = function() {
	throw "Error: This function should not be called, inheriting classes should override and not call!";
	return null;
}
titanium_reindeer.Shape.prototype.isPointInside = function(p) {
	return false;
}
titanium_reindeer.Shape.prototype.__class__ = titanium_reindeer.Shape;
titanium_reindeer.SoundSource = function(filePath) {
	if( filePath === $_ ) return;
	this.isLoaded = false;
	this.sound = new Audio();
	this.sound.addEventListener("canplaythrough",$closure(this,"soundLoaded"),true);
	this.sound.src = filePath;
	this.sound.load();
}
titanium_reindeer.SoundSource.__name__ = ["titanium_reindeer","SoundSource"];
titanium_reindeer.SoundSource.prototype.sound = null;
titanium_reindeer.SoundSource.prototype.isLoaded = null;
titanium_reindeer.SoundSource.prototype.loadedFunctions = null;
titanium_reindeer.SoundSource.prototype.soundLoaded = function(event) {
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
titanium_reindeer.SoundSource.prototype.registerLoadEvent = function(cb) {
	if(this.isLoaded) return;
	if(this.loadedFunctions == null) this.loadedFunctions = new List();
	this.loadedFunctions.push(cb);
}
titanium_reindeer.SoundSource.prototype.identify = function() {
	return "SoundSource(" + this.sound.src + ");";
}
titanium_reindeer.SoundSource.prototype.destroy = function() {
	this.isLoaded = false;
	this.sound = null;
	if(this.loadedFunctions != null) {
		this.loadedFunctions.clear();
		this.loadedFunctions = null;
	}
}
titanium_reindeer.SoundSource.prototype.__class__ = titanium_reindeer.SoundSource;
Reflect = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	if(o.hasOwnProperty != null) return o.hasOwnProperty(field);
	var arr = Reflect.fields(o);
	var $it0 = arr.iterator();
	while( $it0.hasNext() ) {
		var t = $it0.next();
		if(t == field) return true;
	}
	return false;
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
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	if(o == null) return new Array();
	var a = new Array();
	if(o.hasOwnProperty) {
		for(var i in o) if( o.hasOwnProperty(i) ) a.push(i);
	} else {
		var t;
		try {
			t = o.__proto__;
		} catch( e ) {
			t = null;
		}
		if(t != null) o.__proto__ = null;
		for(var i in o) if( i != "__proto__" ) a.push(i);
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
		var a = new Array();
		var _g1 = 0, _g = arguments.length;
		while(_g1 < _g) {
			var i = _g1++;
			a.push(arguments[i]);
		}
		return f(a);
	};
}
Reflect.prototype.__class__ = Reflect;
titanium_reindeer.ComponentManager = function(gameObjectManager) {
	if( gameObjectManager === $_ ) return;
	titanium_reindeer.ObjectManager.call(this);
	this.gameObjectManager = gameObjectManager;
	this.componentsChanged = true;
}
titanium_reindeer.ComponentManager.__name__ = ["titanium_reindeer","ComponentManager"];
titanium_reindeer.ComponentManager.__super__ = titanium_reindeer.ObjectManager;
for(var k in titanium_reindeer.ObjectManager.prototype ) titanium_reindeer.ComponentManager.prototype[k] = titanium_reindeer.ObjectManager.prototype[k];
titanium_reindeer.ComponentManager.prototype.gameObjectManager = null;
titanium_reindeer.ComponentManager.prototype.components = null;
titanium_reindeer.ComponentManager.prototype.getComponents = function() {
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
titanium_reindeer.ComponentManager.prototype.componentsChanged = null;
titanium_reindeer.ComponentManager.prototype.preUpdate = function(msTimeStep) {
}
titanium_reindeer.ComponentManager.prototype.update = function(msTimeStep) {
}
titanium_reindeer.ComponentManager.prototype.postUpdate = function(msTimeStep) {
}
titanium_reindeer.ComponentManager.prototype.addComponent = function(component) {
	titanium_reindeer.ObjectManager.prototype.addObject.call(this,component);
	this.componentsChanged = true;
}
titanium_reindeer.ComponentManager.prototype.removeComponent = function(component) {
	titanium_reindeer.ObjectManager.prototype.removeObject.call(this,component);
	this.componentsChanged = true;
}
titanium_reindeer.ComponentManager.prototype.removeComponents = function() {
	titanium_reindeer.ObjectManager.prototype.removeObjects.call(this);
	this.componentsChanged = true;
}
titanium_reindeer.ComponentManager.prototype.destroy = function() {
	titanium_reindeer.ObjectManager.prototype.destroy.call(this);
	this.components = null;
	this.gameObjectManager = null;
}
titanium_reindeer.ComponentManager.prototype.__class__ = titanium_reindeer.ComponentManager;
titanium_reindeer.RendererComponentManager = function(gameObjectManager) {
	if( gameObjectManager === $_ ) return;
	titanium_reindeer.ComponentManager.call(this,gameObjectManager);
	var game = this.gameObjectManager.game;
	this.renderLayerManager = new titanium_reindeer.RenderLayerManager(game.layerCount,game.targetElement,game.backgroundColor,game.width,game.height);
	this.cachedBitmaps = new titanium_reindeer.CachedBitmaps();
}
titanium_reindeer.RendererComponentManager.__name__ = ["titanium_reindeer","RendererComponentManager"];
titanium_reindeer.RendererComponentManager.__super__ = titanium_reindeer.ComponentManager;
for(var k in titanium_reindeer.ComponentManager.prototype ) titanium_reindeer.RendererComponentManager.prototype[k] = titanium_reindeer.ComponentManager.prototype[k];
titanium_reindeer.RendererComponentManager.prototype.renderLayerManager = null;
titanium_reindeer.RendererComponentManager.prototype.cachedBitmaps = null;
titanium_reindeer.RendererComponentManager.prototype.postUpdate = function(msTimeStep) {
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
titanium_reindeer.RendererComponentManager.prototype.getImageFromPath = function(path) {
	var pathIdentifier = "filePath:" + path;
	if(this.cachedBitmaps.exists(pathIdentifier)) return this.cachedBitmaps.get(pathIdentifier);
	var imageSource = new titanium_reindeer.ImageSource(path);
	this.cachedBitmaps.set(pathIdentifier,imageSource);
	return imageSource;
}
titanium_reindeer.RendererComponentManager.prototype.destroy = function() {
	titanium_reindeer.ComponentManager.prototype.destroy.call(this);
	this.renderLayerManager.destroy();
	this.renderLayerManager = null;
	this.cachedBitmaps.destroy();
	this.cachedBitmaps = null;
}
titanium_reindeer.RendererComponentManager.prototype.__class__ = titanium_reindeer.RendererComponentManager;
titanium_reindeer.CollisionComponent = function(width,height,layer,group) {
	if( width === $_ ) return;
	titanium_reindeer.Component.call(this);
	this.setWidth(width);
	this.setHeight(height);
	this.watchedOffset = new titanium_reindeer.WatchedVector2(0,0,$closure(this,"offsetChanged"));
	this.layerName = layer;
	this.groupName = group;
	this.allowUpdateBounds = true;
	this.registeredCallbacks = new Array();
}
titanium_reindeer.CollisionComponent.__name__ = ["titanium_reindeer","CollisionComponent"];
titanium_reindeer.CollisionComponent.__super__ = titanium_reindeer.Component;
for(var k in titanium_reindeer.Component.prototype ) titanium_reindeer.CollisionComponent.prototype[k] = titanium_reindeer.Component.prototype[k];
titanium_reindeer.CollisionComponent.prototype.collisionManager = null;
titanium_reindeer.CollisionComponent.prototype.getCollisionManager = function() {
	if(this.manager == null) return null; else return (function($this) {
		var $r;
		var $t = $this.manager;
		if(Std["is"]($t,titanium_reindeer.CollisionComponentManager)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
}
titanium_reindeer.CollisionComponent.prototype.minBoundingRect = null;
titanium_reindeer.CollisionComponent.prototype.getMinBoundingRect = function() {
	return this.minBoundingRect.getCopy();
}
titanium_reindeer.CollisionComponent.prototype.width = null;
titanium_reindeer.CollisionComponent.prototype.setWidth = function(value) {
	this.width = value;
	this.updateBounds();
	return this.width;
}
titanium_reindeer.CollisionComponent.prototype.height = null;
titanium_reindeer.CollisionComponent.prototype.setHeight = function(value) {
	this.height = value;
	this.updateBounds();
	return this.height;
}
titanium_reindeer.CollisionComponent.prototype.watchedOffset = null;
titanium_reindeer.CollisionComponent.prototype.offset = null;
titanium_reindeer.CollisionComponent.prototype.getOffset = function() {
	return this.watchedOffset;
}
titanium_reindeer.CollisionComponent.prototype.setOffset = function(value) {
	if(value != null) {
		if(this.watchedOffset != value && !this.watchedOffset.equal(value)) {
			this.watchedOffset.setVector2(value);
			this.updateBounds();
		}
	}
	return this.getOffset();
}
titanium_reindeer.CollisionComponent.prototype.allowUpdateBounds = null;
titanium_reindeer.CollisionComponent.prototype.getCenter = function() {
	return this.owner.getPosition().add(this.getOffset());
}
titanium_reindeer.CollisionComponent.prototype.layerName = null;
titanium_reindeer.CollisionComponent.prototype.groupName = null;
titanium_reindeer.CollisionComponent.prototype.registeredCallbacks = null;
titanium_reindeer.CollisionComponent.prototype.collide = function(otherCompId) {
	var otherComp = this.getCollisionManager().getComponent(otherCompId);
	if(otherComp == null) return;
	var _g = 0, _g1 = this.registeredCallbacks;
	while(_g < _g1.length) {
		var func = _g1[_g];
		++_g;
		func(otherComp);
	}
}
titanium_reindeer.CollisionComponent.prototype.registerCallback = function(func) {
	if(func != null) this.registeredCallbacks.push(func);
}
titanium_reindeer.CollisionComponent.prototype.unregisterCallback = function(func) {
	if(func == null) return;
	var _g1 = 0, _g = this.registeredCallbacks.length;
	while(_g1 < _g) {
		var i = _g1++;
		while(i < this.registeredCallbacks.length) if(Reflect.compareMethods(this.registeredCallbacks[i],func)) this.registeredCallbacks.splice(i,1); else break;
	}
}
titanium_reindeer.CollisionComponent.prototype.getShape = function() {
	return this.getMinBoundingRect();
}
titanium_reindeer.CollisionComponent.prototype.isPointIntersecting = function(point) {
	return this.getShape().isPointInside(point);
}
titanium_reindeer.CollisionComponent.prototype.setOwner = function(gameObject) {
	titanium_reindeer.Component.prototype.setOwner.call(this,gameObject);
	this.updateBounds();
}
titanium_reindeer.CollisionComponent.prototype.getManagerType = function() {
	return titanium_reindeer.CollisionComponentManager;
}
titanium_reindeer.CollisionComponent.prototype.initialize = function() {
	var layer = this.getCollisionManager().getLayer(this.layerName);
	layer.addComponent(this);
}
titanium_reindeer.CollisionComponent.prototype.notifyPositionChange = function() {
	this.updateBounds();
}
titanium_reindeer.CollisionComponent.prototype.offsetChanged = function() {
	this.updateBounds();
}
titanium_reindeer.CollisionComponent.prototype.updateBounds = function() {
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
titanium_reindeer.CollisionComponent.prototype.destroy = function() {
	titanium_reindeer.Component.prototype.destroy.call(this);
}
titanium_reindeer.CollisionComponent.prototype.__class__ = titanium_reindeer.CollisionComponent;
titanium_reindeer.Circle = function(radius,center) {
	if( radius === $_ ) return;
	this.radius = radius;
	this.setCenter(new titanium_reindeer.Vector2(0,0));
	this.setCenter(center);
}
titanium_reindeer.Circle.__name__ = ["titanium_reindeer","Circle"];
titanium_reindeer.Circle.__super__ = titanium_reindeer.Shape;
for(var k in titanium_reindeer.Shape.prototype ) titanium_reindeer.Circle.prototype[k] = titanium_reindeer.Shape.prototype[k];
titanium_reindeer.Circle.isIntersecting = function(a,b) {
	return a.radius + b.radius > titanium_reindeer.Vector2.getDistance(a.center,b.center);
}
titanium_reindeer.Circle.prototype.radius = null;
titanium_reindeer.Circle.prototype.center = null;
titanium_reindeer.Circle.prototype.setCenter = function(value) {
	if(value != null) this.center = value;
	return this.center;
}
titanium_reindeer.Circle.prototype.getMinBoundingRect = function() {
	return new titanium_reindeer.Rect(this.center.getX() - this.radius,this.center.getY() - this.radius,this.radius * 2,this.radius * 2);
}
titanium_reindeer.Circle.prototype.isPointInside = function(p) {
	return this.radius >= titanium_reindeer.Vector2.getDistance(p,this.center);
}
titanium_reindeer.Circle.prototype.__class__ = titanium_reindeer.Circle;
titanium_reindeer.CollisionRect = function(width,height,layer,group) {
	if( width === $_ ) return;
	titanium_reindeer.CollisionComponent.call(this,width,height,layer,group);
}
titanium_reindeer.CollisionRect.__name__ = ["titanium_reindeer","CollisionRect"];
titanium_reindeer.CollisionRect.__super__ = titanium_reindeer.CollisionComponent;
for(var k in titanium_reindeer.CollisionComponent.prototype ) titanium_reindeer.CollisionRect.prototype[k] = titanium_reindeer.CollisionComponent.prototype[k];
titanium_reindeer.CollisionRect.prototype.collide = function(otherCompId) {
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
titanium_reindeer.CollisionRect.prototype.__class__ = titanium_reindeer.CollisionRect;
IntIter = function(min,max) {
	if( min === $_ ) return;
	this.min = min;
	this.max = max;
}
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
titanium_reindeer.ImageSource = function(path) {
	if( path === $_ ) return;
	this.image = new Image();;
	this.image.onload = $closure(this,"imageLoaded");
	this.image.src = path;
}
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
		var $it0 = this.loadedFunctions.iterator();
		while( $it0.hasNext() ) {
			var func = $it0.next();
			func(event);
		}
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
star_control.ArtilleryShell = function(owner) {
	if( owner === $_ ) return;
	var sprite = new titanium_reindeer.RectRenderer(18,10,2);
	var colorStops = new Array();
	colorStops.push(new titanium_reindeer.ColorStop(new titanium_reindeer.Color(255,127,0),0));
	colorStops.push(new titanium_reindeer.ColorStop(new titanium_reindeer.Color(255,204,153),0.5));
	colorStops.push(new titanium_reindeer.ColorStop(new titanium_reindeer.Color(255,127,0),1));
	sprite.setFillGradient(new titanium_reindeer.LinearGradient(0,-5,0,5,colorStops));
	star_control.Projectile.call(this,owner,sprite,400,4,2000);
}
star_control.ArtilleryShell.__name__ = ["star_control","ArtilleryShell"];
star_control.ArtilleryShell.__super__ = star_control.Projectile;
for(var k in star_control.Projectile.prototype ) star_control.ArtilleryShell.prototype[k] = star_control.Projectile.prototype[k];
star_control.ArtilleryShell.prototype.__class__ = star_control.ArtilleryShell;
titanium_reindeer.CursorType = { __ename__ : ["titanium_reindeer","CursorType"], __constructs__ : ["AllScroll","ColResize","CrossHair","Custom","Default","EResize","Help","Move","NEResize","NoDrop","None","NotAllowed","NResize","NWResize","Pointer","Progress","RowResize","SEResize","SResize","SWResize","Text","VerticalText","Wait","WResize"] }
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
titanium_reindeer.Cursor = function(targetElement) {
	if( targetElement === $_ ) return;
	this.targetElement = targetElement;
	this.setCursorType(titanium_reindeer.CursorType.Default);
}
titanium_reindeer.Cursor.__name__ = ["titanium_reindeer","Cursor"];
titanium_reindeer.Cursor.prototype.cursorType = null;
titanium_reindeer.Cursor.prototype.setCursorType = function(value) {
	if(value != this.cursorType) {
		this.cursorType = value;
		if(this.cursorType != titanium_reindeer.CursorType.Custom) this.setCustomUrl("");
		this.targetElement.style.cursor = this.getCursorTypeValue(this.cursorType);
	}
	return this.cursorType;
}
titanium_reindeer.Cursor.prototype.customUrl = null;
titanium_reindeer.Cursor.prototype.setCustomUrl = function(value) {
	if(value != this.customUrl) {
		this.customUrl = value;
		if(this.customUrl != "") this.setCursorType(titanium_reindeer.CursorType.Custom);
	}
	return this.customUrl;
}
titanium_reindeer.Cursor.prototype.targetElement = null;
titanium_reindeer.Cursor.prototype.getCursorTypeValue = function(cursorType) {
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
titanium_reindeer.Cursor.prototype.__class__ = titanium_reindeer.Cursor;
titanium_reindeer.Rect = function(x,y,width,height) {
	if( x === $_ ) return;
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
}
titanium_reindeer.Rect.__name__ = ["titanium_reindeer","Rect"];
titanium_reindeer.Rect.__super__ = titanium_reindeer.Shape;
for(var k in titanium_reindeer.Shape.prototype ) titanium_reindeer.Rect.prototype[k] = titanium_reindeer.Shape.prototype[k];
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
titanium_reindeer.Rect.prototype.x = null;
titanium_reindeer.Rect.prototype.y = null;
titanium_reindeer.Rect.prototype.width = null;
titanium_reindeer.Rect.prototype.height = null;
titanium_reindeer.Rect.prototype.top = null;
titanium_reindeer.Rect.prototype.getTop = function() {
	return this.y;
}
titanium_reindeer.Rect.prototype.bottom = null;
titanium_reindeer.Rect.prototype.getBottom = function() {
	return this.y + this.height;
}
titanium_reindeer.Rect.prototype.left = null;
titanium_reindeer.Rect.prototype.getLeft = function() {
	return this.x;
}
titanium_reindeer.Rect.prototype.right = null;
titanium_reindeer.Rect.prototype.getRight = function() {
	return this.x + this.width;
}
titanium_reindeer.Rect.prototype.getMinBoundingRect = function() {
	return this.getCopy();
}
titanium_reindeer.Rect.prototype.isPointInside = function(p) {
	return p.getX() >= this.getLeft() && p.getX() < this.getRight() && p.getY() >= this.getTop() && p.getY() < this.getBottom();
}
titanium_reindeer.Rect.prototype.getCopy = function() {
	return new titanium_reindeer.Rect(this.x,this.y,this.width,this.height);
}
titanium_reindeer.Rect.prototype.getArea = function() {
	return this.width * this.height;
}
titanium_reindeer.Rect.prototype.__class__ = titanium_reindeer.Rect;
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
	} catch( e ) {
		cl = null;
	}
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e;
	try {
		e = eval(name);
	} catch( err ) {
		e = null;
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
	var c = e.__constructs__[index];
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
Type.prototype.__class__ = Type;
titanium_reindeer.LineRenderer = function(endPoint,layer) {
	if( endPoint === $_ ) return;
	titanium_reindeer.StrokeFillRenderer.call(this,0,0,layer);
	this.startPointAlignment = new titanium_reindeer.Vector2(0,0);
	this.requestedOffset = new titanium_reindeer.Vector2(0,0);
	this.watchedEndPoint = new titanium_reindeer.WatchedVector2(endPoint.getX(),endPoint.getY(),$closure(this,"endPointChanged"));
	this.recalculateAlignment();
	this.recalculateDrawnSize();
	this.setLineWidth(1);
}
titanium_reindeer.LineRenderer.__name__ = ["titanium_reindeer","LineRenderer"];
titanium_reindeer.LineRenderer.__super__ = titanium_reindeer.StrokeFillRenderer;
for(var k in titanium_reindeer.StrokeFillRenderer.prototype ) titanium_reindeer.LineRenderer.prototype[k] = titanium_reindeer.StrokeFillRenderer.prototype[k];
titanium_reindeer.LineRenderer.prototype.watchedEndPoint = null;
titanium_reindeer.LineRenderer.prototype.endPoint = null;
titanium_reindeer.LineRenderer.prototype.getEndPoint = function() {
	return this.watchedEndPoint;
}
titanium_reindeer.LineRenderer.prototype.setEndPoint = function(value) {
	if(value != null) {
		if(this.watchedEndPoint != value && !this.watchedEndPoint.equal(value)) this.watchedEndPoint.setVector2(value);
	}
	return this.getEndPoint();
}
titanium_reindeer.LineRenderer.prototype.startPointAlignment = null;
titanium_reindeer.LineRenderer.prototype.requestedOffset = null;
titanium_reindeer.LineRenderer.prototype.setOffset = function(value) {
	if(value != null && value != this.getOffset()) {
		this.requestedOffset = value.getCopy();
		value.addTo(this.startPointAlignment);
	}
	return titanium_reindeer.StrokeFillRenderer.prototype.setOffset.call(this,value);
}
titanium_reindeer.LineRenderer.prototype.offsetChanged = function() {
	var oldRequestedOffset = this.getOffset().subtract(this.startPointAlignment);
	if(this.requestedOffset.getX() == oldRequestedOffset.getX()) this.setOffset(new titanium_reindeer.Vector2(this.requestedOffset.getX(),oldRequestedOffset.getY())); else this.setOffset(new titanium_reindeer.Vector2(oldRequestedOffset.getX(),this.requestedOffset.getY()));
}
titanium_reindeer.LineRenderer.prototype.endPointChanged = function() {
	this.recalculateAlignment();
	this.recalculateDrawnSize();
}
titanium_reindeer.LineRenderer.prototype.recalculateAlignment = function() {
	if(this.getEndPoint() == null) return;
	this.startPointAlignment = this.getEndPoint().getExtend(0.5);
	this.setOffset(this.requestedOffset);
}
titanium_reindeer.LineRenderer.prototype.recalculateDrawnSize = function() {
	if(this.getEndPoint() == null) return;
	this.setInitialWidth(Math.abs(this.getEndPoint().getX() + 2));
	this.setInitialHeight(Math.abs(this.getEndPoint().getY() + 2));
}
titanium_reindeer.LineRenderer.prototype.render = function() {
	titanium_reindeer.StrokeFillRenderer.prototype.render.call(this);
	if(this.lineWidth > 0) {
		var start = this.startPointAlignment.getReverse();
		var end = start.add(this.getEndPoint());
		this.getPen().beginPath();
		this.getPen().moveTo(start.getX(),start.getY());
		this.getPen().lineTo(end.getX(),end.getY());
		this.getPen().stroke();
		this.getPen().closePath();
	}
}
titanium_reindeer.LineRenderer.prototype.__class__ = titanium_reindeer.LineRenderer;
titanium_reindeer.ColorStop = function(color,offset) {
	if( color === $_ ) return;
	this.color = color;
	this.offset = offset;
}
titanium_reindeer.ColorStop.__name__ = ["titanium_reindeer","ColorStop"];
titanium_reindeer.ColorStop.prototype.color = null;
titanium_reindeer.ColorStop.prototype.offset = null;
titanium_reindeer.ColorStop.prototype.identify = function() {
	return "ColorStop(" + this.color.identify() + "," + this.offset + ");";
}
titanium_reindeer.ColorStop.prototype.__class__ = titanium_reindeer.ColorStop;
titanium_reindeer.RectRenderer = function(width,height,layer) {
	if( width === $_ ) return;
	titanium_reindeer.StrokeFillRenderer.call(this,width,height,layer);
	this.setWidth(width);
	this.setHeight(height);
}
titanium_reindeer.RectRenderer.__name__ = ["titanium_reindeer","RectRenderer"];
titanium_reindeer.RectRenderer.__super__ = titanium_reindeer.StrokeFillRenderer;
for(var k in titanium_reindeer.StrokeFillRenderer.prototype ) titanium_reindeer.RectRenderer.prototype[k] = titanium_reindeer.StrokeFillRenderer.prototype[k];
titanium_reindeer.RectRenderer.prototype.width = null;
titanium_reindeer.RectRenderer.prototype.setWidth = function(value) {
	if(this.width != value) {
		this.setInitialWidth(value);
		this.width = value;
	}
	return this.width;
}
titanium_reindeer.RectRenderer.prototype.height = null;
titanium_reindeer.RectRenderer.prototype.setHeight = function(value) {
	if(this.height != value) {
		this.setInitialHeight(value);
		this.height = value;
	}
	return this.height;
}
titanium_reindeer.RectRenderer.prototype.render = function() {
	titanium_reindeer.StrokeFillRenderer.prototype.render.call(this);
	var x = -this.width / 2;
	var y = -this.height / 2;
	this.getPen().fillRect(x,y,this.width,this.height);
	if(this.lineWidth > 0) this.getPen().strokeRect(x + this.lineWidth / 2,y + this.lineWidth / 2,this.width - this.lineWidth,this.height - this.lineWidth);
}
titanium_reindeer.RectRenderer.prototype.identify = function() {
	return titanium_reindeer.StrokeFillRenderer.prototype.identify.call(this) + "Rect();";
}
titanium_reindeer.RectRenderer.prototype.__class__ = titanium_reindeer.RectRenderer;
if(typeof js=='undefined') js = {}
js.Boot = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__unhtml(js.Boot.__string_rec(v,"")) + "<br/>";
	var d = document.getElementById("haxe:trace");
	if(d == null) alert("No haxe:trace element defined\n" + msg); else d.innerHTML += msg;
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__closure = function(o,f) {
	var m = o[f];
	if(m == null) return null;
	var f1 = function() {
		return m.apply(o,arguments);
	};
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
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__") {
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
		if(x != x) return null;
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
	$closure = js.Boot.__closure;
}
js.Boot.prototype.__class__ = js.Boot;
titanium_reindeer.BitmapEffect = function(p) {
}
titanium_reindeer.BitmapEffect.__name__ = ["titanium_reindeer","BitmapEffect"];
titanium_reindeer.BitmapEffect.prototype.apply = function(bitmapData) {
}
titanium_reindeer.BitmapEffect.prototype.identify = function() {
	return "";
}
titanium_reindeer.BitmapEffect.prototype.destroy = function() {
}
titanium_reindeer.BitmapEffect.prototype.__class__ = titanium_reindeer.BitmapEffect;
if(typeof haxe=='undefined') haxe = {}
haxe.Timer = function(time_ms) {
	if( time_ms === $_ ) return;
	var arr = haxe_timers;
	this.id = arr.length;
	arr[this.id] = this;
	this.timerId = window.setInterval("haxe_timers[" + this.id + "].run();",time_ms);
}
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
haxe.Timer.prototype.id = null;
haxe.Timer.prototype.timerId = null;
haxe.Timer.prototype.stop = function() {
	if(this.id == null) return;
	window.clearInterval(this.timerId);
	var arr = haxe_timers;
	arr[this.id] = null;
	if(this.id > 100 && this.id == arr.length - 1) {
		var p = this.id - 1;
		while(p >= 0 && arr[p] == null) p--;
		arr = arr.slice(0,p + 1);
	}
	this.id = null;
}
haxe.Timer.prototype.run = function() {
}
haxe.Timer.prototype.__class__ = haxe.Timer;
IntHash = function(p) {
	if( p === $_ ) return;
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
}
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
	for( x in this.h ) a.push(x);
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
	s.b[s.b.length] = "{" == null?"null":"{";
	var it = this.keys();
	while( it.hasNext() ) {
		var i = it.next();
		s.b[s.b.length] = i == null?"null":i;
		s.b[s.b.length] = " => " == null?"null":" => ";
		s.add(Std.string(this.get(i)));
		if(it.hasNext()) s.b[s.b.length] = ", " == null?"null":", ";
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
IntHash.prototype.__class__ = IntHash;
star_control.CollisionGroups = function() { }
star_control.CollisionGroups.__name__ = ["star_control","CollisionGroups"];
star_control.CollisionGroups.prototype.__class__ = star_control.CollisionGroups;
titanium_reindeer.CollisionGroup = function(name,layer) {
	if( name === $_ ) return;
	this.name = name;
	this.layer = layer;
	this.members = new IntHash();
	this.mCollidingGroups = new Hash();
}
titanium_reindeer.CollisionGroup.__name__ = ["titanium_reindeer","CollisionGroup"];
titanium_reindeer.CollisionGroup.prototype.name = null;
titanium_reindeer.CollisionGroup.prototype.layer = null;
titanium_reindeer.CollisionGroup.prototype.members = null;
titanium_reindeer.CollisionGroup.prototype.mCollidingGroups = null;
titanium_reindeer.CollisionGroup.prototype.collidingGroups = null;
titanium_reindeer.CollisionGroup.prototype.getCollidingGroups = function() {
	var groups = new Hash();
	var $it0 = this.mCollidingGroups.iterator();
	while( $it0.hasNext() ) {
		var group = $it0.next();
		groups.set(group.name,group);
	}
	return groups;
}
titanium_reindeer.CollisionGroup.prototype.addCollidingGroup = function(collidingGroupName) {
	var collidingGroup = this.layer.getGroup(collidingGroupName);
	this.mCollidingGroups.set(collidingGroupName,collidingGroup);
}
titanium_reindeer.CollisionGroup.prototype.removeCollidingGroup = function(collidingGroupName) {
	var collidingGroup = this.layer.getGroup(collidingGroupName);
	if(this.mCollidingGroups.exists(collidingGroupName)) this.mCollidingGroups.remove(collidingGroupName);
}
titanium_reindeer.CollisionGroup.prototype.addAllCollidingGroups = function() {
	var $it0 = this.layer.groups.iterator();
	while( $it0.hasNext() ) {
		var group = $it0.next();
		if(!this.mCollidingGroups.exists(group.name)) this.mCollidingGroups.set(group.name,group);
	}
}
titanium_reindeer.CollisionGroup.prototype.clearCollidingGroups = function() {
	this.mCollidingGroups = new Hash();
}
titanium_reindeer.CollisionGroup.prototype.destroy = function() {
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
titanium_reindeer.CollisionGroup.prototype.__class__ = titanium_reindeer.CollisionGroup;
titanium_reindeer.Vector2 = function(x,y) {
	if( x === $_ ) return;
	this.mX = x;
	this.mY = y;
}
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
	var _g = this;
	_g.setX(_g.getX() * n);
	var _g = this;
	_g.setY(_g.getY() * n);
}
titanium_reindeer.Vector2.prototype.getNormalized = function() {
	var mag = this.getMagnitude();
	if(mag == 0) return new titanium_reindeer.Vector2(0,0);
	return new titanium_reindeer.Vector2(this.getX() / mag,this.getY() / mag);
}
titanium_reindeer.Vector2.prototype.normalize = function() {
	var mag = this.getMagnitude();
	if(mag != 0) {
		var _g = this;
		_g.setX(_g.getX() / mag);
		var _g = this;
		_g.setY(_g.getY() / mag);
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
	if(this.getX() < 0) rads += Math.PI; else if(this.getY() < 0) rads += Math.PI * 2;
	return rads;
}
titanium_reindeer.Vector2.prototype.add = function(b) {
	if(b == null) return this.getCopy();
	return new titanium_reindeer.Vector2(this.getX() + b.getX(),this.getY() + b.getY());
}
titanium_reindeer.Vector2.prototype.addTo = function(b) {
	var _g = this;
	_g.setX(_g.getX() + b.getX());
	var _g = this;
	_g.setY(_g.getY() + b.getY());
	return this;
}
titanium_reindeer.Vector2.prototype.subtract = function(b) {
	return new titanium_reindeer.Vector2(this.getX() - b.getX(),this.getY() - b.getY());
}
titanium_reindeer.Vector2.prototype.subtractFrom = function(b) {
	var _g = this;
	_g.setX(_g.getX() - b.getX());
	var _g = this;
	_g.setY(_g.getY() - b.getY());
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
titanium_reindeer.GameObjectManager = function(game) {
	if( game === $_ ) return;
	titanium_reindeer.ObjectManager.call(this);
	this.game = game;
	this.componentManagers = new Hash();
}
titanium_reindeer.GameObjectManager.__name__ = ["titanium_reindeer","GameObjectManager"];
titanium_reindeer.GameObjectManager.__super__ = titanium_reindeer.ObjectManager;
for(var k in titanium_reindeer.ObjectManager.prototype ) titanium_reindeer.GameObjectManager.prototype[k] = titanium_reindeer.ObjectManager.prototype[k];
titanium_reindeer.GameObjectManager.prototype.game = null;
titanium_reindeer.GameObjectManager.prototype.componentManagers = null;
titanium_reindeer.GameObjectManager.prototype.addGameObject = function(obj) {
	titanium_reindeer.ObjectManager.prototype.addObject.call(this,obj);
}
titanium_reindeer.GameObjectManager.prototype.addGameObjects = function(objs) {
	var _g = 0;
	while(_g < objs.length) {
		var obj = objs[_g];
		++_g;
		titanium_reindeer.ObjectManager.prototype.addObject.call(this,obj);
	}
}
titanium_reindeer.GameObjectManager.prototype.removeGameObject = function(obj) {
	if(titanium_reindeer.ObjectManager.prototype.objectIdExists.call(this,obj.id)) obj.remove();
	titanium_reindeer.ObjectManager.prototype.removeObject.call(this,obj);
}
titanium_reindeer.GameObjectManager.prototype.getGameObject = function(id) {
	return (function($this) {
		var $r;
		var $t = titanium_reindeer.ObjectManager.prototype.getObject.call($this,id);
		if(Std["is"]($t,titanium_reindeer.GameObject)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
}
titanium_reindeer.GameObjectManager.prototype.getManager = function(managerType) {
	var className = Type.getClassName(managerType);
	var manager;
	if(this.componentManagers.exists(className)) manager = this.componentManagers.get(className); else {
		manager = Type.createInstance(managerType,[this]);
		this.componentManagers.set(className,manager);
	}
	return manager;
}
titanium_reindeer.GameObjectManager.prototype.delegateComponent = function(component) {
	var manager = this.getManager(component.getManagerType());
	manager.addComponent(component);
	component.initialize();
}
titanium_reindeer.GameObjectManager.prototype.update = function(msTimeStep) {
	var $it0 = this.componentManagers.iterator();
	while( $it0.hasNext() ) {
		var manager = $it0.next();
		manager.preUpdate(msTimeStep);
	}
	var $it1 = this.objects.iterator();
	while( $it1.hasNext() ) {
		var obj = $it1.next();
		if(!obj.toBeDestroyed) ((function($this) {
			var $r;
			var $t = obj;
			if(Std["is"]($t,titanium_reindeer.GameObject)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this))).update(msTimeStep);
	}
	var $it2 = this.componentManagers.iterator();
	while( $it2.hasNext() ) {
		var manager = $it2.next();
		manager.update(msTimeStep);
	}
	var $it3 = this.componentManagers.iterator();
	while( $it3.hasNext() ) {
		var manager = $it3.next();
		manager.postUpdate(msTimeStep);
	}
	titanium_reindeer.ObjectManager.prototype.removeObjects.call(this);
	var $it4 = this.objects.iterator();
	while( $it4.hasNext() ) {
		var obj = $it4.next();
		((function($this) {
			var $r;
			var $t = obj;
			if(Std["is"]($t,titanium_reindeer.GameObject)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this))).removeComponents();
	}
	var $it5 = this.componentManagers.iterator();
	while( $it5.hasNext() ) {
		var manager = $it5.next();
		manager.removeComponents();
	}
}
titanium_reindeer.GameObjectManager.prototype.destroy = function() {
	titanium_reindeer.ObjectManager.prototype.destroy.call(this);
	var $it0 = this.componentManagers.keys();
	while( $it0.hasNext() ) {
		var managerName = $it0.next();
		this.componentManagers.get(managerName).destroy();
		this.componentManagers.remove(managerName);
	}
	this.componentManagers = null;
	this.game = null;
}
titanium_reindeer.GameObjectManager.prototype.__class__ = titanium_reindeer.GameObjectManager;
StringBuf = function(p) {
	if( p === $_ ) return;
	this.b = new Array();
}
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype.add = function(x) {
	this.b[this.b.length] = x == null?"null":x;
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
titanium_reindeer.RecordedEvent = function(type,event) {
	if( type === $_ ) return;
	this.type = type;
	this.event = event;
}
titanium_reindeer.RecordedEvent.__name__ = ["titanium_reindeer","RecordedEvent"];
titanium_reindeer.RecordedEvent.prototype.type = null;
titanium_reindeer.RecordedEvent.prototype.event = null;
titanium_reindeer.RecordedEvent.prototype.__class__ = titanium_reindeer.RecordedEvent;
titanium_reindeer.MouseButtonData = function(button,buttonState,cb) {
	if( button === $_ ) return;
	this.button = button;
	this.buttonState = buttonState;
	this.cb = cb;
}
titanium_reindeer.MouseButtonData.__name__ = ["titanium_reindeer","MouseButtonData"];
titanium_reindeer.MouseButtonData.prototype.button = null;
titanium_reindeer.MouseButtonData.prototype.buttonState = null;
titanium_reindeer.MouseButtonData.prototype.cb = null;
titanium_reindeer.MouseButtonData.prototype.__class__ = titanium_reindeer.MouseButtonData;
titanium_reindeer.MouseMoveData = function(cb) {
	if( cb === $_ ) return;
	this.cb = cb;
}
titanium_reindeer.MouseMoveData.__name__ = ["titanium_reindeer","MouseMoveData"];
titanium_reindeer.MouseMoveData.prototype.cb = null;
titanium_reindeer.MouseMoveData.prototype.__class__ = titanium_reindeer.MouseMoveData;
titanium_reindeer.MouseWheelData = function(cb) {
	if( cb === $_ ) return;
	this.cb = cb;
}
titanium_reindeer.MouseWheelData.__name__ = ["titanium_reindeer","MouseWheelData"];
titanium_reindeer.MouseWheelData.prototype.cb = null;
titanium_reindeer.MouseWheelData.prototype.__class__ = titanium_reindeer.MouseWheelData;
titanium_reindeer.MouseButtonAnyData = function(cb) {
	if( cb === $_ ) return;
	this.cb = cb;
}
titanium_reindeer.MouseButtonAnyData.__name__ = ["titanium_reindeer","MouseButtonAnyData"];
titanium_reindeer.MouseButtonAnyData.prototype.cb = null;
titanium_reindeer.MouseButtonAnyData.prototype.__class__ = titanium_reindeer.MouseButtonAnyData;
titanium_reindeer.KeyData = function(key,keyState,cb) {
	if( key === $_ ) return;
	this.key = key;
	this.keyState = keyState;
	this.cb = cb;
}
titanium_reindeer.KeyData.__name__ = ["titanium_reindeer","KeyData"];
titanium_reindeer.KeyData.prototype.key = null;
titanium_reindeer.KeyData.prototype.keyState = null;
titanium_reindeer.KeyData.prototype.cb = null;
titanium_reindeer.KeyData.prototype.__class__ = titanium_reindeer.KeyData;
titanium_reindeer.KeyAnyData = function(cb) {
	if( cb === $_ ) return;
	this.cb = cb;
}
titanium_reindeer.KeyAnyData.__name__ = ["titanium_reindeer","KeyAnyData"];
titanium_reindeer.KeyAnyData.prototype.cb = null;
titanium_reindeer.KeyAnyData.prototype.__class__ = titanium_reindeer.KeyAnyData;
titanium_reindeer.InputManager = function(targetElement) {
	if( targetElement === $_ ) return;
	this.mouseButtonsRegistered = new IntHash();
	this.mouseButtonsRegistered.set(titanium_reindeer.MouseButtonState.Down[1],new IntHash());
	this.mouseButtonsRegistered.set(titanium_reindeer.MouseButtonState.Held[1],new IntHash());
	this.mouseButtonsRegistered.set(titanium_reindeer.MouseButtonState.Up[1],new IntHash());
	this.mouseButtonsAnyRegistered = new Array();
	this.mouseWheelsRegistered = new Array();
	this.mousePositionChangesRegistered = new Array();
	this.mouseButtonsHeld = new IntHash();
	this.lastMousePos = new titanium_reindeer.Vector2(0,0);
	this.keysRegistered = new IntHash();
	this.keysRegistered.set(titanium_reindeer.KeyState.Down[1],new IntHash());
	this.keysRegistered.set(titanium_reindeer.KeyState.Held[1],new IntHash());
	this.keysRegistered.set(titanium_reindeer.KeyState.Up[1],new IntHash());
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
	this.targetElement = targetElement;
	this.recalculateCanvasOffset();
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
	targetElement.oncontextmenu = $closure(this,"contextMenu");
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
}
titanium_reindeer.InputManager.__name__ = ["titanium_reindeer","InputManager"];
titanium_reindeer.InputManager.prototype.mouseButtonsRegistered = null;
titanium_reindeer.InputManager.prototype.downMouseButtonsRegistered = null;
titanium_reindeer.InputManager.prototype.getDownMouseButtonsRegistered = function() {
	return this.mouseButtonsRegistered.get(titanium_reindeer.MouseButtonState.Down[1]);
}
titanium_reindeer.InputManager.prototype.heldMouseButtonsRegistered = null;
titanium_reindeer.InputManager.prototype.getHeldMouseButtonsRegistered = function() {
	return this.mouseButtonsRegistered.get(titanium_reindeer.MouseButtonState.Held[1]);
}
titanium_reindeer.InputManager.prototype.upMouseButtonsRegistered = null;
titanium_reindeer.InputManager.prototype.getUpMouseButtonsRegistered = function() {
	return this.mouseButtonsRegistered.get(titanium_reindeer.MouseButtonState.Up[1]);
}
titanium_reindeer.InputManager.prototype.mouseButtonsAnyRegistered = null;
titanium_reindeer.InputManager.prototype.mouseWheelsRegistered = null;
titanium_reindeer.InputManager.prototype.mousePositionChangesRegistered = null;
titanium_reindeer.InputManager.prototype.mouseButtonsHeld = null;
titanium_reindeer.InputManager.prototype.lastMousePos = null;
titanium_reindeer.InputManager.prototype.mousePosition = null;
titanium_reindeer.InputManager.prototype.getMousePos = function() {
	return this.lastMousePos.getCopy();
}
titanium_reindeer.InputManager.prototype.keysRegistered = null;
titanium_reindeer.InputManager.prototype.downKeysRegistered = null;
titanium_reindeer.InputManager.prototype.getDownKeysRegistered = function() {
	return this.keysRegistered.get(titanium_reindeer.KeyState.Down[1]);
}
titanium_reindeer.InputManager.prototype.heldKeysRegistered = null;
titanium_reindeer.InputManager.prototype.getHeldKeysRegistered = function() {
	return this.keysRegistered.get(titanium_reindeer.KeyState.Held[1]);
}
titanium_reindeer.InputManager.prototype.upKeysRegistered = null;
titanium_reindeer.InputManager.prototype.getUpKeysRegistered = function() {
	return this.keysRegistered.get(titanium_reindeer.KeyState.Up[1]);
}
titanium_reindeer.InputManager.prototype.keysAnyRegistered = null;
titanium_reindeer.InputManager.prototype.heldKeys = null;
titanium_reindeer.InputManager.prototype.recordedEvents = null;
titanium_reindeer.InputManager.prototype.queuedMouseButtonRegisters = null;
titanium_reindeer.InputManager.prototype.queuedMouseMoveRegisters = null;
titanium_reindeer.InputManager.prototype.queuedMouseWheelRegisters = null;
titanium_reindeer.InputManager.prototype.queuedMouseButtonAnyRegisters = null;
titanium_reindeer.InputManager.prototype.queuedKeyRegisters = null;
titanium_reindeer.InputManager.prototype.queuedKeyAnyRegisters = null;
titanium_reindeer.InputManager.prototype.queuedMouseButtonUnregisters = null;
titanium_reindeer.InputManager.prototype.queuedMouseMoveUnregisters = null;
titanium_reindeer.InputManager.prototype.queuedMouseWheelUnregisters = null;
titanium_reindeer.InputManager.prototype.queuedMouseButtonAnyUnregisters = null;
titanium_reindeer.InputManager.prototype.queuedKeyUnregisters = null;
titanium_reindeer.InputManager.prototype.queuedKeyAnyUnregisters = null;
titanium_reindeer.InputManager.prototype.queueRegisters = null;
titanium_reindeer.InputManager.prototype.targetElement = null;
titanium_reindeer.InputManager.prototype.targetDocumentOffset = null;
titanium_reindeer.InputManager.prototype.timeLeftToRecalculateOffsetMs = null;
titanium_reindeer.InputManager.prototype.recordEvent = function(type,event) {
	this.recordedEvents.push(new titanium_reindeer.RecordedEvent(type,event));
}
titanium_reindeer.InputManager.prototype.contextMenu = function(event) {
	var found = false;
	if(this.getUpMouseButtonsRegistered().exists(titanium_reindeer.MouseButton.Right[1])) found = this.getUpMouseButtonsRegistered().get(titanium_reindeer.MouseButton.Right[1]).length != 0;
	return !(found || this.mouseButtonsAnyRegistered.length != 0);
}
titanium_reindeer.InputManager.prototype.mouseDown = function(event) {
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
titanium_reindeer.InputManager.prototype.mouseUp = function(event) {
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
titanium_reindeer.InputManager.prototype.mouseMove = function(event) {
	var mousePos = this.getMousePositionFromEvent(event);
	var _g = 0, _g1 = this.mousePositionChangesRegistered;
	while(_g < _g1.length) {
		var cb = _g1[_g];
		++_g;
		if(cb != null) cb(mousePos.getCopy());
	}
	this.lastMousePos = mousePos;
}
titanium_reindeer.InputManager.prototype.mouseWheel = function(event) {
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
titanium_reindeer.InputManager.prototype.keyDown = function(event) {
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
titanium_reindeer.InputManager.prototype.keyUp = function(event) {
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
titanium_reindeer.InputManager.prototype.update = function(msTimeStep) {
	var tempEvents = new Array();
	var _g = 0, _g1 = this.recordedEvents;
	while(_g < _g1.length) {
		var recordedEvent = _g1[_g];
		++_g;
		tempEvents.push(recordedEvent);
	}
	this.recordedEvents = new Array();
	this.queueRegisters = true;
	var _g = 0;
	while(_g < tempEvents.length) {
		var recordedEvent = tempEvents[_g];
		++_g;
		var func;
		switch( (recordedEvent.type)[1] ) {
		case 0:
			func = $closure(this,"mouseDown");
			break;
		case 1:
			func = $closure(this,"mouseUp");
			break;
		case 2:
			func = $closure(this,"mouseMove");
			break;
		case 3:
			func = $closure(this,"mouseWheel");
			break;
		case 5:
			func = $closure(this,"keyDown");
			break;
		case 4:
			func = $closure(this,"keyUp");
			break;
		default:
			func = null;
		}
		func(recordedEvent.event);
	}
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
	this.queueRegisters = false;
	this.flushQueues();
	this.timeLeftToRecalculateOffsetMs -= msTimeStep;
	if(this.timeLeftToRecalculateOffsetMs <= 0) {
		this.timeLeftToRecalculateOffsetMs = 1000;
		this.recalculateCanvasOffset();
	}
}
titanium_reindeer.InputManager.prototype.destroy = function() {
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
	this.targetElement.onmousedown = null;
	this.targetElement.onmouseup = null;
	this.targetElement.onmousemove = null;
	this.targetElement.oncontextmenu = null;
	js.Lib.document.onmousewheel = null;
	js.Lib.document.onkeydown = null;
	js.Lib.document.onkeyup = null;
	var firefoxReg = new EReg("Firefox","i");
	if(firefoxReg.match(js.Lib.window.navigator.userAgent)) js.Lib.document.removeEventListener("DOMMouseScroll",$closure(this,"mouseWheel"),true); else js.Lib.document.onmousewheel = null;
	this.targetElement = null;
}
titanium_reindeer.InputManager.prototype.registerMouseButtonEvent = function(button,buttonState,cb) {
	if(cb == null) return;
	if(this.queueRegisters) {
		this.queuedMouseButtonRegisters.push(new titanium_reindeer.MouseButtonData(button,buttonState,cb));
		return;
	}
	var buttons = this.mouseButtonsRegistered.get(buttonState[1]);
	if(!buttons.exists(button[1])) buttons.set(button[1],new Array());
	buttons.get(button[1]).push(cb);
}
titanium_reindeer.InputManager.prototype.registerMouseButtonAnyEvent = function(cb) {
	if(cb == null) return;
	if(this.queueRegisters) {
		this.queuedMouseButtonAnyRegisters.push(new titanium_reindeer.MouseButtonAnyData(cb));
		return;
	}
	this.mouseButtonsAnyRegistered.push(cb);
}
titanium_reindeer.InputManager.prototype.registerMouseMoveEvent = function(cb) {
	if(cb == null) return;
	if(this.queueRegisters) {
		this.queuedMouseMoveRegisters.push(new titanium_reindeer.MouseMoveData(cb));
		return;
	}
	this.mousePositionChangesRegistered.push(cb);
}
titanium_reindeer.InputManager.prototype.registerMouseWheelEvent = function(cb) {
	if(cb == null) return;
	if(this.queueRegisters) {
		this.queuedMouseWheelRegisters.push(new titanium_reindeer.MouseWheelData(cb));
		return;
	}
	this.mouseWheelsRegistered.push(cb);
}
titanium_reindeer.InputManager.prototype.registerKeyEvent = function(key,keyState,cb) {
	if(cb == null) return;
	if(this.queueRegisters) {
		this.queuedKeyRegisters.push(new titanium_reindeer.KeyData(key,keyState,cb));
		return;
	}
	var arr = this.keysRegistered.get(keyState[1]);
	if(!arr.exists(key[1])) arr.set(key[1],new Array());
	arr.get(key[1]).push(cb);
}
titanium_reindeer.InputManager.prototype.registerKeyAnyEvent = function(cb) {
	if(cb == null) return;
	if(this.queueRegisters) {
		this.queuedKeyAnyRegisters.push(new titanium_reindeer.KeyAnyData(cb));
		return;
	}
	this.keysAnyRegistered.push(cb);
}
titanium_reindeer.InputManager.prototype.unregisterMouseButtonEvent = function(mouseButton,mouseButtonState,cb) {
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
titanium_reindeer.InputManager.prototype.unregisterMouseButtonAnyEvent = function(cb) {
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
titanium_reindeer.InputManager.prototype.unregisterMouseMoveEvent = function(cb) {
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
titanium_reindeer.InputManager.prototype.unregisterMouseWheelEvent = function(cb) {
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
titanium_reindeer.InputManager.prototype.unregisterKeyEvent = function(key,keyState,cb) {
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
titanium_reindeer.InputManager.prototype.unregisterKeyAnyEvent = function(cb) {
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
titanium_reindeer.InputManager.prototype.flushQueues = function() {
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
	this.queuedMouseWheelRegisters = new Array();
	var _g = 0, _g1 = this.queuedMouseWheelRegisters;
	while(_g < _g1.length) {
		var data = _g1[_g];
		++_g;
		this.registerMouseWheelEvent(data.cb);
	}
	this.queuedMouseButtonAnyRegisters = new Array();
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
titanium_reindeer.InputManager.prototype.isMouseButtonDown = function(mouseButton) {
	return this.mouseButtonsHeld.exists(mouseButton[1]);
}
titanium_reindeer.InputManager.prototype.isKeyDown = function(key) {
	return this.heldKeys.exists(key[1]);
}
titanium_reindeer.InputManager.prototype.recalculateCanvasOffset = function() {
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
}
titanium_reindeer.InputManager.prototype.getMousePositionFromEvent = function(event) {
	if(event == null) return new titanium_reindeer.Vector2(0,0);
	var mousePos;
	if(event.pageX || event.pageY) mousePos = new titanium_reindeer.Vector2(event.pageX,event.pageY); else if(event.clientX || event.clientY) mousePos = new titanium_reindeer.Vector2(event.clientX + js.Lib.document.body.scrollLeft + js.Lib.document.documentElement.scrollLeft,event.clientY + js.Lib.document.body.scrollTop + js.Lib.document.documentElement.scrollTop); else return new titanium_reindeer.Vector2(0,0);
	return mousePos.subtract(this.targetDocumentOffset);
}
titanium_reindeer.InputManager.prototype.getMouseButtonFromButton = function(which) {
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
titanium_reindeer.InputManager.prototype.getKeyFromCode = function(keyCode) {
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
titanium_reindeer.InputManager.prototype.__class__ = titanium_reindeer.InputManager;
titanium_reindeer.ImageRenderer = function(image,layer,sourceRect,width,height) {
	if( image === $_ ) return;
	if(height == null) height = 0;
	if(width == null) width = 0;
	titanium_reindeer.RendererComponent.call(this,0,0,layer);
	this.sourceRect = sourceRect;
	this.destWidth = width;
	this.destHeight = height;
	this.setImage(image);
}
titanium_reindeer.ImageRenderer.__name__ = ["titanium_reindeer","ImageRenderer"];
titanium_reindeer.ImageRenderer.__super__ = titanium_reindeer.RendererComponent;
for(var k in titanium_reindeer.RendererComponent.prototype ) titanium_reindeer.ImageRenderer.prototype[k] = titanium_reindeer.RendererComponent.prototype[k];
titanium_reindeer.ImageRenderer.prototype.image = null;
titanium_reindeer.ImageRenderer.prototype.setImage = function(value) {
	if(value != null && value != this.image) {
		this.image = value;
		if(this.image.isLoaded) this.imageLoaded(null); else this.image.registerLoadEvent($closure(this,"imageLoaded"));
	}
	return this.image;
}
titanium_reindeer.ImageRenderer.prototype.sourceRect = null;
titanium_reindeer.ImageRenderer.prototype.destWidth = null;
titanium_reindeer.ImageRenderer.prototype.destHeight = null;
titanium_reindeer.ImageRenderer.prototype.render = function() {
	titanium_reindeer.RendererComponent.prototype.render.call(this);
	if(this.image.isLoaded) {
		var x = 2;
		this.getPen().drawImage(this.image.image,this.sourceRect.x,this.sourceRect.y,this.sourceRect.width,this.sourceRect.height,-this.destWidth / 2,-this.destHeight / 2,this.destWidth,this.destHeight);
	} else this.setRedraw(true);
}
titanium_reindeer.ImageRenderer.prototype.imageLoaded = function(event) {
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
titanium_reindeer.ImageRenderer.prototype.identify = function() {
	return titanium_reindeer.RendererComponent.prototype.identify.call(this) + "Image(" + this.image.identify() + ");";
}
titanium_reindeer.ImageRenderer.prototype.destroy = function() {
	titanium_reindeer.RendererComponent.prototype.destroy.call(this);
	this.setImage(null);
}
titanium_reindeer.ImageRenderer.prototype.__class__ = titanium_reindeer.ImageRenderer;
titanium_reindeer.CollisionComponentManager = function(gameObjectManager) {
	if( gameObjectManager === $_ ) return;
	titanium_reindeer.ComponentManager.call(this,gameObjectManager);
	this.collisionLayers = new Hash();
	this.mouseRegionManager = new titanium_reindeer.MouseRegionManager(this);
}
titanium_reindeer.CollisionComponentManager.__name__ = ["titanium_reindeer","CollisionComponentManager"];
titanium_reindeer.CollisionComponentManager.__super__ = titanium_reindeer.ComponentManager;
for(var k in titanium_reindeer.ComponentManager.prototype ) titanium_reindeer.CollisionComponentManager.prototype[k] = titanium_reindeer.ComponentManager.prototype[k];
titanium_reindeer.CollisionComponentManager.prototype.collisionLayers = null;
titanium_reindeer.CollisionComponentManager.prototype.mouseRegionManager = null;
titanium_reindeer.CollisionComponentManager.prototype.getLayer = function(layerName) {
	if(this.collisionLayers.exists(layerName)) return this.collisionLayers.get(layerName); else {
		var layer = new titanium_reindeer.CollisionLayer(this,layerName);
		this.collisionLayers.set(layerName,layer);
		return layer;
	}
}
titanium_reindeer.CollisionComponentManager.prototype.getComponent = function(id) {
	return (function($this) {
		var $r;
		var $t = titanium_reindeer.ComponentManager.prototype.getObject.call($this,id);
		if(Std["is"]($t,titanium_reindeer.CollisionComponent)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
}
titanium_reindeer.CollisionComponentManager.prototype.removeComponent = function(component) {
	var collisionComp = (function($this) {
		var $r;
		var $t = component;
		if(Std["is"]($t,titanium_reindeer.CollisionComponent)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	this.getLayer(collisionComp.layerName).removeComponent(collisionComp);
}
titanium_reindeer.CollisionComponentManager.prototype.update = function(msTimeStep) {
	var $it0 = this.collisionLayers.iterator();
	while( $it0.hasNext() ) {
		var layer = $it0.next();
		layer.update();
	}
}
titanium_reindeer.CollisionComponentManager.prototype.destroy = function() {
	titanium_reindeer.ComponentManager.prototype.destroy.call(this);
	var $it0 = this.collisionLayers.keys();
	while( $it0.hasNext() ) {
		var layerName = $it0.next();
		this.collisionLayers.get(layerName).destroy();
		this.collisionLayers.remove(layerName);
	}
}
titanium_reindeer.CollisionComponentManager.prototype.__class__ = titanium_reindeer.CollisionComponentManager;
Lambda = function() { }
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
Lambda.prototype.__class__ = Lambda;
titanium_reindeer.MouseRegionMoveEvent = { __ename__ : ["titanium_reindeer","MouseRegionMoveEvent"], __constructs__ : ["Move","Enter","Exit"] }
titanium_reindeer.MouseRegionMoveEvent.Move = ["Move",0];
titanium_reindeer.MouseRegionMoveEvent.Move.toString = $estr;
titanium_reindeer.MouseRegionMoveEvent.Move.__enum__ = titanium_reindeer.MouseRegionMoveEvent;
titanium_reindeer.MouseRegionMoveEvent.Enter = ["Enter",1];
titanium_reindeer.MouseRegionMoveEvent.Enter.toString = $estr;
titanium_reindeer.MouseRegionMoveEvent.Enter.__enum__ = titanium_reindeer.MouseRegionMoveEvent;
titanium_reindeer.MouseRegionMoveEvent.Exit = ["Exit",2];
titanium_reindeer.MouseRegionMoveEvent.Exit.toString = $estr;
titanium_reindeer.MouseRegionMoveEvent.Exit.__enum__ = titanium_reindeer.MouseRegionMoveEvent;
titanium_reindeer.MouseRegionButtonEvent = { __ename__ : ["titanium_reindeer","MouseRegionButtonEvent"], __constructs__ : ["Down","Up","Click"] }
titanium_reindeer.MouseRegionButtonEvent.Down = ["Down",0];
titanium_reindeer.MouseRegionButtonEvent.Down.toString = $estr;
titanium_reindeer.MouseRegionButtonEvent.Down.__enum__ = titanium_reindeer.MouseRegionButtonEvent;
titanium_reindeer.MouseRegionButtonEvent.Up = ["Up",1];
titanium_reindeer.MouseRegionButtonEvent.Up.toString = $estr;
titanium_reindeer.MouseRegionButtonEvent.Up.__enum__ = titanium_reindeer.MouseRegionButtonEvent;
titanium_reindeer.MouseRegionButtonEvent.Click = ["Click",2];
titanium_reindeer.MouseRegionButtonEvent.Click.toString = $estr;
titanium_reindeer.MouseRegionButtonEvent.Click.__enum__ = titanium_reindeer.MouseRegionButtonEvent;
titanium_reindeer.MouseRegionHandler = function(manager,collisionComponent) {
	if( manager === $_ ) return;
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
}
titanium_reindeer.MouseRegionHandler.__name__ = ["titanium_reindeer","MouseRegionHandler"];
titanium_reindeer.MouseRegionHandler.prototype.manager = null;
titanium_reindeer.MouseRegionHandler.prototype.collisionRegion = null;
titanium_reindeer.MouseRegionHandler.prototype.registeredMouseMoveEvents = null;
titanium_reindeer.MouseRegionHandler.prototype.registeredMouseEnterEvents = null;
titanium_reindeer.MouseRegionHandler.prototype.registeredMouseExitEvents = null;
titanium_reindeer.MouseRegionHandler.prototype.registeredMouseDownEvents = null;
titanium_reindeer.MouseRegionHandler.prototype.registeredMouseUpEvents = null;
titanium_reindeer.MouseRegionHandler.prototype.registeredMouseClickEvents = null;
titanium_reindeer.MouseRegionHandler.prototype.isMouseInside = null;
titanium_reindeer.MouseRegionHandler.prototype.isMouseButtonsDownInside = null;
titanium_reindeer.MouseRegionHandler.prototype.getIsMouseDownInside = function(mouseButton) {
	return this.isMouseButtonsDownInside.get(mouseButton[1]);
}
titanium_reindeer.MouseRegionHandler.prototype.depth = null;
titanium_reindeer.MouseRegionHandler.prototype.isBlockingBelow = null;
titanium_reindeer.MouseRegionHandler.prototype.setIsBlockingBelow = function(value) {
	if(value != this.isBlockingBelow) {
		this.isBlockingBelow = value;
		if(value) this.exclusionRegion = this.manager.createExclusionRegion(this.depth,this.collisionRegion.getShape()); else if(this.exclusionRegion != null) {
			this.exclusionRegion.destroy();
			this.exclusionRegion = null;
		}
	}
	return this.isBlockingBelow;
}
titanium_reindeer.MouseRegionHandler.prototype.exclusionRegion = null;
titanium_reindeer.MouseRegionHandler.prototype.mouseMove = function(mousePos,colliding) {
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
titanium_reindeer.MouseRegionHandler.prototype.mouseDown = function(mousePos,button,colliding) {
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
titanium_reindeer.MouseRegionHandler.prototype.mouseUp = function(mousePos,button,colliding) {
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
titanium_reindeer.MouseRegionHandler.prototype.registerMouseMoveEvent = function(mouseEvent,func) {
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
titanium_reindeer.MouseRegionHandler.prototype.registerMouseButtonEvent = function(mouseEvent,func) {
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
titanium_reindeer.MouseRegionHandler.prototype.unregisterMouseMoveEvent = function(mouseEvent,func) {
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
titanium_reindeer.MouseRegionHandler.prototype.unregisterMouseButtonEvent = function(mouseEvent,func) {
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
titanium_reindeer.MouseRegionHandler.prototype.destroy = function() {
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
titanium_reindeer.MouseRegionHandler.prototype.__class__ = titanium_reindeer.MouseRegionHandler;
titanium_reindeer.WatchedVector2 = function(x,y,changeCallback) {
	if( x === $_ ) return;
	this.changeCallback = changeCallback;
	titanium_reindeer.Vector2.call(this,x,y);
}
titanium_reindeer.WatchedVector2.__name__ = ["titanium_reindeer","WatchedVector2"];
titanium_reindeer.WatchedVector2.__super__ = titanium_reindeer.Vector2;
for(var k in titanium_reindeer.Vector2.prototype ) titanium_reindeer.WatchedVector2.prototype[k] = titanium_reindeer.Vector2.prototype[k];
titanium_reindeer.WatchedVector2.prototype.setX = function(value) {
	if(value != this.mX && this.changeCallback != null) this.changeCallback();
	titanium_reindeer.Vector2.prototype.setX.call(this,value);
	return this.mX;
}
titanium_reindeer.WatchedVector2.prototype.setY = function(value) {
	if(value != this.mY && this.changeCallback != null) this.changeCallback();
	titanium_reindeer.Vector2.prototype.setY.call(this,value);
	return this.mY;
}
titanium_reindeer.WatchedVector2.prototype.setVector2 = function(value) {
	if(value != null) {
		if(value.getX() != this.getX() || value.getY() != this.getY()) {
			this.mX = value.getX();
			this.mY = value.getY();
			this.changeCallback();
		}
	}
	return this;
}
titanium_reindeer.WatchedVector2.prototype.changeCallback = null;
titanium_reindeer.WatchedVector2.prototype.destroy = function() {
	this.changeCallback = null;
}
titanium_reindeer.WatchedVector2.prototype.__class__ = titanium_reindeer.WatchedVector2;
titanium_reindeer.CachedBitmaps = function(p) {
	if( p === $_ ) return;
	this.cachedBitmaps = new Hash();
}
titanium_reindeer.CachedBitmaps.__name__ = ["titanium_reindeer","CachedBitmaps"];
titanium_reindeer.CachedBitmaps.prototype.cachedBitmaps = null;
titanium_reindeer.CachedBitmaps.prototype.exists = function(identifier) {
	return this.cachedBitmaps.exists(identifier);
}
titanium_reindeer.CachedBitmaps.prototype.set = function(identifier,bitmap) {
	if(!this.cachedBitmaps.exists(identifier)) {
		this.cachedBitmaps.set(identifier,bitmap);
		return true;
	}
	return false;
}
titanium_reindeer.CachedBitmaps.prototype.get = function(identifier) {
	return this.cachedBitmaps.get(identifier);
}
titanium_reindeer.CachedBitmaps.prototype.remove = function(identifier) {
	return this.cachedBitmaps.remove(identifier);
}
titanium_reindeer.CachedBitmaps.prototype.destroy = function() {
	var $it0 = this.cachedBitmaps.iterator();
	while( $it0.hasNext() ) {
		var image = $it0.next();
		image.destroy();
	}
	this.cachedBitmaps = null;
}
titanium_reindeer.CachedBitmaps.prototype.__class__ = titanium_reindeer.CachedBitmaps;
titanium_reindeer.CollisionCircle = function(radius,layer,group) {
	if( radius === $_ ) return;
	titanium_reindeer.CollisionComponent.call(this,radius * 2,radius * 2,layer,group);
	this.setRadius(radius);
}
titanium_reindeer.CollisionCircle.__name__ = ["titanium_reindeer","CollisionCircle"];
titanium_reindeer.CollisionCircle.__super__ = titanium_reindeer.CollisionComponent;
for(var k in titanium_reindeer.CollisionComponent.prototype ) titanium_reindeer.CollisionCircle.prototype[k] = titanium_reindeer.CollisionComponent.prototype[k];
titanium_reindeer.CollisionCircle.prototype.radius = null;
titanium_reindeer.CollisionCircle.prototype.setRadius = function(value) {
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
titanium_reindeer.CollisionCircle.prototype.collide = function(otherCompId) {
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
titanium_reindeer.CollisionCircle.prototype.getShape = function() {
	return new titanium_reindeer.Circle(this.radius,this.getCenter());
}
titanium_reindeer.CollisionCircle.prototype.__class__ = titanium_reindeer.CollisionCircle;
titanium_reindeer.BitmapData = function(pen,sourceRect) {
	if( pen === $_ ) return;
	if(pen != null && sourceRect != null) this.rawData = pen.getImageData(sourceRect.x,sourceRect.y,sourceRect.width,sourceRect.height);
}
titanium_reindeer.BitmapData.__name__ = ["titanium_reindeer","BitmapData"];
titanium_reindeer.BitmapData.prototype.rawData = null;
titanium_reindeer.BitmapData.prototype.data = null;
titanium_reindeer.BitmapData.prototype.getData = function() {
	return this.rawData.data;
}
titanium_reindeer.BitmapData.prototype.width = null;
titanium_reindeer.BitmapData.prototype.getWidth = function() {
	return this.rawData.width;
}
titanium_reindeer.BitmapData.prototype.height = null;
titanium_reindeer.BitmapData.prototype.getHeight = function() {
	return this.rawData.height;
}
titanium_reindeer.BitmapData.prototype.getCopy = function() {
	var newData = new titanium_reindeer.BitmapData();
	newData.rawData = this.rawData;
	return newData;
}
titanium_reindeer.BitmapData.prototype.destroy = function() {
	this.rawData = null;
}
titanium_reindeer.BitmapData.prototype.__class__ = titanium_reindeer.BitmapData;
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype.__class__ = haxe.Log;
Hash = function(p) {
	if( p === $_ ) return;
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
}
Hash.__name__ = ["Hash"];
Hash.prototype.h = null;
Hash.prototype.set = function(key,value) {
	this.h["$" + key] = value;
}
Hash.prototype.get = function(key) {
	return this.h["$" + key];
}
Hash.prototype.exists = function(key) {
	try {
		key = "$" + key;
		return this.hasOwnProperty.call(this.h,key);
	} catch( e ) {
		for(var i in this.h) if( i == key ) return true;
		return false;
	}
}
Hash.prototype.remove = function(key) {
	if(!this.exists(key)) return false;
	delete(this.h["$" + key]);
	return true;
}
Hash.prototype.keys = function() {
	var a = new Array();
	for(var i in this.h) a.push(i.substr(1));
	return a.iterator();
}
Hash.prototype.iterator = function() {
	return { ref : this.h, it : this.keys(), hasNext : function() {
		return this.it.hasNext();
	}, next : function() {
		var i = this.it.next();
		return this.ref["$" + i];
	}};
}
Hash.prototype.toString = function() {
	var s = new StringBuf();
	s.b[s.b.length] = "{" == null?"null":"{";
	var it = this.keys();
	while( it.hasNext() ) {
		var i = it.next();
		s.b[s.b.length] = i == null?"null":i;
		s.b[s.b.length] = " => " == null?"null":" => ";
		s.add(Std.string(this.get(i)));
		if(it.hasNext()) s.b[s.b.length] = ", " == null?"null":", ";
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
Hash.prototype.__class__ = Hash;
StarControl = function() { }
StarControl.__name__ = ["StarControl"];
StarControl.main = function() {
	var game = new star_control.StarControlGame();
	game.play();
}
StarControl.prototype.__class__ = StarControl;
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
star_control.Player = function(game,ship,thrustKey,turnRightKey,turnLeftKey,shootKey) {
	if( game === $_ ) return;
	titanium_reindeer.GameObject.call(this);
	this.game = game;
	this.ship = ship;
	this.isThrusting = false;
	this.isTurningRight = false;
	this.isTurningLeft = false;
	this.isShooting = false;
	this.thrustKey = thrustKey;
	this.turnRightKey = turnRightKey;
	this.turnLeftKey = turnLeftKey;
	this.shootKey = shootKey;
	this.game.inputManager.registerKeyEvent(thrustKey,titanium_reindeer.KeyState.Down,$closure(this,"thrustDown"));
	this.game.inputManager.registerKeyEvent(thrustKey,titanium_reindeer.KeyState.Up,$closure(this,"thrustUp"));
	this.game.inputManager.registerKeyEvent(turnRightKey,titanium_reindeer.KeyState.Down,$closure(this,"rightDown"));
	this.game.inputManager.registerKeyEvent(turnRightKey,titanium_reindeer.KeyState.Up,$closure(this,"rightUp"));
	this.game.inputManager.registerKeyEvent(turnLeftKey,titanium_reindeer.KeyState.Down,$closure(this,"leftDown"));
	this.game.inputManager.registerKeyEvent(turnLeftKey,titanium_reindeer.KeyState.Up,$closure(this,"leftUp"));
	this.game.inputManager.registerKeyEvent(shootKey,titanium_reindeer.KeyState.Down,$closure(this,"shootDown"));
	this.game.inputManager.registerKeyEvent(shootKey,titanium_reindeer.KeyState.Up,$closure(this,"shootUp"));
}
star_control.Player.__name__ = ["star_control","Player"];
star_control.Player.__super__ = titanium_reindeer.GameObject;
for(var k in titanium_reindeer.GameObject.prototype ) star_control.Player.prototype[k] = titanium_reindeer.GameObject.prototype[k];
star_control.Player.prototype.game = null;
star_control.Player.prototype.ship = null;
star_control.Player.prototype.isThrusting = null;
star_control.Player.prototype.isTurningRight = null;
star_control.Player.prototype.isTurningLeft = null;
star_control.Player.prototype.isShooting = null;
star_control.Player.prototype.thrustKey = null;
star_control.Player.prototype.turnRightKey = null;
star_control.Player.prototype.turnLeftKey = null;
star_control.Player.prototype.shootKey = null;
star_control.Player.prototype.thrustDown = function() {
	this.isThrusting = true;
}
star_control.Player.prototype.thrustUp = function() {
	this.isThrusting = false;
}
star_control.Player.prototype.rightDown = function() {
	this.isTurningRight = true;
}
star_control.Player.prototype.rightUp = function() {
	this.isTurningRight = false;
}
star_control.Player.prototype.leftDown = function() {
	this.isTurningLeft = true;
}
star_control.Player.prototype.leftUp = function() {
	this.isTurningLeft = false;
}
star_control.Player.prototype.shootDown = function() {
	this.isShooting = true;
	this.ship.startShooting();
}
star_control.Player.prototype.shootUp = function() {
	this.isShooting = false;
	this.ship.endShooting();
}
star_control.Player.prototype.update = function(msTimeStep) {
	if(this.ship.health <= 0) this.game.notifyShipDied(this);
	if(this.isThrusting) this.ship.thrust(msTimeStep);
	if(this.isTurningRight && !this.isTurningLeft) this.ship.turn(star_control.Direction.Right,msTimeStep);
	if(this.isTurningLeft && !this.isTurningRight) this.ship.turn(star_control.Direction.Left,msTimeStep);
	if(this.isShooting) this.ship.shooting(msTimeStep);
}
star_control.Player.prototype.__class__ = star_control.Player;
titanium_reindeer.MovementComponentManager = function(gameObjectManager) {
	if( gameObjectManager === $_ ) return;
	titanium_reindeer.ComponentManager.call(this,gameObjectManager);
}
titanium_reindeer.MovementComponentManager.__name__ = ["titanium_reindeer","MovementComponentManager"];
titanium_reindeer.MovementComponentManager.__super__ = titanium_reindeer.ComponentManager;
for(var k in titanium_reindeer.ComponentManager.prototype ) titanium_reindeer.MovementComponentManager.prototype[k] = titanium_reindeer.ComponentManager.prototype[k];
titanium_reindeer.MovementComponentManager.prototype.update = function(msTimeStep) {
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
titanium_reindeer.MovementComponentManager.prototype.__class__ = titanium_reindeer.MovementComponentManager;
star_control.Fighter = function(isPlayer1,shipUi) {
	if( isPlayer1 === $_ ) return;
	star_control.Ship.call(this,isPlayer1,"fighter.png",shipUi,10,14,600,50,2,Math.PI,400,250);
}
star_control.Fighter.__name__ = ["star_control","Fighter"];
star_control.Fighter.__super__ = star_control.Ship;
for(var k in star_control.Ship.prototype ) star_control.Fighter.prototype[k] = star_control.Ship.prototype[k];
star_control.Fighter.prototype.fireSound = null;
star_control.Fighter.prototype.hasInitialized = function() {
	star_control.Ship.prototype.hasInitialized.call(this);
	if(this.fireSound == null) this.fireSound = this.getManager().game.soundManager.getSound("sound/fighter_fire.mp3");
}
star_control.Fighter.prototype.shoot = function(msTimeStep) {
	var newProjectile = new star_control.FighterBullet(this);
	this.addProjectile(newProjectile);
	this.getManager().game.soundManager.playSound(this.fireSound);
}
star_control.Fighter.prototype.shooting = function(msTimeStep) {
	this.attemptShoot(msTimeStep);
}
star_control.Fighter.prototype.__class__ = star_control.Fighter;
EReg = function(r,opt) {
	if( r === $_ ) return;
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
}
EReg.__name__ = ["EReg"];
EReg.prototype.r = null;
EReg.prototype.match = function(s) {
	this.r.m = this.r.exec(s);
	this.r.s = s;
	this.r.l = RegExp.leftContext;
	this.r.r = RegExp.rightContext;
	return this.r.m != null;
}
EReg.prototype.matched = function(n) {
	return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
		var $r;
		throw "EReg::matched";
		return $r;
	}(this));
}
EReg.prototype.matchedLeft = function() {
	if(this.r.m == null) throw "No string matched";
	if(this.r.l == null) return this.r.s.substr(0,this.r.m.index);
	return this.r.l;
}
EReg.prototype.matchedRight = function() {
	if(this.r.m == null) throw "No string matched";
	if(this.r.r == null) {
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	return this.r.r;
}
EReg.prototype.matchedPos = function() {
	if(this.r.m == null) throw "No string matched";
	return { pos : this.r.m.index, len : this.r.m[0].length};
}
EReg.prototype.split = function(s) {
	var d = "#__delim__#";
	return s.replace(this.r,d).split(d);
}
EReg.prototype.replace = function(s,by) {
	return s.replace(this.r,by);
}
EReg.prototype.customReplace = function(s,f) {
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
EReg.prototype.__class__ = EReg;
titanium_reindeer.RenderLayerManager = function(numLayers,targetElement,backgroundColor,gameWidth,gameHeight) {
	if( numLayers === $_ ) return;
	this.gameWidth = gameWidth;
	this.gameHeight = gameHeight;
	targetElement.style.width = gameWidth + "px";
	targetElement.style.height = gameHeight + "px";
	this.layers = new Array();
	var _g = 0;
	while(_g < numLayers) {
		var i = _g++;
		if(i == 0) this.layers.push(new titanium_reindeer.RenderLayer(this,i,targetElement,gameWidth,gameHeight,backgroundColor)); else this.layers.push(new titanium_reindeer.RenderLayer(this,i,targetElement,gameWidth,gameHeight));
	}
	var canvas = js.Lib.document.createElement("canvas");
	canvas.id = "gameCanvas";
	canvas.setAttribute("width",gameWidth + "px");
	canvas.setAttribute("height",gameHeight + "px");
	targetElement.appendChild(canvas);
	this.visiblePen = canvas.getContext("2d");
	this.canvas = js.Lib.document.createElement("canvas");
	this.canvas.id = "gameCanvasBuffer";
	this.canvas.setAttribute("width",gameWidth + "px");
	this.canvas.setAttribute("height",gameHeight + "px");
	this.pen = this.canvas.getContext("2d");
}
titanium_reindeer.RenderLayerManager.__name__ = ["titanium_reindeer","RenderLayerManager"];
titanium_reindeer.RenderLayerManager.prototype.layers = null;
titanium_reindeer.RenderLayerManager.prototype.gameWidth = null;
titanium_reindeer.RenderLayerManager.prototype.gameHeight = null;
titanium_reindeer.RenderLayerManager.prototype.canvas = null;
titanium_reindeer.RenderLayerManager.prototype.pen = null;
titanium_reindeer.RenderLayerManager.prototype.visiblePen = null;
titanium_reindeer.RenderLayerManager.prototype.layerExists = function(layerId) {
	return 0 <= layerId && layerId < this.layers.length;
}
titanium_reindeer.RenderLayerManager.prototype.getLayer = function(layerId) {
	if(this.layerExists(layerId)) return this.layers[layerId]; else return null;
}
titanium_reindeer.RenderLayerManager.prototype.clear = function() {
	var _g = 0, _g1 = this.layers;
	while(_g < _g1.length) {
		var layer = _g1[_g];
		++_g;
		layer.clear();
	}
	this.visiblePen.clearRect(0,0,this.gameWidth,this.gameHeight);
}
titanium_reindeer.RenderLayerManager.prototype.display = function() {
	this.pen.clearRect(0,0,this.gameWidth,this.gameHeight);
	var _g = 0, _g1 = this.layers;
	while(_g < _g1.length) {
		var layer = _g1[_g];
		++_g;
		layer.display(this.pen);
	}
	this.visiblePen.drawImage(this.canvas,0,0);
}
titanium_reindeer.RenderLayerManager.prototype.destroy = function() {
	while(this.layers.length != 0) {
		var layer = this.layers.pop();
		layer.destroy();
	}
	this.layers = null;
	this.pen = null;
	this.canvas = null;
	this.visiblePen = null;
	var element = js.Lib.document.getElementById("gameCanvas");
	element.parentNode.removeChild(element);
}
titanium_reindeer.RenderLayerManager.prototype.__class__ = titanium_reindeer.RenderLayerManager;
titanium_reindeer.CollisionLayer = function(manager,name) {
	if( manager === $_ ) return;
	this.manager = manager;
	this.name = name;
	this.componentsRTree = new titanium_reindeer.RTreeFastInt();
	this.groups = new Hash();
	this.debugView = false;
}
titanium_reindeer.CollisionLayer.__name__ = ["titanium_reindeer","CollisionLayer"];
titanium_reindeer.CollisionLayer.prototype.manager = null;
titanium_reindeer.CollisionLayer.prototype.name = null;
titanium_reindeer.CollisionLayer.prototype.componentsRTree = null;
titanium_reindeer.CollisionLayer.prototype.groups = null;
titanium_reindeer.CollisionLayer.prototype.debugView = null;
titanium_reindeer.CollisionLayer.prototype.getGroup = function(groupName) {
	if(this.groups.exists(groupName)) return this.groups.get(groupName); else {
		var group = new titanium_reindeer.CollisionGroup(groupName,this);
		this.groups.set(groupName,group);
		return group;
	}
}
titanium_reindeer.CollisionLayer.prototype.getIdsIntersectingPoint = function(point) {
	var ids = this.componentsRTree.getPointIntersectingValues(point);
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
titanium_reindeer.CollisionLayer.prototype.addComponent = function(component) {
	var group = this.getGroup(component.groupName);
	if(group.members.exists(component.id)) haxe.Log.trace("---ERROR---: component id " + component.id + " already exists in group " + component.groupName + "!",{ fileName : "CollisionLayer.hx", lineNumber : 83, className : "titanium_reindeer.CollisionLayer", methodName : "addComponent"}); else {
		group.members.set(component.id,component);
		this.componentsRTree.insert(component.getMinBoundingRect(),component.id);
	}
}
titanium_reindeer.CollisionLayer.prototype.updateComponent = function(component) {
	this.componentsRTree.update(component.getMinBoundingRect(),component.id);
}
titanium_reindeer.CollisionLayer.prototype.removeComponent = function(component) {
	var group = this.getGroup(component.groupName);
	group.members.remove(component.id);
	this.componentsRTree.remove(component.id);
}
titanium_reindeer.CollisionLayer.prototype.enableDebugView = function(debugCanvas,debugOffset) {
	this.debugView = true;
	this.componentsRTree.debugCanvas = debugCanvas;
	this.componentsRTree.debugOffset = debugOffset;
}
titanium_reindeer.CollisionLayer.prototype.update = function() {
	var $it0 = this.groups.iterator();
	while( $it0.hasNext() ) {
		var group = $it0.next();
		var $it1 = group.members.iterator();
		while( $it1.hasNext() ) {
			var component = $it1.next();
			var collidingIds = this.componentsRTree.getRectIntersectingValues(component.getMinBoundingRect());
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
	if(this.debugView) this.componentsRTree.drawDebug();
}
titanium_reindeer.CollisionLayer.prototype.destroy = function() {
	var $it0 = this.groups.keys();
	while( $it0.hasNext() ) {
		var groupName = $it0.next();
		this.groups.get(groupName).destroy();
		this.groups.remove(groupName);
	}
	this.groups = null;
	this.manager = null;
}
titanium_reindeer.CollisionLayer.prototype.__class__ = titanium_reindeer.CollisionLayer;
titanium_reindeer.SoundManager = function(p) {
	if( p === $_ ) return;
	this.soundChannels = new Array();
	this.lastChannelUsed = -1;
	this.cachedSounds = new Hash();
	this.setMaxSoundChannels(32);
	this.setGlobalVolume(1);
	this.setIsMuted(false);
}
titanium_reindeer.SoundManager.__name__ = ["titanium_reindeer","SoundManager"];
titanium_reindeer.SoundManager.prototype.maxSoundChannels = null;
titanium_reindeer.SoundManager.prototype.setMaxSoundChannels = function(value) {
	if(this.maxSoundChannels != value) {
		if(this.maxSoundChannels < value) {
			var _g = this.maxSoundChannels;
			while(_g < value) {
				var i = _g++;
				this.soundChannels[i] = new Audio();;
				this.soundChannels[i].volume = this.globalVolume;
			}
		}
		this.maxSoundChannels = value;
	}
	return this.maxSoundChannels;
}
titanium_reindeer.SoundManager.prototype.globalVolume = null;
titanium_reindeer.SoundManager.prototype.setGlobalVolume = function(value) {
	if(this.globalVolume != value) {
		if(this.soundChannels != null) {
			var _g = 0, _g1 = this.soundChannels;
			while(_g < _g1.length) {
				var channel = _g1[_g];
				++_g;
				channel.volume = value;
			}
		}
		this.globalVolume = value;
	}
	return this.globalVolume;
}
titanium_reindeer.SoundManager.prototype.isMuted = null;
titanium_reindeer.SoundManager.prototype.setIsMuted = function(value) {
	this.isMuted = value;
	return this.isMuted;
}
titanium_reindeer.SoundManager.prototype.soundChannels = null;
titanium_reindeer.SoundManager.prototype.lastChannelUsed = null;
titanium_reindeer.SoundManager.prototype.cachedSounds = null;
titanium_reindeer.SoundManager.prototype.getSound = function(filePath) {
	if(this.cachedSounds.exists(filePath)) return this.cachedSounds.get(filePath); else {
		var newSound = new titanium_reindeer.SoundSource(filePath);
		this.cachedSounds.set(filePath,newSound);
		return newSound;
	}
}
titanium_reindeer.SoundManager.prototype.playSound = function(sound) {
	if(this.isMuted || sound == null || !sound.isLoaded) return;
	this.lastChannelUsed = this.lastChannelUsed == this.soundChannels.length - 1?0:this.lastChannelUsed + 1;
	var channel = this.soundChannels[this.lastChannelUsed];
	channel.src = sound.sound.src;
	channel.load();
	channel.play();
}
titanium_reindeer.SoundManager.prototype.playRandomSound = function(possibleSounds) {
	if(possibleSounds == null || possibleSounds.length == 0) return -1;
	var r = Std.random(possibleSounds.length);
	if(possibleSounds[r] == null) return -1; else {
		this.playSound(possibleSounds[r]);
		return r;
	}
}
titanium_reindeer.SoundManager.prototype.__class__ = titanium_reindeer.SoundManager;
titanium_reindeer.Game = function(targetHtmlId,width,height,layerCount,debugMode,backgroundColor) {
	if( targetHtmlId === $_ ) return;
	if(targetHtmlId == null || targetHtmlId == "") this.targetElement = js.Lib.document.createElement("div"); else this.targetElement = js.Lib.document.getElementById(targetHtmlId);
	this.width = width == null?400:width;
	this.height = height == null?300:height;
	this.layerCount = layerCount == null?1:layerCount;
	this.backgroundColor = backgroundColor == null?new titanium_reindeer.Color(255,255,255):backgroundColor;
	this.debugMode = debugMode == null?false:debugMode;
	this.setMaxAllowedUpdateLengthMs(1000);
	this.exitGame = false;
	this.gameObjectManager = new titanium_reindeer.GameObjectManager(this);
	this.inputManager = new titanium_reindeer.InputManager(this.targetElement);
	this.soundManager = new titanium_reindeer.SoundManager();
	this.cursor = new titanium_reindeer.Cursor(this.targetElement);
	if(debugMode) js.Lib.setErrorHandler(function(msg,stack) {
		js.Lib.alert("ERROR[ " + msg + " ]");
		haxe.Log.trace(stack,{ fileName : "Game.hx", lineNumber : 68, className : "titanium_reindeer.Game", methodName : "new"});
		return true;
	});
}
titanium_reindeer.Game.__name__ = ["titanium_reindeer","Game"];
titanium_reindeer.Game.prototype.targetElement = null;
titanium_reindeer.Game.prototype.width = null;
titanium_reindeer.Game.prototype.height = null;
titanium_reindeer.Game.prototype.layerCount = null;
titanium_reindeer.Game.prototype.backgroundColor = null;
titanium_reindeer.Game.prototype.debugMode = null;
titanium_reindeer.Game.prototype.maxAllowedUpdateLengthMs = null;
titanium_reindeer.Game.prototype.setMaxAllowedUpdateLengthMs = function(value) {
	if(value != this.maxAllowedUpdateLengthMs) this.maxAllowedUpdateLengthMs = Std["int"](Math.max(1,Math.min(value,Math.POSITIVE_INFINITY)));
	return this.maxAllowedUpdateLengthMs;
}
titanium_reindeer.Game.prototype.exitGame = null;
titanium_reindeer.Game.prototype.msLastTimeStep = null;
titanium_reindeer.Game.prototype.gameObjectManager = null;
titanium_reindeer.Game.prototype.inputManager = null;
titanium_reindeer.Game.prototype.soundManager = null;
titanium_reindeer.Game.prototype.cursor = null;
titanium_reindeer.Game.prototype.play = function() {
	this.requestAnimFrame();
}
titanium_reindeer.Game.prototype.gameLoop = function(now) {
	if(this.exitGame) this.destroy(); else {
		if(this.msLastTimeStep == null) this.msLastTimeStep = now;
		var msTimeStep;
		if(now == null) msTimeStep = Math.round(1000 / 60); else msTimeStep = Std["int"](Math.min(now - this.msLastTimeStep,this.maxAllowedUpdateLengthMs));
		this.msLastTimeStep = now;
		this.update(msTimeStep);
		this.gameObjectManager.update(msTimeStep);
		this.inputManager.update(msTimeStep);
		this.requestAnimFrame();
	}
}
titanium_reindeer.Game.prototype.requestAnimFrame = function() {
	if(js.Lib.window.requestAnimationFrame) js.Lib.window.requestAnimationFrame($closure(this,"gameLoop"),this.targetElement); else if(js.Lib.window.webkitRequestAnimationFrame) js.Lib.window.webkitRequestAnimationFrame($closure(this,"gameLoop"),this.targetElement); else if(js.Lib.window.mozRequestAnimationFrame) js.Lib.window.mozRequestAnimationFrame($closure(this,"gameLoop"),this.targetElement); else if(js.Lib.window.oRequestAnimationFrame) js.Lib.window.oRequestAnimationFrame($closure(this,"gameLoop"),this.targetElement); else if(js.Lib.window.msRequestAnimationFrame) js.Lib.window.msRequestAnimationFrame($closure(this,"gameLoop"),this.targetElement); else js.Lib.window.setTimeout($closure(this,"gameLoop"),Math.round(1000 / 60));
}
titanium_reindeer.Game.prototype.update = function(msTimeStep) {
}
titanium_reindeer.Game.prototype.destroy = function() {
	this.targetElement = null;
	this.backgroundColor = null;
	this.gameObjectManager.destroy();
	this.inputManager.destroy();
}
titanium_reindeer.Game.prototype.stopGame = function() {
	this.exitGame = true;
}
titanium_reindeer.Game.prototype.__class__ = titanium_reindeer.Game;
star_control.StarControlGame = function(p) {
	if( p === $_ ) return;
	titanium_reindeer.Game.call(this,"TestGame",700,600,7,true,titanium_reindeer.Color.getBlackConst());
	this.player1Score = 0;
	this.player2Score = 0;
	this.ui = new star_control.UiBar(new titanium_reindeer.Vector2(600,0));
	this.gameObjectManager.addGameObject(this.ui);
	var ship1 = new star_control.Fighter(true,this.ui.ship1Ui);
	ship1.setPosition(new titanium_reindeer.Vector2(50,50));
	this.gameObjectManager.addGameObject(ship1);
	this.player1 = new star_control.Player(this,ship1,titanium_reindeer.Key.W,titanium_reindeer.Key.D,titanium_reindeer.Key.A,titanium_reindeer.Key.Q);
	this.gameObjectManager.addGameObject(this.player1);
	var ship2 = new star_control.Artillery(false,this.ui.ship2Ui);
	ship2.setPosition(new titanium_reindeer.Vector2(550,550));
	this.gameObjectManager.addGameObject(ship2);
	this.player2 = new star_control.Player(this,ship2,titanium_reindeer.Key.UpArrow,titanium_reindeer.Key.RightArrow,titanium_reindeer.Key.LeftArrow,titanium_reindeer.Key.Period);
	this.gameObjectManager.addGameObject(this.player2);
	var collisionManager = (function($this) {
		var $r;
		var $t = $this.gameObjectManager.getManager(titanium_reindeer.CollisionComponentManager);
		if(Std["is"]($t,titanium_reindeer.CollisionComponentManager)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	collisionManager.getLayer("main").getGroup("ships").addCollidingGroup("ships");
	collisionManager.getLayer("main").getGroup("ships").addCollidingGroup("bullets");
	collisionManager.getLayer("main").getGroup("bullets").addCollidingGroup("ships");
	this.soundManager.setGlobalVolume(0.2);
}
star_control.StarControlGame.__name__ = ["star_control","StarControlGame"];
star_control.StarControlGame.__super__ = titanium_reindeer.Game;
for(var k in titanium_reindeer.Game.prototype ) star_control.StarControlGame.prototype[k] = titanium_reindeer.Game.prototype[k];
star_control.StarControlGame.getFieldRect = function() {
	return new titanium_reindeer.Rect(-30,-30,660,660);
}
star_control.StarControlGame.prototype.player1 = null;
star_control.StarControlGame.prototype.player2 = null;
star_control.StarControlGame.prototype.ui = null;
star_control.StarControlGame.prototype.player1Score = null;
star_control.StarControlGame.prototype.player2Score = null;
star_control.StarControlGame.prototype.notifyShipDied = function(player) {
	if(this.player1 == player) this.player2Score++; else this.player1Score++;
	this.player1.ship.reset(new titanium_reindeer.Vector2(50,50));
	this.player2.ship.reset(new titanium_reindeer.Vector2(550,550));
	this.ui.updateScore(this.player1Score,this.player2Score);
	var rendererManager = (function($this) {
		var $r;
		var $t = $this.gameObjectManager.getManager(titanium_reindeer.RendererComponentManager);
		if(Std["is"]($t,titanium_reindeer.RendererComponentManager)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this));
	rendererManager.renderLayerManager.getLayer(2).redrawBackground = true;
}
star_control.StarControlGame.prototype.__class__ = star_control.StarControlGame;
titanium_reindeer.MouseExclusionRegion = function(manager,id,depth,shape) {
	if( manager === $_ ) return;
	this.manager = manager;
	this.id = id;
	this.depth = depth;
	if(shape == null) throw "Error: MouseExclusionRegion must take a non-null shape!";
	this.dontUpdateManager = true;
	this.setShape(shape);
	this.dontUpdateManager = false;
}
titanium_reindeer.MouseExclusionRegion.__name__ = ["titanium_reindeer","MouseExclusionRegion"];
titanium_reindeer.MouseExclusionRegion.prototype.manager = null;
titanium_reindeer.MouseExclusionRegion.prototype.id = null;
titanium_reindeer.MouseExclusionRegion.prototype.dontUpdateManager = null;
titanium_reindeer.MouseExclusionRegion.prototype.depth = null;
titanium_reindeer.MouseExclusionRegion.prototype.shape = null;
titanium_reindeer.MouseExclusionRegion.prototype.setShape = function(value) {
	if(value != this.shape && value != null) {
		this.shape = value;
		if(!this.dontUpdateManager) this.manager.updateExclusionRegionShape(this);
	}
	return this.shape;
}
titanium_reindeer.MouseExclusionRegion.prototype.destroy = function() {
	if(this.manager != null) {
		this.manager.removeExclusionRegion(this);
		this.manager = null;
	}
}
titanium_reindeer.MouseExclusionRegion.prototype.__class__ = titanium_reindeer.MouseExclusionRegion;
titanium_reindeer.MovementComponent = function(velocity) {
	if( velocity === $_ ) return;
	titanium_reindeer.Component.call(this);
	this.setVelocity(velocity == null?new titanium_reindeer.Vector2(0,0):velocity);
}
titanium_reindeer.MovementComponent.__name__ = ["titanium_reindeer","MovementComponent"];
titanium_reindeer.MovementComponent.__super__ = titanium_reindeer.Component;
for(var k in titanium_reindeer.Component.prototype ) titanium_reindeer.MovementComponent.prototype[k] = titanium_reindeer.Component.prototype[k];
titanium_reindeer.MovementComponent.prototype.velocity = null;
titanium_reindeer.MovementComponent.prototype.setVelocity = function(value) {
	if(value != null && !value.equal(this.velocity)) this.velocity = value.getCopy();
	return this.velocity;
}
titanium_reindeer.MovementComponent.prototype.move = function(msTimeStep) {
	this.owner.getPosition().addTo(this.velocity.getExtend(msTimeStep / 1000));
}
titanium_reindeer.MovementComponent.prototype.getManagerType = function() {
	return titanium_reindeer.MovementComponentManager;
}
titanium_reindeer.MovementComponent.prototype.destroy = function() {
	titanium_reindeer.Component.prototype.destroy.call(this);
	this.setVelocity(null);
}
titanium_reindeer.MovementComponent.prototype.__class__ = titanium_reindeer.MovementComponent;
star_control.UiBar = function(pos) {
	if( pos === $_ ) return;
	titanium_reindeer.GameObject.call(this);
	this.setPosition(pos.add(new titanium_reindeer.Vector2(100 / 2,600 / 2)));
	this.background = new titanium_reindeer.RectRenderer(100,600,3);
	this.background.setFill(titanium_reindeer.Color.getGreyConst());
	this.background.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.background.setLineWidth(2);
	this.addComponent("background",this.background);
	this.p1Title = new titanium_reindeer.TextRenderer("Player 1",4);
	this.p1Title.setFill(new titanium_reindeer.Color(0,162,232));
	this.p1Title.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.p1Title.setLineWidth(1);
	this.p1Title.setFontSize(22);
	this.p1Title.setFontWeight(titanium_reindeer.FontWeight.Bold);
	this.p1Title.setOffset(new titanium_reindeer.Vector2(0,80 - 600 / 2));
	this.addComponent("p1Title",this.p1Title);
	this.p2Title = new titanium_reindeer.TextRenderer("Player 2",4);
	this.p2Title.setFill(new titanium_reindeer.Color(193,29,37));
	this.p2Title.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.p2Title.setLineWidth(1);
	this.p2Title.setFontSize(22);
	this.p2Title.setFontWeight(titanium_reindeer.FontWeight.Bold);
	this.p2Title.setOffset(new titanium_reindeer.Vector2(0,600 / 2 - 100 - 86 - 20));
	this.addComponent("p2Title",this.p2Title);
	this.p1Score = new titanium_reindeer.TextRenderer("0",4);
	this.p1Score.setFill(new titanium_reindeer.Color(0,162,232));
	this.p1Score.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.p1Score.setLineWidth(1);
	this.p1Score.setFontSize(22);
	this.p1Score.setFontWeight(titanium_reindeer.FontWeight.Bold);
	this.p1Score.setOffset(new titanium_reindeer.Vector2(0,-20));
	this.addComponent("p1Score",this.p1Score);
	this.p2Score = new titanium_reindeer.TextRenderer("0",4);
	this.p2Score.setFill(new titanium_reindeer.Color(193,29,37));
	this.p2Score.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.p2Score.setLineWidth(1);
	this.p2Score.setFontSize(22);
	this.p2Score.setFontWeight(titanium_reindeer.FontWeight.Bold);
	this.p2Score.setOffset(new titanium_reindeer.Vector2(0,20));
	this.addComponent("p2Score",this.p2Score);
	this.divideLine = new titanium_reindeer.LineRenderer(new titanium_reindeer.Vector2(100,0),4);
	this.divideLine.setOffset(new titanium_reindeer.Vector2(-100 / 2,0));
	this.divideLine.setLineWidth(4);
	this.divideLine.setStrokeColor(titanium_reindeer.Color.getBlackConst());
	this.addComponent("divideLine",this.divideLine);
	var shipUiMargin = 28 / 2;
	this.ship1Ui = new star_control.ShipUi();
	this.ship1Ui.setPosition(pos.add(new titanium_reindeer.Vector2(72 / 2 + shipUiMargin,86 / 2 + 100)));
	this.ship2Ui = new star_control.ShipUi();
	this.ship2Ui.setPosition(pos.add(new titanium_reindeer.Vector2(72 / 2 + shipUiMargin,500 - 86 / 2)));
}
star_control.UiBar.__name__ = ["star_control","UiBar"];
star_control.UiBar.__super__ = titanium_reindeer.GameObject;
for(var k in titanium_reindeer.GameObject.prototype ) star_control.UiBar.prototype[k] = titanium_reindeer.GameObject.prototype[k];
star_control.UiBar.prototype.background = null;
star_control.UiBar.prototype.p1Title = null;
star_control.UiBar.prototype.p2Title = null;
star_control.UiBar.prototype.p1Score = null;
star_control.UiBar.prototype.p2Score = null;
star_control.UiBar.prototype.divideLine = null;
star_control.UiBar.prototype.ship1Ui = null;
star_control.UiBar.prototype.ship2Ui = null;
star_control.UiBar.prototype.updateScore = function(p1Score,p2Score) {
	this.p1Score.setText(p1Score + "");
	this.p2Score.setText(p2Score + "");
}
star_control.UiBar.prototype.setManager = function(manager) {
	titanium_reindeer.GameObject.prototype.setManager.call(this,manager);
	this.getManager().addGameObject(this.ship1Ui);
	this.getManager().addGameObject(this.ship2Ui);
}
star_control.UiBar.prototype.__class__ = star_control.UiBar;
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
star_control.Layers = function() { }
star_control.Layers.__name__ = ["star_control","Layers"];
star_control.Layers.prototype.__class__ = star_control.Layers;
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
$_ = {}
js.Boot.__res = {}
js.Boot.__init();
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
if(typeof(haxe_timers) == "undefined") haxe_timers = [];
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
	d.prototype.__class__ = d;
	d.__name__ = ["Date"];
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
star_control.Ship.COLLISION_RADIUS = 20;
star_control.Ship.DRAG = 25;
star_control.Ship.HIT_SOUND = "sound/ship_hit.mp3";
star_control.Ship.HIT_SOUND2 = "sound/ship_hit.mp3";
star_control.Artillery.MAX_HEALTH = 14;
star_control.Artillery.MAX_AMMO = 16;
star_control.Artillery.RECHARGE_RATE = 300;
star_control.Artillery.FIRE_RATE = 500;
star_control.Artillery.PRIMARY_AMMO_COST = 8;
star_control.Artillery.TURN_RATE = Math.PI / 2;
star_control.Artillery.THRUST_ACCEL = 100;
star_control.Artillery.MAX_THRUST = 150;
star_control.Artillery.FIRE_SOUND = "sound/artillery_fire.mp3";
star_control.Projectile.RADIUS = 5;
star_control.FighterBullet.SPEED = 300;
star_control.FighterBullet.DAMAGE = 1;
star_control.FighterBullet.LIFE_TIME = 1500;
star_control.FighterBullet.RADIUS = 5;
star_control.ShipUi.WIDTH = 72;
star_control.ShipUi.HEIGHT = 86;
star_control.ShipUi.START_X = -72 / 2;
star_control.ShipUi.START_Y = -86 / 2;
star_control.ShipUi.BAR_WIDTH = 12;
star_control.ShipUi.BAR_HEIGHT = 6;
star_control.ShipUi.HEALTH_FILLED = new titanium_reindeer.Color(34,255,51);
star_control.ShipUi.HEALTH_EMPTY = new titanium_reindeer.Color(34,34,34);
star_control.ShipUi.AMMO_FILLED = new titanium_reindeer.Color(255,0,17);
star_control.ShipUi.AMMO_EMPTY = new titanium_reindeer.Color(34,34,34);
star_control.ArtilleryShell.SPEED = 400;
star_control.ArtilleryShell.DAMAGE = 4;
star_control.ArtilleryShell.LIFE_TIME = 2000;
star_control.CollisionGroups.SHIPS = "ships";
star_control.CollisionGroups.BULLETS = "bullets";
titanium_reindeer.InputManager.DEFAULT_OFFSET_RECALC_DELAY_MS = 1000;
star_control.Fighter.MAX_HEALTH = 10;
star_control.Fighter.MAX_AMMO = 14;
star_control.Fighter.RECHARGE_RATE = 600;
star_control.Fighter.FIRE_RATE = 50;
star_control.Fighter.PRIMARY_AMMO_COST = 2;
star_control.Fighter.TURN_RATE = Math.PI;
star_control.Fighter.THRUST_ACCEL = 400;
star_control.Fighter.MAX_THRUST = 250;
star_control.Fighter.FIRE_SOUND = "sound/fighter_fire.mp3";
titanium_reindeer.Game.DEFAULT_UPDATES_TIME_MS = Math.round(1000 / 60);
star_control.StarControlGame.IMAGE_BASE = "img/";
star_control.StarControlGame.FIELD_SIZE = 600;
star_control.StarControlGame.OFFSCREEN_EDGE = 30;
star_control.StarControlGame.PLAYER1_COLOR = new titanium_reindeer.Color(0,162,232);
star_control.StarControlGame.PLAYER2_COLOR = new titanium_reindeer.Color(193,29,37);
star_control.UiBar.WIDTH = 100;
star_control.UiBar.HEIGHT = 600;
js.Lib.onerror = null;
star_control.Layers.BACKGROUND = 0;
star_control.Layers.BELOW_SHIPS = 1;
star_control.Layers.SHIPS = 2;
star_control.Layers.UI_A = 3;
star_control.Layers.UI_B = 4;
star_control.Layers.UI_C = 5;
star_control.Layers.TOP = 6;
star_control.Layers.NUM_LAYERS = 7;
StarControl.main()