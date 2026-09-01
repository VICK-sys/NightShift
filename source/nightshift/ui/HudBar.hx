package nightshift.ui;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import nightshift.core.NightEngine;

class HudBar extends FlxTypedGroup<FlxSprite>
{
	public var camStrip(default, null):FlxSprite;

	var engine:NightEngine;
	var powerText:FlxText;
	var pips:Array<FlxSprite> = [];
	var clockText:FlxText;
	var nightText:FlxText;
	var seedText:FlxText;
	var stripLabel:FlxText;

	public function new(engine:NightEngine, night:Int, seed:Int)
	{
		super();
		this.engine = engine;
		powerText = new FlxText(30, 640, 300, "", Theme.hudSize);
		powerText.color = Theme.textPrimary;
		add(powerText);
		var usageLabel = new FlxText(30, 670, 80, "Usage", Theme.bodySize);
		usageLabel.color = Theme.textSecondary;
		add(usageLabel);
		for (i in 0...6)
		{
			var pip = new FlxSprite(100 + i * 26, 672);
			pip.makeGraphic(20, 14, FlxColor.WHITE);
			add(pip);
			pips.push(pip);
		}
		clockText = new FlxText(1030, 30, 220, "", Theme.titleSize);
		clockText.color = Theme.textPrimary;
		clockText.alignment = RIGHT;
		add(clockText);
		nightText = new FlxText(30, 30, 300, "Night " + night, Theme.hudSize);
		nightText.color = Theme.textSecondary;
		add(nightText);
		seedText = new FlxText(30, 56, 300, "Seed " + seed, Theme.bodySize);
		seedText.color = Theme.textSecondary;
		seedText.alpha = 0.5;
		add(seedText);
		camStrip = new FlxSprite(390, 688);
		camStrip.makeGraphic(500, 26, FlxColor.WHITE);
		camStrip.color = Theme.panelBorder;
		add(camStrip);
		stripLabel = new FlxText(390, 692, 500, "CAMERA  (Space)", Theme.bodySize);
		stripLabel.color = Theme.textPrimary;
		stripLabel.alignment = CENTER;
		add(stripLabel);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var percent = Math.ceil(engine.power.power);
		powerText.text = "Power " + percent + "%";
		powerText.color = percent <= 20 ? Theme.danger : (percent <= 50 ? Theme.powerLow : Theme.powerOk);
		var usage = engine.outageActive ? 0 : engine.usage();
		for (i in 0...pips.length)
		{
			pips[i].color = i < usage ? (usage >= 4 ? Theme.danger : Theme.accent) : Theme.panelBorder;
		}
		clockText.text = engine.clock.label();
		camStrip.color = engine.cameraUp ? Theme.accent : Theme.panelBorder;
		camStrip.visible = !engine.outageActive;
		stripLabel.visible = !engine.outageActive;
	}
}
