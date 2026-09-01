package nightshift.ui;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import nightshift.core.NightEngine;

class OfficeView extends FlxTypedGroup<FlxSprite>
{
	public var btnDoorLeft(default, null):FlxSprite;
	public var btnLightLeft(default, null):FlxSprite;
	public var btnDoorRight(default, null):FlxSprite;
	public var btnLightRight(default, null):FlxSprite;

	var engine:NightEngine;
	var officeWidth:Int;
	var slabLeft:FlxSprite;
	var slabRight:FlxSprite;
	var glowLeft:FlxSprite;
	var glowRight:FlxSprite;
	var badgeLeft:FlxSprite;
	var badgeRight:FlxSprite;
	var badgeTextLeft:FlxText;
	var badgeTextRight:FlxText;
	var darkOverlay:FlxSprite;

	static inline var DOOR_W = 150;
	static inline var DOOR_H = 380;
	static inline var DOOR_Y = 150;

	public function new(engine:NightEngine, officeWidth:Int)
	{
		super();
		this.engine = engine;
		this.officeWidth = officeWidth;
		var wall = Placeholder.sprite(Theme.imgOffice, officeWidth, 540, Theme.officeWall);
		add(wall);
		var floor = new FlxSprite(0, 540);
		floor.makeGraphic(officeWidth, 180, Theme.officeFloor);
		add(floor);
		var desk = new FlxSprite(Std.int(officeWidth / 2 - 260), 500);
		desk.makeGraphic(520, 140, Theme.desk);
		add(desk);
		buildDoor(true);
		buildDoor(false);
		darkOverlay = new FlxSprite(0, 0);
		darkOverlay.makeGraphic(officeWidth, 720, FlxColor.BLACK);
		darkOverlay.alpha = 0;
		add(darkOverlay);
	}

	function buildDoor(isLeft:Bool):Void
	{
		var frameX = isLeft ? 80 : officeWidth - 80 - DOOR_W;
		var frame = new FlxSprite(frameX - 12, DOOR_Y - 12);
		frame.makeGraphic(DOOR_W + 24, DOOR_H + 24, Theme.doorFrame);
		add(frame);
		var glow = new FlxSprite(frameX, DOOR_Y);
		glow.makeGraphic(DOOR_W, DOOR_H, Theme.lightGlow);
		glow.visible = false;
		add(glow);
		var badge = new FlxSprite(frameX + Std.int(DOOR_W / 2 - 45), DOOR_Y + 80);
		badge.makeGraphic(90, 240, FlxColor.WHITE);
		badge.visible = false;
		add(badge);
		var badgeText = new FlxText(frameX - 30, DOOR_Y + 20, DOOR_W + 60, "", Theme.bodySize);
		badgeText.color = Theme.textPrimary;
		badgeText.alignment = CENTER;
		badgeText.visible = false;
		add(badgeText);
		var slabPath = isLeft ? Theme.imgDoorLeft : Theme.imgDoorRight;
		var slab = Placeholder.sprite(slabPath, DOOR_W, DOOR_H, Theme.doorSlab);
		slab.setPosition(frameX, DOOR_Y);
		slab.origin.y = 0;
		slab.scale.y = 0;
		add(slab);
		var buttonX = isLeft ? frameX + DOOR_W + 50 : frameX - 50 - 70;
		var doorButton = new FlxSprite(buttonX, 240);
		doorButton.makeGraphic(70, 70, FlxColor.WHITE);
		add(doorButton);
		var doorLabel = new FlxText(buttonX - 15, 314, 100, "DOOR", Theme.bodySize);
		doorLabel.color = Theme.textSecondary;
		doorLabel.alignment = CENTER;
		add(doorLabel);
		var lightButton = new FlxSprite(buttonX, 370);
		lightButton.makeGraphic(70, 70, FlxColor.WHITE);
		add(lightButton);
		var lightLabel = new FlxText(buttonX - 15, 444, 100, "LIGHT", Theme.bodySize);
		lightLabel.color = Theme.textSecondary;
		lightLabel.alignment = CENTER;
		add(lightLabel);
		if (isLeft)
		{
			slabLeft = slab;
			glowLeft = glow;
			badgeLeft = badge;
			badgeTextLeft = badgeText;
			btnDoorLeft = doorButton;
			btnLightLeft = lightButton;
		}
		else
		{
			slabRight = slab;
			glowRight = glow;
			badgeRight = badge;
			badgeTextRight = badgeText;
			btnDoorRight = doorButton;
			btnLightRight = lightButton;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		syncDoor(slabLeft, engine.doorLeft, elapsed);
		syncDoor(slabRight, engine.doorRight, elapsed);
		syncSide("left", glowLeft, badgeLeft, badgeTextLeft, engine.lightLeft);
		syncSide("right", glowRight, badgeRight, badgeTextRight, engine.lightRight);
		btnDoorLeft.color = buttonColor(engine.doorLeft);
		btnDoorRight.color = buttonColor(engine.doorRight);
		btnLightLeft.color = buttonColor(engine.lightLeft);
		btnLightRight.color = buttonColor(engine.lightRight);
		darkOverlay.alpha = engine.outageActive ? 0.65 : 0;
	}

	function buttonColor(active:Bool):FlxColor
	{
		if (engine.outageActive)
		{
			return Theme.buttonDead;
		}
		return active ? Theme.buttonActive : Theme.buttonIdle;
	}

	function syncDoor(slab:FlxSprite, closed:Bool, elapsed:Float):Void
	{
		var target = closed ? 1.0 : 0.0;
		var speed = elapsed / Theme.doorSlideTime;
		if (slab.scale.y < target)
		{
			slab.scale.y = Math.min(target, slab.scale.y + speed);
		}
		else if (slab.scale.y > target)
		{
			slab.scale.y = Math.max(target, slab.scale.y - speed);
		}
	}

	function syncSide(side:String, glow:FlxSprite, badge:FlxSprite, badgeText:FlxText, lightOn:Bool):Void
	{
		glow.visible = lightOn && !engine.outageActive;
		var revealed = glow.visible ? engine.lightReveals(side) : [];
		var showBadge = revealed.length > 0;
		badge.visible = showBadge;
		badgeText.visible = showBadge;
		if (showBadge)
		{
			badge.color = Placeholder.parseColor(revealed[0].config.color, Theme.danger);
			badgeText.text = revealed[0].config.name;
		}
	}
}
