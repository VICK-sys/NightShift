package nightshift.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import nightshift.core.NightEngine;
import nightshift.data.GameConfig;

class CamPanel extends FlxTypedGroup<FlxSprite>
{
	public var shown(default, null):Bool = false;
	public var selectedRoom(default, null):String;

	var engine:NightEngine;
	var camRooms:Array<RoomConfig>;
	var mapRects:Array<FlxSprite> = [];
	var roomTitle:FlxText;
	var roomImage:FlxSprite;
	var occupantBadges:Array<FlxSprite> = [];
	var occupantNames:Array<FlxText> = [];
	var emptyText:FlxText;
	var flicker:FlxSprite;
	var flickerTimer:Float = 0;

	static inline var MAX_OCCUPANTS = 4;

	public function new(engine:NightEngine, rooms:Array<RoomConfig>)
	{
		super();
		this.engine = engine;
		camRooms = [for (room in rooms) if (room.camera) room];
		var backdrop = new FlxSprite(0, 0);
		backdrop.makeGraphic(1280, 720, Theme.panel);
		backdrop.alpha = 0.97;
		add(backdrop);
		roomImage = new FlxSprite(60, 110);
		roomImage.makeGraphic(760, 480, Theme.mapRoom);
		add(roomImage);
		roomTitle = new FlxText(60, 60, 760, "", Theme.titleSize);
		roomTitle.color = Theme.textPrimary;
		add(roomTitle);
		for (i in 0...MAX_OCCUPANTS)
		{
			var badge = new FlxSprite(120 + i * 180, 220);
			badge.makeGraphic(110, 280, FlxColor.WHITE);
			badge.visible = false;
			add(badge);
			occupantBadges.push(badge);
			var name = new FlxText(90 + i * 180, 510, 170, "", Theme.bodySize);
			name.color = Theme.textPrimary;
			name.alignment = CENTER;
			name.visible = false;
			add(name);
			occupantNames.push(name);
		}
		emptyText = new FlxText(60, 340, 760, "No movement", Theme.hudSize);
		emptyText.color = Theme.textSecondary;
		emptyText.alignment = CENTER;
		add(emptyText);
		buildMap();
		flicker = new FlxSprite(60, 110);
		flicker.makeGraphic(760, 480, FlxColor.WHITE);
		flicker.alpha = 0;
		add(flicker);
		var hint = new FlxText(60, 660, 1160, "Click a room or press 1-" + camRooms.length + "   Space or S closes the camera", Theme.bodySize);
		hint.color = Theme.textSecondary;
		add(hint);
		selectedRoom = camRooms.length > 0 ? camRooms[0].id : "";
		setShown(false);
	}

	function buildMap():Void
	{
		var originX = 880;
		var originY = 320;
		var autoIndex = 0;
		for (i in 0...camRooms.length)
		{
			var room = camRooms[i];
			var x = room.mapX;
			var y = room.mapY;
			if (x < 0 || y < 0)
			{
				x = (autoIndex % 3) * 120;
				y = Std.int(autoIndex / 3) * 70;
				autoIndex++;
			}
			var rect = new FlxSprite(originX + x, originY + y);
			rect.makeGraphic(110, 56, FlxColor.WHITE);
			add(rect);
			mapRects.push(rect);
			var label = new FlxText(originX + x, originY + y + 16, 110, "CAM " + (i + 1), Theme.bodySize);
			label.color = Theme.textPrimary;
			label.alignment = CENTER;
			add(label);
		}
	}

	public function setShown(value:Bool):Void
	{
		shown = value;
		for (member in members)
		{
			member.visible = value;
		}
		if (!value)
		{
			return;
		}
		refreshVisibility();
	}

	public function select(roomId:String):Void
	{
		selectedRoom = roomId;
		flickerTimer = 0.12;
	}

	public function selectIndex(index:Int):Void
	{
		if (index >= 0 && index < camRooms.length)
		{
			select(camRooms[index].id);
		}
	}

	public function handleClick():Void
	{
		for (i in 0...mapRects.length)
		{
			if (MouseUtil.clicked(mapRects[i], camera))
			{
				select(camRooms[i].id);
				return;
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!shown)
		{
			return;
		}
		flickerTimer -= elapsed;
		flicker.alpha = flickerTimer > 0 ? 0.5 : (FlxG.random.bool(4) ? 0.08 : 0);
		refreshVisibility();
	}

	function refreshVisibility():Void
	{
		var selectedIndex = 0;
		for (i in 0...camRooms.length)
		{
			var active = camRooms[i].id == selectedRoom;
			if (active)
			{
				selectedIndex = i;
			}
			mapRects[i].color = active ? Theme.accent : Theme.mapRoom;
		}
		var room = camRooms[selectedIndex];
		roomTitle.text = "CAM " + (selectedIndex + 1) + "  " + room.name;
		var here = engine.occupants(room.id);
		for (i in 0...MAX_OCCUPANTS)
		{
			var present = i < here.length;
			occupantBadges[i].visible = present;
			occupantNames[i].visible = present;
			if (present)
			{
				occupantBadges[i].color = Placeholder.parseColor(here[i].config.color, Theme.danger);
				occupantNames[i].text = here[i].config.name;
			}
		}
		emptyText.visible = here.length == 0;
	}
}
