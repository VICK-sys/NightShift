package nightshift.core;

class NightClock
{
	public var elapsed(default, null):Float = 0;
	public var durationSeconds(default, null):Float;
	public var hour(default, null):Int = 0;
	public var done(default, null):Bool = false;

	public function new(durationSeconds:Float)
	{
		this.durationSeconds = durationSeconds;
	}

	public function advance(dt:Float):Array<Int>
	{
		if (done)
		{
			return [];
		}
		elapsed += dt;
		var reached = [];
		var target = Std.int(Math.min(6, elapsed / (durationSeconds / 6)));
		while (hour < target)
		{
			hour++;
			reached.push(hour);
		}
		if (elapsed >= durationSeconds)
		{
			done = true;
		}
		return reached;
	}

	public function label():String
	{
		return hour == 0 ? "12 AM" : hour + " AM";
	}
}
