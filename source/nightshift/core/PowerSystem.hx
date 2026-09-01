package nightshift.core;

class PowerSystem
{
	public var power(default, null):Float;
	public var usage(default, null):Int = 1;
	public var depleted(default, null):Bool = false;

	var drainTable:Array<Float>;

	public function new(startingPower:Float, drainTable:Array<Float>)
	{
		power = startingPower;
		this.drainTable = drainTable;
	}

	public function setUsage(usage:Int):Void
	{
		this.usage = usage;
	}

	public function drain(dt:Float):Bool
	{
		if (depleted)
		{
			return false;
		}
		var index = usage - 1;
		if (index < 0)
		{
			index = 0;
		}
		if (index >= drainTable.length)
		{
			index = drainTable.length - 1;
		}
		power -= drainTable[index] * dt;
		if (power <= 0)
		{
			power = 0;
			depleted = true;
			return true;
		}
		return false;
	}
}
