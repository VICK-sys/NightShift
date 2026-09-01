package nightshift.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.text.FlxText;
import nightshift.data.ValidationIssue;
import nightshift.ui.Theme;

class ErrorState extends FlxState
{
	var issues:Array<ValidationIssue>;

	public function new(issues:Array<ValidationIssue>)
	{
		super();
		this.issues = issues;
	}

	override function create():Void
	{
		FlxG.cameras.bgColor = Theme.background;
		var title = new FlxText(40, 40, 1200, "nightshift.json has problems", Theme.titleSize);
		title.color = Theme.danger;
		add(title);
		var lines = [for (issue in issues) "- " + issue.message];
		var body = new FlxText(40, 110, 1200, lines.join("\n"), Theme.bodySize + 2);
		body.color = Theme.textPrimary;
		add(body);
		var footer = new FlxText(40, FlxG.height - 50, FlxG.width - 80, "Fix nightshift.json, then press R or Y to retry.", Theme.bodySize);
		footer.color = Theme.textSecondary;
		add(footer);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.R || FlxG.gamepads.anyJustPressed(FlxGamepadInputID.Y))
		{
			FlxG.switchState(() -> new InitState());
		}
	}
}
