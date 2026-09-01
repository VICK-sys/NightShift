package nightshift.input;

class RepeatGate
{
	var delay:Float;
	var interval:Float;
	var held:Float = 0;
	var wasPressed:Bool = false;

	public function new(delay:Float, interval:Float)
	{
		this.delay = delay;
		this.interval = interval;
	}

	public function poll(pressed:Bool, elapsed:Float):Bool
	{
		if (!pressed)
		{
			wasPressed = false;
			held = 0;
			return false;
		}
		if (!wasPressed)
		{
			wasPressed = true;
			held = 0;
			return true;
		}
		held += elapsed;
		if (held >= delay)
		{
			held -= interval;
			return true;
		}
		return false;
	}
}
