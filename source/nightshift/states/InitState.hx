package nightshift.states;

import flixel.FlxG;
import flixel.FlxState;
import lime.app.Application;
import nightshift.data.ConfigLoader;
import nightshift.data.GameRuntime;
import nightshift.ui.Theme;

class InitState extends FlxState
{
	override function create():Void
	{
		FlxG.cameras.bgColor = Theme.background;
		var result = ConfigLoader.load();
		for (issue in result.issues)
		{
			if (!issue.fatal)
			{
				Sys.println("warning: " + issue.message);
			}
		}
		if (result.hasFatal() || result.config == null)
		{
			FlxG.switchState(() -> new ErrorState(result.issues));
			return;
		}
		GameRuntime.setup(result);
		Application.current.window.title = GameRuntime.config.title;
		FlxG.switchState(() -> new MenuState());
	}
}
