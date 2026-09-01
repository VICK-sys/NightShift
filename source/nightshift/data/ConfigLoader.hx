package nightshift.data;

import json2object.Error;
import json2object.JsonParser;
import nightshift.data.GameConfig;
import sys.FileSystem;
import sys.io.File;

class LoadResult
{
	public var config:Null<GameConfig>;
	public var issues:Array<ValidationIssue>;

	public function new()
	{
		issues = [];
	}

	public function hasFatal():Bool
	{
		for (issue in issues)
		{
			if (issue.fatal)
			{
				return true;
			}
		}
		return false;
	}
}

class ConfigLoader
{
	public static inline var FILE_NAME = "nightshift.json";

	public static function load(path:String = FILE_NAME):LoadResult
	{
		var result = new LoadResult();
		if (!FileSystem.exists(path))
		{
			result.issues.push(new ValidationIssue(true, path + " was not found next to the executable"));
			return result;
		}
		var contents = try File.getContent(path) catch (e:Dynamic) null;
		if (contents == null)
		{
			result.issues.push(new ValidationIssue(true, path + " could not be read"));
			return result;
		}
		if (contents.length > 0 && StringTools.fastCodeAt(contents, 0) == 0xFEFF)
		{
			contents = contents.substr(1);
		}
		var parser = new JsonParser<GameConfig>();
		parser.fromJson(contents, path);
		for (error in parser.errors)
		{
			result.issues.push(new ValidationIssue(true, describeError(error, path)));
		}
		if (parser.value == null || result.hasFatal())
		{
			return result;
		}
		result.config = parser.value;
		validate(result);
		return result;
	}

	static function validate(result:LoadResult):Void
	{
		var config = result.config;
		var fatal = (message:String) -> result.issues.push(new ValidationIssue(true, message));
		var warn = (message:String) -> result.issues.push(new ValidationIssue(false, message));
		if (config.rooms.length == 0)
		{
			fatal("the config has no rooms");
			return;
		}
		if (config.nights.length == 0)
		{
			fatal("the config has no nights");
			return;
		}
		var roomIds = new Map<String, Bool>();
		for (room in config.rooms)
		{
			if (room.id == "")
			{
				fatal("a room has an empty id");
				continue;
			}
			if (roomIds.exists(room.id))
			{
				fatal('duplicate room id "${room.id}"');
			}
			roomIds.set(room.id, true);
			if (room.name == "")
			{
				fatal('room "${room.id}" has an empty name');
			}
		}
		var cameraCount = 0;
		for (room in config.rooms)
		{
			if (room.camera)
			{
				cameraCount++;
			}
		}
		if (cameraCount == 0)
		{
			warn("no room has a camera");
		}
		for (i in 0...config.nights.length)
		{
			var night = config.nights[i];
			if (night.number != i + 1)
			{
				fatal('night at position ${i + 1} has number ${night.number}, expected ${i + 1}');
			}
			if (night.durationSeconds <= 0)
			{
				fatal('night ${night.number} has a non-positive duration');
			}
			if (night.startingPower <= 0)
			{
				fatal('night ${night.number} has non-positive starting power');
			}
			if (night.usageDrainPerSecond.length == 0)
			{
				fatal('night ${night.number} has an empty usageDrainPerSecond table');
			}
			for (rate in night.usageDrainPerSecond)
			{
				if (rate < 0)
				{
					fatal('night ${night.number} has a negative drain rate');
					break;
				}
			}
		}
		var charIds = new Map<String, Bool>();
		for (character in config.characters)
		{
			if (character.id == "")
			{
				fatal("a character has an empty id");
				continue;
			}
			if (charIds.exists(character.id))
			{
				fatal('duplicate character id "${character.id}"');
			}
			charIds.set(character.id, true);
			var label = 'character "${character.id}"';
			if (character.name == "")
			{
				fatal('${label} has an empty name');
			}
			if (character.attackSide != "left" && character.attackSide != "right")
			{
				fatal('${label} has attackSide "${character.attackSide}", expected "left" or "right"');
			}
			for (roomRef in [character.startRoom, character.attackRoom, character.retreatRoom])
			{
				if (!roomIds.exists(roomRef))
				{
					fatal('${label} references unknown room "${roomRef}"');
				}
			}
			if (character.aiLevels.length != config.nights.length)
			{
				fatal('${label} has ${character.aiLevels.length} aiLevels, expected ${config.nights.length}');
			}
			for (level in character.aiLevels)
			{
				if (level < 0 || level > 20)
				{
					fatal('${label} has AI level ${level}, expected 0 to 20');
					break;
				}
			}
			if (character.moveIntervalSeconds <= 0)
			{
				fatal('${label} has a non-positive moveIntervalSeconds');
			}
			if (character.waitAtDoorSeconds < 0)
			{
				fatal('${label} has a negative waitAtDoorSeconds');
			}
			var fromSeen = new Map<String, Bool>();
			for (move in character.moves)
			{
				if (fromSeen.exists(move.from))
				{
					fatal('${label} has duplicate moves from "${move.from}"');
				}
				fromSeen.set(move.from, true);
				if (!roomIds.exists(move.from))
				{
					fatal('${label} has a move from unknown room "${move.from}"');
				}
				for (to in move.to)
				{
					if (!roomIds.exists(to))
					{
						fatal('${label} has a move to unknown room "${to}"');
					}
				}
			}
			if (!result.hasFatal() && !reaches(character))
			{
				warn('${label} cannot reach "${character.attackRoom}" from "${character.startRoom}"');
			}
		}
		if (config.outageAttackerId != "" && !charIds.exists(config.outageAttackerId))
		{
			fatal('outageAttackerId references unknown character "${config.outageAttackerId}"');
		}
		if (config.outageMinSeconds < 0 || config.outageMinSeconds > config.outageMaxSeconds)
		{
			fatal("outageMinSeconds must be between 0 and outageMaxSeconds");
		}
	}

	static function reaches(character:CharacterConfig):Bool
	{
		var moves = [for (move in character.moves) move.from => move.to];
		var visited = new Map<String, Bool>();
		var frontier = [character.startRoom];
		while (frontier.length > 0)
		{
			var room = frontier.pop();
			if (room == character.attackRoom)
			{
				return true;
			}
			if (visited.exists(room))
			{
				continue;
			}
			visited.set(room, true);
			var next = moves.get(room);
			if (next != null)
			{
				for (to in next)
				{
					frontier.push(to);
				}
			}
		}
		return false;
	}

	static function describeError(error:Error, path:String):String
	{
		return switch (error)
		{
			case IncorrectType(variable, expected, pos):
				'${posText(pos, path)}: field "${variable}" should be ${expected}';
			case IncorrectEnumValue(value, expected, pos):
				'${posText(pos, path)}: value "${value}" is not valid, expected ${expected}';
			case InvalidEnumConstructor(value, expected, pos):
				'${posText(pos, path)}: constructor "${value}" is not valid, expected ${expected}';
			case UninitializedVariable(variable, pos):
				'${posText(pos, path)}: required field "${variable}" is missing';
			case UnknownVariable(variable, pos):
				'${posText(pos, path)}: unknown field "${variable}"';
			case ParserError(message, pos):
				'${posText(pos, path)}: ${message}';
			case CustomFunctionException(e, pos):
				'${posText(pos, path)}: ${Std.string(e)}';
		}
	}

	static function posText(pos:json2object.Position, path:String):String
	{
		if (pos == null || pos.lines == null || pos.lines.length == 0)
		{
			return path;
		}
		return path + " line " + pos.lines[0].number;
	}
}
