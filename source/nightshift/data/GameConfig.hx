package nightshift.data;

typedef GameConfig =
{
	@:default("NightShift") @:optional var title:String;
	@:default(1920) @:optional var officeWidth:Int;
	@:default([]) @:optional var rooms:Array<RoomConfig>;
	@:default([]) @:optional var characters:Array<CharacterConfig>;
	@:default([]) @:optional var nights:Array<NightConfig>;
	@:default(5.0) @:optional var outageMinSeconds:Float;
	@:default(20.0) @:optional var outageMaxSeconds:Float;
	@:default("") @:optional var outageAttackerId:String;
}

typedef RoomConfig =
{
	var id:String;
	var name:String;
	@:default(true) @:optional var camera:Bool;
	@:default(-1) @:optional var mapX:Int;
	@:default(-1) @:optional var mapY:Int;
	@:default("") @:optional var image:String;
}

typedef CharacterConfig =
{
	var id:String;
	var name:String;
	var startRoom:String;
	var attackSide:String;
	var attackRoom:String;
	var retreatRoom:String;
	var aiLevels:Array<Int>;
	var moves:Array<MoveConfig>;
	@:default(5.0) @:optional var moveIntervalSeconds:Float;
	@:default(8.0) @:optional var waitAtDoorSeconds:Float;
	@:default("") @:optional var color:String;
	@:default("") @:optional var image:String;
}

typedef MoveConfig =
{
	var from:String;
	var to:Array<String>;
}

typedef NightConfig =
{
	var number:Int;
	@:default(480.0) @:optional var durationSeconds:Float;
	@:default(100.0) @:optional var startingPower:Float;
	@:default([0.10, 0.21, 0.33, 0.46, 0.60, 0.75]) @:optional var usageDrainPerSecond:Array<Float>;
}
