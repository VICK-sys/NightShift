# NightShift

A framework for FNAF-style fan games, built with HaxeFlixel. It ships the full survival loop: an office with doors and lights, a camera panel, a power system, and animatronic AI driven by one JSON file. All graphics are generated placeholders, so the game runs before you add a single asset.

NightShift contains no assets, names, or characters from Five Nights at Freddy's. You bring your own.

## Setup

You need [Haxe](https://haxe.org) 4.3 or newer and [hmm](https://github.com/andywhite37/hmm).

```
haxelib newrepo
hmm install
haxelib run lime test windows
```

The demo has two placeholder animatronics and five nights. Night 1 is calm. Night 5 is not.

## How to play

- Move the mouse to a screen edge or press A / D to look around the office.
- Closed doors block attacks. Lights reveal who is outside.
- Space opens the cameras. Click a room or press 1-6 to switch.
- Everything you turn on drains power faster. At 0% the doors open.
- Survive until 6 AM.

## Make your own game

All gameplay lives in `nightshift.json`: rooms, characters, movement graphs, night difficulty, power drain. Edit it and restart. A broken file shows a readable error screen instead of a crash.

Character fields:

| Field | Purpose |
| --- | --- |
| `startRoom` | Room where the night begins |
| `moves` | Movement graph, `from` one room `to` a list of rooms |
| `attackSide` | `left` or `right` office door |
| `attackRoom` | Room the character attacks from |
| `retreatRoom` | Room the character returns to after a blocked attack |
| `aiLevels` | Aggression 0 to 20, one value per night |
| `moveIntervalSeconds` | Seconds between movement rolls |
| `waitAtDoorSeconds` | Time at the door before the attack resolves |

The AI uses the classic movement model. Every `moveIntervalSeconds` the character rolls 1-20. A roll at or below its AI level moves it one room. From `attackRoom` a successful roll puts it at your door. Closed door means retreat. Open door means jumpscare.

To replace the art, drop PNG files at the paths in `source/nightshift/ui/Theme.hx` and at the `image` paths in the config. Audio works the same way with wav files. Missing files fall back to placeholders, silently.

The states in `source/nightshift/states/` are plain FlxState classes. Extend or replace them for real menus, cutscenes, and jumpscare animations.

## Test your balance

`tools/probe` simulates whole nights in milliseconds, no window needed:

```
cd tools/probe
haxe run.hxml -- night=5 seed=123 policy=reactive
```

Policies: `open` touches nothing, `doors` camps both doors, `reactive` closes a door only when someone is at it. The same seed always produces the same night, and `--seed=123` on the game reproduces it in play. For fast in-game testing, raise `Theme.timeScale`.

## License

MIT. See [LICENSE](LICENSE).
