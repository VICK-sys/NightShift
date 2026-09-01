package nightshift.input;

import flixel.FlxBasic;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInput.FlxInputDeviceID;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import nightshift.ui.Theme;

class NavInput extends FlxBasic
{
	public var up(default, null):Bool = false;
	public var down(default, null):Bool = false;
	public var left(default, null):Bool = false;
	public var right(default, null):Bool = false;
	public var accept(default, null):Bool = false;
	public var back(default, null):Bool = false;
	public var menu(default, null):Bool = false;

	var aUp:FlxActionDigital;
	var aDown:FlxActionDigital;
	var aLeft:FlxActionDigital;
	var aRight:FlxActionDigital;
	var aAccept:FlxActionDigital;
	var aBack:FlxActionDigital;
	var aMenu:FlxActionDigital;

	var gateUp:RepeatGate;
	var gateDown:RepeatGate;
	var gateLeft:RepeatGate;
	var gateRight:RepeatGate;

	public function new()
	{
		super();
		aUp = direction([FlxKey.W, FlxKey.UP], [FlxGamepadInputID.DPAD_UP, FlxGamepadInputID.LEFT_STICK_DIGITAL_UP]);
		aDown = direction([FlxKey.S, FlxKey.DOWN], [FlxGamepadInputID.DPAD_DOWN, FlxGamepadInputID.LEFT_STICK_DIGITAL_DOWN]);
		aLeft = direction([FlxKey.A, FlxKey.LEFT], [FlxGamepadInputID.DPAD_LEFT, FlxGamepadInputID.LEFT_STICK_DIGITAL_LEFT]);
		aRight = direction([FlxKey.D, FlxKey.RIGHT], [FlxGamepadInputID.DPAD_RIGHT, FlxGamepadInputID.LEFT_STICK_DIGITAL_RIGHT]);
		aAccept = edge([FlxKey.ENTER, FlxKey.Z], [FlxGamepadInputID.A]);
		aBack = edge([FlxKey.ESCAPE, FlxKey.BACKSPACE, FlxKey.X], [FlxGamepadInputID.B]);
		aMenu = edge([FlxKey.TAB], [FlxGamepadInputID.START]);
		gateUp = new RepeatGate(Theme.scrollRepeatDelay, Theme.scrollRepeatInterval);
		gateDown = new RepeatGate(Theme.scrollRepeatDelay, Theme.scrollRepeatInterval);
		gateLeft = new RepeatGate(Theme.scrollRepeatDelay, Theme.scrollRepeatInterval);
		gateRight = new RepeatGate(Theme.scrollRepeatDelay, Theme.scrollRepeatInterval);
	}

	function direction(keys:Array<FlxKey>, buttons:Array<FlxGamepadInputID>):FlxActionDigital
	{
		return build(keys, buttons, FlxInputState.PRESSED);
	}

	function edge(keys:Array<FlxKey>, buttons:Array<FlxGamepadInputID>):FlxActionDigital
	{
		return build(keys, buttons, FlxInputState.JUST_PRESSED);
	}

	function build(keys:Array<FlxKey>, buttons:Array<FlxGamepadInputID>, trigger:FlxInputState):FlxActionDigital
	{
		var action = new FlxActionDigital();
		for (key in keys)
		{
			action.addKey(key, trigger);
		}
		for (button in buttons)
		{
			action.addGamepad(button, trigger, FlxInputDeviceID.ALL);
		}
		return action;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		up = gateUp.poll(aUp.check(), elapsed);
		down = gateDown.poll(aDown.check(), elapsed);
		left = gateLeft.poll(aLeft.check(), elapsed);
		right = gateRight.poll(aRight.check(), elapsed);
		accept = aAccept.check();
		back = aBack.check();
		menu = aMenu.check();
	}

	override public function destroy():Void
	{
		for (action in [aUp, aDown, aLeft, aRight, aAccept, aBack, aMenu])
		{
			action.destroy();
		}
		super.destroy();
	}
}
