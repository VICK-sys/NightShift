package nightshift.audio;

import flixel.FlxG;
import openfl.utils.Assets;

class Sfx
{
	public static function play(path:String):Void
	{
		if (path == "" || !Assets.exists(path))
		{
			return;
		}
		FlxG.sound.play(path);
	}
}
