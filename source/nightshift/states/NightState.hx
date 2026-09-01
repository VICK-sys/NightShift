package nightshift.states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import nightshift.audio.Sfx;
import nightshift.core.CharacterAgent;
import nightshift.core.NightEngine;
import nightshift.core.NightEvent;
import nightshift.core.Rng;
import nightshift.data.GameRuntime;
import nightshift.ui.CamPanel;
import nightshift.ui.HudBar;
import nightshift.ui.MouseUtil;
import nightshift.ui.OfficeView;
import nightshift.ui.Theme;

class NightState extends FlxState
{
	var engine:NightEngine;
	var office:OfficeView;
	var camPanel:CamPanel;
	var hud:HudBar;
	var hudCamera:FlxCamera;
	var ending:Bool = false;

	override function create():Void
	{
		FlxG.cameras.bgColor = Theme.background;
		FlxG.mouse.visible = true;
		var config = GameRuntime.config;
		var rng = new Rng(GameRuntime.forcedSeed);
		engine = new NightEngine(config, GameRuntime.nightIndex(), rng);
		FlxG.camera.setScrollBoundsRect(0, 0, config.officeWidth, 720);
		FlxG.camera.scroll.x = (config.officeWidth - 1280) / 2;
		hudCamera = new FlxCamera(0, 0, 1280, 720);
		hudCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(hudCamera, false);
		office = new OfficeView(engine, config.officeWidth);
		office.cameras = [FlxG.camera];
		add(office);
		hud = new HudBar(engine, GameRuntime.currentNight, rng.initialSeed);
		hud.cameras = [hudCamera];
		add(hud);
		camPanel = new CamPanel(engine, config.rooms);
		camPanel.cameras = [hudCamera];
		add(camPanel);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!ending)
		{
			handleInput(elapsed);
			engine.update(elapsed * Theme.timeScale);
			for (event in engine.drainEvents())
			{
				react(event);
			}
		}
	}

	function handleInput(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			setCamera(!engine.cameraUp);
		}
		if (camPanel.shown)
		{
			if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.ESCAPE)
			{
				setCamera(false);
				return;
			}
			camPanel.handleClick();
			var digits = [
				FlxG.keys.justPressed.ONE, FlxG.keys.justPressed.TWO, FlxG.keys.justPressed.THREE,
				FlxG.keys.justPressed.FOUR, FlxG.keys.justPressed.FIVE, FlxG.keys.justPressed.SIX,
				FlxG.keys.justPressed.SEVEN, FlxG.keys.justPressed.EIGHT, FlxG.keys.justPressed.NINE
			];
			for (i in 0...digits.length)
			{
				if (digits[i])
				{
					camPanel.selectIndex(i);
				}
			}
			return;
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(() -> new MenuState());
			return;
		}
		if (MouseUtil.clicked(hud.camStrip, hudCamera))
		{
			setCamera(true);
			return;
		}
		scroll(elapsed);
		if (MouseUtil.clicked(office.btnDoorLeft, FlxG.camera))
		{
			engine.toggleDoor("left");
			Sfx.play(engine.outageActive ? Theme.sfxDeny : Theme.sfxDoor);
		}
		if (MouseUtil.clicked(office.btnDoorRight, FlxG.camera))
		{
			engine.toggleDoor("right");
			Sfx.play(engine.outageActive ? Theme.sfxDeny : Theme.sfxDoor);
		}
		if (MouseUtil.clicked(office.btnLightLeft, FlxG.camera))
		{
			engine.toggleLight("left");
			Sfx.play(engine.outageActive ? Theme.sfxDeny : Theme.sfxLight);
		}
		if (MouseUtil.clicked(office.btnLightRight, FlxG.camera))
		{
			engine.toggleLight("right");
			Sfx.play(engine.outageActive ? Theme.sfxDeny : Theme.sfxLight);
		}
	}

	function scroll(elapsed:Float):Void
	{
		var direction = 0.0;
		if (FlxG.mouse.viewX < Theme.edgeScrollZone)
		{
			direction -= (Theme.edgeScrollZone - FlxG.mouse.viewX) / Theme.edgeScrollZone;
		}
		if (FlxG.mouse.viewX > 1280 - Theme.edgeScrollZone)
		{
			direction += (FlxG.mouse.viewX - (1280 - Theme.edgeScrollZone)) / Theme.edgeScrollZone;
		}
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
		{
			direction -= Theme.keyScrollSpeed / Theme.edgeScrollSpeed;
		}
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
		{
			direction += Theme.keyScrollSpeed / Theme.edgeScrollSpeed;
		}
		FlxG.camera.scroll.x += direction * Theme.edgeScrollSpeed * elapsed;
	}

	function setCamera(up:Bool):Void
	{
		if (engine.outageActive && up)
		{
			Sfx.play(Theme.sfxDeny);
			return;
		}
		engine.setCameraUp(up);
		camPanel.setShown(engine.cameraUp);
		Sfx.play(engine.cameraUp ? Theme.sfxCamOpen : Theme.sfxCamClose);
	}

	function react(event:NightEvent):Void
	{
		switch (event)
		{
			case Moved(_, _, _):
				Sfx.play(Theme.sfxFootstep);
			case AtDoor(_, _):
				Sfx.play(Theme.sfxKnock);
			case OutageStarted:
				camPanel.setShown(false);
				Sfx.play(Theme.sfxOutage);
			case Killed(id):
				endNight(id);
			case Won:
				ending = true;
				FlxG.switchState(() -> new WinState());
			case _:
		}
	}

	function endNight(killerId:String):Void
	{
		ending = true;
		var killer:CharacterAgent = null;
		for (agent in engine.agents)
		{
			if (agent.config.id == killerId)
			{
				killer = agent;
			}
		}
		var name = killer != null ? killer.config.name : "???";
		var color = killer != null ? killer.config.color : "";
		FlxG.switchState(() -> new JumpscareState(name, color));
	}
}
