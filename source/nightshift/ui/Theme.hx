package nightshift.ui;

import flixel.util.FlxColor;

class Theme
{
	public static var background:FlxColor = 0xFF0A0A10;
	public static var officeWall:FlxColor = 0xFF1A1A26;
	public static var officeFloor:FlxColor = 0xFF12121C;
	public static var desk:FlxColor = 0xFF242434;
	public static var doorFrame:FlxColor = 0xFF2E2E42;
	public static var doorSlab:FlxColor = 0xFF3A3A52;
	public static var buttonIdle:FlxColor = 0xFF232334;
	public static var buttonActive:FlxColor = 0xFF7C6CF0;
	public static var buttonDead:FlxColor = 0xFF15151E;
	public static var lightGlow:FlxColor = 0xFFF0E8C0;
	public static var panel:FlxColor = 0xFF10101A;
	public static var panelBorder:FlxColor = 0xFF2E2E42;
	public static var mapRoom:FlxColor = 0xFF232334;
	public static var mapRoomActive:FlxColor = 0xFF3A3A58;
	public static var accent:FlxColor = 0xFF7C6CF0;
	public static var textPrimary:FlxColor = 0xFFF0F0F5;
	public static var textSecondary:FlxColor = 0xFF9A9AB0;
	public static var powerOk:FlxColor = 0xFF6CD08C;
	public static var powerLow:FlxColor = 0xFFE0B055;
	public static var danger:FlxColor = 0xFFE05555;
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
