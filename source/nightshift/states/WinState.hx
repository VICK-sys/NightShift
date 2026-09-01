package nightshift.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import nightshift.audio.Sfx;
import nightshift.data.GameRuntime;
import nightshift.input.NavInput;
import nightshift.ui.Theme;

class WinState extends FlxState
{
	var nav:NavInput;
	var timer:Float = 0;

	override function create():Void
	{
		FlxG.cameras.bgColor = Theme.background;
		FlxG.mouse.visible = true;
		GameRuntime.save.markCleared(GameRuntime.currentNight);
		var title = new FlxText(0, 280, 1280, "6 AM", Theme.titleSize + 28);
		title.color = Theme.powerOk;
		title.alignment = CENTER;
		add(title);
		var sub = new FlxText(0, 380, 1280, "Night " + GameRuntime.currentNight + " cleared", Theme.hudSize);
		sub.color = Theme.textPrimary;
		sub.alignment = CENTER;
		add(sub);
		var hasNext = GameRuntime.currentNight < GameRuntime.nightCount();
		var footer = new FlxText(40, FlxG.height - 50, FlxG.width - 80,
			hasNext ? "Enter: next night   Escape: menu" : "All nights cleared. Enter or Escape: menu", Theme.bodySize);
		footer.color = Theme.textSecondary;
		add(footer);
		nav = new NavInput();
		add(nav);
		Sfx.play(Theme.sfxChime);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		timer += elapsed;
		if (timer < Theme.winHoldTime)
		{
			return;
		}
		var hasNext = GameRuntime.currentNight < GameRuntime.nightCount();
		if (nav.accept)
		{
			if (hasNext)
			{
				GameRuntime.currentNight++;
				FlxG.switchState(() -> new NightState());
			}
			else
			{
				FlxG.switchState(() -> new MenuState());
			}
		}
		if (nav.back)
		{
			FlxG.switchState(() -> new MenuState());
		}
	}
}
