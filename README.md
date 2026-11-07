# Custom TADA Mode

Sets how many times **TADA mode** multiplies rewards. The game's own value is 2.

## What it changes

While TADA mode is on, these use your multiplier instead of 2:

- battle gold,
- battle EXP (before the party size and quest bonuses),
- familiar growth per fight.

TADA mode itself is still chosen in the game, as before. The game's texts that call TADA mode
"double" are not changed.

## Keys and settings

Open `config.ini` in the mod's folder and change the number:

```ini
multiplier = 3
```

- Use a whole number from 1 to 100. `1` makes TADA mode give the same as Classic mode.
- The game reads the file when it starts, so restart it after a change.
- A value the mod cannot use (a decimal such as `1.5`, a word, an empty value, a missing line or
  file) shows a warning at the top of the screen for 15 seconds at start, and the game's 2 is used.
  The warning also goes to `logs\rqmod.log`.

Only whole numbers are possible: the game multiplies whole numbers by a whole number in its own
code, and the mod changes that number.

## Saves

Only what you earn: gold, EXP and familiar growth stay in the save as usual.

## Install

Needs [RQ MOD](https://github.com/RQ-Modding/RQ-Mod) with loader **1.3.0** or newer. Extract the
release zip into the game's `mods` folder, so that you have `mods/custom-tada-mode/mod.json`. An
update replaces `config.ini`, so note your number first.

## How it works

| Reward | Game code |
| --- | --- |
| Battle gold | `◆取得金額 * 2` in `Ｔ戦闘後の取得経験値算出` |
| Battle EXP | `bexp * 2` in the same function |
| Familiar growth | `ra *= 2` in `Ｔ戦闘前初期化` |

Each 2 is found as the first 2 after the game reads `◆２倍モード`, with `rq.ain.patch_int_after`, so
it does not depend on how many other 2s the function has. If one of the three is not found, the mod
warns the same way as for a bad value.

## License

MIT, see [LICENSE](LICENSE).
