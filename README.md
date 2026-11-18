# Custom TADA Mode

Sets how many times **TADA mode** multiplies rewards: battle gold, battle EXP and familiar growth,
each with its own number. The game's own value is 2 for all three.

## Showcase

<img width="1270" height="910" alt="image" src="https://github.com/user-attachments/assets/5360c345-98f6-4cb8-8e3a-76af0d0cfc8f" />

## What it changes

While TADA mode is on, each of these uses its own multiplier instead of 2:

- battle gold,
- battle EXP (before the party size and quest bonuses),
- familiar growth per fight.

TADA mode itself is still chosen in the game, as before. The game's texts that call TADA mode
"double" are not changed.

## Keys and settings

The multipliers are on the mod's page in Config's **Mods** tab: **Custom TADA Mode**, three numbers
from 1 to 100 (the game's own is 2 for each): **Battle gold**, **Battle EXP** and **Familiar growth**.

- Change one with **-** and **+** (Shift for 10 at a time), the mouse wheel over it, or a click on the
  number to type it, then Enter (Esc puts the old number back).
- A change counts from the next fight; no restart.
- `1` makes that reward the same as in Classic mode.
- **Reset** puts back 2 for all three.
- The page also says whether TADA mode is on in the loaded save.

The numbers are kept for every save. Version 1.1 had one number for the three: the first start of
1.2.0 gives it to each. Version 1.0.0's `config.ini` is read once if neither is there; the file is
no longer used after that and can be deleted.

Only whole numbers are possible: the game multiplies whole numbers by a whole number in its own
code, and the mod changes that number.
## Saves

Only what you earn: gold, EXP and familiar growth stay in the save as usual.

## Install

Needs [RQ MOD](https://github.com/RQ-Modding/RQ-Mod) with loader **2.36.0** or newer. Extract the
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
`rq.ain.set_code_int`, so the `1` of `if (◆２倍モード == 1)` is never taken for a multiplier. If one
of the three is not found, the page says which and only its number is greyed.

## License

MIT, see [LICENSE](LICENSE).
