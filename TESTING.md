# Testing Custom TADA Mode

For people and agents who test the mod in the game. Check `logs\rqmod.log` for
`Loading custom-tada-mode` first.

## What it adds

No buttons and no `rq.agent.control` ids. Do not invent controls for it. It reads `config.ini` once
at start.

## How to check it

1. At start the log says `Custom TADA Mode: TADA mode multiplier is Nx`.
2. Set `multiplier = 3` in the Mods copy's `mods\custom-tada-mode\config.ini`, start the game, turn
   TADA mode on, and win a fight: gold and EXP are about 3/2 of what the same fight gives with 2.
3. Set `multiplier = 1.5`: a yellow warning shows at the top of the screen for 15 seconds, the log
   says why, and the multiplier is 2.
4. Put `config.ini` back to `multiplier = 2` afterwards (`apply.ps1` also restores it).
