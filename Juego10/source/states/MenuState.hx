package states;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flash.system.System;
import flixel.math.FlxMath;
import openfl.Lib;

class MenuState extends FlxState
{
	private var title:FlxText;
	private var nombres:FlxText;

	private var play:FlxButton;
	private var salir:FlxButton;
	
	private var splash:Bool;
	private var counter:Int;
	override public function create():Void
	{
		super.create();
		splash = false;
		counter = 0;
		title = new FlxText(130, 30,0 , 40);
		title.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFFFF0000);
		title.text = "SAMPLE TEXT420";
		nombres = new FlxText(120,80,0,10);
		nombres.text = "Damian Iglesias";
		nombres.scale.x = 1;
		nombres.scale.y = 1;
		
		play = new FlxButton(240, 240, "Jugar");
		play.scale.x = 2;
		play.scale.y = 1;
		add(title);
		add(nombres);
		add(play);
		add(salir);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (play.justReleased)
				FlxG.switchState(new PlayState());

		
	}
}
