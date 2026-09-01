package nightshift.core;

enum NightEvent
{
	Moved(id:String, from:String, to:String);
	RollFailed(id:String, roll:Int, level:Int);
	AtDoor(id:String, side:String);
	Retreated(id:String);
	DoorDenied(side:String);
	HourReached(hour:Int);
	OutageStarted;
	Killed(id:String);
	Won;
}
