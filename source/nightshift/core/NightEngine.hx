package nightshift.core;

import nightshift.data.GameConfig;

class TimedEvent
{
	public var t(default, null):Float;
	public var e(default, null):NightEvent;

	public function new(t:Float, e:NightEvent)
	{
		this.t = t;
		this.e = e;
	}
}

class NightEngine
{
	public var outcome(default, null):NightOutcome = InProgress;
	public var clock(default, null):NightClock;
	public var power(default, null):PowerSystem;
	public var agents(default, null):Array<CharacterAgent>;
	public var doorLeft(default, null):Bool = false;
	public var doorRight(default, null):Bool = false;
	public var lightLeft(default, null):Bool = false;
	public var lightRight(default, null):Bool = false;
	public var cameraUp(default, null):Bool = false;
	public var outageActive(default, null):Bool = false;
	public var log(default, null):Array<TimedEvent> = [];

	var rng:Rng;
	var config:GameConfig;
	var night:NightConfig;
	var outageTimer:Float = 0;
	var queue:Array<NightEvent> = [];

	public function new(config:GameConfig, nightIndex:Int, rng:Rng)
	{
		this.config = config;
		this.rng = rng;
		night = config.nights[nightIndex];
		clock = new NightClock(night.durationSeconds);
		power = new PowerSystem(night.startingPower, night.usageDrainPerSecond);
		agents = [for (c in config.characters) new CharacterAgent(c, c.aiLevels[nightIndex])];
	}

	public function update(dt:Float):Void
	{
		if (outcome != InProgress)
		{
			return;
		}
		for (hour in clock.advance(dt))
		{
			emit(HourReached(hour));
		}
		if (clock.done)
		{
			outcome = Win;
			emit(Won);
			return;
		}
		if (outageActive)
		{
			outageTimer -= dt;
			if (outageTimer <= 0)
			{
				kill(outageAttackerId());
			}
			return;
		}
		power.setUsage(usage());
		if (power.drain(dt))
		{
			beginOutage();
			return;
		}
		for (agent in agents)
		{
			stepAgent(agent, dt);
			if (outcome != InProgress)
			{
				return;
			}
		}
	}

	function stepAgent(agent:CharacterAgent, dt:Float):Void
	{
		if (agent.level <= 0)
		{
			return;
		}
		if (agent.atDoor)
		{
			agent.doorWait += dt;
			if (agent.doorWait >= agent.config.waitAtDoorSeconds)
			{
				if (doorClosed(agent.config.attackSide))
				{
					agent.reset();
					emit(Retreated(agent.config.id));
				}
				else
				{
					kill(agent.config.id);
				}
			}
			return;
		}
		agent.moveTimer += dt;
		while (agent.moveTimer >= agent.config.moveIntervalSeconds && !agent.atDoor)
		{
			agent.moveTimer -= agent.config.moveIntervalSeconds;
			var roll = rng.int(1, 20);
			if (roll > agent.level)
			{
				emit(RollFailed(agent.config.id, roll, agent.level));
				continue;
			}
			if (agent.room == agent.config.attackRoom)
			{
				agent.atDoor = true;
				agent.doorWait = 0;
				emit(AtDoor(agent.config.id, agent.config.attackSide));
				continue;
			}
			var options = agent.destinations();
			if (options.length == 0)
			{
				continue;
			}
			var to = rng.pick(options);
			emit(Moved(agent.config.id, agent.room, to));
			agent.room = to;
		}
	}

	public function toggleDoor(side:String):Void
	{
		if (outageActive || outcome != InProgress)
		{
			emit(DoorDenied(side));
			return;
		}
		if (side == "left")
		{
			doorLeft = !doorLeft;
		}
		else
		{
			doorRight = !doorRight;
		}
	}

	public function toggleLight(side:String):Void
	{
		if (outageActive || cameraUp || outcome != InProgress)
		{
			return;
		}
		if (side == "left")
		{
			lightLeft = !lightLeft;
			lightRight = false;
		}
		else
		{
			lightRight = !lightRight;
			lightLeft = false;
		}
	}

	public function setCameraUp(up:Bool):Void
	{
		if (outageActive || outcome != InProgress)
		{
			return;
		}
		cameraUp = up;
		if (up)
		{
			lightLeft = false;
			lightRight = false;
		}
	}

	public function usage():Int
	{
		var total = 1;
		if (doorLeft) total++;
		if (doorRight) total++;
		if (lightLeft) total++;
		if (lightRight) total++;
		if (cameraUp) total++;
		return total;
	}

	public function doorClosed(side:String):Bool
	{
		return side == "left" ? doorLeft : doorRight;
	}

	public function occupants(roomId:String):Array<CharacterAgent>
	{
		return [for (agent in agents) if (!agent.atDoor && agent.room == roomId) agent];
	}

	public function lightReveals(side:String):Array<CharacterAgent>
	{
		return [
			for (agent in agents)
				if (agent.config.attackSide == side && (agent.atDoor || agent.room == agent.config.attackRoom))
					agent
		];
	}

	public function drainEvents():Array<NightEvent>
	{
		var drained = queue;
		queue = [];
		return drained;
	}

	function beginOutage():Void
	{
		outageActive = true;
		doorLeft = false;
		doorRight = false;
		lightLeft = false;
		lightRight = false;
		cameraUp = false;
		outageTimer = rng.float(config.outageMinSeconds, config.outageMaxSeconds);
		emit(OutageStarted);
	}

	function outageAttackerId():String
	{
		if (config.outageAttackerId != "")
		{
			return config.outageAttackerId;
		}
		return config.characters.length > 0 ? config.characters[0].id : "";
	}

	function kill(id:String):Void
	{
		outcome = Killed(id);
		emit(NightEvent.Killed(id));
	}

	function emit(event:NightEvent):Void
	{
		log.push(new TimedEvent(clock.elapsed, event));
		queue.push(event);
	}
}
