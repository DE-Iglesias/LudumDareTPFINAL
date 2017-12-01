package;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;

class Bichi extends FlxSprite
{
	public static inline var GRAVITY:Float = 600;
	
	public var fsm:FlxFSM<Bichi>;
	public var isFast(get, null):Bool;


	
	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);
		loadGraphic(AssetPaths.GordoNarizSS__png, true, 64, 64);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		facing = FlxObject.RIGHT;
		width = 35;
		offset.x += 12;
		animation.add("idle", [8, 9, 10, 11], 12);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 12);
		animation.add("jump", [12,13,14], 15, false);
		animation.add("attack", [31, 32, 33],5, false);
		animation.add("fall", [14], 8, true);
		FlxFlicker.flicker(this, 1, 0.1, true, true);
		acceleration.y = GRAVITY;
		maxVelocity.set(100, GRAVITY);
		
		fsm = new FlxFSM<Bichi>(this);
		fsm.transitions
			.add(Idle, Jump, Conditions.jump)
			.add(Jump, Idle, Conditions.grounded)
			.add(Jump, Attack, Conditions.attack)
			.add(Idle, Attack, Conditions.attack)
			.add(Attack, Jump, Conditions.air)
			.add(Attack, Idle, Conditions.animationFinished)
			.start(Idle);
	}
	
	override public function update(elapsed:Float):Void 
	{
		fsm.update(elapsed);
		super.update(elapsed);
	}
	
	override public function destroy():Void 
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
	public function get_isFast():Bool
	{	
		return isFast;
	}
	
	public function invertIsFast():Void
	{
		isFast = !isFast;
	}

}

class Conditions
{
	
	public static function air(Owner:Bichi):Bool
	{
		return (Owner.velocity.y != 0 && Owner.animation.finished);
	}
	public static function jump(Owner:Bichi):Bool
	{
		return (FlxG.keys.justPressed.UP && Owner.velocity.y==0);
	}
	
	public static function grounded(Owner:Bichi):Bool
	{
		return Owner.velocity.y == 0;
	}
	
	public static function attack(Owner:Bichi):Bool
	{
		return FlxG.keys.justPressed.Z;
	}
	
	public static function animationFinished(Owner:Bichi):Bool
	{
		return Owner.animation.finished;
	}
}

class Idle extends FlxFSMState<Bichi>
{
	override public function enter(owner:Bichi, fsm:FlxFSM<Bichi>):Void 
	{
		owner.animation.play("idle");
	}
	
	override public function update(elapsed:Float, owner:Bichi, fsm:FlxFSM<Bichi>):Void 
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.facing = FlxG.keys.pressed.LEFT ? FlxObject.LEFT : FlxObject.RIGHT;
			owner.animation.play("walk");
			if (!owner.isFast)
			{
			owner.velocity.x = FlxG.keys.pressed.LEFT ? -300 : 300;
			}
			else
			{
			owner.velocity.x = FlxG.keys.pressed.LEFT ? -600 : 600;
			}
		}
		else
		{
			owner.animation.play("idle");
			owner.velocity.x = 0;
		}
		if (FlxG.keys.pressed.X)
		{
			owner.invertIsFast();
		}
	}
}

class Jump extends FlxFSMState<Bichi>
{
	override public function enter(owner:Bichi, fsm:FlxFSM<Bichi>):Void 
	{
		if(owner.velocity.y == 0)
		{
		owner.animation.play("jump");
		owner.velocity.y = -350;
		}
		if (owner.velocity.y > 0)
		{
			owner.animation.play("fall");
		}
		if (FlxG.keys.pressed.X)
		{
			owner.invertIsFast();
		}
	}
	
	override public function update(elapsed:Float, owner:Bichi, fsm:FlxFSM<Bichi>):Void 
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			if (!owner.isFast)
			{
			owner.velocity.x = FlxG.keys.pressed.LEFT ? -300 : 300;
			}
			else
			{
			owner.velocity.x = FlxG.keys.pressed.LEFT ? -600 : 600;
			}
		}
	}
}
class Attack extends FlxFSMState<Bichi>
{
	override public function enter(owner:Bichi, fsm:FlxFSM<Bichi>):Void 
	{
		owner.animation.play("attack");
	
	}
}
