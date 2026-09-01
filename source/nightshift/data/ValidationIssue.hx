package nightshift.data;

class ValidationIssue
{
	public var fatal(default, null):Bool;
	public var message(default, null):String;

	public function new(fatal:Bool, message:String)
	{
		this.fatal = fatal;
		this.message = message;
	}
}
