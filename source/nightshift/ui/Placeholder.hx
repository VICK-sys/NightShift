package nightshift.ui;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Placeholder
{
	public static function sprite(path:String, width:Int, height:Int, color:FlxColor, label:String = ""):FlxSprite
	{
		var result = new FlxSprite();
		var graphic = ImageCache.get(path);
		if (graphic != null)
		{
			result.loadGraphic(graphic);
			result.setGraphicSize(width, height);
			result.updateHitbox();
			return result;
		}
		result.makeGraphic(width, height, color);
		if (label != "")
		{
			var text = new FlxText(0, 0, width, label, Theme.bodySize);
			text.color = Theme.textSecondary;
			text.alignment = CENTER;
			result.stamp(text, 0, Std.int(height / 2 - text.height / 2));
		}
		return result;
	}

	public static function parseColor(hex:String, fallback:FlxColor):FlxColor
	{
		if (hex == null || hex == "")
		{
			return fallback;
		}
		var parsed = FlxColor.fromString(hex);
		return parsed != null ? parsed : fallback;
	}
}
