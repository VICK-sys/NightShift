import nightshift.core.CharacterAgent;
import nightshift.core.NightEngine;
import nightshift.core.NightEvent;
import nightshift.core.Rng;
import nightshift.data.ConfigLoader;

class Probe
{
	static var logMoves = false;
	static var logRolls = false;

	static function main()
	{
		var configPath = "../../nightshift.json";
		var night = 1;
		var seed:Null<Int> = null;
		var policy = "open";
		var step = 0.05;
		for (arg in Sys.args())
		{
			var parts = arg.split("=");
			if (parts.length != 2)
			{
				continue;
			}
			switch (parts[0])
			{
				case "config": configPath = parts[1];
				case "night": night = Std.parseInt(parts[1]);
				case "seed": seed = Std.parseInt(parts[1]);
				case "policy": policy = parts[1];
				case "step": step = Std.parseFloat(parts[1]);
				case "log":
					logMoves = parts[1] == "moves" || parts[1] == "rolls";
					logRolls = parts[1] == "rolls";
			}
		}
		var result = ConfigLoader.load(configPath);
		for (issue in result.issues)
		{
			Sys.println((issue.fatal ? "error: " : "warning: ") + issue.message);
		}
		if (result.hasFatal() || result.config == null)
		{
			Sys.exit(1);
		}
		var config = result.config;
		if (night < 1 || night > config.nights.length)
		{
			Sys.println('error: night ${night} does not exist');
			Sys.exit(1);
		}
		var rng = new Rng(seed);
		var engine = new NightEngine(config, night - 1, rng);
		Sys.println('night=${night} seed=${rng.initialSeed} policy=${policy} step=${step}');
		if (policy == "doors")
		{
			engine.toggleDoor("left");
			engine.toggleDoor("right");
		}
		var guard = Std.int(engine.clock.durationSeconds / step) + 200;
		while (engine.outcome == InProgress && guard-- > 0)
		{
			if (policy == "reactive")
			{
				applyReactive(engine);
			}
			engine.update(step);
			for (event in engine.drainEvents())
			{
				report(engine, event);
			}
		}
		var powerText = Math.round(engine.power.power * 10) / 10;
		Sys.println('outcome=${engine.outcome} time=${stamp(engine.clock.elapsed)} power=${powerText} seed=${rng.initialSeed}');
	}

	static function applyReactive(engine:NightEngine):Void
	{
		if (engine.outageActive)
		{
			return;
		}
		for (side in ["left", "right"])
		{
			var threat = false;
			for (agent in engine.agents)
			{
				if (agent.atDoor && agent.config.attackSide == side)
				{
					threat = true;
				}
			}
			if (threat != engine.doorClosed(side))
			{
				engine.toggleDoor(side);
			}
		}
	}

	static function report(engine:NightEngine, event:NightEvent):Void
	{
		var line = switch (event)
		{
			case Moved(id, from, to):
				logMoves ? '${id} moved ${from} -> ${to}' : null;
			case RollFailed(id, roll, level):
				logRolls ? '${id} rolled ${roll} vs ${level}' : null;
			case AtDoor(id, side):
				'${id} at ${side} door';
			case Retreated(id):
				'${id} retreated';
			case DoorDenied(side):
				'${side} door denied';
			case HourReached(hour):
				'hour ${hour} power=${Math.round(engine.power.power * 10) / 10} usage=${engine.usage()}';
			case OutageStarted:
				'outage started';
			case Killed(id):
				'killed by ${id}';
			case Won:
				'won';
		}
		if (line != null)
		{
			Sys.println(stamp(engine.clock.elapsed) + " " + line);
		}
	}

	static function stamp(t:Float):String
	{
		var total = Std.int(t);
		var minutes = Std.int(total / 60);
		var seconds = total % 60;
		return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
	}
}
