# Testing Custom TADA Mode

For people and agents who test the mod in the game. Check `logs\rqmod.log` for
`Loading custom-tada-mode` first.

## What it adds

A page in Config's Mods tab, **Custom TADA Mode**, with three number fields and a Reset button (built
with `rq.config.settings`, loader 2.35.0). In `rqmod-ctl ui`, on that page:

| Control | What it is |
| --- | --- |
| `stepper-gold`, `stepper-exp`, `stepper-familiar` | The multipliers of battle gold, battle EXP and familiar growth; each `value` is the number, `selected` while it is typed into. |
| `button-gold-dec`, `button-gold-inc` (and `exp`, `familiar`) | - and +. |
| `button-reset` | Puts back 2 for all three. Not there when none of the game's places was found. |

Type a number: `press stepper-gold`, then `type 5` and `key enter` (`key esc` puts the old one
back). No other `rq.agent.control` ids. Do not invent controls.

## How to check it

1. At start the log says `Custom TADA Mode: TADA mode multiplies battle gold Nx, battle EXP Nx,
   familiar growth Nx`.
2. On the page, set Battle gold to 5: the log says `battle gold 5x`. With TADA mode on, win a fight:
   the gold is 5/2 of what the same fight gives with 2, and the EXP is as its own field says. No
   restart.
3. Set 1, then 2 again: the log says each, and TADA mode still applies (the game's `== 1` check is
   untouched).
4. Put them back to 2 afterwards; the numbers are kept for every save (`rq.store.global`, keys `gold`,
   `exp` and `familiar`).

## Forcing it for a test

`rq.mod.get("custom-tada-mode")` returns `multiplier(what)` (`"gold"`, `"exp"` or `"familiar"`;
the gold's with none), `multipliers()`, `set(n)` for all three or `set(what, n)` for one (as the
page), and `places()`, the three numbers now in the game's code (battle gold, battle EXP, familiar
growth).

## Tested in the game

The Test Lab's scenario `config-pages`: the page, the three fields, a set through `rqmod-ctl`-style
keys, and the three places in the game's code at each step. `tada-fight`: real fights with the
three multipliers apart (gold, EXP and the familiar's growth each follow their own).