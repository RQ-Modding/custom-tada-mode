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

The multiplier is on the mod's page in Config's **Mods** tab: **Custom TADA Mode**, a number from 1
to 100 (the game's own is 2).

- Change it with **-** and **+** (Shift for 10 at a time), the mouse wheel over it, or a click on the
  number to type it, then Enter (Esc puts the old number back).
- It counts from the next fight; no restart.
- `1` makes TADA mode give the same as Classic mode.
- **Reset** puts back 2.
- The page also says whether TADA mode is on in the loaded save.

The number is kept for every save. Version 1.0.0's `config.ini` is read once, on the first start of
1.1.0, so your number carries over; the file is no longer used after that and can be deleted.

Only whole numbers are possible: the game multiplies whole numbers by a whole number in its own
code, and the mod changes that number.
## Saves

Only what you earn: gold, EXP and familiar growth stay in the save as usual.

## Install

Needs [RQ MOD](https://github.com/RQ-Modding/RQ-Mod) with loader **2.35.0** or newer. Extract the
release zip into the game's `mods` folder, so that you have `mods/custom-tada-mode/mod.json`.

## How it works

| Reward | Game code |
| --- | --- |
| Battle gold | `◆取得金額 * 2` in `Ｔ戦闘後の取得経験値算出` |
| Battle EXP | `bexp * 2` in the same function |
| Familiar growth | `ra *= 2` in `Ｔ戦闘前初期化` |

Each 2 is found as the first 2 after the game reads `◆２倍モード`, with `rq.ain.patch_int_after`, so
it does not depend on how many other 2s the function has. The mod finds the three places once, at
start, from the game's 2; a change on the page writes the new number into them with
`rq.ain.set_code_int`, so the `1` of `if (◆２倍モード == 1)` is never taken for the multiplier. If one
of the three is not found, the page says which and its number is greyed.

## License

MIT, see [LICENSE](LICENSE).
