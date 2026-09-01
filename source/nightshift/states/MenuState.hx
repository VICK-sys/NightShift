package nightshift.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import nightshift.audio.Sfx;
import nightshift.data.GameRuntime;
import nightshift.input.NavInput;
import nightshift.ui.MouseUtil;
import nightshift.ui.Theme;

class MenuState extends FlxState
{
	var nav:NavInput;
	var cards:Array<FlxSprite> = [];
	var cardLabels:Array<FlxText> = [];
	var selected:Int = 0;

	override function create():Void
	{
		FlxG.cameras.bgColor = Theme.background;
		FlxG.mouse.visible = true;
		var title = new FlxText(0, 120, 1280, GameRuntime.config.title, Theme.titleSize + 12);
		title.color = Theme.textPrimary;
		title.alignment = CENTER;
		add(title);
		var count = GameRuntime.nightCount();
		var cardWidth = 140;
		var gap = 30;
		var startX = Std.int((1280 - count * cardWidth - (count - 1) * gap) / 2);
		for (i in 0...count)
		{
			var card = new FlxSprite(startX + i * (cardWidth + gap), 300);
			card.makeGraphic(cardWidth, 180, FlxColor.WHITE);
			add(card);
			cards.push(card);
			var label = new FlxText(startX + i * (cardWidth + gap), 370, cardWidth, "Night " + (i + 1), Theme.hudSize);
			label.alignment = CENTER;
			add(label);
			cardLabels.push(label);
		}
		var footer = new FlxText(40, FlxG.height - 50, FlxG.width - 80, "Select: Arrows / Mouse   Start: Enter / Click   Quit: Escape", Theme.bodySize);
		footer.color = Theme.textSecondary;
		add(footer);
		selected = unlockedCount() - 1;
		nav = new NavInput();
		add(nav);
	}

	function unlockedCount():Int
	{
		var unlocked = GameRuntime.save.highestClearedNight + 1;
		return unlocked > GameRuntime.nightCount() ? GameRuntime.nightCount() : unlocked;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var unlocked = unlockedCount();
		if (nav.left && selected > 0)
		{
			selected--;
			Sfx.play(Theme.sfxMove);
		}
		if (nav.right && selected < unlocked - 1)
		{
			selected++;
			Sfx.play(Theme.sfxMove);
		}
		for (i in 0...cards.length)
		{
			var isUnlocked = i < unlocked;
			if (isUnlocked && MouseUtil.hover(cards[i], FlxG.camera) && FlxG.mouse.justMoved)
			{
				selected = i;
			}
			cards[i].color = i == selected ? Theme.accent : (isUnlocked ? Theme.mapRoomActive : Theme.buttonDead);
			cardLabels[i].color = isUnlocked ? Theme.textPrimary : Theme.textSecondary;
			if (isUnlocked && MouseUtil.clicked(cards[i], FlxG.camera))
			{
				start(i + 1);
				return;
			}
		}
		if (nav.accept)
		{
			start(selected + 1);
			return;
		}
		if (nav.back)
		{
			Sys.exit(0);
		}
	}

	function start(night:Int):Void
	{
		Sfx.play(Theme.sfxConfirm);
		GameRuntime.currentNight = night;
		FlxG.switchState(() -> new NightState());
	}
}
