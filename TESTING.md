# Testing Custom TADA Mode

For people and agents who test the mod in the game. Check `logs\rqmod.log` for
`Loading custom-tada-mode` first.

## What it adds

A page in Config's Mods tab, **Custom TADA Mode**, with one number field and a Reset button (built
with `rq.config.settings`, loader 2.35.0). In `rqmod-ctl ui`, on that page:

| Control | What it is |
| --- | --- |
| `stepper-multiplier` | The multiplier; its `value` is the number, `selected` while it is typed into. |
| `button-multiplier-dec`, `button-multiplier-inc` | - and +. |
| `button-reset` | Puts back 2. Not there when the game's code was not found. |

Type a number: `press stepper-multiplier`, then `type 5` and `key enter` (`key esc` puts the old one
back). No other `rq.agent.control` ids. Do not invent controls.

## How to check it

1. At start the log says `Custom TADA Mode: TADA mode multiplier is Nx`.
2. On the page, set 5: the log says `... multiplier is 5x`. With TADA mode on, win a fight: gold and
   EXP are 5/2 of what the same fight gives with 2. No restart.
3. Set 1, then 2 again: the log says each, and TADA mode still applies (the game's `== 1` check is
   untouched).
4. Put it back to 2 afterwards; the number is kept for every save (`rq.store.global`).

## Forcing it for a test

`rq.mod.get("custom-tada-mode")` returns `multiplier()`, `set(n)` (as the page) and `places()`, the
three numbers now in the game's code (battle gold, battle EXP, familiar growth).

## Test Lab

`test-lab/scenarios/config-pages.lua`: the page, the field, a set through `rqmod-ctl`-style keys, and
the three places in the game's code at each step.