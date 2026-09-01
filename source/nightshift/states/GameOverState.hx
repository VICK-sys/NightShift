package nightshift.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import nightshift.data.GameRuntime;
import nightshift.input.NavInput;
import nightshift.ui.Theme;

class GameOverState extends FlxState
{
	var nav:NavInput;

	override function create():Void
	{
		FlxG.cameras.bgColor = Theme.background;
		FlxG.mouse.visible = true;
		var title = new FlxText(0, 280, 1280, "You were caught", Theme.titleSize + 12);
		title.color = Theme.danger;
		title.alignment = CENTER;
		add(title);
		var sub = new FlxText(0, 370, 1280, "Night " + GameRuntime.currentNight, Theme.hudSize);
		sub.color = Theme.textSecondary;
		sub.alignment = CENTER;
		add(sub);
		var footer = new FlxText(40, FlxG.height - 50, FlxG.width - 80, "Enter or R: retry   Escape: menu", Theme.bodySize);
		footer.color = Theme.textSecondary;
		add(footer);
		nav = new NavInput();
		add(nav);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (nav.accept || FlxG.keys.justPressed.R)
		{
			FlxG.switchState(() -> new NightState());
		}
		if (nav.back)
		{
			FlxG.switchState(() -> new MenuState());
		}
	}
}
