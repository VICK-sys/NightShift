package;

import flixel.FlxG;
import flixel.FlxGame;
import nightshift.Boot;
import nightshift.states.InitState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Boot.resetWorkingDir();
		nightshift.data.GameRuntime.readArgs();
		addChild(new FlxGame(1280, 720, () -> new InitState(), 60, 60, true));
		FlxG.autoPause = false;
		FlxG.fixedTimestep = false;
		FlxG.signals.focusLost.add(() -> FlxG.keys.reset());
	}
}
