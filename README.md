# Custom TADA Mode

Sets how many times **TADA mode** multiplies rewards. The game's own value is 2. Needs loader **1.3.0**.

## Setting it

Open `config.ini` in this folder and change the number:

```ini
multiplier = 3
```

- Use a whole number from 1 to 100. `1` makes TADA mode give the same as Classic mode.
- The game reads the file when it starts, so restart it after a change.
- It only matters while TADA mode is on. TADA mode itself is still chosen in the game, as before.
- A value the mod cannot use (a decimal such as `1.5`, a word, an empty value, a missing line or file) shows a warning at the top of the screen for 15 seconds at start, and the game's 2 is used. The warning also goes to `logs\rqmod.log`.

## What it changes

Everything TADA mode multiplies:

| Reward | Game code |
| --- | --- |
| Battle gold | `◆取得金額 * 2` in `Ｔ戦闘後の取得経験値算出` |
| Battle EXP | `bexp * 2` in the same function, before the party size and quest bonuses |
| Familiar growth per fight | `ra *= 2` in `Ｔ戦闘前初期化` |

The in-game texts that describe TADA mode as "double" are not changed.

Each 2 is found as the first 2 after the game reads `◆２倍モード`, with `rq.ain.patch_int_after`, so it does not depend on how many other 2s the function has. If one of the three is not found, the mod says so the same way as a bad value.

Only whole numbers are possible: the game multiplies these whole numbers by a whole number in its own code, and the mod changes that number.

Local-only git. No remote.
