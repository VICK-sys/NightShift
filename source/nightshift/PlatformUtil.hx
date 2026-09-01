package nightshift;

import haxe.io.Path;
import sys.FileSystem;

class PlatformUtil
{
	public static function applicationDir():String
	{
		var dir = Path.directory(Sys.programPath());
		#if mac
		var resources = Path.join([dir, "..", "Resources"]);
		if (FileSystem.exists(resources))
		{
			dir = resources;
		}
		#end
		return Path.addTrailingSlash(FileSystem.fullPath(dir));
	}
}
