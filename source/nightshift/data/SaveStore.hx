package nightshift.data;

import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

class SaveStore
{
	public var highestClearedNight:Int = 0;

	static inline var DIR = "save";

	public function new()
	{
		var path = filePath();
		if (FileSystem.exists(path))
		{
			var data = try Json.parse(File.getContent(path)) catch (e:Dynamic) null;
			if (data != null)
			{
				var cleared = Reflect.field(data, "highestClearedNight");
				if (cleared != null && Std.isOfType(cleared, Int) && cleared > 0)
				{
					highestClearedNight = cleared;
				}
			}
		}
	}

	public function markCleared(night:Int):Void
	{
		if (night <= highestClearedNight)
		{
			return;
		}
		highestClearedNight = night;
		save();
	}

	function save():Void
	{
		try
		{
			if (!FileSystem.exists(DIR))
			{
				FileSystem.createDirectory(DIR);
			}
			var path = filePath();
			var tmp = path + ".tmp";
			File.saveContent(tmp, Json.stringify({highestClearedNight: highestClearedNight}, null, "\t"));
			if (FileSystem.exists(path))
			{
				FileSystem.deleteFile(path);
			}
			FileSystem.rename(tmp, path);
		}
		catch (e:Dynamic) {}
	}

	function filePath():String
	{
		return Path.join([DIR, "progress.json"]);
	}
}
