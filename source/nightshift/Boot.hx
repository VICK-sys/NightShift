package nightshift;

class Boot
{
	public static function resetWorkingDir():Void
	{
		Sys.setCwd(PlatformUtil.applicationDir());
	}
}
