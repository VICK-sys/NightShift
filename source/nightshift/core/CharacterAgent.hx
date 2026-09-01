package nightshift.core;

import nightshift.data.GameConfig;

class CharacterAgent
{
	public var config(default, null):CharacterConfig;
	public var level(default, null):Int;
	public var room:String;
	public var atDoor:Bool = false;
	public var moveTimer:Float = 0;
	public var doorWait:Float = 0;

	var moves:Map<String, Array<String>>;

	public function new(config:CharacterConfig, level:Int)
	{
		this.config = config;
		this.level = level;
		room = config.startRoom;
		moves = [for (move in config.moves) move.from => move.to];
	}

	public function destinations():Array<String>
	{
		var found = moves.get(room);
		return found != null ? found : [];
	}

	public function reset():Void
	{
		room = config.retreatRoom;
		atDoor = false;
		moveTimer = 0;
		doorWait = 0;
	}
}
