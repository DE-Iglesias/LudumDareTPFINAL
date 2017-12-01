package states;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var bichi:Bichi;

	private var pickup: Pickup;
	private var pickup2: Pickup;
	private var trail:FlxTrail;
	private var timer:Float;
	private var nivel:FlxOgmoLoader;
	private var pared:FlxTilemap;
	private var fondo:FlxTilemap;
	private var spike:FlxTilemap;
	private var emisor:FlxEmitter;
	
	override public function create():Void
	{
		super.create();
		pickup = new Pickup(80, 550);
		pickup2 = new Pickup(810, 490);
		bichi = new Bichi(100, 500);
		trail = new FlxTrail(bichi);
		
		
		FlxG.worldBounds.set(0, 0, 1920, 640);
		nivel = new FlxOgmoLoader(AssetPaths.level1__oel);
		fondo = nivel.loadTilemap(AssetPaths.tiles__png, 64, 64, "Fondo");	
		fondo.setTileProperties(0, FlxObject.NONE);
		fondo.setTileProperties(1, FlxObject.ANY);
		fondo.setTileProperties(2, FlxObject.NONE);
		fondo.setTileProperties(3, FlxObject.NONE);
		add(fondo);
		spike = nivel.loadTilemap(AssetPaths.spike__png, 64, 64, "Spikes");
		spike.setTileProperties(0, FlxObject.NONE);
		spike.setTileProperties(1, FlxObject.ANY);
		FlxG.camera.follow(bichi);
		timer = 0;
		FlxG.camera.setScrollBounds(0, 1920, 0, 640);
		FlxG.camera.fade(FlxColor.BLACK,1,true, false);
		add(pickup);
		add(pickup2);
		add(trail);
		add(bichi);
		add(spike);
		trail.kill();
		
		
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.R)
		{
			create();
		}
		if (bichi.isFast)
		{
			
			timer += elapsed;
			if (timer > 5)
			{
				bichi.invertIsFast();
				trail.kill();				
			}
		}
		FlxG.collide(fondo, bichi);
		
		
		
		if (FlxG.collide(spike, bichi))
		{
			ded();
		}
		super.update(elapsed);
		if (FlxG.collide(pickup, bichi))
		{
			trail.revive();
			if (!bichi.isFast)
			{
			bichi.invertIsFast();
			}
			pickup.kill();
			timer = 0;
		}
		
		if (FlxG.collide(pickup2, bichi))
		{
			trail.revive();
			if (!bichi.isFast)
			{
			bichi.invertIsFast();
			}
			pickup2.kill();
			timer = 0;
		}
	}
	public function ded():Void
	{
		trail.kill();
		emisor = new FlxEmitter(0, 0, 15);
		emisor.makeParticles(3, 3, FlxColor.RED, 150);
		emisor.focusOn(bichi);
		emisor.lifespan.set(0.8, 1);
		emisor.solid = true;
		emisor.color.set(FlxColor.RED);
		emisor.start(true);
		add(emisor);
		FlxG.camera.shake(0.05, 0.2);
		FlxG.camera.fade(FlxColor.BLACK,1,false, false);
		bichi.destroy();
		
	}
}
