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

- The office is wider than the screen. Move the mouse to a screen edge or press A / D to look around.
- Each side has a door button and a light button. Closed doors block attacks. Lights reveal who is outside.
- Space or the bottom strip opens the cameras. Click a room or press 1-6 to switch.
- Everything you turn on drains power faster. At 0% the doors open and the night usually ends badly.
- Survive until 6 AM.

## Make your own game

Everything about the gameplay lives in `nightshift.json`: rooms, characters, movement graphs, night difficulty, power drain. Edit it and restart. A broken file shows a readable error screen instead of a crash.

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

The AI uses the classic movement model. Every `moveIntervalSeconds` the character rolls 1-20. A roll at or below its AI level moves it one room along its graph. From `attackRoom` a successful roll puts it at your door. If the door is closed when the wait ends, it retreats. If not, jumpscare.

Replacing the art: drop PNG files at the paths in `source/nightshift/ui/Theme.hx` and at each room and character `image` path in the config. Missing images fall back to generated rectangles. Audio works the same way with wav files, and missing audio is silent.

The states in `source/nightshift/states/` are plain FlxState classes. Extend or replace them for real menus, cutscenes, and jumpscare animations.

## Verify the balance

`tools/probe` simulates whole nights headless in milliseconds, with no window and no waiting. Use it to test your config after tuning.

```
cd tools/probe
haxe run.hxml -- night=5 seed=123 policy=reactive log=moves
```

- `policy=open` touches nothing all night.
- `policy=doors` holds both doors closed from the start.
- `policy=reactive` closes a door only while someone is at it, which is near optimal play.

The demo config passes these checks:

- Night 1 with `open`, seeds 1 to 10: all survive.
- Night 5 with `open`, seeds 1 to 10: all caught.
- Night 1 with `doors`: power runs out near 5 AM, then caught.
- Night 5 with `reactive`, seeds 1 to 10: all survive with 6 to 17 percent power left.
- The same seed always produces the same night. Run the launcher with `--seed=123` to reproduce a probe run in game.

For fast in-game testing, raise `Theme.timeScale` to compress a night into a minute.

## License

MIT. See [LICENSE](LICENSE).
