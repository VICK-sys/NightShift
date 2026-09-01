package nightshift.ui;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import sys.FileSystem;

class ImageCache
{
	static var cache:Map<String, FlxGraphic> = [];

	public static function get(path:String):Null<FlxGraphic>
	{
		if (path == null || path == "")
		{
			return null;
		}
		var abs = FileSystem.absolutePath(path);
		if (cache.exists(abs))
		{
			return cache.get(abs);
		}
		if (!FileSystem.exists(abs))
		{
			cache.set(abs, null);
			return null;
		}
		var bitmap = try BitmapData.fromFile(abs) catch (e:Dynamic) null;
		if (bitmap == null)
		{
			cache.set(abs, null);
			return null;
		}
		var graphic = FlxGraphic.fromBitmapData(bitmap, false, abs);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		cache.set(abs, graphic);
		return graphic;
	}
}
