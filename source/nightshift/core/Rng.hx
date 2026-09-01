package nightshift.core;

class Rng
{
	static inline var MODULUS:Float = 2147483647;
	static inline var MULTIPLIER:Float = 16807;

	public var initialSeed(default, null):Int;

	var state:Float;

	public function new(?seed:Int)
	{
		var s = seed != null ? seed : Std.random(2147483646) + 1;
		s = s % 2147483646;
		if (s <= 0)
		{
			s += 2147483646;
		}
		initialSeed = s;
		state = s;
	}

	function next():Float
	{
		state = (state * MULTIPLIER) % MODULUS;
		return state;
	}

	public function float(min:Float, max:Float):Float
	{
		return min + (next() / MODULUS) * (max - min);
	}

	public function int(min:Int, max:Int):Int
	{
		return min + Std.int((next() / MODULUS) * (max - min + 1));
	}

	public function pick<T>(items:Array<T>):T
	{
		return items[int(0, items.length - 1)];
	}
}
