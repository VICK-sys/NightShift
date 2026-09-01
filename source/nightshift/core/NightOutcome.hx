package nightshift.core;

enum NightOutcome
{
	InProgress;
	Win;
	Killed(characterId:String);
}
