package nightshift.ui;

import flixel.util.FlxColor;

class Theme
{
	public static var background:FlxColor = 0xFF0C0A07;
	public static var officeWall:FlxColor = 0xFF221B13;
	public static var officeFloor:FlxColor = 0xFF17120D;
	public static var desk:FlxColor = 0xFF322820;
	public static var doorFrame:FlxColor = 0xFF3E3226;
	public static var doorSlab:FlxColor = 0xFF52422F;
	public static var buttonIdle:FlxColor = 0xFF2C241B;
	public static var buttonActive:FlxColor = 0xFFE39B27;
	public static var buttonDead:FlxColor = 0xFF141009;
	public static var lightGlow:FlxColor = 0xFFF5E3AE;
	public static var panel:FlxColor = 0xFF0A120C;
	public static var panelBorder:FlxColor = 0xFF29402F;
	public static var mapRoom:FlxColor = 0xFF1D3324;
	public static var mapRoomActive:FlxColor = 0xFF2F5238;
	public static var accent:FlxColor = 0xFFE39B27;
	public static var textPrimary:FlxColor = 0xFFF2EDDF;
	public static var textSecondary:FlxColor = 0xFFA69C85;
	public static var powerOk:FlxColor = 0xFF7ECB5F;
	public static var powerLow:FlxColor = 0xFFE3B455;
	public static var danger:FlxColor = 0xFFD84343;
	public static var staticOverlay:FlxColor = 0x30FFFFFF;

	public static var titleSize:Int = 32;
	public static var hudSize:Int = 18;
	public static var bodySize:Int = 14;

	public static var scrollRepeatDelay:Float = 0.4;
	public static var scrollRepeatInterval:Float = 0.1;
	public static var edgeScrollZone:Float = 160;
	public static var edgeScrollSpeed:Float = 900;
	public static var keyScrollSpeed:Float = 1100;
	public static var doorSlideTime:Float = 0.18;
	public static var camFlipTime:Float = 0.12;
	public static var jumpscareTime:Float = 1.2;
	public static var winHoldTime:Float = 2.5;
	public static var timeScale:Float = 1.0;

	public static var imgOffice:String = "assets/images/office.png";
	public static var imgDoorLeft:String = "assets/images/door_left.png";
	public static var imgDoorRight:String = "assets/images/door_right.png";

	public static var sfxDoor:String = "assets/sounds/door.wav";
	public static var sfxLight:String = "assets/sounds/light.wav";
	public static var sfxCamOpen:String = "assets/sounds/cam_open.wav";
	public static var sfxCamClose:String = "assets/sounds/cam_close.wav";
	public static var sfxFootstep:String = "assets/sounds/footstep.wav";
	public static var sfxKnock:String = "assets/sounds/knock.wav";
	public static var sfxDeny:String = "assets/sounds/deny.wav";
	public static var sfxJumpscare:String = "assets/sounds/jumpscare.wav";
	public static var sfxOutage:String = "assets/sounds/outage.wav";
	public static var sfxChime:String = "assets/sounds/chime.wav";
	public static var sfxMove:String = "assets/sounds/move.wav";
	public static var sfxConfirm:String = "assets/sounds/confirm.wav";
}
