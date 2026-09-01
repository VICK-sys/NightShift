package nightshift.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import nightshift.audio.Sfx;
import nightshift.ui.Placeholder;
import nightshift.ui.Theme;

class JumpscareState extends FlxState
{
	var name:String;
	var colorHex:String;
	var timer:Float = 0;
	var flash:FlxSprite;
	var face:FlxSprite;
	var label:FlxText;

	public function new(name:String, colorHex:String)
	{
		super();
		this.name = name;
		this.colorHex = colorHex;
	}

	override function create():Void
	{
		FlxG.cameras.bgColor = FlxColor.BLACK;
		FlxG.mouse.visible = false;
		flash = new FlxSprite(0, 0);
		flash.makeGraphic(1280, 720, FlxColor.WHITE);
		flash.color = Placeholder.parseColor(colorHex, Theme.danger);
		add(flash);
		face = new FlxSprite(440, 100);
		face.makeGraphic(400, 460, FlxColor.BLACK);
		add(face);
		label = new FlxText(0, 300, 1280, name, Theme.titleSize + 20);
		label.color = FlxColor.WHITE;
		label.alignment = CENTER;
		add(label);
		Sfx.play(Theme.sfxJumpscare);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		timer += elapsed;
		flash.visible = Std.int(timer * 20) % 2 == 0;
		face.x = 440 + FlxG.random.float(-18, 18);
		face.y = 100 + FlxG.random.float(-18, 18);
		label.y = 300 + FlxG.random.float(-10, 10);
		if (timer >= Theme.jumpscareTime)
		{
			FlxG.switchState(() -> new GameOverState());
		}
	}
}
