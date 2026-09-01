package nightshift.ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

class MouseUtil
{
	public static function hover(sprite:FlxSprite, camera:FlxCamera):Bool
	{
		return sprite.visible && FlxG.mouse.overlaps(sprite, camera);
	}

	public static function clicked(sprite:FlxSprite, camera:FlxCamera):Bool
	{
		return FlxG.mouse.justPressed && hover(sprite, camera);
	}
}
