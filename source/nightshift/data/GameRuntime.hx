package nightshift.data;

import nightshift.data.ConfigLoader.LoadResult;
import nightshift.data.GameConfig;

class GameRuntime
{
	public static var config:GameConfig;
	public static var save:SaveStore;
	public static var currentNight:Int = 1;
	public static var forcedSeed:Null<Int> = null;

	static inline var SEED_PREFIX = "--seed=";

	public static function readArgs():Void
	{
		for (arg in Sys.args())
		{
			if (StringTools.startsWith(arg, SEED_PREFIX))
			{
				var parsed = Std.parseInt(arg.substr(SEED_PREFIX.length));
				if (parsed != null)
				{
					forcedSeed = parsed;
				}
			}
		}
	}

	public static function setup(result:LoadResult):Void
	{
		config = result.config;
		if (save == null)
		{
			save = new SaveStore();
		}
	}

	public static function nightIndex():Int
	{
		return currentNight - 1;
	}

	public static function nightConfig():NightConfig
	{
		return config.nights[nightIndex()];
	}

	public static function nightCount():Int
	{
		return config.nights.length;
	}
}
